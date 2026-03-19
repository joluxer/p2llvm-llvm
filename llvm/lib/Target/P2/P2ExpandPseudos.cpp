//===- P2ExpandPseudosPass - P2 expand pseudo instructions ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass expands pseudo instructions into real propeller instrucitons
// The only two instructions here can probably be moved to P2InstrInfo
// and this pass be removed.
// 
//===----------------------------------------------------------------------===//

#include "P2.h"
#include "P2InstrInfo.h"
#include "P2RegisterInfo.h"
#include "P2Subtarget.h"
#include "P2TargetMachine.h"
#include "MCTargetDesc/P2BaseInfo.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

using namespace llvm;

#define DEBUG_TYPE "p2-expand-pseudos"

namespace {

    class P2ExpandPseudos : public MachineFunctionPass {
    public:
        static char ID;
        P2ExpandPseudos(P2TargetMachine &tm) : MachineFunctionPass(ID), TM(tm) {}

        bool runOnMachineFunction(MachineFunction &Fn) override;

        StringRef getPassName() const override { return "P2 Expand Pseudos"; }

    private:
        const P2InstrInfo *TII;
        const P2TargetMachine &TM;

        void expand_QUDIV(MachineFunction &MF, MachineBasicBlock::iterator SII);
        void expand_QUREM(MachineFunction &MF, MachineBasicBlock::iterator SII);
        void expand_SELECTCC(MachineFunction &MF, MachineBasicBlock::iterator SII);
        void expand_MOVi64(MachineFunction &MF, MachineBasicBlock::iterator SII);
    };

    char P2ExpandPseudos::ID = 0;

} // end anonymous namespace

void P2ExpandPseudos::expand_QUDIV(MachineFunction &MF, MachineBasicBlock::iterator SII) {
    MachineInstr &SI = *SII;

    LLVM_DEBUG(errs()<<"== lower pseudo unsigned division\n");
    LLVM_DEBUG(SI.dump());

    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::QDIVrr))
            .addReg(SI.getOperand(1).getReg())
            .addReg(SI.getOperand(2).getReg())
            .addImm(P2::ALWAYS);
    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::GETQX), SI.getOperand(0).getReg())
            .addReg(P2::QX)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);

    SI.eraseFromParent();
}

void P2ExpandPseudos::expand_QUREM(MachineFunction &MF, MachineBasicBlock::iterator SII) {
    MachineInstr &SI = *SII;

    LLVM_DEBUG(errs()<<"== lower pseudo unsigned remainder\n");
    LLVM_DEBUG(SI.dump());

    MachineRegisterInfo &MRI = MF.getRegInfo();
    Register scratch = MRI.createVirtualRegister(&P2::P2GPRRegClass);

    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::QDIVrr))
            .addReg(SI.getOperand(1).getReg())
            .addReg(SI.getOperand(2).getReg())
            .addImm(P2::ALWAYS);

    // Consume QX into a scratch register to flush the CORDIC quotient result.
    // This prevents a subsequent CORDIC operation from reading a stale QX value.
    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::GETQX), scratch)
            .addReg(P2::QX)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);

    // The remainder is in QY — write it to the actual output register.
    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::GETQY), SI.getOperand(0).getReg())
            .addReg(P2::QY)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);

    SI.eraseFromParent();
}

bool P2ExpandPseudos::runOnMachineFunction(MachineFunction &MF) {
    TII = TM.getInstrInfo();

    for (auto &MBB : MF) {
        MachineBasicBlock::iterator MBBI = MBB.begin(), E = MBB.end();
        while (MBBI != E) {
            MachineBasicBlock::iterator NMBBI = std::next(MBBI);
            switch (MBBI->getOpcode()) {
                case P2::QUDIV:
                    expand_QUDIV(MF, MBBI);
                    break;
                case P2::QUREM:
                    expand_QUREM(MF, MBBI);
                    break;
            }

            MBBI = NMBBI;
        }
    }

    LLVM_DEBUG(errs()<<"done with pseudo expansion\n");

    return true;
}

FunctionPass *llvm::createP2ExpandPseudosPass(P2TargetMachine &tm) {
    return new P2ExpandPseudos(tm);
}

//===----------------------------------------------------------------------===//
// P2ExpandTailCalls — post-regalloc pass
//
// Expands TCALL_a/TCALL_r to JMPa/JMPr.  This must run *after* register
// allocation so that the CopyToReg nodes that set up argument registers are
// visible to the RA and not eliminated as dead stores before it runs.
//
// QUDIV/QUREM cannot share this pass because their expansion calls
// createVirtualRegister(), which is illegal after register allocation.
//===----------------------------------------------------------------------===//

namespace {

    class P2ExpandTailCalls : public MachineFunctionPass {
    public:
        static char ID;
        P2ExpandTailCalls(P2TargetMachine &tm)
            : MachineFunctionPass(ID), TM(tm) {}

        bool runOnMachineFunction(MachineFunction &MF) override;

        StringRef getPassName() const override { return "P2 Expand Tail Calls"; }

    private:
        const P2TargetMachine &TM;
    };

    char P2ExpandTailCalls::ID = 0;

} // end anonymous namespace

bool P2ExpandTailCalls::runOnMachineFunction(MachineFunction &MF) {
    const P2InstrInfo *TII = TM.getInstrInfo();
    bool changed = false;

    for (auto &MBB : MF) {
        MachineBasicBlock::iterator MBBI = MBB.begin(), E = MBB.end();
        while (MBBI != E) {
            MachineBasicBlock::iterator NMBBI = std::next(MBBI);
            MachineInstr &MI = *MBBI;
            DebugLoc DL = MI.getDebugLoc();

            switch (MI.getOpcode()) {
                case P2::TCALL_a:
                    LLVM_DEBUG(errs() << "== expand TCALL_a to JMPa\n");
                    LLVM_DEBUG(MI.dump());
                    // JMPa operand layout (from P2InstrInfo.td):
                    //   0: absjmptarget:$d   — call target
                    //   1: P2Implicit:$cmp   — status word placeholder (value 1)
                    //   2: condition         — P2::ALWAYS for unconditional jump
                    // The encoder reads operand(2) for the condition field.
                    BuildMI(MBB, MI, DL, TII->get(P2::JMPa))
                        .add(MI.getOperand(0))  // target address
                        .addImm(1)              // P2Implicit:$cmp placeholder
                        .addImm(P2::ALWAYS);    // condition code
                    MI.eraseFromParent();
                    changed = true;
                    break;

                case P2::TCALL_r:
                    LLVM_DEBUG(errs() << "== expand TCALL_r to JMPr\n");
                    LLVM_DEBUG(MI.dump());
                    BuildMI(MBB, MI, DL, TII->get(P2::JMPr))
                        .add(MI.getOperand(0))
                        .addImm(P2::NOEFF)
                        .addImm(P2::ALWAYS);
                    MI.eraseFromParent();
                    changed = true;
                    break;

                default:
                    break;
            }

            MBBI = NMBBI;
        }
    }

    return changed;
}

FunctionPass *llvm::createP2ExpandTailCallsPass(P2TargetMachine &tm) {
    return new P2ExpandTailCalls(tm);
}
