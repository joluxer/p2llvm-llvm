//===-- P2FixupKinds.h - P2 Specific Fixup Entries ----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_P2_MCTARGETDESC_P2FIXUPKINDS_H
#define LLVM_LIB_TARGET_P2_MCTARGETDESC_P2FIXUPKINDS_H

#include "llvm/MC/MCFixup.h"

namespace llvm {
    namespace P2 {
        // Although most of the current fixup types reflect a unique relocation
        // one can have multiple fixup types for a given relocation and thus need
        // to be uniquely named.
        //
        // This table *must* be in the save order of
        // MCFixupKindInfo Infos[P2::NumTargetFixupKinds]
        // in P2AsmBackend.cpp.
        //
        enum Fixups {
            // Pure 32 bit fixup
            fixup_P2_32 = FirstTargetFixupKind,

            // 32 bit PC relative fixup (i don't think these would ever exist)
            fixup_P2_PC32,

            // 20 bit fixup for calls — obsolete, hard linker error in Phase-2
            fixup_P2_20,

            // 20 bit pc-relative fixup for jumps — obsolete, hard linker error in Phase-2
            fixup_P2_PC20,

            // 20+ bit fixup for global addresses — obsolete, hard linker error in Phase-2
            fixup_P2_AUG20,

            // 9 bit fixup for cog based functions — obsolete, hard linker error in Phase-2
            fixup_P2_COG9,

            // 9 bit PC relative fixup for cog jumps — obsolete, hard linker error in Phase-2
            fixup_P2_PCCOG9,

            // Phase-2 typed fixup kinds — one per new ELF relocation type (#8–#21).
            // Order must match MCFixupKindInfo Infos[] in P2AsmBackend.cpp.

            // Cog RAM: absolute targets and PC-relative branches
            fixup_P2_COG_PC20,    // R_P2_COG_PC20  (#8):  JMP/CALL 20-bit, val/4
            fixup_P2_COG_PC9,     // R_P2_COG_PC9   (#9):  9-bit absolute target, val/4 (reserved)
            fixup_P2_COG_DATA9,   // R_P2_COG_DATA9 (#10): ALU SRC/DEST index, val/4
            fixup_P2_COG_PCREL9,  // R_P2_COG_PCREL9(#11): PC-relative short branch, signed 9-bit long offset

            // LUT RAM: absolute targets and PC-relative branches
            fixup_P2_LUT_PC20,    // R_P2_LUT_PC20  (#12): JMP/CALL 20-bit, (val-base)/4+0x200
            fixup_P2_LUT_PC9,     // R_P2_LUT_PC9   (#13): 9-bit absolute LUT long index, (val-base)/4
            fixup_P2_LUT_DATA9,   // R_P2_LUT_DATA9 (#14): RDLUT/WRLUT address, (val-base)/4
            fixup_P2_LUT_PCREL9,  // R_P2_LUT_PCREL9(#15): PC-relative short branch, signed 9-bit long offset

            // Hub RAM: absolute, PC-relative, and AUGx-extended
            fixup_P2_HUB_PC20,      // R_P2_HUB_PC20    (#16): 20-bit absolute Hub reference
            fixup_P2_HUB_PCREL20,   // R_P2_HUB_PCREL20 (#17): 20-bit PC-relative Hub branch
            fixup_P2_HUB_PCAUG32,   // R_P2_HUB_PCAUG32 (#18): AUGS+JMP/CALL, 23+9=32-bit

            // AUGx fallback: no-attribute symbols placed in Cog/LUT by linker script
            fixup_P2_COG_PCAUG32,   // R_P2_COG_PCAUG32   (#19): AUGS+JMP into Cog RAM
            fixup_P2_LUT_PCAUG32,   // R_P2_LUT_PCAUG32   (#20): AUGS+JMP into LUT RAM
            fixup_P2_HUB_DATAAUG32, // R_P2_HUB_DATAAUG32 (#21): AUGS+RDLONG/WRLONG, Hub data

            // Marker
            LastTargetFixupKind,
            NumTargetFixupKinds = LastTargetFixupKind - FirstTargetFixupKind
        };
    }
}

#endif // LLVM_P2_P2FIXUPKINDS_H

