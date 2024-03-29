# 1st frame, so jump to one-time initialization code
WRD init RF
JMP RF

[io-ram]
WRD display RF
JMP RF

[main]
# Not 1st frame.  On 2nd or later frame.
# Normally, your game loop would go here
# Check the gamepad input from the active I/O register
# Update game state based on input
# Update tile cells based on new state
END

(init)
.const first_frame_flag $8000
WRD first_frame_flag RF
WRD 1 R1
STR R1 RF
END

(display)
WRD first-frame RF
WRD first_frame_flag RE
LOD RE R1
BRV R1 P RF
END

(first-frame)
# Register names
.const dataR 2
.const counter 3
.const temp 4
.const from_addr 6
.const to_addr 7
.const func 8
.const loop 9
.const return $A
# Clear first_frame_flag
ZER R1
STR R1 RE
# Set frame skip to 0 (run at 60 fps)
WRD frame_skip RE
STR R1 RE
# Set serial I/O command to 'do nothing' (cassette/hubLink)
WRD cassette RE
STR R1 RE
# Mute audio
WRD audio RE
STR R1 RE
INC RE
STR R1 RE
INC RE
STR R1 RE
INC RE
STR R1 RE
INC RE
STR R1 RE
# Copy colors over to background_palette 0
WRD colors from_addr
WRD background_palettes to_addr
LOD from_addr dataR
STR dataR to_addr
INC from_addr
INC to_addr
LOD from_addr dataR
STR dataR to_addr
# set color cells to all 0
WRD 200 counter
WRD color_cells_loop loop
WRD color_cells to_addr
(color_cells_loop)
STR R0 to_addr
INC to_addr
DEC counter
BRV counter P loop
# set tile cells to all 0
WRD 750 counter
WRD tile_cells_loop loop
WRD tile_cells to_addr
(tile_cells_loop)
STR R0 to_addr
INC to_addr
DEC counter
BRV counter P loop
# Write HI in middle of screen (screen is 30 x 25 cells)
# We will write HI at row 12, col 13 = tile cell 373
# 30 * 12 + 13 = 373
WRD 373 temp
WRD tile_cells to_addr
ADD temp to_addr
# ASCII letter H (72 = $48)
WRD $48 dataR
STR dataR to_addr
# ASCII letter I (73 = $49)
INC to_addr
INC dataR
STR dataR to_addr

# set tiles 0 = blank, ascii H, I
WRD write_tile func

# set source & dest registers for blank tile
WRD blank_tile from_addr
WRD background_tiles to_addr
SPC return
JMP func

# set source & dest registers for H tile
WRD h_tile from_addr
# ascii H = 72
# $F000 + (8 * 72) = 62016 = $F240
WRD $F240 to_addr
SPC return
JMP func

# set source & dest registers for I tile
WRD i_tile from_addr
# ascii I = 73
# $F000 + (8 * 73) = 62024 = $F248
WRD $F248 to_addr
SPC return
JMP func

END

# Expects from_addr register to be set to source address (tile in ROM)
# Expects to_addr register to be set to destination address (tile in RAM)
(write_tile)
# writes tile data from ROM to tile set RAM
ADI R0 8 counter
WRD tile_loop loop
(tile_loop)
LOD from_addr dataR
STR dataR to_addr
INC from_addr
INC to_addr
DEC counter
BRV counter NP loop
JMP return

(colors)
#    Dark blue | Magenta
.word %00000001_00110011
#         Cyan | White
.word %00001111_00101111

# A blank tile
(blank_tile)
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000

# The letter H
(h_tile)
.word %0011110000111100
.word %0011110000111100
.word %0011110000111100
.word %0011111111111100
.word %0011111111111100
.word %0011110000111100
.word %0011110000111100
.word %0000000000000000

# The letter I
(i_tile)
.word %0011111111111100
.word %0000001111000000
.word %0000001111000000
.word %0000001111000000
.word %0000001111000000
.word %0000001111000000
.word %0011111111111100
.word %0000000000000000
