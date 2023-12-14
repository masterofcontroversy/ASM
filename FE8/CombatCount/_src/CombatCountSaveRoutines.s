.thumb

@ This defines two functions to be used with EMS block declarations:
@ - SU_SaveCombatCount, the saving function
@ - SU_LoadCombatCount, the loading function

@ This EMS module is probably simple enough that you can use this as example
@ If you ever need to write your own.

WriteAndVerifySramFast = 0x080D184C+1
ReadSramFastAddr       = 0x030067A0   @ pointer to the actual ReadSramFast function

.global SU_SaveCombatCount
.type SU_SaveCombatCount, %function

@Arguments:
@ r0=Target address (SRAM)
@ r1=Target size
SU_SaveCombatCount:
    ldr r3, =WriteAndVerifySramFast

    mov r2, r1 @ WriteAndVerifySramFast arg r2 = size
    mov r1, r0 @ WriteAndVerifySramFast arg r1 = target address

    ldr r0, =CombatCountTablePointers
    ldr r0, [r0] @ WriteAndVerifySramFast arg r0 = source address

    bx  r3

.align

.global SU_LoadCombatCount
.type SU_LoadCombatCount, %function

SU_LoadCombatCount:
	ldr r3, =ReadSramFastAddr
	ldr r3, [r3] @ r3 = ReadSramFast

	mov r2, r1   @ ReadSramFast arg r2 = size
	@ implied    @ ReadSramFast arg r0 = source address

	ldr r1, =CombatCountTablePointers
    ldr r1, [r1] @ ReadSramFast arg r1 = target address

	bx  r3

.align
.ltorg

