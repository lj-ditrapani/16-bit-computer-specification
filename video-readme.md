<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
Video subsystem for LJD 16-bit computer
=======================================

Author:  Lyall Jonathan Di Trapani


Overview
--------

```
256 x 240 pixel screen
16 x 15 grid of large (16 x 16) tiles
32 x 30 text characters (8 x 8)
Colors are 8-bits with (3:3:2) RGB color format
Up to 64 simultaneous colors on screen per frame
```

3 tiles sets
- 64 large tiles (16 x 16, 2 bpp)
- 64 small tiles (8 x 8, 2 bpp)
- 128 text characters (8 x 8, 1 bpp)

4 layers
- Background cells (16 x 16, 4 colors)
- Text character cells (8 x 8, 1 color, color shared from background tile)
- 64 large sprites (16 x 16, 3 colors)
- 64 small sprites (8 x 8, 3 colors)


Video Ram
---------
```
4,096 Words (= 8 KB)

                   Words   Address Range   Description
------------------------------------------------------------------------
Large tiles        2,048   $F000-$F7FF     64 tiles X 32 words
Small tiles          512   $F800-$F9FF     64 tiles X 8 words
Text char tiles      512   $FA00-$FBFF     128 tiles X 4 words
Background cells     240   $FC00-$FCEF     16 X 15 cells X 1 word
Text cells           480   $FD00-$FEDF     32 X 30 cells X 0.5 words
Background colors     16   $FEE0-$FEEF     32 colors X 0.5 words
Sprite colors         16   $FEF0-$FEFF     32 colors X 0.5 words
Large sprites        128   $FF00-$FF7F     attribute data for 64 sprites
Small sprites        128   $FF80-$FFFF     attribute data for 64 sprites
------------------------------------------------------------------------
Total              4,096
```


Large Tiles
-----------
Each pixel in a tile is represented by 2-bits.
Each 2-bit value indexes into the selected four colors.

```
Size:  32 words
16 x 16 pixel tiles = 256 pixels
2-bits per pixel
Each word contains 8 pixels (a half-row)
For a given pixel in a tile, bit one selects the color pair,
and bit zero selects the color.
00 -> pair 0, color 0
01 -> pair 0, color 1
10 -> pair 1, color 0
11 -> pair 1, color 1
```


Small Tiles
-----------
Each pixel in a tile is represented by 2-bits.
Each 2-bit value indexes into the selected four colors.

```
Size:  8 words
8 x 8 pixel tiles = 64 pixels
2-bits per pixel
Each word contains a row of 8 pixels
For a given pixel in a tile, bit one selects the color pair,
and bit zero selects the color.
00 -> pair 0, color 0
01 -> pair 0, color 1
10 -> pair 1, color 0
11 -> pair 1, color 1
```


Text Character Tiles
--------------------
Each pixel in a tile is represented by 1 bit.
```
Size:  4 words
8 x 8 pixel tiles = 64 pixels
1 bit per pixel
Each word contains 16 pixels (2 rows)
If the pixel is 0, it is transparent,
if it is 1, it takes the 11 (pair 1, color 1) color of the background
tile on which it is placed.
```


Background Cells
----------------
```
Size:  1 word
Color pairs are indexed into the background colors (not the sprite colors)

                    # of bits
------------------------------------
Color pair 1 (cp1)  4
Color pair 2 (cp2)  4
X-flip              1
Y-flip              1
Large tile index    6
------------------------------------
Total              16 bits = 1 word


Layout of a grid cell in RAM:

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|  cp1  |  cp2  |X-Y| Tile Index|
---------------------------------
```

Each background tile in the grid cell can be flipped about the x axis or
the y axis.


Text Character Cells
--------------------

```
Size:  8 bits (1/2 word)
The cell indexes into the text character tiles.
The color of the character is taken from the 4th (11) color of the
background tile over which it is placed.

                    # of bits
------------------------------------
Text char tile index    7
On/off (O)              1
------------------------------------
Total              16 bits = 1 word

 7 6 5 4 3 2 1 0
-----------------
|O|  Tile Index |
-----------------
```


Large Sprites
-------------
```
Size:  2 words
Sprite data:

                    # of bits
------------------------------------
Color pair 1 (cp1)  4
Color pair 2 (cp2)  4
Mirror flip x (X)   1
Mirror flip y (Y)   1
Large tile index    6
Unused (U)          4
x position          4
On/off (O)          1
Unused (U)          3
y position          4
------------------------------------
Total              32 bits = 2 words


Layout of a sprite across 2 RAM cells:

 F E D C B A 9 8 7 6 5 4 3 2 1 0       F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------     ---------------------------------
|  cp1  |  cp2  |X|Y| Tile Index|     |   U   | x-pos |O|  U  | y-pos |
---------------------------------     ---------------------------------
```

Large sprites can be placed in any cell on a 16x15 grid.
Only one sprite is displayed per grid cell.
Therefore, there can be up to 16 large sprites displayed on the same
row.

Small Sprites
-------------
```
Size:  2 words
Sprite data:

                    # of bits
------------------------------------
Color pair 1 (cp1)  4
Color pair 2 (cp2)  4
Mirror flip x (X)   1
Mirror flip y (Y)   1
Small tile index    6
Unused (U)          3
x position          5
On/off (O)          1
Unused (U)          2
y position          5
------------------------------------
Total              32 bits = 2 words


Layout of a sprite across 2 RAM cells:

 F E D C B A 9 8 7 6 5 4 3 2 1 0       F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------     ---------------------------------
|  cp1  |  cp2  |X|Y| Tile Index|     |  U  |  x-pos  |O| U |  y-pos  |
---------------------------------     ---------------------------------
```

Small sprites can be placed in any cell on a 32x30 grid.
Only one sprite is displayed per grid cell.
Therefore, there can be up to 32 small sprites displayed on the same
row.

Colors Pairs
------------
```
There are 2 sets of color pairs:  background and sprite
Each set has 32 colors arranged in 16 pairs
16 x 2 x 8-bit colors
4-bit color pair index
```

Colors
------
```
A color is 8 bits in a 3-3-2 RGB format.

R Red color component
G Green color component
B Blue color component

Layout of a color

 7 6 5 4 3 2 1 0
-----------------
|R R R|G G G|B B|
-----------------
```


Double Buffering
----------------
```
This system uses double buffering, so there is actually
two sets of 4,096 words.  The GPU renders one video RAM
while the CPU writes the next frame on the other video RAM.
At the end of each frame, the video RAM sets are swapped.
```
