// REQUIRES: p2-registered-target
// RUN: %clang_cc1 -triple p2-none-unknown-elf -ffreestanding \
// RUN:   -isystem %p2_sysroot_include -fsyntax-only -x c %s
// RUN: %clang_cc1 -triple p2-none-unknown-elf -ffreestanding \
// RUN:   -isystem %p2_sysroot_include -fsyntax-only -x c++ %s
// expected-no-diagnostics

#include <sys/p2_atomic.h>

#if !defined(__has_builtin) || !__has_builtin(__builtin_p2_atomic_lock)
#  error "__builtin_p2_atomic_lock not available"
#endif
#if !defined(__has_builtin) || !__has_builtin(__builtin_p2_atomic_unlock)
#  error "__builtin_p2_atomic_unlock not available"
#endif

_Static_assert(P2AtomicLock   == 1, "P2AtomicLock value mismatch");
_Static_assert(P2AtomicUnlock == 2, "P2AtomicUnlock value mismatch");
