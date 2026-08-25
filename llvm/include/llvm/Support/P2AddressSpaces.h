//===-- llvm/Support/P2AddressSpaces.h - P2 address space constants -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// Copyright (C) 2026 Johannes Lode (MTRONIG GmbH)
//
//===----------------------------------------------------------------------===//
//
// Authoritative C++ definitions of P2 address space boundary constants.
// These are PC long addresses (not byte addresses); each unit is one 32-bit
// long (4 bytes).
//
// Single source of truth for:
//   - LLVM backend  (MCTargetDesc/P2AsmBackend.cpp, lld/ELF/Arch/P2.cpp)
//   - lld Writer    (lld/ELF/Writer.cpp - injected as ABI symbols)
//
// User-visible access: #include <bits/p2_address_spaces.h>
// (clang resource header, installed by the P2 toolchain build)
//
// Do not hardcode these values elsewhere. All consumers must include this
// header or the user-facing resource header that declares the ABI symbols.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_P2ADDRESSSPACES_H
#define LLVM_SUPPORT_P2ADDRESSSPACES_H

#include <cstdint>

namespace llvm {

// Cog RAM: PC long addresses 0x000-0x1FF (hardware limit: 512 longs)
constexpr uint64_t P2CogPcMin  = 0x000;
constexpr uint64_t P2CogPcMax  = 0x1FF;

// Largest Cog long address available to user code.
// Longs 0x1CF-0x1FF are reserved by the p2llvm ABI (ISR flag slot, register
// file). User code and compiler register allocation must not use them.
constexpr uint64_t P2CogAbiMax = 0x1CE;

// LUT RAM: PC long addresses 0x200-0x3FF (hardware limit: 512 longs)
constexpr uint64_t P2LutPcBase = 0x200;
constexpr uint64_t P2LutPcMax  = 0x3FF;

// Hub RAM: byte addresses 0x400 and above (PC value when entering Hub mode)
constexpr uint64_t P2HubPcBase = 0x400;

} // namespace llvm

#endif // LLVM_SUPPORT_P2ADDRESSSPACES_H
