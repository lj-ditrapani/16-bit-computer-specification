System Timing
=============

- Console renders using the NTSC video standard.
- System execution is divided into 16.6833 ms frames (60 frames per 1.001 second)
- Each scan line takes 63.55555 us (there are 262.5 scan lines in a non-interlaced frame; aka field)
- The vdp only renders on the middle 200 visible scan lines.
- The vdp allows cpu and apu access during the 60 of the blank scan lines, a total time of 3.813 ms.
- On frames where IO is performed, the cpu is active for 25,740 instructions per frame.
- For frames where frame skip is on (no IO is performed), the cpu is active for the full frame, 33,366 instructions.
- CPU performance is 2 million instructions per second (MIPS).


Potential physical implementation:
-----------------------------------------

- CPU runs at 4 MHz.  All CPU instructions take exactly 2 cycles.
- The VDP is always active.
- The CPU sleeps for the last 4% of the frame (4 ms) which is 16K cycles.
- The VDP uses the frame interrupt line (FI) to tell the CPU when to sleep
- In NTCS a vblank of 60 lines = 3.816 ms.  Putting the CPU to sleep for 4 ms allows the VDP to have complete control of the system during 1 vblank to copy over I/O registers.

```
       100 ms frame
    --------------------------------
    |        96 ms          | 4 ms |
    --------------------------------
      cpu active              cpu off
```


Frame Interrupt (FI)
----------------------------

The computer starts executing with the program counter
PC set to $0000.
At the end of the 75 ms CPU active time for each frame,
the VDP sets the FI to high.  This causes the CPU to
stop execution and sleep.
At the end of the frame (after the next 25 ms VDP phase),
the VDP sets the FI back to low.
When the FI goes from high to low, the CPU sets the
program counter (PC) to $0100 and starts running again.


Reading and writing to the I/O RAM
----------------------------------

The VDP copies the output registers of the I/O registers to the VDP
section of ram during the 25% VDP portion of each frame.
The VDP copies the input registers from VDP section of ram to the I/O
registers during the 25% VDP portion of each frame.
The VDP can take up 2 two frames to copy over the tiles, so changes
to tile ram can take an extra frame before they are reflected on
screen.  When modifying tile ram, you should wait a frame before
trying to use the tile in the tile cells.
The VDP uses the reserved VDP section of ram to render the screen
contents.
This is a form of double buffering, allowing the CPU to freely modify
the I/O registers without messing up the current video rendering.
