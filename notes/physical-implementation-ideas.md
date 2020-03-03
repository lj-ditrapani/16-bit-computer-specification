<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
General
-------

- 16-bit CPU
- Program ROM 64 KWords = 128 KB = 1 M-bit
- Data ROM 32 KWords = 64 KB = 512 K-bit
- RAM 32 KWords = 64 KB = 512 K-bit
- 8 MHz clock
- 4 clocks per LOD or STR instruction
- 2 clocks for all other instructions
- 2-4 Million instructions per second (MIPS)
- It can do 4 million memory accesses (reads or writes) per second.
- Physical implementations should meet above 2-4 MIPS performance.  So if the
  implementation requires max 4 clocks per instruction, then the clock
  should run at 8 MHz.  If the implementation requires max 8 clocks
  per instruction, the clock should run at 16 MHz.

Example of implementation that uses a max of 2 clocks per instruction (8 MHz).

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

```
4 Million instructions per second
  400 K instructions per frame
    360 K for cpu compute
     40 K instructions cpu sleeps during I/O buffer switching & setting PC = FIV
100 ms / frame
90 ms cpu active compute
10 ms for buffer stwiching and setting PC = FIV

8 Million clocks per second
  133 K clocks per frame
    120 K for cpu compute
     13 K clocks cpu sleeps during setting PC = FIV
16.6 ms / frame
15.0 ms cpu active compute
 1.6 ms for setting PC = FIV

5.369318 Million clocks per second
   89 K clocks per frame
    80 K for cpu compute
     8.9 K clocks cpu sleeps during setting PC = FIV
16.6 ms / frame
15.0 ms cpu active compute
 1.6 ms for setting PC = FIV
```

Memory:
 2 MHz  500 ns
 2.66 MHz  375 ns
 3 MHz  333 ns
 4 MHz  250 ns
 5.369318 186 ns
 8 MHz  125 ns
10 MHz  100 ns
 5.369   186.2 ns
 1 / 60 / (261 * 340) = 187.8 ns

261 lines
340 pixels

21.477272 MHz ÷ 4
5.369318 MHz cpu & ppu
2.684659
8 memory reads every 16 pixels

At startup:
Copy over 64 color sets (32 words) from rom

Every 16 pixels, read in:
cell: fg tile index & bg tile index
fg color set index
bg color set index

solder iron
digital multimeter
2-channel oscilloscope
logic analyzer 


Video:
Could do 16 color
4 bit per pixel 256x240 frame buffer
32 kW rom
16 kW ram
15 kW video ram
1 kW IO ram

Harder to program/smaller programs/more expensive (more ram)/hard to update full screen/hard to animate large areas
Easier to explain/more flexible/cheaper video hardware

256 8x8 1 bit per pixel
1 kW tile                       ram or rom; choose
1 kW grid (index + fg + bg)     ram
