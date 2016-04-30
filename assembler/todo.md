- Design is wrong!  The frame-interrupt-vector will usually need to be set by a label in the program section, and that label referenced at the frame-interrupt-vector address in the .data section.  So the binary for the .data section cannot be generated until the labels in the program section have been parsed.


    .data
        set a bunch of values
        move frame-interrupt-vector
        word handle-fiv
    .end
    .program
        init code
    (handle-fiv)
        main loop
    .end

- Use regex.test instead of str.match for boolean
- Improve regexes with character classes :decimal :alpha?
- any amount of whitesace before any command is ok
- Token
  int or symbol
- Symbol table
  - set(symbol\_str, value\_token) instead of (key, int\_value)
  - resolve symbol tokens to int first by table lookup
  - the `_` symbol should not add anything to teh table
- Pipeline
  - make nice browser acceptance test to test the production bundle
  - Either force user to install CoffeeScript (CoffeeScript becomes runtime
    dependency on node) or acceptance test standalone bundle.js on command
    line.
    - probably do both since command line addition (read/write real files)
      will be in CoffeeScript anyway.
  - May need to make a command line node acceptance test that runs against
    the standalone javascript browserified bundle.js
  - could have test/acceptance-web.js and test/acceptance-cli.js
- Rewrite readme usage
    - primarily browser (assembler core interface)
    - secondarily cli-interface (future; comment out for now)
- Should have the command line app (file-based) call the standalone bundle.js
  instead of using the CoffeeScript
- Rewrite assembler to work in Harvard architecture.
    - string of asm -> assembler core -> {ram: [], rom: []}
    - asm file -> asm-cli -> binary file
    - asm-cli uses assembler core
    - browser uses only assembler core (via browserify)
    - node uses asm-cli or assmbler core
- Make a good user acceptance test
  - full program as string
  - outputs {rom: [], ram: []}
  - exercises all commands & instructions
  - add program output as an acceptance test for cpu


Refactoring ideas (from old design)
Error handling

- SymbolTable:  do not allow reserved words as symbols
  (no directives, instructions, or pseudo-instructions)
  (what about LR, NZP, CV-, strip-newlines, keep-newlines
- Negative values get treated like symbols because they don't start
  with a digit, a $ or a %
- BRV value condition:  NZZ, NNNN, PZP will all pass without error.
  Not worth checking?  Currently only check with /^[NZP]+$/ regex.
