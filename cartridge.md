Cartridge
=========

A cartridge is made up of 1 to four pairs of ROM chips.  Each chip has 8 data pins.
A pair of ROM chips is 2 chips of the same capacity paired together to create a 16-bit data path.
The first pair is for the Program (PGR) ROM.
The PGR ROM is the only ROM bank used for CPU instructions (though it may also contain data).

Each pair of ROM chips can use 16K, 32K, or 64K x 8 sized ROM chips.

The console works with ROM as slow as 250 ns.

Possible ROM Pairs with Jan 1985 pricing (estimated)
```
Size (per chip) | Pair Capacity | Part Num | 250ns Pair | 200ns Pair | 150ns Pair
----------------|---------------|----------|------------|------------|-----------
16K x 8         |  32 KB        | 23128    | $6.40      | $7.30      | $9.10
32K x 8         |  64 KB        | 23256    | $11.00     | $12.50     | $15.60
64K x 8         | 128 KB        | 23512    | $22.00     | $25.00     | $31.25
```

Up to 3 Data ROM banks can be added to the cartridge.
They cannot contain CPU instructions, only data.
Each Data ROM bank is a pair of matching 8-wide ROM chips like PGR ROM.
The cartridge receives 3 Data ROM device enable lines from the CPU,
to allow bank switching between 3 Data ROM banks.
The max number of ROM chips on a cartridge is 8: 2 for Program (PGR) ROM,
and up to 6 for Data ROM.
A fully populated cartridge with 64K x 8 chips is 512 KB.

Data ROM Table
```
Number of banks | Addressable words | Max size in KB | Data ROM Chip Count
----------------|-------------------|----------------|--------------------
  1             |  64K x 16-bit     | 128 KB         | 2
  2             | 128K x 16-bit     | 256 KB         | 4
  3             | 192K x 16-bit     | 384 KB         | 6
```

This allows cartridges to get larger as the price of ROM chips fall over the years.

A Data ROM bank could contain battery-backed SRAM instead of mask ROM to allow
for persistent game saves.  For example, a pair of
Hitachi HM6264 8K x 8 bit 150 ns chips could be used for the 3rd Data bank.
