// REQUIRES: p2-registered-target
// RUN: %clang_cc1 -triple p2-none-unknown-elf -O0 -emit-llvm -o - %s \
// RUN:   | FileCheck %s
// RUN: %clang_cc1 -triple p2-none-unknown-elf -O1 -S -o - %s \
// RUN:   | FileCheck %s --check-prefix=ASM-O1

#include <bits/p2_atomic_types.h>

// CHECK-LABEL: define {{.*}}void @test_lock(
// CHECK:         call void @__p2_atomic_operation(ptr {{.*}}, i32 1)
// CHECK-NOT:     invoke
// ASM-O1-LABEL: test_lock:
// ASM-O1:         mov r1, #1
// ASM-O1:         jmp __p2_atomic_operation
void test_lock(void *ptr) {
    __builtin_p2_atomic_lock(ptr);
}

// CHECK-LABEL: define {{.*}}void @test_unlock(
// CHECK:         call void @__p2_atomic_operation(ptr {{.*}}, i32 2)
// CHECK-NOT:     invoke
// ASM-O1-LABEL: test_unlock:
// ASM-O1:         mov r1, #2
// ASM-O1:         jmp __p2_atomic_operation
void test_unlock(void *ptr) {
    __builtin_p2_atomic_unlock(ptr);
}
