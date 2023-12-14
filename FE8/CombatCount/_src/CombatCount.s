.thumb

.macro blh to, reg
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

.equ memset,       0x80D1C6D
.equ gBattleStats, 0x203A4D4

.global GetCombatCountEntry
.type GetCombatCountEntry, %function

@r0=Unit pointer
@Returns pointer to combat count table entry
GetCombatCountEntry:
    ldrb r0, [r0, #0xB]
    lsr  r1, r0, #0x6   @Get unit allegiance
    mov  r2, #0x3F
    and  r0, r2         @Get unit index
    lsr  r0, #0x1       @Halve index

    @r0 = CombatCount table entry ID
    @r1 = Unit allegiance
    
    ldr  r3, =CombatCountTablePointers
    lsl  r1, #0x2 @Multiply by 4
    ldr  r1, [r3, r1] @Get pointer to correct table
    
    add  r0, r1 @CombatCount entry

    bx   lr

.align

.global GetCombatCount
.type GetCombatCount, %function

@r0=Unit pointer
@Returns combat count
GetCombatCount:
    push {r4, lr}
    mov  r4, r0
    bl   GetCombatCountEntry
    ldrb r0, [r0]
    
    @Check if using high or low nybble
    ldrb r1, [r4, #0xB]
    lsl  r1, #0x1F
    cmp  r1, #0x0
    bne  GetCombatCount.LowNybble
        lsr r0, #0x4
        b   GetCombatCount.End
        
    GetCombatCount.LowNybble:
    mov  r1, #0xF
    and  r0, r1
    
    GetCombatCount.End:
    pop  {r4}
    pop  {r1}
    bx   r1

.global SetCombatCount
.type SetCombatCount, %function

@r0=Unit pointer, r1=Amount to set
SetCombatCount:
    push {r4-r5, lr}
    mov  r4, r0
    mov  r5, r1
    bl   GetCombatCountEntry
    ldrb r3, [r0]
    
    @r0 = CombatCount Entry address
    @r3 = CombatCount entry byte
    
    @Check if using high or low nybble
    ldrb r1, [r4, #0xB]
    lsl  r1, #0x1F
    cmp  r1, #0x0
    bne  SetCombatCount.LowNybble
        mov  r1, #0xF
        and  r1, r3   @Preserve low nybble value
        lsl  r5, #0x4 @Move number to high nybble
        orr  r5, r1   @Combine both nybbles
        b    SetCombatCount.End
        
    SetCombatCount.LowNybble:
    mov  r1, #0xF0
    and  r1, r3       @Preserve high nybble value
    add  r5, r1       @Add amount to set to byte since lower nybble is empty
    
    SetCombatCount.End:
    strb r5, [r0]
    pop  {r4-r5}
    pop  {r0}
    bx   r0

.align

.global AddCombatCount
.type AddCombatCount, %function

@r0=Unit pointer, r1=Number to add
AddCombatCount:
    push {r4-r5, lr}
    mov  r4, r0
    mov  r5, r1
    bl   GetCombatCount
    add  r1, r0, r5
    mov  r0, r4
    bl   SetCombatCount
    pop  {r4-r5}
    pop  {r0}
    bx   r0

.align

.global ClearAllCombatCount
.type ClearAllCombatCount, %function
 
 ClearAllCombatCount:
    push {lr}
    ldr  r0, =CombatCountTablePointers
    ldr  r0, [r0] @Start of table
    
    mov  r1, #0x0 @Value to write
    
    ldr  r2, =CombatCountTableSizeLink
    ldr  r2, [r2] @Amount of bytes to write
    
    ldr  r3, =memset
    mov  lr, r3
    .short 0xF800

    pop  {r0}
    bx   r0

.global CombatCountPostBattle
.type CombatCountPostBattle, %function

CombatCountPostBattle:
    push {lr}
    ldr  r0, =gActionData
    ldrb r1, [r0, #0x11] @r1 = gActionData.unitActionType
    cmp  r1, #0x01
    ble  CombatCountPostBattle.End
    cmp  r1, #0x03
    bgt  CombatCountPostBattle.End

    ldrb r0, [r0, #0xD]  @r0 = gActionData.subjectIndex
    blh  GetUnit, r1
    mov  r1, #1
    bl   AddCombatCount

    CombatCountPostBattle.End:
    pop  {r0}
    bx   r0

.global CombatCountResetWrapper

.equ ResetWrapperReturn, 0x8015442|1

CombatCountResetWrapper:
    bl   InitFactionCombatCounts
    ldr  r0, =ResetWrapperReturn
    bx   r0
