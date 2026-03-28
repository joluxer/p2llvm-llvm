; RUN: llc -march=p2 < %s | FileCheck %s

define void @inline_asm_no_operand() {
; CHECK-LABEL: inline_asm_no_operand:
; CHECK: add r0, r1
    call void asm sideeffect "add r0, r1", ""() nounwind
    ret void
}

define void @inline_asm_no_operand2() {
; CHECK-LABEL: inline_asm_no_operand2:
; CHECK: add r0, #100
    call void asm sideeffect "add r0, #100", ""() nounwind
    ret void
}

define void @inline_asm_no_operand3() {
; CHECK-LABEL: inline_asm_no_operand3:
; CHECK: augs #1
; CHECK-NEXT: add {{r[0-9]+}}, #488
    call void asm sideeffect "add r0, ##1000", ""() nounwind
    ret void
}

define void @inline_asm_reg_operand(i32 %a) {
; CHECK-LABEL: inline_asm_reg_operand:
; CHECK: add r0, {{r[0-9]+}}
    call void asm sideeffect "add r0, $0", "r"(i32 %a) nounwind
    ret void
}

define void @inline_asm_imm_operand() {
; CHECK-LABEL: inline_asm_imm_operand:
; CHECK: add  r0, #100
    call void asm sideeffect "add r0, $0", "i"(i32 100) nounwind
    ret void
}

define void @inline_asm_large_imm_operand() {
; CHECK-LABEL: inline_asm_large_imm_operand:
; CHECK-NEXT: add r0, #488
    call void asm sideeffect "add r0, $0", "i"(i32 1000) nounwind
    ret void
}

define void @inline_asm_c463_write(i32 %val) {
; CHECK-LABEL: inline_asm_c463_write:
; CHECK: mov c463, {{r[0-9]+}}
    call void asm sideeffect "mov c463, $0", "r"(i32 %val) nounwind
    ret void
}

define i32 @inline_asm_c463_read() {
; CHECK-LABEL: inline_asm_c463_read:
; CHECK: mov {{r[0-9]+}}, c463
    %val = call i32 asm sideeffect "mov $0, c463", "=r"() nounwind
    ret i32 %val
}
