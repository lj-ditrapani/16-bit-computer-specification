<!-- =============================================================== -->
The ljd 16-bit computer specification
=====================================

A complete 16-bit computer
with the following:
- 64 KW ROM for program
- 64 KW RAM for data
- Color display
- Keyboard input
- Storage
- Primitive Networking
- NES-style audio output


Component Specifications
------------------------

- CPU:  [cpu.md](cpu.md)
- Video:  [video.md](video.md)
- Keyboard:  [keyboard.md](keyboard.md)
- Storage:  [storage.md](storage.md)
- Networking:  [networking.md](networking.md)
- Audio:  Not yet even in design phase...


System-level Specifications
---------------------------

- I/O Map:  [I/O Map](IO-map.txt)
- Notes on possible physical implementation:
  [notes/physical-implementation-ideas.md](notes/physical-implementation-ideas.md)


Implementations
---------------

Scala (recently started, in progress):
- Full Computer: <https://github.com/lj-ditrapani/16-bit-computer-scala>

CoffeeScript:
- CPU: <https://github.com/lj-ditrapani/16-bit-computer-cpu-coffeescript>
- Video: <https://github.com/lj-ditrapani/original-design-16-bit-computer-video>
- Old, first design, CPU: <https://github.com/lj-ditrapani/original-design-16-bit-computer-cpu>


Software
--------

- Planning to rewrite assembler in scala
- Assembler (old version in ruby) <https://github.com/lj-ditrapani/original-design-16-bit-computer-assembler>
