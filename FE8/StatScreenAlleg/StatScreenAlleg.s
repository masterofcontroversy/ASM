.thumb

.equ EnemyPal, PlayerPal+4
.equ NPCPal,   PlayerPal+8
.equ OtherPal, PlayerPal+12

.equ GetUnit,       0x8019431
.equ gGameState,    0x202BCB0
.equ gActiveUnitId, 0x202BE44
.equ gUnitMap,      0x202E4D8

@fetches the appropriate palette based on unit allegiance and returns to 80885a4

ldr  r2,=gGameState
ldrh r0,[r2,#0x14] @xcoord
ldrh r1,[r2,#0x16] @ycoord
bl   GetUnitFromCoords
cmp  r0,#0
bne  CheckAlleg
ldr  r1,=gActiveUnitID
ldrb r0,[r1]

CheckAlleg:
mov  r1,#0xC0
and  r1,r0
ldr  r0,PlayerPal
cmp  r1,#0
beq  End @If player unit, we're done

CheckNPC:
cmp  r1,#0x40
bne  CheckEnemy
ldr  r0,NPCPal
b    End

CheckEnemy:
cmp  r1,#0x80
bne  CheckOther
ldr  r0,EnemyPal
b    End

CheckOther:
cmp  r1,#0xC0
bne  End
ldr  r0,OtherPal

End:
mov  r1,#0xc0
lsl  r1,#1
mov  r2,#0x80
ldr  r3,=0x80885a4|1
bx   r3

GetUnitFromCoords:
@gets deployment number, given r0=x and r1=y
ldr  r2,=gUnitMap
ldr  r2,[r2]
lsl  r1,#2 @y*4
add  r1,r2 @row address
ldr  r1,[r1]
ldrb r0,[r1,r0]
bx   lr

.align
.ltorg

PlayerPal:
@POIN PlayerPal
@POIN EnemyPal
@POIN NPCPal
@POIN OtherPal
