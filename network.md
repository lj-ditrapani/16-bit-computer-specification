LJD 16-bit Computer Network
===========================

Up to 16 computers networked together at a time.
Each message sent is delivered to all other computers on the network
that are enabled in the destination mask.
Only one message is sent per frame.
Only the computer with the transmit token can send the message for that
frame.
The token rotates round robin to each computer on the network.
The Net ID RAM cell contains the computer's own Net ID.
The network token RAM cell contains the Net ID of the computer with the
token.
If the Net ID and the token ID match, then it is the computer's turn to
talk (send a message) if it so chooses.
If the computer declines (net output enable is 0),
then a message of 1,024 zeros is sent.

If fewer than 16 computers are on the network, then the token resets to
0 when it gets to the last computer on the network.  So if only 2
computers are on the network, the token cycles 0, 1, 0, 1...  If there
are 4 computers, 0, 1, 2, 3, 0, 1, 2, 3...

The destination mask write-only control register determines which of
the 15 other computers receive the message.  Each bit, 0-15
represents one of the computers on the network who's Net ID matches
the bit position.  A 1 means the
send the transmission to that computer and a 0 means do not send the
transmission to that computer.
