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

- any amount of whitesace before any command is ok
