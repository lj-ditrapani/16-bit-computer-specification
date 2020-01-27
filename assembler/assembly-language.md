<!-- ====|=========|=========|=========|=========|=========|=========|====== -->
LJD 16-bit CPU Assembly Language
================================

An assembly file consists of only printable ASCII characters
(which includes space, hex $20)
and the line feed character (a.k.a. \n).
In other words, hex values $0A and $20-$7E.
Tabs and carriage returns are forbidden.
Each line is limited to 80 characters in length.


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
Labels and variables are named with symbols.
Symbols start with a letter and can contain letters, numbers, - and \_.


Predefined symbols
------------------

The symbol table is initialized with the following symbols already defined.

For CPU registers (defined as 0-15):

```
R0-R9 & RA-RF
```

For I/O registers in RAM (defined according to the I/O map):

```
gamepad
color-sets
video-cells
frame-interrupt-vector
```


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


Sections
--------

A complete assembly file has 4 sections.

- Symbols
- Program
- Video
- Data

The Symbols section comes first.  It is delimited by
.symbols and .end-symbols section markers.
The second section is the Program section which is delimited by
.program and .end-program section markers.
The third section is the Video section, delimited by
.video and .end-video markers.
The fourth and final section is the Data section which is delimited by
.data and .end-data section markers.


Section markers:

- Symbols
    - .symbols
    - .end-symbols
- Program ROM
    - .program
    - .end-program
- Video ROM
    - .video
    - .end-video
- Data ROM
    - .data
    - .end-data


Symbols Section
===============

Each line in the symbols section sets a symbol in the symbol table.

Format:

    var_name value

`var_name` becomes a key in the symbol table that maps to value.
The value is stored as a 16-bit integer.  If the value is negative,
it is stored as a two's complement 16-bit integer.

Examples:

    x -7
    winning_number 42

The symbols can be used anywhere a number is expected.


Program Section
===============

The program section defines the instructions that go into the program ROM.
It does not effect data ROM or video ROM.
Lines in the program section can be one of 3 types:

- label
- instruction
- pseudo instruction


Labels
------
```
Labels are symbols surrounded with ()
(label_name)
labels go on separate lines by themselves
The value of a label is the ROM memory address of the line below it

One label per line

Use a label to name an address to be used for jumps/branches.
```


Instructions
------------

These are the actual 16 hardware instructions.  They map 1-to-1 to the real
CPU instructions.

```
END
HBY i8 R
LBY i8 R
LOD R  R
STR R  R
ADD R  R  R
SUB R  R  R
ADI R  i4 R
SBI R  i4 R
AND R  R  R
ORR R  R  R
XOR R  R  R
NOT R  R
SHF R  D  A  R
BRV R  value-condition R
BRF flag-condition R

Legend
---------------------------------------------------------------------
i4                  4-bit unsigned integer
i8                  8-bit unsigned integer
R                   Register number 0-15 (R0-R9 & RA-RF are symbols)
D                   Direction (L or R)
A                   Shift amount (1-8)
value-condition     any combination of [NZP]
flag-condition      any single character of [-CV]
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

Store at the memory address in RF the value of R1
STR RF R1       #  $4F10

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
If both carry and overflow flags are **NOT** set, jump to address in R8
BRF - RB        #  $E0B8
If carry flag is set, jump to address in R8
BRF C RB        #  $E0B9
If overflow flag is set, jump to address in R8
BRF V RB        #  $E0BA
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


Video Section
=================

The video ROM can contain only and exactly 1 instance of 1 command.

Video ROM copy
--------------

Copies binary content of file directly into video rom section of final
assembled binary.  The binary should have the 64 colors first and
then the large tiles followed by the small tiles.
The file copied in must be exactly
9,248 W (64 B + 18 KB = 18,496 B).
This command can only be used once.

```
video-rom-copy path/to/video-rom.bin
```


Data Section
============

The data section allows the programmer to easily define values for the
computer's data ROM.  The data section does not effect the program ROM.
There are 4 data commands.

Data commands:
- word
- array
- fill-array
- str

A data command takes a name argument as its first parameter.
The name is entered into the symbol table as a key that maps to the current
data ROM address.  This allows the data ROM cell address to be used like a
variable in the program section.  To prevent an entry into the symbol table,
set the name to `_`.  If the name is `_`, then nothing is entered
into the symbol table.


## word ##
Sets the current address in the data ROM to specified 16-bit value.
The value can be a symbol defined in the symbol table.

```
word name initValue     # put initValue at current address in data ROM
                        # & SymbolTable[name] maps to current data ROM address

word x 42               # Data ROM cell at current address contains 42
                        # & SymbolTable[x] maps to current data ROM address

word _ 99               # The value at current address is 99, but nothing is
                        # added to the symbol table
```


## array ##
Array reserves multiple consecutive 16-bit slots in data ROM and sets the
slots to specific values.  The values are all listed on the same line.
```
array name [list of whitespace delimited unsigned integers]
array my_ints 1 2 3
array beep %0101_1100 $FEED $FACE 42
# Array with 8 hex values
array long $F0 $F1 $F2 $F3     # First 4 words
array _    $F4 $F5 $F6 $F7     # Last 4 words
# Array with 9 mixed-representation numbers; 3 per line.
array foo %0101_0000_1111_1010 $FEED 16
array _   %1111_0000_1111_1010 $FACE 32
array _   %0000_1111_1111_0101 $BACE 64
end
```


## fill-array ##
Format:
```
fill-array name size fill
```

Examples:
```
fill-array my_array 16 0    # my_array now refers to first address of
                            # 16-element array initialized to all zeros
fill-array costs 4 $FF      # Creates an array named costs of 4 values of 255
fill-array _ 5 7            # Creates unnamed array of 5 values of 7
```
Size and fill represent 16-bit numbers.
If size is a symbol, it must be a pre-defined symbol, a symbol from the
.symbols section, or a symbol defined by a previous .data command.
The symbol definition may not occur after the fill-array command
that uses it.  The fill argument can be a literal integer or any symbol.


## str ##
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
str hello Hello World
# The symbol points to the next word in memory
# The string "Hello Joe" can be referred to by greet symbol
str greet Hello Joe
# You can use " in strings
str _ She said "hi"
# Entering a long string
str story This is the first sentence of the story
str _     and it needs a newline now.
word _ 10
str _     This is the second sentence after the
str _     first newline.
```

The str command, name, and the string must fit on a single line.
You cannot embed newlines in a str string.
Use `word _ 10` on the next line after the str command to add a
newline after the string.
