<!-- ====|=========|=========|=========|=========|=========|=========|===== -->
LJD 16-bit CPU Assembly Language
================================

An assembly file consists of only printable ASCII characters (includes space)
and the line feed character (a.k.a. \n).
In other words, hex values $0A and $20-$7E.
Tabs and carriage returns are forbidden.


Numbers
------
Numbers are integers (no floating point).
They can be decimal, hexadecimal ($), or binary (%).
Decimals can be positive or negative.

Examples:
```
42                represents a positive decimal value
+42             + represents a positive decimal value
-42             - represents a negative decimal value
$D7E0           $ represents a hex value
%0101_1100      % represents a binary value
```

Underscores in numbers are ignored.
A negative decimal value is encoded as 16, 8 or 4-bit two's complement.


Symbols
-------
Labels and variables are named with symbols.
Symbols start with a letter and can contain letters, numbers, - and \_.


Predefined symbols
------------------

The symbol table is initialized with the following symbols already defined.

For CPU registers (defined as 0-15):

```
R0-RF
R0-R15
```

For I/O registers in RAM (defined accord to the I/O map):

```
keyboard
net-status
net-destination
enable-bits
storage-read-address
storage-write-address
frame-interrupt-vector
control-registers
audio
net-in
net-out
storage-in
storage-out
video
large-tiles
small-tiles
char-tiles
background-cells
text-cells
background-colors
sprite-colors
large-sprites
small-sprites
```


Comments
--------

Use # to comment a line.
```
# this is a comment
END   # comment at end of line
```
Comments can be placed on any lines except on string related .data commands.
Specifically, comments cannot appear on (w)str lines and on lines within a
long-(w)str command.


Sections
--------

A complete assembly file has 3 sections.

- Symbols
- Data (RAM)
- Program (ROM)

The Symbols section comes first.  It is delimited by .symbols and .end-symbols
section markers.  The second section is the data section which is delimited by
.data and .end-data section markers.  The third and final section is the
program section which is delimited by .program and .end-program section markers.

Section markers:

- Symbols
    - .symbols
    - .end-symbols
- Data
    - .data
    - .end-data
- Program
    - .program
    - .end-program


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


Data Section
============

The data section allows the programmer to easily define initial values for the
computer's RAM.  The data section does not effect ROM.
There are 13 data commands split into two groups
(8 value commands & 5 block commands):

value commands:
- word
- array
- long-array
- fill-array
- str
- wstr
- long-str
- long-wstr

block commands
- move
- copy
- tiles
- scene
- bg-cells

A value command takes a name argument as its first parameter.
The name is entered into the symbol table as a key that maps to the current
RAM address.  This allows the RAM cell at the current address to be used like a
variable in the program section.  To prevent an entry into the symbol table,
set the name to `_`.  If the name is `_`, then nothing is entered
into the symbol table.


## word ##
Sets the current address in the RAM to specified 16-bit value.
```
word name initValue     # put initValue at current address in RAM
                        # name now maps to current address in symbol table

word x 42               # x now refers to RAM address which contains value 42

word _ 99               # The value at current address is 99, but nothing is
                        # added to the symbol table
```


## array ##
Array reserves multiple consecutive 16-bit slots in RAM and sets the
slots to specific values.  The values are all listed on the same line.
Use long-array for multi-line arrays.
```
array name [list of whitespace delimited unsigned integers]
array my_ints 1 2 3
array beep %0101_1100 $FEED $FACE 42
```


## long-array ##

If you need more than one line worth of values, use long-array instead of
array.  The `end` keyword on a line by itself ends the long-array.
```
long-array indecies
    $F0 $F1 $F2 $F3     # First 4 words
    $F4 $F5 $F6 $F7     # Last 4 words
end
```

Array with 9 mixed-representation numbers; 3 per line.
```
long-array foo
    %0101_0000_1111_1010 $FEED 16
    %1111_0000_1111_1010 $FACE 32
    %0000_1111_1111_0101 $BACE 64
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
```
The str command, name, and the string must fit on a single line.
Use the long-(w)str command for multi-line strings.
You cannot embed newlines in a str string.
Use the long-(w)str to embed newlines in a string or put `word _ 10`
after the str command to add a newline after the string.


