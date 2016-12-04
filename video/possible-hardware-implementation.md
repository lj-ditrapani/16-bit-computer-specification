Memory Access
-------------

VRAM is accessed independently from main ram.
VRAM can perform 4 million operations per second
(250 ns per operation)
where an operation is a 1 word read or a one word write.
Memory Bandwidth: 8 MB/sec (same for ROM and RAM).

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

The video systems needs to make
4 video ram reads before every set of 8 pixels is rendered.
Since there are 35 VRAM cycles available for each 8 pixel string,
there is no problem meeting the 4 reads requirement.


Buffers
-------

2 x 1.5-word buffers
for a total 3 words for both buffers.

```
Name                words
-------------------------
Tile pixel buffer     0.5
Color buffer          1
-------------------------
Total                 1.5

When one buffer is being rendered, the other is being loaded.
```


Tile pixel buffer
---------------------------
```
0.5 word
8 bits = 8 pixels (1 bit per pixel)

                    Pixels

tile                8 x 1bpp
```


Color buffer
------------

```
1 word (2 8-bit colors)

Background color:       1 8-bit color = 0.5 word
Foreground color:       1 8-bit color = 0.5 word
```
