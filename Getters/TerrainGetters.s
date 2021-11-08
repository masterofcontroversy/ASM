.thumb

.equ GetTrueTerrainAt, 0x8019AF5

@non-flier terrain data tables
.equ TerrainDefTable, 0x880C4BA
.equ TerrainAvoidTable, 0x880C479
.equ TerrainResTable, 0x80C4FB
.equ TerrainHealTable, 0x880C744
.equ TerrainInfoDisplayTable, 0x880B90C

.macro GetTerrainDefense, tile_x, tile_y
    mov r0, #\tile_x @ X
    mov r1, #\tile_y @ Y
    ldr r3,=GetTrueTerrainAt
    mov lr, r3
    .short 0xF800
    ldr r2,=TerrainDefTable
    ldrb r0, [r2, r0]
.endm

.macro GetTerrainAvoid, tile_x, tile_y
    mov r0, #\tile_x @ X
    mov r1, #\tile_y @ Y
    ldr r3,=GetTrueTerrainAt
    mov lr, r3
    .short 0xF800
    ldr r2,=TerrainAvoidTable
    ldrb r0, [r2, r0]
.endm

.macro GetTerrainResistance, tile_x, tile_y
    mov r0, #\tile_x @ X
    mov r1, #\tile_y @ Y
    ldr r3,=GetTrueTerrainAt
    mov lr, r3
    .short 0xF800
    ldr r2,=TerrainResTable
    ldrb r0, [r2, r0]
.endm

@MSS text draw macros
.macro draw_terrain_defense_at, tile_x, tile_y, sstile_x sstile_y
GetTerrainDefense \tile_x, \tile_y
draw_number_at \sstile_x, \sstile_y
.endm

.macro draw_terrain_avoid_at, tile_x, tile_y, sstile_x sstile_y
GetTerrainAvoid \tile_x, \tile_y
draw_number_at \sstile_x, \sstile_y
.endm

.macro draw_terrain_resistance_at, tile_x, tile_y, sstile_x sstile_y
GetTerrainResistance \tile_x, \tile_y
draw_number_at \sstile_x, \sstile_y
.endm

.ltorg
.align
