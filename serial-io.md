Serial IO
=========

Serial communication is handled by the APU.
Devices that connect to the serial port are the cassette drive and the LinkHub.  Only one can be connected at a time.
The serial port is just a standard TRRS audio jack.


Cassette
--------

A standard audio cassette recorder with tone and volume control and an aux audio port can be connected to the console's serial TRRS port.  Software can use this a external storage.  This can be useful for saving game progression.  But also for storing user created content.

When the software wants to write data to the cassette, it should write the 2 words of data it wants to save into the cassette data RAM addresses.  Then it must prompt the user to do the following:
- plugin the cassette recorder with a cassette inserted
- rewind the cassette to the beginning (but past the blank header, if any)
- press record on the cassette recorder
- press any key on the gamepad
The software should then write to the cassette control RAM address signaling the APU it wants to write to the serial output.  On the next vertical blank period, when the VDP signals the APU with the APU interrupt line (AI), the APU will read the cassette control RAM and the cassette data RAM and then write the 2 words over the serial line, bit-by-bit, which will make there way to the cassette recorder and onto the data cassette.  This will take the entire next frame to complete.  If the software wants to write more data, it can continue to send 2 words per frame until complete.  When completed, the software should notify the user that it is finished and prompt the user to stop the cassette recorder.

The process for reading data from a cassette is similar.
When the software wants to read data from the cassette it must prompt the user to do the following:
- plugin the cassette recorder with the data cassette inserted.
- rewind the cassette to the beginning (but past the blank header, if any)
- press play by itself on the cassette recorder
- press any key on the gamepad
The software should then write to the cassette control RAM address signaling the APU it wants to read from the serial input.  On the next vertical blank period, when the VDP signals the APU with the APU interrupt line (AI), the APU will read the cassette control RAM and then begin to read bits from the serial input and buffer them into its internal 2 word buffer (4 bytes).  This will take the entire frame.  On the following vertical blank period, the APU will write the 2 words it received over the serial input to the cassette data RAM addresses, which the CPU can then read on the next frame.  If the software wants to read more data, it can leave the cassette control RAM address with the read request in it.  As long as the CPU does not clear the cassette control RAM, The APU will continue to read 2 words per frame from the serial input.  When completed, the software should clear the cassette control RAM and then notify the user that it is finished and prompt the user to stop the cassette recorder.


LinkHub
-------

The LinkHub allows up to 4 ljd computers to communicate with each other.  This allows programs to be written that would run on up-to 4 machines, allowing each user to see their own private screen.  Since, each console supports up to 4 controllers, up to 16 players could play the same game.  Of course, each screen would be shared by each group of 4 players.

Each machine can only transmit or receive 4 Bytes (2 words) per frame.
Each of the 4 connections to the LinkHub device are labeled as:
- lead
- node 1
- node 2
- node 3

The software program that wants to support the LinkHub is expected to allow the user to specify the want use the LinkHub.
The software is then expected to prompt the user with gamepad 1 to enter the port of the LinkHub the console is connected to.
