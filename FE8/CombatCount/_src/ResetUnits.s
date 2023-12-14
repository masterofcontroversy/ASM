	.cpu arm7tdmi
	.arch armv4t
	.fpu softvfp
	.eabi_attribute 20, 1	@ Tag_ABI_FP_denormal
	.eabi_attribute 21, 1	@ Tag_ABI_FP_exceptions
	.eabi_attribute 23, 3	@ Tag_ABI_FP_number_model
	.eabi_attribute 24, 1	@ Tag_ABI_align8_needed
	.eabi_attribute 25, 1	@ Tag_ABI_align8_preserved
	.eabi_attribute 26, 1	@ Tag_ABI_enum_size
	.eabi_attribute 30, 2	@ Tag_ABI_optimization_goals
	.eabi_attribute 34, 0	@ Tag_CPU_unaligned_access
	.eabi_attribute 18, 4	@ Tag_ABI_PCS_wchar_t
	.file	"ResetUnits.c"
@ GNU C17 (devkitARM release 62) version 13.2.0 (arm-none-eabi)
@	compiled by GNU C version 8.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.18-GMP

@ GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
@ options passed: -mcpu=arm7tdmi -mthumb -mthumb-interwork -mtune=arm7tdmi -mlong-calls -march=armv4t -O2
	.text
	.align	1
	.p2align 2,,3
	.global	InitFactionCombatCounts
	.syntax unified
	.code	16
	.thumb_func
	.type	InitFactionCombatCounts, %function
InitFactionCombatCounts:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}	@
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:8:     for (i = gChapterData.currentPhase + 1; i < gChapterData.currentPhase + 0x40; ++i) {
	ldr	r5, .L12	@ tmp134,
	ldrb	r4, [r5, #15]	@ tmp124,
	ldr	r6, .L12+4	@ tmp133,
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:12:             SetCombatCount(unit, 0);
	ldr	r7, .L12+8	@ tmp135,
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:8:     for (i = gChapterData.currentPhase + 1; i < gChapterData.currentPhase + 0x40; ++i) {
	adds	r4, r4, #1	@ i,
.L3:
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:9:         Unit* unit = GetUnit(i);
	lsls	r0, r4, #24	@ tmp126, i,
	lsrs	r0, r0, #24	@ tmp125, tmp126,
	bl	.L14		@
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:11:         if (UNIT_IS_VALID(unit)) {
	cmp	r0, #0	@ unit,
	beq	.L2		@,
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:11:         if (UNIT_IS_VALID(unit)) {
	ldr	r3, [r0]	@ unit_14->pCharacterData, unit_14->pCharacterData
	cmp	r3, #0	@ unit_14->pCharacterData,
	beq	.L2		@,
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:12:             SetCombatCount(unit, 0);
	movs	r1, #0	@,
	bl	.L15		@
.L2:
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:8:     for (i = gChapterData.currentPhase + 1; i < gChapterData.currentPhase + 0x40; ++i) {
	ldrb	r3, [r5, #15]	@ tmp131,
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:8:     for (i = gChapterData.currentPhase + 1; i < gChapterData.currentPhase + 0x40; ++i) {
	adds	r4, r4, #1	@ i,
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:8:     for (i = gChapterData.currentPhase + 1; i < gChapterData.currentPhase + 0x40; ++i) {
	adds	r3, r3, #63	@ tmp132,
	cmp	r3, r4	@ tmp132, i
	bge	.L3		@,
@ /home/myles/Ozmas_Prophecy/EngineHacks/ASM/EvasionDecay/_src/ResetUnits.c:15: }
	@ sp needed	@
	pop	{r3, r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L13:
	.align	2
.L12:
	.word	gChapterData
	.word	GetUnit
	.word	SetCombatCount
	.size	InitFactionCombatCounts, .-InitFactionCombatCounts
	.ident	"GCC: (devkitARM release 62) 13.2.0"
	.code 16
	.align	1
.L14:
	bx	r6
.L15:
	bx	r7
