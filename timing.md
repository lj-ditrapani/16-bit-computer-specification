System Timing
=============

- Console outputs 64-color digital RGB for an IBM EGA compatible monitor (Oct 1984).
- Master clock is 157.5 MHz / 11 = ~14.31818 MHz (common master clock for early 1980s).
  - ~69.841 ns period
- Each scan line takes 912 clock cycles, or ~63.69523 us
- There are 262 scan lines in a non-interlaced frame; aka field. A frame takes ~16.6881 ms total.
- The vdp only renders on the middle 200 visible scan lines.
- The bus is segmented in 2 during vdp rendering so the vdp has exclusive access to the video ram during this time.
- The vdp unifies the bus to allow the cpu access to Video RAM during the 62 blank scan lines, a total time of ~3.94910 ms.
- CPU performance is between 1.33875 and 1.78977 million instructions per second (MIPS).


Potential physical implementation:
-----------------------------------------

- CPU runs at 157.5 / 22 MHz = ~7.15909 MHz.
  All CPU instructions take 4 or 6 cycles.
  Instructions that access data memory (LOD and STR) take 6 cycles.
  All other 14 instructions take 4 cycles.  There is no pipelining.
- The VDP sets the "rendering output" line to high to segment the bus and signal
  the CPU the bus is segmented, the CPU can no longer access the following
  devices: VRAM, VDP, APU.
  It sets the line low to unify the bus and signal the CPU it can once again access the devices.
- The VDP sets the "rendering output" line to high during the 200 visible scan line rendering.
  It keeps the line low during the 62 blank lines.
- VDP pixel clock is the master clock.  So a pixel period is ~69.841 ns.
  The VDP can read 4 memory words for every 16 pixels* because it has exclusive
  access to video RAM during the 200 line rendering.
  *(16 pixels in high-res, 8 pixels in low-res)

```
       16.6881 ms frame
    ---------------------------------------
    ---------------------------------------
    |         200               | 62      | <- scan lines per section
    ---------------------------------------
    |       12.739 ms           | 3949 us | <- duration
    ---------------------------------------
      cpu no VDP/VRAM/APU        cpu access
      access                     VDP/VRAM/APU
      vdp renders frame          VDP blank/hblank
```


The CPU starts executing with the program counter
PC set to $0000.

When the CPU sees the interrupt line go low, if the CPU is HALTed, the PC is set to PC + 1, and the CPU proceeds with execution.


VDP and APU internal Buffers
----------------------------

- The CPU can write to the VDP the 16 color palette during vblank (unified bus).
During rendering:
- vdp copies over current tile cell, both tile rows (fg and bg or 2 bg), and the color cell for the current line just-in-time to render the next 16 pixels.  This happens while rendering the previous 16 pixels.  The VDP can read exactly 4 memory words from RAM every 16 pixels.
- In 1-layer high-res 640 x 200 mode, the VDP treats the tile cell as 2 side-by-side tiles.  Giving us 16 horizontal pixels across the 2 background tiles.
- In 2-layer low-res 320 x 200 mode, the VDP treats the tile cell as an fg and bg tile.  Giving us 8 horizontal pixels.  Each pixel is emitted twice (in other words, output for 2 clock cycles), so it takes 16 pixel clocks to render the 8 pixels.
- vdp has an internal 24 word cached
    - 16 word color palette cache (for entire frame)
    - 2 word color cell (current/next)
    - 2 word tile cell (current/next)
    - 2 word background tile row (8 pixels) (current/next)
    - 2 word foreground tile row (8 pixels) (current/next)
      - note: in 1-layer mode this is used for the 2nd background tile
- APU: audio and peripheral unit
    - 5 to 8 audio registers
    - 2 gamepad registers
    - 2 keyboard registers
    - 4 serial registers (for cassette, floppy and linkHub use)
