System Timing
=============

- System runs at 4 MHz
- Each CPU instruction executes in exactly 4 clocks
- System execution is divided into 100 ms frames
- CPU runs at 10 frames-per-second
- The VDP is always active.  The CPU is active 75% of the time.
- While the CPU is active, the bus is shared between VDP and CPU.  CPU can use the bus on odd clocks.  VDP can use the bus on even clocks.
- When the CPU is sleeping (25% of the time), the VDP has full access to the buss.
- For the first 75 ms of a frame, the CPU is active.  The last 25 ms of a frame, the CPU is sleeping.
- The VDP uses the frame interrupt line (FI) to control the CPU

```
       100 ms frame
    --------------------------------
    |        75 ms          | 25 ms|
    --------------------------------
      cpu active              cpu off
```

- The cpu is active for 300K clocks per frame, therefore it can execute up to 75K instructions per frame.
- CPU performance is 0.75 million instructions per second (MIPS)
