System Timing
=============

- 4 clocks per LOD or STR instruction
- 2 clocks for all other instructions
- Frames per second: 60

CPU executes 79,998 or 80,000 clocks per frame depending on the instructions.
- The VDP counts clocks for each frame, starting at 1.
- VDP sends wait signal to CPU during clock 79,998
- CPU finishes current instruction before going into wait mode
- The current CPU instruction completes at the end of clock 79,998
  for a 2 cycle instruction, or 80,000 for a 4 cycle instruction.
- VDP waits until clock 80,000 completes
  before starting the work for the next frame.
- The VDP releases the CPU from wait mode in time to maintain 60 frames per second.
  The VDP starts counting clocks again from 1 once the CPU is active again.

A correct implementation must chose a CPU frequency and
the amount of time the VDP puts the CPU in wait mode
in order that the above properties hold true.

The CPU executes 1.2-2.4 million instructions per second (MIPS).
