Audio
=====

Audio output is handled by the APU.
The APU contains a Programmable Sound Generator (PSG)
similar in capability to the
General Instrument AY-3-8910
and the Texas Instruments SN76489.
There is no envelop generator and
the noise channel has it's own dedicated oscillator.

APU PSG 4 sound channels (or "voices"):
- Square wave
- Square wave
- Square wave
- Noise with dedicated oscillator

The APU has 4 internal 16-bit registers that control the sound of each channel.

There are 3 square wave registers, one for each channel.
```
----------------------------------------
| 4 bit attenuation | 12 bit frequency |
----------------------------------------
```

And one noise register, for the noise channel.
```
---------------------------------------------------------
| 4 bit attenuation | 11 bit frequency | 1 bit mode bit |
---------------------------------------------------------
```

The noise channel mode bit:
- 0: white noise
- 1: periodic noise with 6.25% duty cycle

The 11-bit frequency value is "upgraded" to 12-bits by appending a 0 to the
right as the least-significant-bit.  So the noise frequency has the same range
as the square wave channels, but is coarser, having half as many frequencies to
choose from.

Volume is controlled by a 4-bit attenuation.
0000 is max volume and 1111 is muted, as with the SN76489.
Each increment of the attenuation decreases the volume by 2 dB.

```
value| Volume
------------------
0000 | Max volume
0001 |  - 2 dB
0010 |  - 4 dB
0011 |  - 6 dB
...  | ...
1101 | - 26 dB
1110 | - 28 dB
1111 | off
```

The APU has 16 data pins, 4 address pins, and an enable input.
You write to the APU registers by setting the address pins to the register you
want to write to and providing the new 16-bit value on the data bus.

```
Address | channel
-----------------------------
0000    | Square channel 0
0001    | Square channel 1
0010    | Square channel 2
0011    | Noise channel
```
