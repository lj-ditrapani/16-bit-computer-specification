LJD 16-bit processor
====================

Design:
-------

- 16-bit CPU
- 16 X 16-bit registers
- We use W to represent word (akin to B representing a Byte).
- A word is 16 bits (2 bytes).  This means 1 KW is 2 KB.
- Internal dual-bus Harvard architecture, but with a single physical bus.
- 16 bit program counter (PC)
- 3-bit device select for load and store instructions
- Separate address space for each device
- Each address space has 2^16 = 65,536 addresses (16-bit resolution)
- Program instructions are in 64 KW PRG ROM on cartridge
- 64 KW cartridge DATA ROM (up to 3 banks)
- 32 KW console DATA RAM
- All devices are word-addressable
- All instructions are 16 bits long
- Instruction set contains 16 instructions (4-bit op-code)

The processor instruction set architecture (ISA) can be found in
[isa.md](isa.md).


Author:  Lyall Jonathan Di Trapani
