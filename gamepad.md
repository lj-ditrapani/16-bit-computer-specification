Gamepad
=======

```
There are 8 buttons
up, down, left, right, a, b, x, y
The gamepad register is read only.
The lower 8 bits of the gamepad register map to
each of the 8 buttons in order.

U   up
D   down
L   left
R   right
A   A
B   B
X   X
Y   Y

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
| 8 Unused bits |U|D|L|R|A|B|X|Y|
---------------------------------

0 -> not pressed
1 -> pressed

The gamepad register is double buffered.
While the cpu has access to the gamepad register values
from on the previous frame, the gamepad controller is recording
the gamepad presses for the current frame.

At the beginning of a frame, the gamepad registers are swapped.
The gamepad controller sets the new gamepad register to $00; clearing
out the previous values.
Then, as the frame progresses, when the user presses a button,
the gamepad controller sets the corresponding button bit value to 1.
By the end of the frame, the gamepad controller will have marked
all buttons that were pressed during that frame as 1,
and any buttons that were never pressed during the frame as 0.
```
