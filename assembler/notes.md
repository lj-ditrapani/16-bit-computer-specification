- Can do a single pass over symbol & data sections
- Must do 2 passes over program section

```
.symbols
.end-symbols

.data-ram
    set a bunch of values
.end-data-ram

.video-rom
.end-video-rom

.program-rom
# Program starts at address $0000
    init code
# Main loop starts at address $0400
    main loop
.end-program-rom
```

- any amount of whitespace before any command is ok
