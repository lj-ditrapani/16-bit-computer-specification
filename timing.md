System Timing
=============

- The system runs at about 4.773 MHz (exactly (14.32 / 3) MHz)
- Each CPU instruction executes in exactly 4 clocks
- System execution is divided into 100 ms frames (+/- 1 ms) (10 frames-per-second)
- There are exactly 477,324 clocks per frame.
- The VDP is always active.  The CPU is active for 356K clocks per frame (almost 75% of the time.)
- While the CPU is active, the bus is shared between VDP and CPU.  CPU can use the bus on odd clocks.  VDP can use the bus on even clocks.
- When the CPU is sleeping (a little over 25% of the time), the VDP has full access to the buss.
- For the first 75 ms of a frame, the CPU is active.  The last 25 ms of a frame, the CPU is sleeping.
- The VDP uses the frame interrupt line (FI) to control the CPU

```
       100 ms frame
    --------------------------------
    |        75 ms          | 25 ms|
    --------------------------------
      cpu active              cpu off
```

- The cpu is active for exactly 356K clocks per frame, therefore it can execute up to 89K instructions per frame.
- CPU performance is 0.89 million instructions per second (MIPS).

- Why 4.773333 MHz?  The NTSC color subcarrier frequency is 3.58 MHz.  4*3.58 = 14.32 MHz.  So if we have a 14.32 MHz clock; we can divide it by four to get the NTSC color subcarrier frequency (so we can write colored pixels at this frequency to an NTSC CRT) and we can divide by three to get our system speed of ~4.77333333.  14.32 / 3 MHz.
- 5.37 MHz (5369473 cyles/sec; 186.238 ns period) might be a better choice.  It is what the NES uses.
