<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
Instruction Set Architecture (ISA)
==================================


Instruction Meaning
-------------------

    0 END    Halt computer
    1 HBY    High byte: load byte into high byte of register
    2 LBY    Low byte: load byte into low byte of register
    3 LOD    Load: load value at address into register
    4 STR    Store: store value into address
    5 ADD    Add: add two values
    6 SUB    Subtract: subtract two value
    7 ADI    Add 4-bit immediate
    8 SBI    Subtract 4-bit immediate
    9 AND    And: logical and two values
    A ORR    Or: logical or two values
    B XOR    exclusive or: exclusive or two values
    C NOR    Nor: logical nor two values
    D SHF    Shift: shift bits in register in direction and by amount
    E BRV    Branch on value (negative, zero, positive)
    F ---    Not used


Instruction operation
--------------------

    0 END
    1 HBY    immd8 -> RD[15-08]
    2 LBY    immd8 -> RD[07-00]
    3 LOD    ram[RS1] -> RD
    4 STR    RS2 -> ram[RS1]
    5 ADD    RS1 +   RS2 -> RD
    6 SUB    RS1 -   RS2 -> RD
    7 ADI    RS1 + immd4 -> RD
    8 SBI    RS1 - immd4 -> RD
    9 AND    RS1 and RS2 -> RD
    A ORR    RS1 or  RS2 -> RD
    B XOR    RS1 xor RS2 -> RD
    C NOR    RS1 nor RS2 -> RD
    D SHF    RS1 shifted by immd4 -> RD
    E BRV    if (RS1 matches NZP) then (RS2 -> PC)
    F ---    Not used


    Legend:
    -----------------------------------------
    immd8   8-bit immediate value
    immd4   4-bit immediate value
      RS1   Source register (2nd nibble)
      RS2   Source register (3rd nibble)
       RD   Destination register (4th nibble)


### SHF ###

Shift, zero fill

    4-bit immd4 format:  DAAA
    D is direction:  0 left, 1 right
    AAA is (amount - 1)
    0-7  ->  1-8
    Assembly:
    SHF R7 L 2 RA ->  $D71A
    SHF R5 R 7 R0 ->  $D5E0


### BRV ###

The 4th nibble in a BRV instruction is the condV (condition) nibble.  The most
significant bit is unused.  The other 3 bits represent negative, zero, and
positive respectively.

    0NZP    Check value in RS1 (negative zero positive)
    -------------------------------------------------------------------
    0111    unconditional jump (jump if value is Neg, Zero or Positive)
    0100    jump if RS1 is negative
    0010    jump if RS1 is zero
    0001    jump if RS1 is positive
    0110    jump if RS1 is not positive
    0101    jump if RS1 is not zero
    0011    jump if RS1 is not negative
    0000    never jump (no operation; NOP)


Instruction format
------------------

            Mm Reg     01  02  03
    --------------------------------
    0 END    - ----     0   0   0
    1 HBY    - --W-    UC  UC  RD
    2 LBY    - --W-    UC  UC  RD
    3 LOD    R R-W-   RS1   0  RD
    4 STR    W RR--   RS1 RS2   0
    5 ADD    - RRW-   RS1 RS2  RD
    6 SUB    - RRW-   RS1 RS2  RD
    7 ADI    - R-W-   RS1  UC  RD
    8 SBI    - R-W-   RS1  UC  RD
    9 AND    - RRW-   RS1 RS2  RD
    A ORR    - RRW-   RS1 RS2  RD
    B XOR    - RRW-   RS1 RS2  RD
    C NOR    - RRW-   RS1 RS2  RD
    D SHF    - R-W-   RS1  DA  RD
    E BRV    - RR-W   RS1 RS2  cond
    F ---    - ----


    Legend:
    ---------------------------------------------------------------------
       Mm   Memory access:    R = read, W = write, - = not accessed
      Reg   Register access:  R = read, W = write, - = not accessed
            The four register access columns correspond to RS1 RS2 RD PC
      RS1   Source register 1 (2nd nibble)
      RS2   Source register 2 (3rd nibble)
       RD   Destination register (4th nibble)
       PC   Program counter (instruction pointer)
       UC   Unsigned constant (1st or 2nd nibble)
        0   Always zero, unused
       DA   Direction and amount to shift bits
     cond   Value condition bits 0NZP
