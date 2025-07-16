for:
mov r6,r2
fmul r6, r6,r3

mov r7,r1
fmul r7,r7,r4
mov r8,r2
fmul r8, r8, r5

fadd r7, r7, r8
fmul r7, r7, r3

fadd r1, r1, r6
fadd r2, r2, r7
subs r0, r0, #1
beq end_for
b for

end_for: