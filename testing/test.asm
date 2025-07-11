MAIN:   
movf r0, #0x3F, #6
movf r1, #0xC, #5
orr r2, r0, r1

movf r3, #0x40,#6
movf r4, #2,#5
orr r5,r3,r4
fadd r6,r2,r5