System Timing
=============

- Console outputs s-video for a Commodore 1702 monitor (Oct 1983).
- System execution is divided into 16.6833 ms frames (60 frames per 1.001 second)
- Each scan line takes 63.6768 us (there are 262 scan lines in a non-interlaced frame; aka field)
- The vdp only renders on the middle 200 visible scan lines.
- The vdp allows cpu access to IO RAM during 62 of the blank scan lines, a total time of 3.820 ms.
- cpu is active for 89,340 cycles (between 22,335 and 44,670 instructions) per frame (202 scan lines).
- CPU performance is between 1.33875 and 2.6775 million instructions per second (MIPS).


Potential physical implementation:
-----------------------------------------

- CPU runs at 60*262*341/1.001 MHz (~5.355164 MHz).  All CPU instructions take exactly 2 or 4 cycles.  Instructions that access data memory (LOD and STR) take 4 cycles.  All other 14 instructions take 2 cycles.  There is no pipe-lining.
- The VDP is always active.
- The VDP uses the Frame interrupt line (FI) to tell the CPU to jump to main loop address.  This happens during when the vdp finishes rendering the 200 visible scan lines, so it is now safe for the next 62 scan lines to read write IO RAM / peripherals.
- VDP pixel clock matches CPU speed, at ~5.355164 MHz.  So a pixel period is 186.735 ns.  The VDP can read 4 memory words for every 8 pixels.

```
       16.6833 ms frame
    -----------------------------------------------
    -----------------------------------------------
    |  200                      | 62      | 1     | <- scan lines per section
    -----------------------------------------------
    |        12.863 ms          | 3756 us | 63 us | <- duration
    -----------------------------------------------
      cpu normal                 cpu         apu
      vpd renders frame          write       access
                                 I/O RAM     I/O RAM
```


CPU and APU Interrupts (CI/AI)
----------------------------

The computer starts executing with the program counter
PC set to $0000.
On frames that are not skipped (controlled by the CPU by setting the frame skip memory address), the CPU can run as normal for 12.86 ms (34,440 instructions), while the VDP prepares (2 scan lines) and renders the 200 scan lines of the frame (total 202 scan lines).
At the end of the CPU active time for the frame,
the VDP sets the CI to high.  This causes the CPU PC to be set to the video copy address ($0080).
The CPU can then read and write to the last 4k of DATA RAM where VDP and APU memory resides for 3,820 us, (10,227 instructions).
The VDP then sets the AI (APU interrupt) line high.  This causes the CPU to sleep and set its PC to the main loop address.  The APU can now read and write to the last 1k of DATA RAM for the next 50 us.
After this the VDP sets both the CI and AI lines low again.  The cpu resumes at the main loop address and the vdp gets ready to render the next frame of 200 scan lines.


VDP and APU internal Buffers
----------------------------

- vdp copies over 16 color palette during vblank.  This happens during the 61st vblank line, after the APU has finished accessing DATA RAM.
- vdp copies over current tile cell, both tile rows (fg and bg), and the color cell for the current line just-in-time to render the next 8 pixels.  This happens while rendering the previous 8 pixels.  The VDP can read exactly 4 memory words from RAM every 8 pixels.
- vdp has an internal 24 word cached
    - 16 word color palette cached (for entire frame)
    - 2 word color cell (current/next)
    - 2 word tile cell (current/next)
    - 2 word background tile row (8 pixels) (current/next)
    - 2 word foreground tile row (8 pixels) (current/next)
- APU: audio and peripheral unit
    - 5 audio registers
    - 2 gamepad registers
    - 2 keyboard registers
    - 4 serial registers (for cassette and linkHub use)
