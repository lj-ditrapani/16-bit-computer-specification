Storage For LJD 16-bit Computer
===============================
```
128 K Words (256 KB)
Addressable as
128 Blocks of 1,024 16-bit words
For each frame:
Can read an entire storage block into the RAM storage input section
Can write the entire RAM storage output section into a storage block

Storage read address word in RAM determines which block to read in to
RAM if the read enable bit is set.
Storage write address word in RAM determines which storage block to write to if the write enable bit is set.
Storage Read Enable bit
Storage Write Enable bit
```

File system
-----------

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
