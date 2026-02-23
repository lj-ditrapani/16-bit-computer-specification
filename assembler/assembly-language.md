<!-- ====|=========|=========|=========|=========|=========|=========|====== -->
LJD 16-bit CPU Assembly Language
================================

An assembly file consists of only printable ASCII characters
(which includes space, hex $20)
and the line feed character (a.k.a. \n).
In other words, hex values $0A and $20-$7E.
Tabs and carriage returns are forbidden.
Each line is limited to 80 characters in length.


Values: Numbers and Symbols
====================================


Numbers
------
Numbers are integers (no floating point).
They can be decimal, hexadecimal ($), or binary (%).
Hexadecimal and binary can be zero or positive
Decimals can be positive, negative or zero.

Examples:
```
42                represents a positive decimal value
+42             + represents a positive decimal value
-42             - represents a negative decimal value
$D7E0           $ represents a hex value
%0101_1100      % represents a binary value
```

Underscores in numbers are ignored.
A negative decimal value is encoded as 16, 8 or 4-bit two's complement
depending on where it is used.


Symbols
-------
Labels, variables, and consts are named with symbols.
Symbols start with a letter and can contain letters, numbers, - and \_.
The assembler uses a symbol table to keep track of the symbols and their
corresponding numeric values.


Predefined symbols
------------------

The symbol table is initialized with the following symbols already defined.

For CPU registers (defined as 0-15):

```
R0-R9 & RA-RF
```

The starting addresse of special areas in memory (defined according to the memory map):

```
background_tiles
foreground_tiles
color_cells
tile_cells
background_palettes
foreground_palettes
audio
gamepad
```

Device names used for LOD and STR instructions

```
pgr   0
drom1 1
drom2 2
drom3 3
dram  4
vram  5
vdp   6
apu   7
```


Lines
=====

Each line in an assembly file consists of one of the following:

- Empty line
- Comment
- Const Command
- Label
- Instruction
- Pseudo Instructions
- Data Command

Each type of line is explained below.


Empty line
----------

An empty line is just the line feed character $0A (a.k.a. \n).
You can use empty lines to arrange your code.


Comments
--------

Use # to comment a line.
```
# this is a comment
END   # comment at end of line
```
Comments can be placed on a line by itself, or after any command except after a
str .data command.  A comment on a str line will be treated as part of the
content of the string.


Const Command
-------------

Use the .const command to enter a symbol into the symbol table.

Format:

    .const var_name value

`var_name` becomes a key in the symbol table that maps to value.
The value is stored as a 16-bit integer.  If the value is negative,
it is stored as a two's complement 16-bit integer.

Examples:

    .const x -7
    .const winning_number 42

The symbols can be used anywhere a number is expected.
The .const command does not generate any actual machine code.


Labels
------
```
Labels are symbols surrounded with ()
(label_name)
labels go on separate lines by themselves
The value of a label is the ROM memory address of the line below it

One label per line

Use a label to name an address to be used for jumps/branches.
Use a label to name data defined immediatly after it for use with WRD+LOD insrtuctions.
Labels do not generate any actual machine code.
```


Instructions
------------

The instructions define the instructions that go into the cartridge ROM.
These are the actual 16 hardware instructions.  They map 1-to-1 to the real
CPU instructions. (See ISA.md for instruction definition and details.)

```
END
HBY  i8  R
LBY  i8  R
LOD DEV  R  R
STR DEV  R  R
ADD   R  R  R
SUB   R  R  R
ADI   R i4  R
SBI   R i4  R
AND   R  R  R
ORR   R  R  R
XOR   R  R  R
NOR   R  R  R
SHF   R  D  A  R
BRV   R  V  R
BRF   F  R

Legend
----------------------------------------------------------------------------
i4                  4-bit unsigned integer
i8                  8-bit unsigned integer
R                   Register number 0-15 (R0-R9 & RA-RF are symbols)
D                   Direction (L or R)
A                   Shift amount (1-8)
V                   any combination of [NZP]
F                   any single character of [-CV]
DEV                 a 3-bit unsigned integer representing one of the devices
----------------------------------------------------------------------------
```


### Instruction Examples ###

Examples of how to write the different instructions with the assembled
hexadecimal output in the comments on the right.
```
Set high byte of RA to 255
HBY $FF RA      #  $1FFA
HBY 255 RA      #  $1FFA

Set low byte of R5 to 16
LBY $10 R5      #  $2105
LBY 16 R5       #  $2105

Load R3 with value at memory address in R9 in Data ROM bank 1
LOD drom1 R9 R3       #  $3903

Store the value of R1 at the memory address in RF in Data RAM
STR dram R1 RF       #  $4F10

Add value in RE to value in R6 and store in RA
ADD RE R6 RA    #  $5E6A

Same format for SUB, AND, ORR, XOR as ADD

Add value in R3 to 15 and store in R0
ADI R3 $F R0    #  $73F0
ADI R3 15 R0    #  $73F0

Same format for SBI as ADI

`Nor` value in RA with RB and store in RC
NOR RA RB RC    #  $CABC

Shift the value in R7 left by 2 and store in RA
SHF R7 L 2 RA   #  $D71A

Shift the value in R5 right by 7 and store in R0
SHF R5 R 7 R0   #  $D5E0

If value in R7 is negative or zero, PC = value in RB
BRV R7 NZ RB    #  $E7B6

If both carry and overflow flags are **NOT** set, jump to address in RB
BRF - RB        #  $F0B0
If carry flag is set, jump to address in RB
BRF C RB        #  $F0B1
If overflow flag is set, jump to address in RB
BRF V RB        #  $F0B2
```


