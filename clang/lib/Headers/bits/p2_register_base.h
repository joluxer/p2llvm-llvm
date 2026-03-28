/*===-- bits/p2_register_base.h - P2 COG-RAM register layout constants ----===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 * Copyright (C) 2026 Johannes Lode (MTRONIG GmbH)
 *
 *===----------------------------------------------------------------------===
 *
 * Authoritative definitions of P2 COG-RAM address constants shared between
 * the compiler backend (P2RegisterInfo.td) and runtime libraries.
 *
 * This file is the single source of truth for COG-RAM layout. Any change
 * to the ABI register base address MUST be reflected here; all other files
 * reference this header or carry a normative comment pointing here.
 *
 * Do not include this file directly in LLVM/TableGen sources — TableGen
 * cannot process C preprocessor directives. Verify consistency manually
 * when changing P2_COG_REG_BASE.
 *
 * Safe to include from:
 *   - C / C++ runtime library sources  (#include <bits/p2_register_base.h>)
 *   - PASM2 assembler sources           (#include <bits/p2_register_base.h>)
 *   - clang CGBuiltin.cpp               (#include "bits/p2_register_base.h")
 *
 *===----------------------------------------------------------------------===
 */

#ifndef _BITS_P2_REGISTER_BASE_H
#define _BITS_P2_REGISTER_BASE_H

/*
 * COG-RAM address of r0, the first ABI general-purpose register.
 * Corresponds to P2Reg<0x1d0> in P2RegisterInfo.td.
 *
 * The ABI register file occupies COG-RAM addresses:
 *   r0  = P2_COG_REG_BASE + 0   (0x1D0)
 *   ...
 *   r31 = P2_COG_REG_BASE + 31  (0x1EF)
 */
#define P2_COG_REG_BASE  (0x1D0u)

/*
 * COG-RAM address reserved for the per-COG atomic ISR-inhibit flag.
 * Occupies the single long immediately below the ABI register file.
 * Corresponds to C463 (the topmost general-purpose COG-RAM slot) in
 * P2RegisterInfo.td. This slot is reserved by the p2llvm ABI and must
 * not be used by application code or compiler register allocation.
 */
#define P2_COG_ATOMIC_ISR_FLAG      (0x1CF)  /* 0x1CF = 463 */
#define P2_COG_ATOMIC_ISR_FLAG_NAME "c463"   /* asm register name */

/*
 * Bit-field layout of P2_COG_ATOMIC_ISR_FLAG (COG-address 0x1CF).
 *
 * USER_ISR  (bit 0): Cleared by stalli(), set by allowi().
 *                    Returned by the geti() call.
 * MANAGED   (bit 1): Set by P2AtomicStallI; signals that Lock/Unlock
 *                    bracket the critical section with STALLI/ALLOWI.
 * ACTIVE    (bit 2): Set by Lock after executing STALLI internally;
 *                    Unlock must issue ALLOWI and clear this bit.
 */
#define P2_COG_ISR_FLAG_USER_ISR  (1u << 0)
#define P2_COG_ISR_FLAG_MANAGED   (1u << 1)
#define P2_COG_ISR_FLAG_ACTIVE    (1u << 2)

#endif /* _BITS_P2_REGISTER_BASE_H */
