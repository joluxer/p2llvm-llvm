// RUN: %clang -target p2-none-elf -x c -E %s | FileCheck %s
// REQUIRES: p2-registered-target

#include <bits/p2_register_base.h>

// Expand constants into patterns FileCheck can match
int P2_COG_REG_BASE_VAL = P2_COG_REG_BASE
int P2_COG_ATOMIC_ISR_FLAG_VAL = P2_COG_ATOMIC_ISR_FLAG

// CHECK: P2_COG_REG_BASE_VAL = 0x1D0u
// CHECK: P2_COG_ATOMIC_ISR_FLAG_VAL = (0x1D0u - 1u)

_Static_assert(P2_COG_ATOMIC_ISR_FLAG == P2_COG_REG_BASE - 1u,
               "ISR flag slot must be immediately below r0");
_Static_assert(P2_COG_ATOMIC_ISR_FLAG < P2_COG_REG_BASE,
               "ISR flag slot must not overlap ABI register file");
