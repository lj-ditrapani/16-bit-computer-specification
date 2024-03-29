<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
Video subsystem for LJD 16-bit computer
=======================================

Author:  Lyall Jonathan Di Trapani


Overview
--------

The Video Display Processor (VDP) is responsible
for generating the video signal.

- 240 x 200 pixel screen
- Tile set: (8 x 8, 2 bpp)
    - 256 background tiles
    - 128 foreground tiles
- 2 layers:
    - Background layer: 30 x 25 cells per frame
    - Foreground layer: 30 x 25 cells per frame
- Colors are 6-bits with (2:2:2) RGB color format
- Up to 28 simultaneous colors on screen


Video RAM
---------

```
Words   Purpose                 Description
------------------------------------------------------------------------------
    8   Background Palettes     16 6-bit colors; 4 groups of 4 colors
    8   Foregroud Palettes      16 6-bit colors; 4 groups of 4 colors
  200   Color Cells             15 x 13 grid; 4 bits/cell; 4 words per row x 13
  750   Tile Cells              30 x 25 cells x 1 word
2,048   Background Tiles        256 8 x 8 2 bpp tiles (8 W / tile)
1,024   Foreground Tiles        128 8 x 8 2 bpp tiles (8 W / tile)

Total: 4,038 words
```


Background Color Palette
------------------------

A background color palette consists of a set of 4 6-bit colors.
There are 4 background color palettes.
The colors are labeled in order, from left to right, 0-3.

The 4 colors take up 2 16-bit words in memory:

```
Size: 2 words

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|    color 0    |   color 1     |
---------------------------------

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|    color 2    |   color 3     |
---------------------------------
```


Foreground Color Palette
------------------------

A foreground color palette consists of a set of 3 6-bit colors.
There are 4 foreground color palettes.
The colors are labeled in order, from left to right, 0-3.

The 3 colors take up 2 16-bit words in memory:

```
Size: 2 words

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|    Unused     |   color 1     |
---------------------------------

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|    color 2    |   color 3     |
---------------------------------
```


Color Cells
-----------

The screen is split into a 30 x 25 grid of 8 x 8 pixel regions
called color cells.
One tile cell fits in each color cell.
The color cell determines which foreground color palette and which
background color palette is active for the 8 x 8 color cell.

```
Size 1/4 word (= 4 bits)

The first 2 bits of a color cell define the foreground palette and
the second 2 bits define the background palette.

Four color cell definitions fit in one word.

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|  cc0  |  cc1  |  cc2  |  cc3  |
---------------------------------
```

There are 30 color cells per row.
A row of color cells needs 8 words.  There are 25 rows.  So 8 * 25 = 200 words.


Tile Cell
---------

The screen is split into a 30 x 25 grid of 8 x 8 pixel regions called tile cells.
A background tile and foreground tile is selected for each cell.
A tile cell contains a background tile index followed by a foreground tile index.
Each index is a one byte value that points to a single tile in the
respective background/foreground tile set.
Since there are only 128 foreground tiles, the most significant bit in
the foreground index is ignored.

```
Size:  1 word

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|  bg index     |   fg index    |
---------------------------------
```


Tile
----

```
Size:  8 words
8 x 8 pixel tiles = 64 pixels
2 bits per pixel (2 bpp)
Each word contains 8 pixels (1 row)
The pixel value serves as a lookup key into the active color palette
of the cell location the tile is placed within.
For a background tile, colors are as follows:
If the pixel is 0, it takes color 0.
If the pixel is 1, it takes color 1.
If the pixel is 2, it takes color 2.
If the pixel is 3, it takes color 3.
For a foreground tile, colors are looked up in
the same fashion, except if the pixel is set to 0, the pixel is
transparent.  In other words, color 0 of the active background palette
for that location is used instead.
So tiles placed in the foreground layer only use 3 colors (1-3) from
their palette, because color 0 is transparent.
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


Available Colors
----------------

![palette.png](video/palette/palette.png)
