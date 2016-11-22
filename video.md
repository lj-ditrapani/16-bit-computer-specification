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


Video ROM
---------

There are two sets of Video ROM, built-in and custom.
The built-in Video ROM cannot be altered.
The custom video ROM is user-definable.
The custom Video ROM can only be set when loading the program;
it cannot be altered during program execution.

```
Words   Purpose   Description
-------------------------------------
   16   Color     16 8-bit colors
1,536   Tiles     256 tiles X 6 words

Total: 1,552
```

Video Ram
---------

```
Words   Purpose   Description
-------------------------------------
  640   Cells     32 X 20 cells X 1 word
    1   Enable    Enable flags
  380   Unused    N/A
```

Video ram memory addresses.

```
Seg    Purpose    Type      Decimal          Hex
--------------------------------------------------------
63     Cells      Output    64,512-65,151   $FC00-$FE7F
63     Enable     Output    65,152-65,152   $FE80-$FE80
63     Unused     Both      65,153-65,532   $FE81-$FFFC
```


Enable Flags
-----------------

```
bit     Purpose                  Symbol
---------------------------------------
1       Custom video ROM            (C)
0       Video output enable         (V)


 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|     14 Unused bits        |C|V|
---------------------------------
```

Enable bit 1: Custom video ROM

There is a video ROM with pre-defined tile set & colors.
If this bit is false, the built-in video ROM is used for the video graphics.
If it is true, the user-defined values in the custom ROM are used as the tile
set & colors.

Enable bit 0: Video output enable

If this bit is 0, the video screen displays all black pixels.


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
This system uses double buffering, so there are actually
two sets of 641 word video RAM.  The GPU renders one video RAM
while the CPU writes the next frame on the other video RAM.
At the end of each frame, the video RAM sets are swapped.
```
