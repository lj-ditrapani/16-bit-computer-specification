# Initialize ram($C000) = 0
.const has_initialized $C000
WRD $0000 R0
WRD has_initialized R7
STR R0 R7
END

[main]
# If ram($C000) == 0, then we should initialize system, else do nothing
WRD has_initialized R7
LOD R7 R1
WRD init R6
BRV R1 Z R6
# Normally, your game loop would go here
# Check the status register to see which I/O register buffer to use (1 or 2).
# Check the gamepad input from the active I/O register
# Update game state based on input
# Update tile cells based on new state
END

(init)
# Register names
.const screen_count 1
.const dataR 2
.const counter 3
.const temp 4
.const io_registers 5
.const from_addr 6
.const to_addr 7
.const func 8
.const loop 9
.const return $A
WRD io_registers_1 io_registers
WRD $0002 screen_count
(screen_setup)
# Copy colors over to background_palette 0
WRD colors from_addr
WRD background_palettes to_addr
ADD io_registers to_addr to_addr
LOD from_addr dataR
STR dataR to_addr
INC from_addr
INC to_addr
LOD from_addr dataR
STR dataR to_addr
# set color cells to all 0
WRD 52 counter
WRD color_cells_loop loop
WRD color_cells to_addr
ADD io_registers to_addr to_addr
(color_cells_loop)
STR R0 to_addr
INC to_addr
DEC counter
BRV counter NP loop
# set tile cells to all 0
WRD 750 counter
WRD tile_cells_loop loop
WRD tile_cells to_addr
ADD io_registers to_addr to_addr
(tile_cells_loop)
STR R0 to_addr
INC to_addr
DEC counter
BRV counter NP loop
# Write HI in middle of screen (screen is 30 x 25 cells)
# 30 * 12 + 13 = 373
WRD 373 temp
WRD tile_cells to_addr
ADD io_registers to_addr to_addr
ADD temp to_addr
# ASCII letter H
WRD $48 dataR
STR dataR to_addr
# ASCII letter I
INC to_addr
INC dataR
STR dataR to_addr
# Repeat for io_registers_2 (unless we just did 2nd run)
DEC screen_count
WRD io_registers_2 io_registers
WRD screen_setup func
BRV screen_count NP func

# set tiles 0 = blank, ascii H, I
WRD write_tile func

# set source & dest registers for blank tile
WRD blank_tile from_addr
CPY tiles to_addr
SPC return
JMP func

# set source & dest registers for H tile
WRD blank_tile from_addr
# ascii H = 72
# $F000 + (8 * 72) = 62016
WRD 62016 to_addr
SPC return
JMP func

# set source & dest registers for I tile
WRD blank_tile from_addr
# ascii I = 73
# $F000 + (8 * 73) = 62024
WRD 62024 to_addr
SPC return
JMP func

# Set ram($C000) = 1 so we don't run initialization again
ADI R0 1 dataR
WRD has_initialized to_addr
STR dataR to_addr
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
