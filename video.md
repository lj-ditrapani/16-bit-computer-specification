<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
Video subsystem for LJD 16-bit computer
=======================================

Author:  Lyall Jonathan Di Trapani


Overview
--------

- 256 x 240 pixel screen
- Large tile set: 256 tiles (16 x 16, 2 bpp)
- Small tile set: 256 tiles (8 x 16, 1 bpp)
- 3 layers:
    - Background layer: 16 x 15 large cells per frame
    - Text layer: 32 x 15 small cells per frame
    - Forground layer: 16 x 15 large cells per frame
- Colors are 8-bits with (3:3:2) RGB color format
- Up to 64 simultaneous colors on screen


Video ROM
---------

```
Words   Purpose         Description
----------------------------------------------------------------
   32   Colors          64 8-bit colors; 16 groups of 4 colors
8,192   Large Tiles     256 16 x 16 2 bpp tiles
2,048   Small Tiles     256 8 x 16 1 bpp tiles

Total: 10,272
```


Video Ram
---------

```
Words   Purpose             Description
--------------------------------------------------------------------------
   64   Color set indexes   256 large tile color indexes; 4 bits per index
  240   Text Cells          32 x 15 text cells x 0.5 word
  120   Foreground Cells    16 x 15 cells x 0.5 word
  120   Background Cells    16 x 15 cells x 0.5 word

Total: 544 words
```

Video ram memory addresses.

```
Purpose                 Decimal          Hex
---------------------------------------------------------------------
Color set               64,704-64,767   $FCC0-$FCFF
Text Cells              64,768-65,007   $FD00-$FDEF
Foreground Cells        65,024-65,143   $FE00-$FE77
Background Cells        65,152-65,271   $FE80-$FEF7
```


Color Set Entry
---------------

A color set entry consists of a set of 4 8-bit colors.
Each entry corresponds to a large tile.
Entry 0 is the color set for tile 0.
Entry 1 is the color set for tile 1, and so forth.
The color entry set defines the 4 color pallet that the tile will
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
Size:  32 words
16 x 16 pixel tiles = 256 pixels
2 bits per pixel (2 bpp)
Each word contains 8 pixels (1/2 row)
The pixel value serves as a lookup key into the tile's corresponding color set entry.
So, if the pixel is 0, it takes color 0.
So, if the pixel is 1, it takes color 1.
So, if the pixel is 2, it takes color 2.
So, if the pixel is 3, it takes color 3.
```


Small Tile
--------------

```
Size:  8 words
8 x 16 pixel tiles = 128 pixels
1 bit per pixel (1 bpp)
Each word contains 16 pixels (2 rows)
If the pixel is 0, it takes color 0 from the background cell beneath it.
If it is 1, it takes color 3 from the background cell beneath it.
The tile index is 0 based.
```


Background Cell and Foreground Cell
----------------------------------

```
Size:  1/2 word
The one byte value indexes into the large tile set.
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


Color Palette
-------------

![palette.png](video/palette/palette.png)
