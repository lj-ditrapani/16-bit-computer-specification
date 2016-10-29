LJD 16-bit Computer Network
===========================

2, 3 or 4 computers can be networked together at a time.
They connect to a network hub.
Each machine has a network ID set by the controller.
A message is 127 words long.
Messages are broadcast to all other computers on the network.
One message is sent at a time.
Only the computer with the write token can send the next message.
The write token rotates round robin to each computer on the network.
The Net ID contains the computer's own Net ID.
The write token contains the Net ID of the computer with the
write token.
If the Net ID and the write token ID match, then it is the computer's turn to
talk next (send a message).

If fewer than 4 computers are on the network, then the token resets to
0 when it gets to the last computer on the network.  So if only 2
computers are on the network, the token cycles 0, 1, 0, 1...  If there
are 4 computers, 0, 1, 2, 3, 0, 1, 2, 3...

Network RAM is two sets of 128 words.  It uses double buffering.
The network hub signals to the program
that it swapped the buffers by setting the
status (S) flag to new (1) in the Network Status register.

If the status is set to new, the program knows:
- There is a new message in the message section of network RAM.
  (If it transmitted last frame, the message
  is still the message that it transmitted.)
- If it had the write token last frame,
  the message it set last frame is now being transmitted.

When the status in new,
the Sender Net ID is the net ID of the machine that sent the message
in the message section in network RAM.


Network RAM
-----------

Total RAM = 128 words
- 1 word network status register ($F780)
- 127 word message (read/write) ($F781-$F7FF)


Network Status Register
-----------------------


```
        Purpose         Bits    Details
----------------------------------------------------------------------
S       Status          1       1 = new, 0 = old
N       Sender Net ID   2       network ID of the machine that sent this message
I       Net ID          2       network ID of this machine
T       Write Token     2       network ID of machine with write token


 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|  10 Unused bits |S| N | I | T |
---------------------------------
```
