.thumb

.equ GetTrueTerrainAt, 0x8019AF5
.equ TerrainTable, 0x880C4BA @non-flier terrain data table

.macro GetTerrainDefense, tile_x, tile_y
    mov r0, #\tile_x @ X
    mov r1, #\tile_y @ Y
    ldr r3,=GetTrueTerrainAt
    mov lr, r3
    .short 0xF800
    ldr r2,=TerrainTable
    ldrb r0, [r2, r0]
.endm

.macro draw_terrain_defense_at, tile_x, tile_y, sstile_x sstile_y
GetTerrainDefense \tile_x, \tile_y
draw_number_at \sstile_x, \sstile_y
.endm

.ltorg
.align
