.thumb

.equ DefaultValue, ExpActionList+0x4

.equ gActionData, 0x203A958

.equ ReturnAddress, 0x802C6D8

.global GetExpByAction
.type GetExpByAction, %function

@Hooks 802C6C8
@r4=BattleUnit pointer
GetExpByAction:
    @Get ready for loop
    ldr  r3, ExpActionList
    ldr  r2, =gActionData
    ldrb r2, [r2, #0x11] @Action taken
    mov  r1, #0x0 @Counter

    Loop:
    ldrb r0, [r3, r1] @ExpActionListEntry.action
    cmp  r0, #0x0
    beq  UseDefault
        cmp  r0, r2
        beq  MatchFound
            add  r1, #0x2
            b    Loop
        
    MatchFound:
    add  r1, #0x1
    ldrb r0, [r3, r1] @ExpActionListEntry.expValue
    b    StoreExp

    UseDefault:
    ldr  r0, DefaultValue

    @Store exp value
    StoreExp:
    mov  r1, #0x6E
    strb r0, [r4, r1] @BattleUnit.expGain
    ldrb r1, [r4, #0x9] @BattleUnit.exp
    add  r1, r0
    strb r1, [r4, #0x9]

    @Put BattleUnit pointer in r0 for CheckForLevelUp call
    mov  r0, r4

    ldr  r3, =ReturnAddress|1
    bx   r3

.align
.ltorg

ExpActionList:
@POIN ExpActionList
@WORD DefaultValue

