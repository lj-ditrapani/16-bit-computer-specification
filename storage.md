Storage For LJD 16-bit Computer
===============================

```
The storage device contains 128 K Words (256 KB).
The contents are addressable as
128 Blocks of 1,024 16-bit words
The storage device can read or write one storage block at a time.
The first word of each block on disk in unused (unreadable/unwritable).
It is used as the command word instead.

The storage address section of the Command Word in RAM determines
which one of the 128 storage blocks to read or write.
If the enable bit is set, the storage controller will attempt
to fulfill the read or write request.
If the enable bit is not set, the storage controller will ignore the request.

The mode bit is how the program tells the storage controller whether
to do a read or a write operation.

The storage controller sets the status to new when it completes a request
and then, swaps the storage buffers.
The storage controller sets the status to old otherwise.
Setting the status bit to new is how the storage controller tells the
program that it has completed a request.
If the enable bit was set on the last frame, then the storage controller is
now working on the next request.
If the previous request was a read, the block read from disk is now in the
Data section of storage RAM.
If the previous request was a write, the words in the Data section of storage
RAM have been transferred to the storage block specified in the command word.
```


Storage RAM
-----------

```
Words   Purpose     Address
--------------------------------
  1     Command     $F800
127     Data        $F801-$FBFF
```


Command Word Register
---------------------

```
Symbol      Purpose                             Size        Usage
----------------------------------------------------------------------
S           Status: 0 -> new, 1 -> old          1 bit       Read only
M           Mode: 0 -> Read, 1 -> Write         1 bit       Write only
E           Enable: 0 -> Off, 1 -> On           1 bit       Write only
Address     Storage address to read or write    7 bits      Write only

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|---------|S|M|E|-|   Address   |
---------------------------------
```


File system
===========

The file system is optional.
It consists of a "used" bitmap, directory and block chaining


Block-used Bitmap
-----------------
```
The first 8 words of the first block contains the "block-used Bitmap
Words $00-$07
"Block-Used" Bitmap: 8 Words $00-$07
8 * 16 = 128 bits which corresponds to the 128 blocks
1 means block is used; 0 means block is free
Bit 0 is set to 1 because it corresponds to the (bit-map + directory)
```


Directory
---------
```
First block (minus the first 8 words) contains the directory
1,016 Words
Directory:
$08-$FF
8 word entries
127 entries
127 * 8 = 1,016 Words

Bitmap        8 words
directory 1,016 words
---------------------
total     1,024 words
```


Block chaining
--------------
```
First word: Number of blocks
If number of blocks > 1
    Second word has address of next block
```
