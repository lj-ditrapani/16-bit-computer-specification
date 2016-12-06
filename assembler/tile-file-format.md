Tile File Format
================

An ASCII file format to represent the tile sets.  This allows defining and
maintaining tile-sets more easily than using the raw binary file format.

Tiles
---------------
The file begins with a header:

      0 1 2 3 4 5 6 7

Followed by 256 tiles.  Each tile
begins with a two digit hex number on the first
line followed by 12 lines of 8 1-bit-per-pixel pixels.

A pixel can be one of
`[], or <>`.

    pixel   value
    -------------
      []      0
      <>      1

Example of first 2 tiles in a tile file:

```
Text Char Tiles
  0 1 2 3 4 5 6 7
00
  [][]<><><>[][][]
  []<>[][][]<>[][]
  []<>[][][]<>[][]
  []<><><><><>[][]
  []<>[][][]<>[][]
  []<>[][][]<>[][]
  [][][][][][][][]
  [][][][][][][][]
01
  []<><><><>[][][]
  []<>[][][]<>[][]
  []<><><><>[][][]
  []<>[][][]<>[][]
  []<>[][][]<>[][]
  []<><><><>[][][]
  [][][][][][][][]
  [][][][][][][][]
254 more tiles defined similarly...
```
