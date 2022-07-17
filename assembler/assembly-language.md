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

Main: a memory address in ROM.  The PC is set to this address when the frame interrupt is triggered.
This is the address of the main loop of your program.

```
main $0100
```

The starting addresse of special areas in RAM (defined according to the memory map):

```
tiles
io_registers
gamepad
foreground_palettes
background_palettes
color_cells
tile_cells
```


Lines
=====

Each line in an assembly file consists of one of the following:

- Empty line
- Comment
- Const Command
- Label
- Main Loop Marker
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
Labels do not generate any actual machine code.
```


Main Loop Marker
----------------

The main loop marker is fixed at address $0100.
Use the main loop marker to increase the assembler's memory address counter
to $0100.  $0100 is the entry to the main loop of your program.
ROM cells that are skipped because of the main loop marker are zero-filled.
The main loop marker must appear at or before address $0100.
The main loop marker cannot appear after address $0100.
The main loop marker looks like a label, except it uses [] instead of ().

```
# Intialization code
# ...
[main]
# Main loop code
# ...
```


Instructions
------------

The instructions define the instructions that go into the cartridge ROM.
These are the actual 15 hardware instructions.  They map 1-to-1 to the real
CPU instructions. (See ISA.md for instruction definition and details.)

```
END
HBY i8  R
LBY i8  R
LOD  R  R
STR  R  R
ADD  R  R  R
SUB  R  R  R
ADI  R i4  R
SBI  R i4  R
AND  R  R  R
ORR  R  R  R
XOR  R  R  R
NOT  R  R
SHF  R  D  A  R
BRV  R  C  R

Legend
---------------------------------------------------------------------
i4                  4-bit unsigned integer
i8                  8-bit unsigned integer
R                   Register number 0-15 (R0-R9 & RA-RF are symbols)
D                   Direction (L or R)
A                   Shift amount (1-8)
C                   any combination of [NZP]
---------------------------------------------------------------------
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

Load R3 with value at memory address in R9
LOD R9 R3       #  $3903

Store the value of R1 at the memory address in RF
STR R1 RF       #  $4F10

Add value in RE to value in R6 and store in RA
ADD RE R6 RA    #  $5E6A

Same format for SUB, AND, ORR, XOR as ADD

Add value in R3 to 15 and store in R0
ADI R3 $F R0    #  $73F0
ADI R3 15 R0    #  $73F0

Same format for SBI as ADI

`Not` value in RA and store in RB
NOT RA RB       #  $CA0B

Shift the value in R7 left by 2 and store in RA
SHF R7 L 2 RA   #  $D71A

Shift the value in R5 right by 7 and store in R0
SHF R5 R 7 R0   #  $D5E0

If value in R7 is negative or zero, PC = value in RB
BRV R7 NZ RB    #  $E7B6
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
JMP     Unconditional jump to address in register
SPC     Add 3 to current program counter (PC) and save result to register
```

The table below provides examples of the 7 pseudo instructions with
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
JMP R3        |   BRV R0 NZP R3
SPC R5        |   HBY $19 R5    LBY $83 R5
```


Data Commands
-------------

The data commands allow the programmer to easily define values in the
cartridge DATA ROM.  There are 4 data commands.

Data commands:
- .word
- .array
- .fill-array
- .str

A data command takes a name argument as its first parameter.
The name is entered into the symbol table as a key that maps to the current
data ROM address.  This allows the data ROM cell address to be used like a
variable in place of instruction arguments.
To prevent an entry into the symbol table, set the name to `_`.
If the name is `_`, then nothing is entered
into the symbol table.


## .word ##
Sets the current address in the data ROM to specified 16-bit value.
The value can be a symbol defined in the symbol table.

```
.word name initValue    # put initValue at current address in data ROM
                        # & SymbolTable[name] maps to current data ROM address

.word x 42              # Data ROM cell at current address contains 42
                        # & SymbolTable[x] maps to current data ROM address

.word _ 99              # The value at current address is 99, but nothing is
                        # added to the symbol table
```


## .array ##
Array reserves multiple consecutive 16-bit slots in data ROM and sets the
slots to specific values.  The values are all listed on the same line.
```
.array name [list of whitespace delimited unsigned integers]
.array my_ints 1 2 3
.array beep %0101_1100 $FEED $FACE 42
# Array with 8 hex values
.array long $F0 $F1 $F2 $F3     # First 4 words
.array _    $F4 $F5 $F6 $F7     # Last 4 words
# Array with 9 mixed-representation numbers; 3 per line.
.array foo %0101_0000_1111_1010 $FEED 16
.array _   %1111_0000_1111_1010 $FACE 32
.array _   %0000_1111_1111_0101 $BACE 64
```


## .fill-array ##
Format:
```
.fill-array name size fill
```

Examples:
```
.fill-array my_array 16 0    # my_array now refers to first address of
                            # 16-element array initialized to all zeros
.fill-array costs 4 $FF      # Creates an array named costs of 4 values of 255
.fill-array _ 5 7            # Creates unnamed array of 5 values of 7
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
.str hello Hello World
# The symbol points to the next word in memory
# The string "Hello Joe" can be referred to by greet symbol
.str greet Hello Joe
# You can use " in strings
.str _ She said "hi"
# Entering a long string
.str line1 This is the first sentence of
.str line2 the story.
.str line3 This is the second sentence
.str line4 of the story.
```

The .str command, name, and the string must fit on a single line.
The string length must be less than or equal to 30 (the screen width).
You cannot embed newlines in a .str string.
You should break up text into the individual lines as you would
like to display them in the program.
