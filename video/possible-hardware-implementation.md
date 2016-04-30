Memory Access
-------------

VRAM is accessed independently from main ram.
VRAM can perform 4 million operations per second
(250 ns per operation)
where an operation is a 1 word read or a one word write.
Memory Bandwidth: 8 MB/sec (same for ROM and RAM).
Net and storage bandwidth: 20 KB/sec for each in each direction.

```
4 M ops / s
400 K ops / frame

262 Lines (240 active lines, 22 vblank lines)
    366,412   cycles for active lines
     33,587   cycles for vblank
      1,526   cycles per line

341 pixels per line (256 active pixels, 85 hsync pixels)
    1,526     cycles per line
    1,145     cycles for active pixels
      380     cycles for hsync
       35.8   cycles per 8 pixels
        4.475 cycles per pixel
```

The video systems needs to make 2 buffer copies (the 2 sprite attribute
words) and 12 video ram reads before every set of 8 pixels is rendered.
Since there are 35 VRAM cycles available for each 8 pixel string,
there is no problem meeting the 12 reads requirement.

It also needs to do up to 176 VRAM reads during each H-sync to load the
sprite data for the next line.  The 176 VRAM reads come from reading
each sprite's lower word (2 sets of 64 sprites = 128) and then loading
the upper word of up to 16 large sprites and
up to 32 small sprites.  (2 x 64) + 16 + 32 = 176.
Since there are 380 memory cycles available during H-sync,
there is no problem meeting the 176 reads requirement.


Buffers
-------

2 x 64-word buffers
for a total 128 words for both buffers.

```
Name                words
-------------------------
Tile pixel buffer       4
Tile attribute buffer   4
Color buffer            5
L-Sprite tile index    17
S-Sprite tile index    34
-------------------------
Total                  64

Each buffer is doubled for a total of 72 words.
When one buffer is being rendered, the other is being loaded.
```


Tile attribute and pixel buffer
-------------------------------
```
4 words, one for each layer
16 bits = 8 pixels (2 bits per pixel)

                    Attributes      Pixels           colors

Background tile     |BG cell |    |8 x 2bpp|    |cp1a|cp1b|cp2a|cp2b|

Text tile               |indx|        |8x1 |

Large sprite        |Attribut|    |8 x 2bpp|         |cp1b|cp2a|cp2b|

Small splite        |Attribut|    |8 x 2bpp|         |cp1b|cp2a|cp2b|
```


Color buffer
------------

```
5 words (10 8-bit colors)

Background color and text color:    4 8-bit colors = 2 words
Large sprite colors:                3 8-bit colors = 1.5 words
Small sprite colors:                3 8-bit colors = 1.5 words
```


Large Sprite Tile Index
-----------------------

Up to 16 large sprites per row.
16 words: one word for each column in the row to designate the sprite's
color pairs, x-y flips and tile index.
16 bits: one bit for each column in the row to designate whether there
is an active sprite in this column or not.
Total of 17 words.


Small Sprite Tile Index
-----------------------

Up to 32 small sprites per row.
32 words: one word for each column in the row to designate the sprite's
color pairs, x-y flips and tile index.
32 bits: one bit for each column in the row to designate whether there
is an active sprite in this column or not.
Total of 34 words.


How sprite tile indexes are loaded
----------------------------------
During the h-sync of each line, get the next sprite tile index buffers setup

```
Set all sprite positions to 0 (off)
For sprite in 64 sprites
    Load lower word of sprite (x-position, y-position, on/off)
    if sprite.enabled and sprite.y = current_line_y
        Load upper word of sprite (cp1, cp2, x/y-flip, index)
          into position(sprite.x)
        set position.flag = 1 (on)
```

There are 64 large and 64 small sprites, so up to 256
memory access may be executed.
