/*===-- bits/p2_address_spaces.h - P2 address space boundary symbols ------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 * Copyright (C) 2026 Johannes Lode (MTRONIG GmbH)
 *
 *===----------------------------------------------------------------------===
 *
 * P2 address space boundary constants, provided as linker-defined ABI symbols.
 *
 * ld.lld injects these as absolute ELF symbols into every P2-target binary.
 * The numeric values are defined exactly once in:
 *   llvm/include/llvm/Support/P2AddressSpaces.h
 * This header contains no values - only names and access casts.
 * A symbol name mismatch causes a linker error (unresolved symbol).
 *
 * Safe to include from:
 *   - C / C++ runtime library sources  (#include <bits/p2_address_spaces.h>)
 *   - Application code                 (#include <bits/p2_address_spaces.h>)
 *
 *===----------------------------------------------------------------------===
 *
 * ADDRESSING NOTE: These constants are P2 long (PC) addresses, not byte
 * addresses. Each unit represents one 32-bit long (4 bytes). When navigating
 * between consecutive longs, use integer addition, not C pointer arithmetic:
 *
 *   Correct:  (uint32_t *)(P2_LUT_PC_BASE + 1)   -- next long in LUT space
 *   Wrong:    ((uint32_t *)P2_LUT_PC_BASE)[1]     -- advances by 4 longs
 *
 *===----------------------------------------------------------------------===
 */

#ifndef _BITS_P2_ADDRESS_SPACES_H
#define _BITS_P2_ADDRESS_SPACES_H

/* Linker-defined absolute symbols. Do not dereference; take address only. */
extern char __p2_cog_pc_min[];
extern char __p2_cog_pc_max[];
extern char __p2_cog_abi_max[];
extern char __p2_lut_pc_base[];
extern char __p2_lut_pc_max[];
extern char __p2_hub_pc_base[];

/*
 * Type-safe accessors. Cast the symbol address to unsigned; contains no
 * hardcoded values - the linker supplies the actual constants at link time.
 */
#define P2_COG_PC_MIN   ((unsigned)(unsigned long)__p2_cog_pc_min)
#define P2_COG_PC_MAX   ((unsigned)(unsigned long)__p2_cog_pc_max)
#define P2_COG_ABI_MAX  ((unsigned)(unsigned long)__p2_cog_abi_max)
#define P2_LUT_PC_BASE  ((unsigned)(unsigned long)__p2_lut_pc_base)
#define P2_LUT_PC_MAX   ((unsigned)(unsigned long)__p2_lut_pc_max)
#define P2_HUB_PC_BASE  ((unsigned)(unsigned long)__p2_hub_pc_base)

#endif /* _BITS_P2_ADDRESS_SPACES_H */
