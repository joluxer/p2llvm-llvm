//===- P2.cpp ------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// generally, programs will be creates as follows:
//
//   ld.lld -Ttext=0 -o foo foo.o
//   objcopy -O binary --only-section=.text foo output.bin
//
// Note that the current P2 support is very preliminary so you can't
// link any useful program yet, though.
//
//===----------------------------------------------------------------------===//

#include "InputFiles.h"
#include "Symbols.h"
#include "Target.h"
#include "lld/Common/ErrorHandler.h"
#include "llvm/Object/ELF.h"
#include "llvm/Support/Endian.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Support/P2AddressSpaces.h"

#define DEBUG_TYPE "p2"

using namespace llvm;
using namespace llvm::object;
using namespace llvm::support::endian;
using namespace llvm::ELF;

namespace lld {
    namespace elf {

        namespace {
            class P2 final : public TargetInfo {
            public:
                RelExpr getRelExpr(RelType type, const Symbol &s, const uint8_t *loc) const override;
                void relocate(uint8_t *loc, const Relocation &rel, uint64_t val) const override;
            };
        } // namespace

        RelExpr P2::getRelExpr(RelType type, const Symbol &s, const uint8_t *loc) const {
            switch (type) {
                default:
                    return R_ABS;
                case R_P2_HUB_PCREL20:
                case R_P2_COG_PCREL9:
                case R_P2_LUT_PCREL9:
                    return R_PC;
            }
        }

