<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
General
-------

- 16-bit CPU
- Program ROM 32 KWords = 64 KB = 512 M-bit
- Data ROM 16 KWords = 32 KB = 256 K-bit
- RAM 16 KWords = 32 KB = 256 K-bit
- 8 MHz clock
- 4 clocks per LOD or STR instruction
- 2 clocks for all other instructions


```
    Triple ported register file
    (2 reads, 1 write per clock)
    CPLD like Control
    10 function ALU (4 control bits)

    Regular (2 clock)
    Fetch instruction (memory read)       1 clock
    Decode & Reg read & ALU & Reg write   1 clock

    STR (4 clocks)
    Fetch instruction (memory read)       1 clock
    Decode & Reg read                     1 clock
    Memory write                          1 clock
    idle                                  1 clock

    LOD (4 clocks)
    Fetch instruction (memory read)       1 clock
    Decode & Reg read                     1 clock
    Memory read                           1 clock
    reg write                             1 clock
```


I/O
-----------

CPU executes 80,000 or 80,002 clocks per frame
    - vdp sends wait signal at end of clock 79,000
    - cpu finishes current instruction before going into wait
    - +2 to finish a pending instruction
    - vdp waits until clock 80,002 before starting any work

```
59.9 frames per second
16.6 ms / frame
15.0 ms cpu active compute
 1.6 ms cpu wait (buffer for flexibility in physical implementation)

5.369318 Million clocks per second
   89 K clocks per frame
    80 K for cpu compute
     8.9 K clocks cpu sleeps to allow VDP free reign on bus
16.6 ms / frame
15.0 ms cpu active compute
 1.6 ms for setting PC = FIV

clock period > 186 ns

Memory:
RAM and ROM must have acces time of 150 ns or faster to allow for one access per clock.
Allows at least 36 ns of stable data lines.
150 ns dynamic and static ram existed in the 80s.

With overscan, h-blank, and v-blank, screen is
262 lines
341 pixels

During v-blank:
Copy over 16 color palettes (16 words) from ram

4 memory reads every 8 pixels

Every 8 pixels, read in:
- color cell: fg & bg color palette
- tile cell: fg tile index & bg tile index
- fg 8-pixel tile row
- bg 8-pixel tile row

Use shift registers to prefil next 8-pixels' data during current
8-pixels' rendering.
```
