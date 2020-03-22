<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
General
-------

- 16-bit CPU
- Program ROM 32 KWords = 64 KB = 512 M-bit
- Data ROM 16 KWords = 32 KB = 256 K-bit
- RAM 16 KWords = 32 KB = 256 K-bit


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


Video
-----

There is a single system bus.
While the CPU is active, the VDP and CPU share the system bus.
Bus access is interleaved between CPU & VDP
The CPU gets to use the system bus on the even clocks.
The VDP gets to use the system bus on the odd clocks.
When the CPU is in wait mode, the VDP gets full access
to the system bus on both even and odd clocks.

```
16.6 ms / frame
15.0 ms cpu active compute
 1.6 ms cpu wait (buffer for flexibility in physical implementation)

VGA
1/60.00 = 16.666.. ms
NTSC
1/60.1 = 16.638 ms
```

NTSC Implementation

```
CPU & VDP clock = 5.369318 MHz
60.1 frames per second
5.369318 Million clocks per second
   89 K clocks per frame
    80 K for cpu compute
     8.9 K clocks cpu sleeps to allow VDP free reign on bus
16.638 ms / frame
15.0 ms cpu active compute
 1.638 ms cpu wait; vdp owns bus on both even AND odd clocks

clock period > 186 ns

Memory:
RAM and ROM must have acces time of 150 ns or faster to allow for one access per clock.
Allows at least 36 ns of stable data lines.
150 ns dynamic and static ram existed in the 80s.

With overscan, h-blank, and v-blank, screen is
262 lines
341 pixels
16.6389 ms / frame
63.5073 us / line
186.238 ns / pixel

During v-blank:
VDP copies over 16 color palettes (16 words) from ram

4 memory reads every 8 pixels

Every 8 pixels, read in:
- color cell: fg & bg color palette
- tile cell: fg tile index & bg tile index
- fg 8-pixel tile row
- bg 8-pixel tile row

Use shift registers to prefil next 8-pixels' data during current
8-pixels' rendering.
```
