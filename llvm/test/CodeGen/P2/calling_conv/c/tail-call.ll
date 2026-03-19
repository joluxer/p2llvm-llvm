; RUN: llc < %s -march=p2 -enable-tail-merge=false | FileCheck %s
;
; Tail call lowering for the P2 backend.
;
; Eligible calls (all arguments in registers, no vararg, no byval) must be
; lowered to JMP instead of CALLA.  The caller's PTRA entry is consumed
; directly by the callee; no PTRA adjustment may appear around the jump.
;
; For eligible calls, argument registers must NOT be restored from the stack
; between argument setup and the JMP.  Restoring them would overwrite the
; values prepared for the callee.  This is verified with CHECK-NOT patterns
; on the relevant rdlong instructions.
;
; Ineligible calls must remain CALLA regardless of the musttail hint.  Normal
; (non-tail) calls must still produce rdlong restores in their epilogue — this
; is verified explicitly to guard against over-aggressive skipping.
;
; The ineligible cases are chosen to be structurally ineligible independent of
; how many argument registers the ABI defines (currently 4, potentially 6 or 8
; in the future).

; -----------------------------------------------------------------------
; Callees
; -----------------------------------------------------------------------
declare void @void_void()
declare void @void_i32(i32 %a)
declare void @void_i32_i32(i32 %a, i32 %b)
declare void @void_i32_i32_i32_i32(i32 %a, i32 %b, i32 %c, i32 %d)
declare void @void_i64_i64(i64 %a, i64 %b)
declare void @void_vaarg(i32 %a, ...)
declare void @__p2_atomic_operation(i8* %ptr, i32 %op)

; -----------------------------------------------------------------------
; Eligible: no arguments.
; No registers are prepared, so no rdlong exclusion is needed here.
; -----------------------------------------------------------------------
define void @tail_void_void() {
; CHECK-LABEL: tail_void_void:
; CHECK:       jmp void_void
; CHECK-NOT:   calla #\void_void
    tail call void @void_void()
    ret void
}

; -----------------------------------------------------------------------
; Eligible: single i32 argument in r0.
; r0 is loaded with the constant 42 as the tail-call argument.  The
; epilogue must NOT restore r0 from the stack between the mov and the jmp,
; otherwise the callee receives the wrong value.
; -----------------------------------------------------------------------
define void @tail_void_i32() {
; CHECK-LABEL: tail_void_i32:
; CHECK:       mov r0, #42
; CHECK-NOT:   rdlong r0
; CHECK:       jmp void_i32
    tail call void @void_i32(i32 42)
    ret void
}

; -----------------------------------------------------------------------
; Eligible: two i32 arguments passed through from caller parameters.
; r0 and r1 carry the incoming arguments directly into the tail call.
; -----------------------------------------------------------------------
define void @tail_void_i32_i32(i32 %x, i32 %y) {
; CHECK-LABEL: tail_void_i32_i32:
; CHECK-NOT:   rdlong r0
; CHECK-NOT:   rdlong r1
; CHECK:       jmp void_i32_i32
    tail call void @void_i32_i32(i32 %x, i32 %y)
    ret void
}

; -----------------------------------------------------------------------
; Eligible: four i32 arguments — maximum with the current ABI (r0-r3).
; If the ABI is later extended to 6 or 8 argument registers this test
; remains valid because the call still fits entirely in registers.
; -----------------------------------------------------------------------
define void @tail_void_i32_i32_i32_i32(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: tail_void_i32_i32_i32_i32:
; CHECK-NOT:   rdlong r0
; CHECK-NOT:   rdlong r1
; CHECK-NOT:   rdlong r2
; CHECK-NOT:   rdlong r3
; CHECK:       jmp void_i32_i32_i32_i32
    tail call void @void_i32_i32_i32_i32(i32 %a, i32 %b, i32 %c, i32 %d)
    ret void
}

; -----------------------------------------------------------------------
; Eligible: two i64 arguments (r0/r1, r2/r3).
; -----------------------------------------------------------------------
define void @tail_void_i64_i64(i64 %a, i64 %b) {
; CHECK-LABEL: tail_void_i64_i64:
; CHECK-NOT:   rdlong r0
; CHECK-NOT:   rdlong r1
; CHECK-NOT:   rdlong r2
; CHECK-NOT:   rdlong r3
; CHECK:       jmp void_i64_i64
    tail call void @void_i64_i64(i64 %a, i64 %b)
    ret void
}

; -----------------------------------------------------------------------
; Eligible: the motivating case for the atomic library.
; __p2_atomic_operation(ptr, op) has two register arguments; the UNLOCK
; call at the end of every __sync_*/__atomic_* wrapper is always in tail
; position and must become a plain JMP to avoid the CALLA/RETA round-trip.
; r0 carries the pointer (passed through), r1 is loaded with the opcode 2.
; r1 must not be restored between the mov and the jmp.
; -----------------------------------------------------------------------
define void @atomic_unlock_wrapper(i8* %ptr) {
; CHECK-LABEL: atomic_unlock_wrapper:
; CHECK:       mov r1, #2
; CHECK-NOT:   rdlong r1
; CHECK:       jmp __p2_atomic_operation
    tail call void @__p2_atomic_operation(i8* %ptr, i32 2)
    ret void
}

; -----------------------------------------------------------------------
; Normal (non-tail) call: epilogue must still restore argument registers.
; This guards against the epilogue fix being applied too aggressively.
; r0 is loaded as a call argument, then restored after the call returns —
; that rdlong is correct and must remain.
; -----------------------------------------------------------------------
define void @normal_call_preserves_epilogue() {
; CHECK-LABEL: normal_call_preserves_epilogue:
; CHECK:       mov r0, #42
; CHECK:       calla #\void_i32
; CHECK:       rdlong r0
; CHECK:       reta
    call void @void_i32(i32 42)
    ret void
}

; -----------------------------------------------------------------------
; NOT eligible: vararg callee.
; Vararg functions expect all fixed arguments on the stack (CC_P2_Vararg),
; so the call is never register-only regardless of ABI register count.
; Must remain CALLA.
; -----------------------------------------------------------------------
define void @no_tail_vararg() {
; CHECK-LABEL: no_tail_vararg:
; CHECK:       calla #\void_vaarg
; CHECK-NOT:   jmp void_vaarg
    tail call void (i32, ...) @void_vaarg(i32 1, i32 2)
    ret void
}

; -----------------------------------------------------------------------
; NOT eligible: byval argument.
; byval implies a stack memcpy regardless of how many argument registers
; the ABI provides.  Must remain CALLA.
; -----------------------------------------------------------------------
%struct.Big = type { [8 x i32] }

declare void @void_byval(%struct.Big* byval(%struct.Big) %s)

define void @no_tail_byval(%struct.Big* %p) {
; CHECK-LABEL: no_tail_byval:
; CHECK:       calla #\void_byval
; CHECK-NOT:   jmp void_byval
    tail call void @void_byval(%struct.Big* byval(%struct.Big) %p)
    ret void
}
