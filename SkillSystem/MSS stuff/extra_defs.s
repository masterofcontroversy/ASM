@to be copy-pasted into mss_defs.s

@Terrain defense getter
.macro GetUnitTerrainDefense
    ldr r0,=#0x203A4EC
    add r0, #0x56
    mov r1, #0x00
    ldrb r0, [r0, r1]
.endm

.macro draw_unit_terrain_defense_at, tile_x, tile_y
GetTerrainDefense
draw_number_at \tile_x, \tile_y
.endm
