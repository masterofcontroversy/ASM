.thumb

.macro blh to, reg
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

.equ RolllRNIfBattleStarted, 0x802A52D

@r5=Battle data, r6=Round attacker, r7=Battle buffer for this round (ldr value before using)
@Hooks at 802B4B0
TrollCrit:
    ldrh  r0, [r5, #0xC] @Get battle crit
    cmp   r0, #0
    beq   RollCrit
    cmp   r0, #3         
    bgt   RollCrit
    
    @Check faction
    ldrb  r2, [r6, #0xB]
    mov   r1, #0x80
    tst   r2, r1
    beq   RollCrit
    mov   r0, #100

    RollCrit:
    mov   r1, #0x0
    blh   RolllRNIfBattleStarted, r3
    lsl   r0, #0x18
    asr   r4, r0, #0x18

    ldr   r3, =0x802B4BA|1
    bx    r3

.align
.ltorg
