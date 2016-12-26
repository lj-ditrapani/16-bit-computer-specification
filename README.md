<!-- =============================================================== -->
The ljd 16-bit computer specification
=====================================

A complete 16-bit computer
with the following:
- 128 KB Program ROM
- 128 KB RAM
- 2 X 3,104 Byte Video ROM
- Color display
- Gamepad input


Component Specifications
------------------------

- CPU:  [cpu.md](cpu.md)
- Video:  [video.md](video.md)
- Gamepad:  [gamepad.md](gamepad.md)


System-level Specifications
---------------------------

- I/O Map:  [IO-map.txt](IO-map.txt)
- Binary program loader: [program-loader.md](program-loader.md)
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
