//For using the first type/aid icon in Modular Stat Screen
//Place this in the mss_defs.s file before use
.macro draw_second_aid_icon_at tile_x, tile_y
  mov     r0, r8
  blh     GetUnitSecondAidIconId
  mov     r1, #3 @sheet ID
  lsl     r1, r1, #8 @shifted 8 bits left
  orr     r1, r0
  mov     r2, #0xA0
  lsl     r2, #7
  ldr     r0, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
  blh     DrawIcon
.endm

//For using the second type/aid icon in Modular Stat Screen
//Place this in the mss_defs.s file before use
.macro draw_second_aid_icon_at tile_x, tile_y
  mov     r0, r8
  blh     GetUnitSecondAidIconId
  mov     r1, #3 @sheet ID
  lsl     r1, r1, #8 @shifted 8 bits left
  orr     r1, r0
  mov     r2, #0xA0
  lsl     r2, #7
  ldr     r0, =(tile_origin+(0x20*2*\tile_y)+(2*\tile_x))
  blh     DrawIcon
.endm
