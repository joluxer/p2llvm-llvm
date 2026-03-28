//===--- P2.cpp - Implement P2 target feature support -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements P2 TargetInfo objects.
//
//===----------------------------------------------------------------------===//

#include "P2.h"
#include "clang/Basic/MacroBuilder.h"
#include "clang/Basic/Builtins.h"
#include "llvm/ADT/StringSwitch.h"

using namespace clang;
using namespace clang::targets;

namespace clang {
namespace targets {

// Table of P2-specific builtin descriptors, generated from BuiltinsP2.def.
static const Builtin::Info P2BuiltinInfoTable[] = {
#define BUILTIN(ID, TYPE, ATTRS)                                               \
    {#ID, TYPE, ATTRS, nullptr, ALL_LANGUAGES, nullptr},
#include "clang/Basic/BuiltinsP2.def"
};

} // namespace targets
} // namespace clang

ArrayRef<Builtin::Info>
clang::targets::P2TargetInfo::getTargetBuiltins() const {
    return llvm::makeArrayRef(P2BuiltinInfoTable,
                              clang::P2::LastTSBuiltin -
                              clang::Builtin::FirstTSBuiltin);
}

const char *const P2TargetInfo::GCCRegNames[] = {
    "r0", "r1", "r2",  "r3",  "r4",  "r5",  "r6",  "r7",
    "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
    "r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23",
    "r24", "r25", "r26", "r27", "r28", "r29", "r30", "r31",
    "ijmp3", "iret3", "ijmp2", "iret2", "ijmp1", "iret1", "pa", "pb",
    "ptra", "ptrb", "dira", "dirb", "outa", "outb", "ina", "inb"
};

ArrayRef<const char *> P2TargetInfo::getGCCRegNames() const {
  return llvm::makeArrayRef(GCCRegNames);
}

bool P2TargetInfo::isValidGCCRegisterName(StringRef Name) const {
    // Check the static table first: r0-r31 and all named special registers.
    if (TargetInfo::isValidGCCRegisterName(Name))
        return true;
    // Accept c0–c463: the full COG-RAM general-purpose register file.
    // TableGen emits lowercase names ("c0"..."c463") via '"c"#i', so the
    // asm() constraint string in C sources must be lowercase too.
    // C463 (0x1CF) is the P2_COG_ATOMIC_ISR_FLAG slot; it is excluded from
    // register allocation via Reserved.set() in P2RegisterInfo.cpp, but valid here.
    if (Name.size() >= 2 && Name[0] == 'c') {
        unsigned N;
        if (!Name.drop_front(1).getAsInteger(10, N))
            return N <= 463;
    }
    return false;
}

void P2TargetInfo::getTargetDefines(const LangOptions &Opts,
                                     MacroBuilder &Builder) const {
    Builder.defineMacro("__ELF__");
    Builder.defineMacro("__propeller2__");
    Builder.defineMacro("__p2llvm__");
}
