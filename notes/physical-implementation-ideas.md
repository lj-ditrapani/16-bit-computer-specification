<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
General
-------

- 16-bit CPU
- Program ROM 64 KWords = 128 KB = 1 M-bit
- Data ROM 32 KWords = 64 KB = 512 K-bit
- RAM 32 KWords = 64 KB = 512 K-bit
- 4 Million instructions per second (MIPS)
- Physical implementations should meet 4 MIPS performance.  So if the
  implementation requires 4 clocks pre instruction, then the clock
  should run at 16 MHz.  If the implementation only requires 2 clocks
  per instruction, the clock should run at 8 MHz.

Example of implementation that uses a max of 2 clocks per instruction (8 MHz).

```
    Triple ported register file
    (2 reads, 1 write per clock)
    CPLD like Control
    10 function ALU (4 control bits)

    Regular (1 clock)
    Fetch instruction (memory read)       1 clock
    Decode & Reg read & ALU & Reg write

    STR (2 clocks)
    Fetch instruction (memory read)       1 clock
    Decode & Reg read
    Memory write                          1 clock

    LOD (2 clocks)
    Fetch instruction (memory read)       1 clock
    Decode & Reg read
    Memory read & reg write               1 clock
```


I/O
-----------

- Use double buffering for I/O

```
4 Million instructions per second
  400 K instructions per frame
    360 K for cpu compute
     40 K instructions cpu sleeps during I/O buffer switching
```
