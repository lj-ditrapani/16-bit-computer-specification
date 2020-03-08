LJD 16-bit processor
====================

Design:
-------

- 16-bit CPU
- 16 X 16-bit registers
- A word is 16 bits (2 bytes)
- Single bus, Von Neumann architecture
- 15 bit program counter (PC)
- 2^16 = 65,536 addresses (16-bit resolution)
- Program instructions are in first 32 KW of ROM
- ROM and RAM are word-addressable
- CPU addressable ROM + RAM:  64 KWords = 128 KB = 1 M-bit
- All instructions are 16 bits long
- 16 instructions (4-bit op-code)

The processor instruction set architecture (ISA) can be found in
[ISA.md](ISA.md).


Author:  Lyall Jonathan Di Trapani
