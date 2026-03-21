//===-- p2.td - Describe the p2 Target Machine -------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
// This is the top level entry point for the p2 target.
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Target-independent interfaces
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

include "P2RegisterInfo.td"
include "P2InstrInfo.td"
include "P2CallingConv.td"

def P2InstrInfo : InstrInfo;

def P2AsmParser : AsmParser {
    let ShouldEmitMatchRegisterName = 0;
    let HasMnemonicFirst = 0;
    // let AsmParserInstCleanup  = "cleanupInst";
}

def P2AsmParserVariant : AsmParserVariant {
    int Variant = 0;

    // Recognize hard coded registers.
    string RegisterPrefix = "$";
}

// SubtargetFeatures
// +atomic-store-lock (default): atomic stores use the lock protocol to prevent
// store-vs-RMW races across cogs and ISRs.
// -atomic-store-lock (opt-out): atomic stores are emitted as plain WRLONG.
// Only safe when the application guarantees no concurrent RMW operations
// on the same memory location from other cogs or ISRs.
def FeatureAtomicStoreLock : SubtargetFeature<
    "atomic-store-lock",
    "hasAtomicStoreLock",
    "true",
    "Use lock protocol for atomic stores (default: enabled)">;

class Proc<string Name> : Processor<Name, NoItineraries, []>;
class ProcWithFeatures<string Name, list<SubtargetFeature> Features>
    : Processor<Name, NoItineraries, Features>;

def : ProcWithFeatures<"generic",    [FeatureAtomicStoreLock]>;
def : ProcWithFeatures<"p2",         [FeatureAtomicStoreLock]>;
def : ProcWithFeatures<"Propeller 2",[FeatureAtomicStoreLock]>;

def P2 : Target {
    let InstructionSet = P2InstrInfo;
    let AssemblyParsers = [P2AsmParser];
    let AssemblyParserVariants = [P2AsmParserVariant];
}
