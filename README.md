<!-- =============================================================== -->
The ljd 16-bit computer
=======================

A complete 16-bit computer
with the following:
- 64KW ROM for program
- 64KW RAM for data
- Color display
- Keyboard input
- Storage
- Primitive Networking
- NES-style audio output


Components
----------

- CPU:  [cpu.md](https://github.com/lj-ditrapani/16-bit-computer-specification/blob/master/cpu.md)
- Video:  [video.md](https://github.com/lj-ditrapani/16-bit-computer-specification/blob/master/video.md)
- Keyboard:  [keyboard.md](https://github.com/lj-ditrapani/16-bit-computer-specification/blob/master/keyboard.md)
- Storage:  [storage.md](https://github.com/lj-ditrapani/16-bit-computer-specification/blob/master/storage.md)
- Networking:  [networking.md](https://github.com/lj-ditrapani/16-bit-computer-specification/blob/master/networking.md)
- Audio:  Not yet even in design phase...


System
------

- IO Map:  [IO Map](https://github.com/lj-ditrapani/16-bit-computer-specification/blob/master/IO-map.txt)
- Notes on possible physical implementation:
  [notes/physical-implementation-ideas.md](https://github.com/lj-ditrapani/16-bit-computer-specification/blob/master/notes/physical-implementation-ideas.md)


Implementations
--------------

Scala (planned, not yet started):
- Full Computer: <https://github.com/lj-ditrapani/16-bit-computer-scala>

CoffeeScript:
- CPU: <https://github.com/lj-ditrapani/16-bit-computer-cpu>
- Video: <https://github.com/lj-ditrapani/16-bit-computer-video>


Software
--------

- Planning to rewrite assembler in scala
- Assembler (old version in ruby) <https://github.com/lj-ditrapani/original-design-16-bit-computer-assembler>
- Assembler (abandoned rewrite in CoffeeScript) <https://github.com/lj-ditrapani/16-bit-computer-assembler>


Status
------

- Aggregating and re-organizing documentation into one place
- Doing re-write in scala