Pseudo Instructions
-------------------

Pseudo instructions are instructions that do not have actual hardware
implementations but instead are assembled into one or more actual hardware
instructions.  They provide a shorthand for common operations and make the
assembly code more clear and concise.

```
name    Description
--------------------------------------------------------------------------
CPY     Copy value in one register to another
NOP     Perform no operation
WRD     Copy word (16-bit integer) into register
INC     Increment contents of register by 1
DEC     Decrement contents of register by 1
NOT     Invert bits of source register and save to destination register
JMP     Unconditional jump to address in register
SPC     Add 3 to current program counter (PC) and save result to register
ZER     Zero register; set register value to 0.
```

The table below provides examples of the 9 pseudo instructions with
the corresponding translated real instructions in the right column.
Assume PC is $1980 for the SPC instruction translation.

```
pseudo        |   Actual assembly instructions
------------------------------------------------
CPY R1 R2     |   ADI R1 0 R2
NOP           |   ADI R0 0 R0
WRD $1234 R7  |   HBY $12 R7    LBY $34 R7
INC R3        |   ADI R3 1 R3
DEC R3        |   SBI R3 1 R3
NOT R1 R2     |   NOR R1 R1 R2
JMP R3        |   BRV R0 NZP R3
SPC R5        |   HBY $19 R5    LBY $83 R5
ZER R0        |   XOR R0 R0 R0
```


Data Commands
-------------

The data commands allow the programmer to easily define values in the
cartridge PGR or DATA ROM.  There are 4 data commands.

Data commands:
- .word
- .array
- .fill-array
- .str

You can use a preceding label to give the address of the data a name.
This allows you to easily use the label in a WRD instruction followed by a LOD.


## .word ##
Sets the current address in the data ROM to specified 16-bit value.
The value can be a symbol defined in the symbol table.

```
.word initValue       # put initValue at current address in data ROM

.word 42              # Data ROM cell at current address contains 42

.word 99              # The value at current address is 99
```


## .array ##
Array reserves multiple consecutive 16-bit slots in data ROM and sets the
slots to specific values.  The values are all listed on the same line.
```
.array [list of whitespace delimited unsigned integers]
.array 1 2 3
.array %0101_1100 $FEED $FACE 42
# Array with 8 hex values
.array $F0 $F1 $F2 $F3     # First 4 words
.array $F4 $F5 $F6 $F7     # Last 4 words
# Array with 9 mixed-representation numbers; 3 per line.
.array %0101_0000_1111_1010 $FEED 16
.array %1111_0000_1111_1010 $FACE 32
.array %0000_1111_1111_0101 $BACE 64
```


## .fill-array ##
Format:
```
.fill-array size fill
```

Examples:
```
(my_array)
.fill-array 16 0      # my_array now refers to first address of
                      # 16-element array initialized to all zeros
(costs)
.fill-array 4 $FF     # Creates an array named costs of 4 values of 255
.fill-array 5 7       # Creates unnamed array of 5 values of 7
```
Size and fill represent 16-bit numbers.
If size is a symbol, it must be a pre-defined symbol, a previously defined
const, or a symbol defined by a previous data command.
The symbol definition may not occur after the .fill-array command
that uses it.  The fill argument can be a literal integer or any symbol.


## .str ##
A string is a sequence of 7-bit ASCII characters.
Two characters are packed into one word.
The first character in the high-order byte and the
second character into the low-order byte.
The string begins with the first non-whitespace character following
the name parameter and ends with a new line.
The generated binary of the str command consists of the 16-bit length
of the string followed by the characters of the string in each
subsequent word, two per word.
There is no null terminating character in the binary.

```
# The string "Hello World" set to the hello symbol
(hello)
.str Hello World
# The symbol points to the next word in memory
# The string "Hello Joe" can be referred to by greet symbol
(greet)
.str Hello Joe
# You can use " in strings
.str She said "hi"
# Entering a long string
(line1)
.str This is the first sentence of
(line2)
.str the story.
(line3)
.str This is the second sentence
(line4)
.str of the story.
```

The .str command and the string must fit on a single line.
The string length must be less than or equal to 80 (the max screen width in high-res mode).
You cannot embed newlines in a .str string.
You should break up text into the individual lines as you would
like to display them in the program.


Sections
========


## ROM Layout ##

The first line of the file must be the ROM layout.
It is delimited by angle brackets and contains the number of 16-bit addresses
available for each ROM bank.  Valid sizes or 16K, 32K, and 64K.
Each bank definition is separated by a colon.
All 4 banks must be defined.
Unused/unpopulated banks should have 0K.
`PGR` is always non-zero/populated.

Examples:
```
# only PGR ROM
<PGR 16K:DATA1 0K:DATA2 0K:DATA3 0K>
# Full PGR ROM and 1 full DATA1 ROM
<PGR 64K:DATA1 64K:DATA2 0K:DATA3 0K>
# Maxed-out catridge
<PGR 64:DATA1 64K:DATA2 64K:DATA3 64K>
```


## Section Markers ##

Each section must be marked with section marker.
Section makers must appear in order.
Don't declare sections that are unused/unpopulated.
A section marker is the name of the ROM bank enclosed in square brackets.
Only the `[PGR]` section may contain CPU instructions.
Data Commands may appear an any section.
The `[PGR]` section is mandatory.

```
[PGR]
[DATA1]
[DATA2]
[DATA3]
```
