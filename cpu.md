LJD 16-bit processor
====================

Design:
-------

- 16-bit CPU
- 16 X 16-bit registers and program counter (PC)
- Harvard architecture
- 2^16 = 65,536 ROM addresses (16-bit resolution)
- 2^16 = 65,536 RAM addresses (16-bit resolution)
- ROM and RAM are word-addressable
- A word is 16 bits (2 bytes)
- ROM + RAM:  128 KWords = 256 KB = 2 M-bit
- All instructions are 16 bits long
- 16 instructions (4-bit op-code)

The processor instruction set architecture (ISA) can be found in
[ISA.md](ISA.md).


Author:  Lyall Jonathan Di Trapani
