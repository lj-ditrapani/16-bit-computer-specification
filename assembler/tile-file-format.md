Tile File Format
================

A textual file format to represent the 3 tiles sets.  This allows defining and
maintaining tile-sets more easily than using the raw binary file format.

The file is broken into 3 sections.  Each section corresponds to one of the
tile-sets.  Each section is separated by an empty line.

- Large Tiles
- Small Tiles
- Text Char Tiles

Large Tiles
-----------
The large tiles section begins with the header:

    Large Tiles
      0 1 2 3 4 5 6 7 8 9 A B C D E F

Followed by 64 large tiles.  Each large tile
begins with a two digit hex number on the first
line followed by 16 lines of 16 2-bit-per-pixel
pixels.

A pixel can be one of
`[], (), {}, or <>`.

    pixel   value
    -------------
      []      0
      ()      1
      {}      2
      <>      3

Example of Large Tiles section:

```
Large Tiles
  0 1 2 3 4 5 6 7 8 9 A B C D E F
00
  [][][][][][][][]{}()(){}[][][][]
  [][]{}{}[][][][][]{}{}[][][][][]
  []{}(){}[][][][][][][][][][][][]
  []{}{}{}[][][][]{}{}{}[][][][][]
  [][][][][][][]{}()(){}[][][][][]
  [][][][][][][]{}{}(){}[][]{}[][]
  [][]{}{}[][][][][]{}[][]{}(){}[]
  [][]{}(){}[][][][][][][][]{}[][]
  [][][]{}[][][][][][]{}[][][][][]
  [][][][][][][][][]{}(){}[][][][]
  [][][][][][][][][][]{}[][][][][]
  {}{}[][][][]{}[][][][][][][][]{}
  ()(){}[][][]{}[][][][][][][]{}()
  {}{}[][][][][][][][][][][][][]{}
  [][][][][][][][][]{}{}[][][][][]
  [][][][][][][][]{}()(){}[][][][]
01
  [][][][]<><>[][][][][][][][]{}{}
  [][]<><>{}{}<><>[][]<>[][][][][]
  []<>{}{}[][]{}{}<><>{}[][][][][]
  []{}[][][][][][]{}{}[][][][][][]
  [][][][][][]<><><>[][][][][][][]
  [][][][][]<>{}{}{}<>[][][]<>[][]
  [][]<><>[]{}[][][]{}<><><>{}[][]
  [][]{}{}<><>[][]<>[]{}{}{}[][][]
  [][][][]{}{}<><>{}[][][][][][][]
  []<><><>[][]{}{}[][]<><>[][][][]
  <>{}{}{}<><>[][]<><>{}{}[][][]<>
  {}[][][]{}{}<><>{}{}[][][][][]{}
  [][][][][][]{}{}[]<>[][][][][][]
  [][][][][][][]<><>{}<><>[][][][]
  [][][][][]<><>{}{}[]{}{}<><>[][]
  [][][][][]{}{}[][][][][]{}{}<><>
62 more tiles defined similarly...
```

Small Tiles
-----------
The small tiles section begins with the header:

    Small Tiles
      0 1 2 3 4 5 6 7

Followed by 64 small tiles.  Each small tile
begins with a two digit hex number on the first
line followed by 8 lines of 8 2-bit-per-pixel
pixels.

A pixel can be one of
`[], (), {}, or <>`.

    pixel   value
    -------------
      []      0
      ()      1
      {}      2
      <>      3

Example of Small Tiles section:

```
Small Tiles
  0 1 2 3 4 5 6 7
00
  [][]()()()()[][]
  []()()()()()()[]
  (){}{}()(){}{}()
  (){}<>()()<>{}()
  ()()()()()()()()
  ()(){}()(){}()()
  []()(){}{}()()[]
  [][]()()()()[][]
01
  <><><><>()()()()
  <><><><>()()()()
  <><><><>()()()()
  <><><><>()()()()
  {}{}{}{}[][][][]
  {}{}{}{}[][][][]
  {}{}{}{}[][][][]
  {}{}{}{}[][][][]
62 more tiles defined similarly...
```

Text Char Tiles
---------------
The text char tiles section begins with the header:

    Text Char Tiles
      0 1 2 3 4 5 6 7

Followed by 128 text char tiles.  Each text char tile
begins with a two digit hex number on the first
line followed by 8 lines of 8 1-bit-per-pixel pixels.

A pixel can be one of
`[], or <>`.

    pixel   value
    -------------
      []      0
      <>      1

Example of Text Char Tiles section:

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
126 more tiles defined similarly...
```
