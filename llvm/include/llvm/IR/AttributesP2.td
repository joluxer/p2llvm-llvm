//===- AttributesP2.td - Defines Propeller-2 attributes -----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines Propeller-2 specific attributes.
//
//===----------------------------------------------------------------------===//

def Cogtext : EnumAttr<"cogtext", [FnAttr]>;
def Cogmain : EnumAttr<"cogmain", [FnAttr]>;
def Cogcache : EnumAttr<"cogcache", [FnAttr]>;
