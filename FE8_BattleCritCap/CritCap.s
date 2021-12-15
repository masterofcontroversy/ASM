.thumb

@called from 2ACA4
push {r14}
mov     r5,r2
add     r5,#0x6A

@Check if crit is greater than 100
cmp r1, #100
blt End
mov     r1, #100 @Make crit 100 if it's greater than 100
End:
strh    r1, [r5]
mov r4, #0x0
mov     r0,r2
add     r0,#0x48
pop {r3}
bx r3
