<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
General
-------

- 16-bit CPU
- ROM 64 KWords = 128 KB = 1 M-bit
- RAM 64 KWords = 128 KB = 1 M-bit
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

See [IO Map](https://github.com/lj-ditrapani/16-bit-computer/blob/master/doc/IOmap.txt)

- Use double buffering for I/O

```
4 Million instructions per second
  400 K instructions per frame
    399 K for cpu compute
      1 K instructions cpu sleeps during I/O buffer switching

RAM for I/O
Words Purpose
-------------------------------------
    7 Control
  505 Unused
  512 Audio out
2,048 Network I/O (1K read, 1K write)
2,048 Storage I/O (1K read, 1K write)
4,096 Video out
-------------------------------------
9,216 Words total (505 words unused)
```
