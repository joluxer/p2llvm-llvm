// RUN: %clang_cc1 -triple p2-none-elf -fsyntax-only %s
// RUN: %clang_cc1 -triple p2-none-elf -fsyntax-only -x c++ %s

// ABI register file: r0–r31
register int r0  asm("r0");
register int r31 asm("r31");

// Named special registers
register int ptra asm("ptra");
register int ptrb asm("ptrb");
register int dira asm("dira");
register int dirb asm("dirb");
register int outa asm("outa");
register int outb asm("outb");
register int ina  asm("ina");
register int inb  asm("inb");
register int pa   asm("pa");
register int pb   asm("pb");

// Interrupt registers
register int ijmp1 asm("ijmp1");
register int iret1 asm("iret1");

// COG-RAM general-purpose file: Grenzen
register int c0   asm("c0");    // unterste Grenze
register int c462 asm("c462");  // höchste allokierbare

// P2_COG_ATOMIC_ISR_FLAG: reserviert, nicht allokierbar, aber namentlich gültig
register int c463 asm("c463");
