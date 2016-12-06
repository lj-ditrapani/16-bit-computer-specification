- Can do a single pass over symbol & data sections
- Must do 2 passes over program section

- Can use the below trick to set frame-interrupt-vector or other ROM addresses
  saved into ram locations.  For a specific example why you would want this:
  The frame-interrupt-vector will usually need to be set by a label in the
  program section. The ROM address at that label will need be written into the
  RAM address for the frame-interrupt-vector.


```
.symbols
.end-symbols

.data-ram
    set a bunch of values
.end-data-ram

.video-rom
.end-video-rom

.program-rom
    init code
    # Copy ROM address of handle-fiv into RAM address for frame-interrupt-vector
    WRD frame-interrupt-vector R0
    WRD handle-fiv R1
    STR R0 R1
(handle-fiv)
    main loop
.end-program-rom
```

- any amount of whitespace before any command is ok
