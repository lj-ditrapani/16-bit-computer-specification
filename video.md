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
- Up to 16 simultaneous colors on screen


Video Ram
---------

```
Words   Purpose   Description
-------------------------------------
  640   Cells     32 X 20 cells X 1 word
  128   Unused    N/A
   16   Color     16 8-bit colors
  496   Unused    N/A
1,536   Tiles     256 tiles X 6 words
```

Video ram memory addresses.

```
Seg    Purpose    Type      Decimal          Hex
--------------------------------------------------------
61     Cells      Output    62,720-63,359   $F500-$F77F
61     Unused     Both      63,360-63,487   $F780-$F7FF
62     Color      None      63,488-63,503   $F800-$F80F
62     Unused     None      63,504-63,999   $F810-$F9FF
62-63  Tiles      None      64,000-65,535   $FA00-$FFFF
```

The tile set and color palette are not accessible during run time by the CPU.
The section of RAM reserved for the tile set and color palette is not
readable or writeable.


Character Tile
--------------

```
Size:  6 words
8 x 12 pixel tiles = 96 pixels
1 bit per pixel (1 bpp)
Each word contains 16 pixels (2 rows)
If the pixel is 0, it takes the background color of the cell.
The color indexes are 0 based.
If it is 1, it takes the foreground color of the cell.
The tile index is 0 based.
```


Character Cell
--------------

```
Size:  1 word
The tile index indexes into the character tile set.
Color value indexes index into the color palette.

                        # of bits
------------------------------------
Background color index  4
Foreground color index  4
Tile index              6
------------------------------------
Total              16 bits = 1 word


Layout of a grid cell in RAM:

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|  BGC  |  FGC  |  Tile Index   |
---------------------------------
```


Color Palette
-------------

```
The color palette contains the 16 colors chosen from the 256
available 8-bit colors.  The character cells' background and foreground
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
two sets of 640 word video RAM.  The GPU renders one video RAM
while the CPU writes the next frame on the other video RAM.
At the end of each frame, the video RAM sets are swapped.
```
