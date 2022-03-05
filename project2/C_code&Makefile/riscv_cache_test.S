# # .include "user_define.h"
.globl _start
# .local _start
# .align 13
.section .text
_start:
     addi   x2,zero,0x20
     add    x3,x2,x2
     add    x4,x3,x3
     li     x5, 0x00010100
     li     x6, 0x00018100
     li     x7, 0x00014100
     sw     x2, 0x0(x5)
     sw     x2, 0x4(x5)
     sw     x2, 0x8(x5)
     sw     x2, 0xc(x5)
     sw     x2, 0x10(x5)
     sw     x2, 0x14(x5)
     sw     x2, 0x18(x5)
     sw     x2, 0x1c(x5)
     sw     x2, 0x20(x5)
     sw     x2, 0x24(x5)
     sw     x2, 0x28(x5)
     sw     x2, 0x2c(x5)
     sw     x3, 0x0(x5)
     sw     x4, 0x0(x6)
     sw     x4, 0x0(x7)
     lw     x2, 0x0(x5)
