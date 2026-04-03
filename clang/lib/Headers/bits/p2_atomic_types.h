/*===-- bits/p2_atomic_types.h - P2 atomic operation type definitions ------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 * Copyright (C) 2026 Johannes Lode (MTRONIG GmbH)
 *
 *===----------------------------------------------------------------------===
 *
 * This file is an implementation detail of <p2_atomic.h>.
 * Do not include this file directly; use <p2_atomic.h> instead.
 *
 * The P2AtomicOp enum is defined here so that both the compiler (CGBuiltin.cpp)
 * and the sysroot header (p2_atomic.h) share a single authoritative definition.
 * This header contains only standard C and has no LLVM or Clang dependencies.
 *
 * IMPORTANT: If the numeric values of this enum are changed, the corresponding
 * constants in CGBuiltin.cpp (EmitP2BuiltinExpr) are updated automatically
 * because that file includes this header.  No manual synchronization needed.
 *
 *===----------------------------------------------------------------------===
 */

#ifndef _BITS_P2_ATOMIC_TYPES_H
#define _BITS_P2_ATOMIC_TYPES_H

/**
 * @brief Operations dispatched through __p2_atomic_operation().
 *
 * P2AtomicSysInit - Boot-COG/COG0: allocate hardware locks.
 * P2AtomicCogInit - Every COG: sync C463 only, no lock allocation.
 * P2AtomicDeinit  - usable by every COG: return locks to pool + clear C463, should be done by last running COG
 * P2AtomicLock    - Acquire the lock for ptr's address (LOCKTRY loop).
 * P2AtomicUnlock  - Release the lock for ptr's address (LOCKREL).
 * P2AtomicStallI  - Enable ISR inhibit for the calling COG (STALLI).
 * P2AtomicAllowI  - Disable ISR inhibit for the calling COG (ALLOWI).
 */
typedef enum {
    P2AtomicSysInit   = 0,
    P2AtomicCogInit   = 1,
    P2AtomicDeinit    = 2,
    P2AtomicLock      = 3,
    P2AtomicUnlock    = 4,
    P2AtomicStallI    = 5,
    P2AtomicAllowI    = 6,
} P2AtomicOp;

#endif /* _BITS_P2_ATOMIC_TYPES_H */
