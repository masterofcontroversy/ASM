.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

.equ CurrentUnitData, 0x3004E50
.equ TerrainCheck, MountedClassTable+4

.thumb

push {r4, r14}
ldr     r0,=CurrentUnitData
ldr     r0, [r0]
ldr     r1, [r0,#0xC] @Has moved
mov     r2, #0x40
and     r1, r2
cmp     r1, #0x0
bne EndFalse

ldr     r0,[r0, #0x4]
ldrb    r0,[r0, #0x4] @Class ID

ldr     r1,=MountedClassTable
mov     r3, #0x0

@Check if the current unit's class is a dismounted class
Loop:
lsl     r2, r3, #0x1
add     r2, r2, r1
ldrb    r4, [r2, #0x1]  @Mounted Class ID
ldrb    r2, [r2]        @Dismounted Class ID
cmp     r2, #0x0
beq EndFalse

cmp     r0, r2
beq DismountEnd

add     r3, #0x1
b Loop

EndFalse:
mov r0, #0x3
b End

DismountEnd:
mov     r0, r4
blh TerrainCheck

End:
pop {r4}
pop {r1}
bx r1

.align
.ltorg

MountedClassTable:
