# Initialize ram($C000) = 0
WRD $0000 R0
WRD $C000 R7
STR R0 R7
END

(main)
# If ram($C000) == 0, then we should initialize system, else do nothing
WRD $C000 R7
LOD R7 R0
WRD init R6
BRV R0 Z R6
# Normally, your game loop would go here
# Check the status register to see which I/O register buffer to use (1 or 2).
# Check the gamepad input from the active I/O register
# Update game state based on input
# Update tile cells based on new state
END

(init)
# Copy colors over to background-palette 0
WRD $F800 R7
WRD $0001 R1
(color-loop)
WRD colors R6
WRD background-palettes R5
ADD R7 R5 R7
LOD R6 R0
STR R0 R7
ADI R6 1 R6
ADI R7 1 R7
LOD R6 R0
STR R0 R7
SBI R1 1 R1
WRD color-loop R3
BRV R1 Z R3
# Set ram($C000) = 1 so we don't run initialization again
WRD $0001 R0
WRD $C000 R7
STR R0 R7
END



(colors)
#    Dark blue | Magenta
.word %00000001_00110011
#         Cyan | White
.word %00001111_00101111

# A blank tile
(blank-tile)
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000
.word %0000000000000000

# The letter H
(h-tile)
.word %0011110000111100
.word %0011110000111100
.word %0011110000111100
.word %0011111111111100
.word %0011111111111100
.word %0011110000111100
.word %0011110000111100
.word %0000000000000000

# The letter I
(i-tile)
.word %0011111111111100
.word %0000001111000000
.word %0000001111000000
.word %0000001111000000
.word %0000001111000000
.word %0000001111000000
.word %0011111111111100
.word %0000000000000000
