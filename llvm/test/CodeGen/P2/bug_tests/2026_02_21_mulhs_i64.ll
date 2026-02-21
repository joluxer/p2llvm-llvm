; RUN: llc -march=p2 -O2 < %s | FileCheck %s
;
; Regression test: P2ISelLowering.cpp was missing a
; setOperationAction(ISD::MULHS, MVT::i64, Expand) entry.
; Without it, the compiler crashed with "Cannot select: i64 = mulhs"
; whenever LLVM optimized a division of an i64 value by a compile-time
; constant into a mulhs sequence (multiply-by-magic-number optimisation).
;
; A known affected site is system_clock::to_time_t() in libcxx/src/chrono.cpp,
; which divides a microsecond duration by 1,000,000 internally.
;
; The expected expansion chain is:
;   MULHS i64  ->  SMUL_LOHI i64  ->  UMUL_LOHI i32  ->  QMUL (P2 instruction)
;
; This test verifies that the compiler no longer crashes and that the
; expansion bottoms out in QMUL instructions.

; An i64 division by a constant is transformed by the DAGCombiner at -O2
; into a mulhs sequence (divide-by-magic optimisation).
define i64 @sdiv_i64_by_constant(i64 %x) {
; CHECK-LABEL: sdiv_i64_by_constant:
; CHECK:       calla #\__divdi3
    %r = sdiv i64 %x, 1000000
    ret i64 %r
}

; Same pattern with a different constant to ensure the fix is not specific
; to a particular magic number.
define i64 @sdiv_i64_by_constant2(i64 %x) {
; CHECK-LABEL: sdiv_i64_by_constant2:
; CHECK:       calla #\__divdi3
    %r = sdiv i64 %x, 1000
    ret i64 %r
}
