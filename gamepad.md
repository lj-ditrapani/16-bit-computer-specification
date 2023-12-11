Gamepad
=======

There are 8 buttons
up, down, left, right, a, s, d, f
The gamepad register is read only.
The lower 8 bits of the gamepad register map to
each of the 8 buttons in order.

```
U   up
D   down
L   left
R   right
A   A
S   S
D   D
F   F

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|U|D|L|R|A|S|D|F|U|D|L|R|A|S|D|F|
---------------------------------

0 -> not pressed
1 -> pressed

The lower 8-bits are for controller 1
and the higher 8-bits are for controller 2.
```

The gamepad register is double buffered.
While the cpu has access to the gamepad register values
from the previous frame, the VDP is recording
the gamepad presses for the current frame in a separate register.

At the beginning of a frame, the VDP's gamepad register value is
copied over to the CPU's gamepad register.
Near the end of a frame, the VDP reads in the gamepad state
and overwrites its gamepad register values with the state of the
gamepad.  1 means pressed and 0 means not pressed.

A physical implementation could follow the Nintendo Entertainment System approach.  You could have a five wire connection

- ground
- high voltage
- clock
- latch
- data

The controller would need an 8-bit parallel to serial shift register that could read in and save the state
of the 8 buttons.
The VDP would send the latch signal when it wants to controller to save
its button press state.
And then it would read the first bit/button press off of the data line.
Next it would cycle the clock line.  The clock would go to the shift
register "shift" pin, which would shift the bits over, making the next
bit/button press available on the data line.  The VDP could then read
the next bit and then repeat the clock/read process six more times until
all 8 bits area read.