        void P2::relocate(uint8_t *loc, const Relocation &rel, uint64_t val) const {

            if (rel.sym)
            {
                if (rel.sym->isLocal())
                    LLVM_DEBUG(outs() << "symbol is local\n");

                LLVM_DEBUG(outs() << "relocate: " << rel.sym->getName() << "\n");
            }

            LLVM_DEBUG(outs() << "reloc value is " << (int)val << "\n");

            auto errorCogAbi = [&](uint64_t adjusted) {
                error(getErrorLocation(loc) + "Cog RAM branch target long 0x" +
                      Twine::utohexstr(adjusted).str() +
                      " exceeds ABI maximum P2CogAbiMax (0x" +
                      Twine::utohexstr(P2CogAbiMax).str() +
                      ") - longs 0x1CF-0x1FF are reserved by the p2-none-elf ABI");
            };
            auto errorLutUnderflow = [&](uint64_t v) {
                error(getErrorLocation(loc) + "LUT relocation to symbol with VMA 0x" +
                      Twine::utohexstr(v).str() +
                      " below LUT base P2LutPcBase (0x" +
                      Twine::utohexstr(P2LutPcBase).str() +
                      ") - check linker script or relocation type");
            };
            auto errorLutOverflow = [&](uint64_t addr) {
                error(getErrorLocation(loc) +
                      "LUT relocation to symbol with LUT PC address 0x" +
                      Twine::utohexstr(addr).str() +
                      " exceeds LUT RAM limit P2LutPcMax (0x" +
                      Twine::utohexstr(P2LutPcMax).str() +
                      ") - symbol VMA is outside LUT section; check relocation type");
            };

            switch (rel.type) {
            case R_P2_32:
                write32le(loc, val);
                break;

            // Abolished legacy types - hard error.
            case R_P2_20:
            case R_P2_PC20:
            case R_P2_AUG20:
            case R_P2_COG9:
            case R_P2_PCCOG9:
                error(getErrorLocation(loc) + toString(rel.type) +
                      " is an obsolete relocation type from pre-Phase-2 p2llvm;"
                      " recompile this object file with a Phase-2-capable p2llvm toolchain");
                return;

            // Cog RAM - 20-bit absolute long address.
            // val = Hub byte VMA of symbol. val/4 = Cog long PC address.
            // Assumes .cog section VMA base == 0x000 (Hub byte).
            // Robust future form: (val - __cog_load_addr) / 4
            // See docs/design/p2_address_translation_quirks.md for background.
            case R_P2_COG_PC20: {
                uint64_t adjusted = val / 4;
                if (adjusted > P2CogAbiMax) {
                    errorCogAbi(adjusted);
                    return;
                }
                checkUInt(loc, adjusted, 20, rel);
                uint32_t inst = read32le(loc);
                write32le(loc, (inst & ~0xfffff) | (adjusted & 0xfffff));
                break;
            }

            // Cog RAM - 9-bit absolute long address (PC target).
            // val = Hub byte VMA. val/4 = Cog long PC address.
            // Assumes .cog section VMA base == 0x000 (Hub byte).
            case R_P2_COG_PC9: {
                uint64_t adjusted = val / 4;
                if (adjusted > P2CogAbiMax) {
                    errorCogAbi(adjusted);
                    return;
                }
                checkUInt(loc, adjusted, 9, rel);
                uint32_t inst = read32le(loc);
                write32le(loc, (inst & ~0x1ff) | (adjusted & 0x1ff));
                break;
            }

            // Cog RAM - 9-bit absolute long address (data operand).
            // No ABI upper-bound check: runtime code legitimately accesses
            // ABI-reserved Cog slots as data (e.g., ISR-flag at 0x1CF).
            case R_P2_COG_DATA9: {
                uint64_t adjusted = val / 4;
                checkUInt(loc, adjusted, 9, rel);
                uint32_t inst = read32le(loc);
                write32le(loc, (inst & ~0x1ff) | (adjusted & 0x1ff));
                break;
            }

            // Cog RAM - 9-bit PC-relative long offset.
            // val = signed byte difference (target VMA - instruction VMA) from R_PC.
            // val/4 converts to signed long offset as required by Cog branch encoding.
            case R_P2_COG_PCREL9: {
                int64_t adjusted = (int64_t)val / 4;
                checkInt(loc, adjusted, 9, rel);
                uint32_t inst = read32le(loc);
                write32le(loc, (inst & ~0x1ff) | ((uint64_t)adjusted & 0x1ff));
                break;
            }

            // LUT RAM - 20-bit absolute long address (LUT-indexed).
            // val = Hub byte VMA. Formula converts to LUT long PC address.
            // Works because .lut VMA base == P2LutPcBase == 0x200 by p2llvm convention.
            // If .lut VMA base changes, replace P2LutPcBase subtrahend with __lut_load_addr.
            // Robust future form: (val - __lut_load_addr) / 4 + P2LutPcBase
            // See docs/design/p2_address_translation_quirks.md for background.
            case R_P2_LUT_PC20: {
                if (val < P2LutPcBase) {
                    errorLutUnderflow(val);
                    return;
                }
                uint64_t adjusted = (val - P2LutPcBase) / 4 + P2LutPcBase;
                if (adjusted > P2LutPcMax) {
                    errorLutOverflow(adjusted);
                    return;
                }
                checkUInt(loc, adjusted, 20, rel);
                uint32_t inst = read32le(loc);
                write32le(loc, (inst & ~0xfffff) | (adjusted & 0xfffff));
                break;
            }

            // LUT RAM - 9-bit 0-based RDLUT/WRLUT index.
            // val = Hub byte VMA. idx = 0-based long offset from LUT RAM start.
            // This is the RDLUT/WRLUT addressing convention (0 = LUT long 0x200).
            // Not for branch targets; for data access instructions only.
            // Assumes .lut VMA base == P2LutPcBase == 0x200.
            case R_P2_LUT_PC9:
            case R_P2_LUT_DATA9: {
                if (val < P2LutPcBase) {
                    errorLutUnderflow(val);
                    return;
                }
                uint64_t idx = (val - P2LutPcBase) / 4;
                checkUInt(loc, idx, 9, rel);
                uint32_t inst = read32le(loc);
                write32le(loc, (inst & ~0x1ff) | (idx & 0x1ff));
                break;
            }

            // LUT RAM - 9-bit PC-relative long offset.
            // val = signed byte difference (target VMA - instruction VMA) from R_PC.
            // val/4 converts to signed long offset for Cog/LUT branch encoding.
            case R_P2_LUT_PCREL9: {
                int64_t adjusted = (int64_t)val / 4;
                checkInt(loc, adjusted, 9, rel);
                uint32_t inst = read32le(loc);
                write32le(loc, (inst & ~0x1ff) | ((uint64_t)adjusted & 0x1ff));
                break;
            }

            // Hub RAM - 20-bit absolute byte address.
            // val = Hub byte VMA. No conversion needed; Hub PC is byte-addressed.
            case R_P2_HUB_PC20: {
                uint32_t inst = read32le(loc);
                write32le(loc, (inst & ~0xfffff) | (val & 0xfffff));
                break;
            }

            // Hub RAM - 20-bit PC-relative byte offset.
            // val = signed byte difference (target VMA - instruction VMA) from R_PC.
            // Written directly; JMP in Hub mode uses byte offsets.
            case R_P2_HUB_PCREL20: {
                uint32_t inst = read32le(loc);
                write32le(loc, (inst & ~0xfffff) | (val & 0xfffff));
                break;
            }

            // Hub RAM - AUGx+CALL/JMP pair, absolute Hub byte address (23+9=32-bit).
            // loc = CALL/JMP instruction; loc-4 = AUGS instruction.
            // val = absolute Hub byte address. Split into (val>>9, val&0x1ff).
            // CALL is absolute (not PC-relative); mode switch to LUT/Cog is implicit
            // if the resulting PC falls below 0x400 - but this type targets Hub only.
            case R_P2_HUB_PCAUG32:
            case R_P2_HUB_DATAAUG32: {
                uint32_t aug = read32le(loc - 4) & ~0x7fffff;
                uint32_t inst = read32le(loc);
                aug |= (val >> 9) & 0x7fffff;
                inst = (inst & ~0x1ff) | (val & 0x1ff);
                write32le(loc - 4, aug);
                write32le(loc, inst);
                break;
            }

            // Cog RAM - AUGx+JMP pair, absolute Cog long address (23+9=32-bit).
            // loc = JMP instruction; loc-4 = AUGS instruction.
            // val = Hub byte VMA. val/4 = Cog long PC address.
            // Assumes .cog VMA base == 0x000. Robust: (val - __cog_load_addr) / 4
            case R_P2_COG_PCAUG32: {
                uint64_t adjusted = val / 4;
                if (adjusted > P2CogAbiMax) {
                    errorCogAbi(adjusted);
                    return;
                }
                uint32_t aug = read32le(loc - 4) & ~0x7fffff;
                uint32_t inst = read32le(loc);
                aug |= (adjusted >> 9) & 0x7fffff;
                inst = (inst & ~0x1ff) | (adjusted & 0x1ff);
                write32le(loc - 4, aug);
                write32le(loc, inst);
                break;
            }

            // LUT RAM - AUGx+CALL/JMP pair, absolute LUT long address (23+9=32-bit).
            // loc = CALL/JMP instruction; loc-4 = AUGS instruction.
            // val = Hub byte VMA. lp = LUT long PC address.
            // Works because .lut VMA base == P2LutPcBase == 0x200 by p2llvm convention.
            // Robust future form: (val - __lut_load_addr) / 4 + P2LutPcBase
            // Cross-space: calling from Hub into LUT switches execution mode
            // automatically when the resulting PC drops into 0x200-0x3FF.
            case R_P2_LUT_PCAUG32: {
                if (val < P2LutPcBase) {
                    errorLutUnderflow(val);
                    return;
                }
                uint64_t lp = (val - P2LutPcBase) / 4 + P2LutPcBase;
                if (lp > P2LutPcMax) {
                    errorLutOverflow(lp);
                    return;
                }
                uint32_t aug = read32le(loc - 4) & ~0x7fffff;
                uint32_t inst = read32le(loc);
                aug |= (lp >> 9) & 0x7fffff;
                inst = (inst & ~0x1ff) | (lp & 0x1ff);
                write32le(loc - 4, aug);
                write32le(loc, inst);
                break;
            }

            default:
                error(getErrorLocation(loc) + "unrecognized relocation " + toString(rel.type));
            }
        }

        TargetInfo *getP2TargetInfo() {
            static P2 target;
            return &target;
        }
    } // namespace elf
} // namespace lld
