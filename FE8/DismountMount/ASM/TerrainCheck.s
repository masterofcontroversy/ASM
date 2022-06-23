.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

.equ ActionStruct, 0x203A958
.equ CurrentUnitData, 0x3004E50
.equ GetTrueTerrainAt, 0x8019AF5

.thumb

TerrainCheck:
push {r4, r14}

mov     r4, r0

@Get terrain ID
ldr     r0,=ActionStruct
ldrb    r1, [r0, #0xF]
ldrb    r0, [r0, #0xE]
blh GetTrueTerrainAt

@Get class' move cost table
@ldr     r1,=CurrentUnitData
@ldr     r1,[r1]
@ldr     r1,[r1, #0x4]

ldr     r1,=ClassTable

mov     r2, #84
mul     r2, r4 @multiply ID by length of the entries
add     r2, #0x38 @Move cost table location
add     r1, r2
ldr     r2, [r1]

@Reference terrain ID in move table
ldrb    r0, [r2, r0]

cmp r0, #0xFF
beq EndFalse
mov r0, #0x0
b End

EndFalse:
mov r0, #0x3

End:
pop {r4}
pop {r1}
bx r1

.align
.ltorg

ClassTable:
