// RUN: %clang_cc1 -triple p2-none-elf -fsyntax-only -verify %s

register int bad0 asm("c464");  // expected-error{{unknown register name 'c464' in asm}}
register int bad1 asm("C463");  // expected-error{{unknown register name 'C463' in asm}}
register int bad2 asm("x99");   // expected-error{{unknown register name 'x99' in asm}}