## wstr ##
wstr stands for wide string.  It is just like the str command
except a character takes up one 16-bit word.  So a wstr takes up twice as much
storage.  However it can accommodate 16-bit Unicode characters.


## long-str ##
Begins a multi-line string.  The binary value generated is in the same
format as that generated by the str command; the length of the string
followed by the character codes of the string---2 characters per word.
The `end` keyword on a line by itself ends the long-str.

Format:

    long-str name (keep-newlines|strip-newlines)

With keep-newlines, the '\n' char is appended to each line

    long-str string1 keep-newlines
    line one
    line two
    line three
    end

With strip-newlines, the newlines at the end of each line are stripped.
Newlines cannot appear in strip-newlines long-strs.

    long-str string2 strip-newlines
    line one
    still line one
    still line one
    end


## long-wstr ##
Just like the long-str command, but uses the wide string format.
A character takes up one 16-bit word.

    long-wstr string1 keep-newlines
    line one
    line two
    end


## move ##
Assembler moves current RAM address to specified address during assembly.
Can only move forward in address space from current address,
not backwards.  Cannot use symbols that refer to labels. The argument
must be a number, a pre-defined symbol, a symbol defined
in the .symbols section, or a symbol defined by a previous data command.
The value is an unsigned 16-bit integer.
The move command zero-fills holes in ram.
```
move $0F00      # All RAM cells from current address to $0EFF are set to zero
                # and the current address is set to $0F00
move audio
```

## copy ##
Copies binary content of file directly into final assembled binary starting at
current location.

    copy path/file-name.ext
    move tiles
    copy video/mario-tiles.bin
    copy text/story.txt  # copies data into ram starting at current address
    copy video-data.bin


## tiles ##
Like copy command, but moves to video address first.
Cannot be used after assembler moves past video address.
The file must be in the
'[text tile format](assembler/tile-file-format.md)'.
The assembler will parse the text tile file into a binary tile format and then
copy the resulting 3 KW (6 KB) binary into the video section.  This command can
only be used once.

    tiles path/main.tiles


## scene ##
Parses file as a scene file and produces a 1 KW (2 KB) binary.
The file must be in the
'[text scene format](assembler/scene-file-format.md)'.
The resulting binary is copied into the current ram address.
This command is often used after a tiles command to place the initial scene of
the program.
It can be used multiple times in other locations in ram to place other scenes for
the program.

    scene path/level1.scene
    scene path/level2.scene
    # bunch of other data
    tiles path/main.tiles
    scene path/main.scene


## bg-cells ##
Parses file as a bg-cells file and produces a 240 word (480 byte) binary.
The file must be in the
'[text bg-cells format](assembler/bg-cells-file-format.md)'.
The resulting binary is copied into the current ram address.
It can be used multiple times in other locations in ram to place other bg-cells
for the program.

    bg-cells path/level1.bgcells
    bg-cells path/level2.bgcells
    # bunch of other data
    tiles path/main.tiles
    bg-cells path/main.bgcells


Program Section
===============

The program section defines the instructions that go into ROM.
It does not effect RAM.
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
R                   Register number 0-15 (R0-R15 & RA-RF are symbols)
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
HBY 255 R10     #  $1FFA

Set low byte of R5 to 16
LBY $10 R5      #  $2105
LBY 16 R5       #  $2105

Load R3 with value at memory address in R9
LOD R9 R3       #  $3903

Store at the memory address in RF the value of R1
STR RF R1       #  $4F10

Add value in RE to value in R6 and store in RA
ADD RE R6 RA    #  $5E6A
ADD R14 R6 R10  #  $5E6A

Same format for SUB, AND, ORR, XOR as ADD

Add value in R3 to 15 and store in R0
ADI R3 $F R0    #  $73F0
ADI R3 15 R0    #  $73F0

Same format for SBI as ADI

Not value in RA and store in RB
NOT RA RB       #  $CA0B

Shift the value in R7 left by 2 and store in RA
SHF R7 L 2 RA   #  $D71A
SHF R7 L 2 R10  #  $D71A

Shift the value in R5 right by 7 and store in R0
SHF R5 R 7 R0   #  $D5E0

If value in R7 is negative or zero, PC = value in RB
BRV R7 NZ RB    #  $E7B6
If both carry and overflow flags are *NOT* set, jump to address in R8
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
the corresponding translated true instructions in the right column.
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
