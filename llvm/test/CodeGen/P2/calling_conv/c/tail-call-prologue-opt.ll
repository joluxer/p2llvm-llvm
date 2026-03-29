; RUN: llc -mtriple=p2-none-elf -O2 < %s | FileCheck %s
; REQUIRES: p2-registered-target

; Verifies that determineCalleeSaves clears SavedRegs for tail-call-only
; functions, suppressing all prologue spills and epilogue corrections.

declare void @callee_0()
declare void @callee_1(i32)
declare void @callee_2(i32, i32)
declare i32  @callee_ret(i32)

; A1: Live-in argument forwarded directly — no def in body.
; CHECK-LABEL: opt_passthrough_1arg:
; CHECK-NOT:   wrlong
; CHECK-NOT:   sub {{.*}}ptra
; CHECK:       jmp callee_1
define void @opt_passthrough_1arg(i32 %x) {
    tail call void @callee_1(i32 %x)
    ret void
}

; A2: Two live-in arguments forwarded directly.
; CHECK-LABEL: opt_passthrough_2arg:
; CHECK-NOT:   wrlong
; CHECK-NOT:   sub {{.*}}ptra
; CHECK:       jmp callee_2
define void @opt_passthrough_2arg(i32 %x, i32 %y) {
    tail call void @callee_2(i32 %x, i32 %y)
    ret void
}

; A3: Constant argument — R0 defined in body, no RETA path.
; CHECK-LABEL: opt_const_tailcall:
; CHECK-NOT:   wrlong
; CHECK-NOT:   sub {{.*}}ptra
; CHECK:       jmp callee_1
define void @opt_const_tailcall() {
    tail call void @callee_1(i32 42)
    ret void
}

; A4: Argument shuffled to different register — R0/R1 defined in body.
; CHECK-LABEL: opt_shift_arg:
; CHECK-NOT:   wrlong
; CHECK-NOT:   sub {{.*}}ptra
; CHECK:       jmp callee_2
define void @opt_shift_arg(i32 %x) {
    tail call void @callee_2(i32 0, i32 %x)
    ret void
}

; B1: Inline-asm barrier prevents tail-call — normal prologue/epilogue required.
; CHECK-LABEL: noopt_barrier:
; CHECK:       calla
; CHECK:       reta
define void @noopt_barrier() {
    call void @callee_0()
    call void asm sideeffect "", "~{memory}"()
    ret void
}

; B2: Non-tail-call return present — SavedRegs must not be cleared.
; CHECK-LABEL: noopt_use_return_value:
; CHECK:       wrlong
; CHECK:       reta
define i32 @noopt_use_return_value(i32 %x) {
    %r = call i32 @callee_ret(i32 %x)
    %s = add i32 %r, 1
    ret i32 %s
}
