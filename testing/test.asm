MAIN:   
movf r0, #0x3F, #2
movf r1, #0xc,#1
orr r2, r0, r1

movf r3, #0x40,#2
movf r4, #2,#1
orr r5,r3,r4
FMUL_16 r7,r5,r2

FADD_16 r8,r5,r2

mov r0, #5
mov r1, #6
add r9, r0, r1