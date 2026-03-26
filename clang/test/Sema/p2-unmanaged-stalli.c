// RUN: %clang_cc1 -triple p2-none-elf -x c -fsyntax-only %s 2>&1 | FileCheck %s
// RUN: %clang_cc1 -triple p2-none-elf -x c -fsyntax-only -Wno-p2-unmanaged-stalli -verify %s

// The second RUN uses -verify; this directive asserts that suppression via
// -Wno-p2-unmanaged-stalli produces no diagnostics at all.
// expected-no-diagnostics

// Lowercase mnemonics must be warned.
void testStalliLower(void) {
    asm volatile("stalli");
    // CHECK: warning: direct use of 'stalli'
}

void testAllowiLower(void) {
    asm volatile("allowi");
    // CHECK: warning: direct use of 'allowi'
}

// Uppercase mnemonics must be warned (case-insensitive match).
void testStalliUpper(void) {
    asm volatile("STALLI");
    // CHECK: warning: direct use of 'STALLI'
}

void testAllowiUpper(void) {
    asm volatile("ALLOWI");
    // CHECK: warning: direct use of 'ALLOWI'
}

// Both mnemonics in a single asm string must each produce a diagnostic.
void testBothInOneAsm(void) {
    asm volatile("stalli\nallowi");
    // CHECK: warning: direct use of 'stalli'
    // CHECK: warning: direct use of 'allowi'
}

// Conditional-execution prefix must not suppress the warning.
void testStalliWithCondition(void) {
    asm volatile("if_c stalli");
    // CHECK: warning: direct use of 'stalli'
}

// Identifiers that contain the mnemonic as a substring must NOT be warned.
void testWordBoundaryLeft(void) {
    // 'mystalli' — left boundary violated, must be silent.
    asm volatile("mystalli");
    // CHECK-NOT: warning:{{.*}}mystalli
}

void testWordBoundaryRight(void) {
    // 'stalli2' — right boundary violated, must be silent.
    asm volatile("stalli2");
    // CHECK-NOT: warning:{{.*}}stalli2
}

// Suppression via -Wno-p2-unmanaged-stalli must silence all diagnostics.
// Verified by the second RUN line together with expected-no-diagnostics above.
void testSuppressed(void) {
    asm volatile("stalli");
    asm volatile("allowi");
}
