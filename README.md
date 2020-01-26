<!-- =============================================================== -->
The ljd 16-bit computer specification
=====================================

A complete catridge-based 16-bit computer
with the following:
- 60 KB General RAM
- 2 KB I/O RAM (double buffered)
- Color display 256 x 240 pixels
- Gamepad input

Catridge:
- 96 pin connector
- 128 KB Program ROM
- 64 KB Data ROM
- 18 KB + 64 B Video ROM

Screenshot:

![video/example-screen.png](video/example-screen.png)


Component Specifications
------------------------

- CPU:  [cpu.md](cpu.md)
- Video:  [video.md](video.md)
- Gamepad:  [gamepad.md](gamepad.md)


System-level Specifications
---------------------------

- I/O Map:  [IO-map.txt](IO-map.txt)
- Notes on possible physical implementation:
  [notes/physical-implementation-ideas.md](notes/physical-implementation-ideas.md)


Implementations
---------------

- Complete computer emulator: <https://github.com/lj-ditrapani/16-bit-computer-scala>

Other projects implementing only individual components:
- CPU: <https://github.com/lj-ditrapani/16-bit-computer-cpu-coffeescript>
- Video (old, first design, incompatible with spec): <https://github.com/lj-ditrapani/original-design-16-bit-computer-video>
- CPU (old, first design, incompatible with spec): <https://github.com/lj-ditrapani/original-design-16-bit-computer-cpu>


Software
--------

- Rewriting assembler in scala
    - ASCII tiles to bin tiles transformer is working
    - Can assemble instructions in program-rom section
      (symbols, labels, data & video rom not implemented yet)
- Assembler (old version in ruby) <https://github.com/lj-ditrapani/original-design-16-bit-computer-assembler>
