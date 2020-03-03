<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
Video subsystem for LJD 16-bit computer
=======================================

Author:  Lyall Jonathan Di Trapani


Overview
--------

The Video Display Processor (VDP) is responsible
for generating the video signal.

- 240 x 200 pixel screen
- Tile set: 256 tiles (8 x 8, 2 bpp)
- 2 layers:
    - Background layer: 30 x 25 cells per frame
    - Foreground layer: 30 x 25 cells per frame
- Colors are 6-bits with (2:2:2) RGB color format
- Up to 64 simultaneous colors on screen


Video RAM
---------

```
Words   Purpose         Description
----------------------------------------------------------------
   32   Colors              64 8-bit colors; 16 groups of 4 colors
   64   Color set indexes   256 large tile color indexes; 4 bits per index
  375   Foreground Cells    30 x 25 cells x 0.5 word
  375   Background Cells    30 x 25 cells x 0.5 word
2,048   Tiles               256 8 x 8 2 bpp tiles (8 W / tile)

Total: 2,894 words
```

Video ram memory addresses.

```
Purpose                 Decimal          Hex
---------------------------------------------------------------------
Color sets              .............   $FC40-$FC7F
Background Cells        .............   $FD00-$FDF7
Foreground Cells        .............   $FD80-$FDF7
Text Cells              .............   $FE00-$FFDF
```


Color Set Entry
---------------

A color set entry consists of a set of 4 6-bit colors.
Each entry corresponds to a large tile.
Entry 0 is the color set for tile 0.
Entry 1 is the color set for tile 1, and so forth.
The color entry set defines the 4 color palette that the tile will
be painted with where ever it is placed on the cell grid.
The colors are labeled in order, from left to right, 0-3.

The 4 colors take up 2 16-bit words in memory:

```
 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|    color 0    |   color 1     |
---------------------------------

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|    color 2    |   color 3     |
---------------------------------
```


Large Tile
--------------

```
Size:  8 words
8 x 8 pixel tiles = 64 pixels
2 bits per pixel (2 bpp)
Each word contains 8 pixels (1 row)
The pixel value serves as a lookup key into the tile's corresponding color set entry.
For a tile used in the background layer, colors are as follows:
If the pixel is 0, it takes color 0.
If the pixel is 1, it takes color 1.
If the pixel is 2, it takes color 2.
If the pixel is 3, it takes color 3.
For a tile used in the foreground layer, colors are looked up in
the same fashion, except if the pixel is set to 0, the pixel is
transparent.  In other words, the color selected for the background
tile pixel at that location is used instead of color 0.
So tiles placed in the foreground layer only use 3 colors (1-3) from
their palette, because color 0 is transparent.
```


Background Cell and Foreground Cell
----------------------------------

```
Size:  1/2 word
The one byte value indexes into the large tile set.
```


Text Cell
---------

```
Size:  1/2 word
The one byte value indexes into the small tile set.
```


Colors
------

```
A color is 6 bits in a 2-2-2 RGB format.

R Red color component
G Green color component
B Blue color component

Layout of a color

 7 6 5 4 3 2 1 0
-----------------
|0 0|R R|G G|B B|
-----------------
```


Color Palette
-------------

![palette.png](video/palette/palette.png)
