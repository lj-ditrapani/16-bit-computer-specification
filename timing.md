System Timing
=============

- System execution is divided into 100 ms frames (+/- 1 ms) (10 frames-per-second)
- The cpu is active for exactly 192K instructions per frame.
- CPU performance is 1.92 million instructions per second (MIPS).


Potential physical implementation:
----------------------------------

- CPU runs at 4 MHz.  All CPU instructions take exactly 2 cycles.
- The VDP is always active.  The CPU is active for 96% of the frame (96 ms) which is 384K cycles which is 192K instructions.
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
