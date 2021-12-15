.thumb

@called from 2ACA4
push {r14}
mov     r5,r2
add     r5,#0x6A

@Check if crit is greater than 100
cmp r1, #100
blt Continue
mov     r1, #100 @Make crit 100 if it's greater than 100
strh    r1,[r5]

pop {r0}
bx r0
