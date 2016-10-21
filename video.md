<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
Video subsystem for LJD 16-bit computer
=======================================

Author:  Lyall Jonathan Di Trapani


Overview
--------

- 256 x 240 pixel screen
- 256 character tile set (8 x 12, 1 bpp)
- 32 x 20 character cells per frame (2 colors)
- Colors are 8-bits with (3:3:2) RGB color format
- Up to 16 simultaneous colors on screen per frame


Video Rom
---------

A tile is 96 pixels and uses 1 bit per pixel (bpp).
The tile set lives in the video section of rom.
The tile set occupies 1,536 words (256 tiles x 6 words).

```
                   Words   Address Range   Description
------------------------------------------------------------------------
Tiles              1,536   $FA00-$FFFF     256 tiles X 6 words
```


Video Ram
---------

```
                   Words   Address Range   Description
------------------------------------------------------------------------
Cells                640   $F000-$F27F     32 X 20 cells X 1 word
Colors                16   $F280-$F28F     16 8-bit colors
```


Character Tile set
------------------

Each pixel in a tile is represented by 1 bit.

```
Size:  6 words
8 x 12 pixel tiles = 96 pixels
1 bit per pixel (1 bpp)
Each word contains 16 pixels (2 rows)
If the pixel is 0, it takes the background color of the cell.
If it is 1, it takes the forground color of the cell.
```


Character Cell
--------------
```
Size:  1 word
Color value indexes index into the color palette.

                        # of bits
------------------------------------
Background color index  4
Forground color index   4
Tile index              6
------------------------------------
Total              16 bits = 1 word


Layout of a grid cell in RAM:

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|  BGC  |  FGC  |  Tile Index   |
---------------------------------
```


Colors
------

```
The color pallette contains the 16 colors chosen from the 256
available 8-bit colors.  The character cells' background and forground
color number indexes into the list of 16 colors.
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
