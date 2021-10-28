.thumb

@called from 1D248

@Canto check
push    {r14}
ldr     r2,=0x3004E50
ldr     r3, [r2]        @Getting unit data
ldr     r0, [r3]
ldr     r1, [r3, #0x4]
ldr     r0, [r0, #0x28] @Unit abilities
ldr     r1, [r1, #0x28] @Class abilities
orr     r0, r1
mov     r1, #0x21
lsl     r1, #0x6        @Canto and on ballista bits
mov     r4, r2
and     r0, r1
pop {r1}
bx r1

.ltorg
.align
