Cartridge
=========

A cartridge has at least 4 ROM chips.  Each chips has 8 data pins.
2 chips of the same capacity are paired together to create a 16-bit data path for the Program (PGR) ROM. The other 2 chips, likewise, of the same capacity, are also paired together, to serve as the Data ROM.

Each pair of ROM chips could use 8k x 8 sized ROM chips, up to 64k x 8 sized ROM chips.

The console works with ROM as slow as 250 ns.

Possible ROM Pairs with Jan 1985 pricing (estimated)
```
Size (per chip) | Pair Capacity | Part Num | 250ns Pair | 200ns Pair | 150ns Pair
----------------|---------------|----------|------------|------------|-----------
 8K x 8         |  16 KB        | 2364     | $3.70      | $4.20      | $5.25
16K x 8         |  32 KB        | 23128    | $6.40      | $7.30      | $9.10
32K x 8         |  64 KB        | 23256    | $11.00     | $12.50     | $15.60
64K x 8         | 128 KB        | 23512    | $22.00     | $25.00     | $31.25
```

If more Data ROM is needed beyond 64K x 16, the cartridge can have addition Data ROM banks, up to 3 total. The cartridge receives 3 Data ROM device enable lines from the CPU, to allow bank switching between 3 Data ROM banks.  Each Data ROM bank is like the fist, made up of 2 matching 8-wide ROM chips.  The max number of ROM chips on a cartridge is 8: 2 for Program (PGR) ROM, and up to 6 for Data ROM.  A fully populated cartridge with 64K x 8 chips is 512 KB.

Data ROM Table
```
Number of banks | Addressable words | Max size in KB | Data ROM Chip Count
----------------|-------------------|----------------|--------------------
  1             |  64K x 16-bit     | 128 KB         | 2
  2             | 128K x 16-bit     | 256 KB         | 4
  3             | 192K x 16-bit     | 384 KB         | 6
```

This allows cartridges to get larger has the price of ROM chips fall over the years.
