Program Loader
==============

The program loader takes a stream of 16-bit words and writes them into the
computer.  The first 64 KW go into the Program ROM section, starting at
address 0 and continuing in numerical order until address 65,536.
The next 16 words go into the colors section of the Video ROM.
Then, the next 1.5 KW go into the Tiles section of the Video ROM.
Finally, the last 64 KW go into the Data RAM section, starting at address 0 and
continuing in numerical order until address 65,536.

The maximum stream length is 132,624 words (64 KW + 64 KW + 16 W + 1.5 KW).
If the stream terminates before 132,624 the remaining memory addresses are
left uninitialized and will have random/garbage data values.
The programmer must take care to properly initialize any uninitialized
Data RAM values.

A program stream can be very short for small programs if the programmer
doesn't set the Video ROM values or initialize any Data RAM.
The program can use the built-in colors and tile set
and initialize any required RAM values during program execution.
