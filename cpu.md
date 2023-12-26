LJD 16-bit processor
====================

Design:
-------

- 16-bit CPU
- 16 X 16-bit registers
- We use W to represent word (akin to B representing a Byte).
- A word is 16 bits (2 bytes).  This means 1 KW is 2 KB.
- Dual-bus Harvard architecture
- 16 bit program counter (PC)
- Separate program (PRG) and data address spaces
- Each address space has 2^16 = 65,536 addresses (16-bit resolution)
- Program instructions are in 64 KW PRG ROM chip on cartridge
- 32 KW cartridge DATA ROM chip
- 32 KW console DATA RAM chip
- All ROM and RAM are word-addressable
- CPU addressable program + data:  128 KW = 256 KB = 2 M-bit
- All instructions are 16 bits long
- Instruction set contains 15 instructions (4-bit op-code)

The processor instruction set architecture (ISA) can be found in
[isa.md](isa.md).


Author:  Lyall Jonathan Di Trapani
