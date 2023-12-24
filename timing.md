System Timing
=============

- Console renders using the NTSC video standard.
- System execution is divided into 16.6833 ms frames (60 frames per 1.001 second)
- Each scan line takes 63.55555 us (there are 262.5 scan lines in a non-interlaced frame; aka field)
- The vdp only renders on the middle 200 visible scan lines.
- The vdp allows cpu and apu access during 60 of the blank scan lines, a total time of 3.813 ms.
- The vdp uses the last 2.5 scan lines of vblank to prepare to render the next frame.
- On frames where IO is performed, the cpu is active for 25,740 instructions per frame (202.5 scan lines).
- For frames where frame skip is on (no IO is performed), the cpu is active for the full frame, 33,365 instructions.
- CPU performance is 2 million instructions per second (MIPS).


Potential physical implementation:
-----------------------------------------

- CPU runs at 4 MHz.  All CPU instructions take exactly 3 cycles, but the fetch cycle from the current instruction and the memory access cycle of the previous instruction happen concurrently, so the throughput is 1 instruction every 2 cycles.
- The VDP is always active.
- The VDP uses the CPU interrupt line (CI) to tell the CPU to jump to video copy address.
- The VDP uses the APU interrupt line (AI) to tell the CPU to sleep and the APU it can use the data bus.  This also signals the CPU to set the PC to the main loop address while it sleeps.
- Once CI and AI both go low again, the CPU can resume to run as normal, starting at the main loop address.
- In NTCS a vblank of 60 lines = 3.813 ms.

```
       16.6833 ms frame
    -----------------------------------------------
    |        12.870 ms          | 3749 us | 63 us |
    -----------------------------------------------
      cpu normal                 cpu         apu
      vpd renders frame          write       access
                                 I/O RAM     I/O RAM
```


CPU and APU Interrupts (CI/AI)
----------------------------

The computer starts executing with the program counter
PC set to $0000.
On frames that are not skipped (controlled by the CPU by setting the frame skip memory address), the CPU can run as normal for 12870 ms (25,740 instructions), while the VDP renders the 200 scan lines of the frame.
At the end of the CPU active time for the frame,
the VDP sets the CI to high.  This causes the CPU PC to be set to the video copy address ($0080).
The CPU can then read and write to the last 4k of DATA RAM where VDP and APU memory resides for 3749 us, (7498 instructions).
The VDP then sets the AI (APU interrupt) line high.  This causes the CPU to sleep and set its PC to the main loop address.  The APU can now read and write to the last 1k of DATA RAM for the next 50 us.
After this the VDP sets both the CI and AI lines low again.  The cpu resumes at the main loop address and the vdp gets ready to render the next frame of 200 scan lines.


Reading and writing to the I/O RAM
----------------------------------

- vdp copies over 16 color palette during vblank.  This happens during the 61st vblank line, after the APU has finished accessing DATA RAM.
- vdp copies over 8 color cells for current scan line during hblank
- vdp copies over current tile cell, and both tile rows (fg and bg) for the current line just-in-time to render the next 8 pixels.
- vdp has an internal 27 word cached
    - 16 word color palette cached
    - 8 word color cells for current line
    - 1 word tile cell
    - 1 word background tile row (8 pixels)
    - 1 word foreground tile row (8 pixels)
- APU: audio and peripheral unit
    - 6 to 16 audio registers
    - 2 gamepad registers
    - 2 keyboard registers
