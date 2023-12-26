Audio
=====

Audio output is handled by the APU.
The APU contains a Programmable Sound Generator (PSG)
similar in capability to the
Texas Instruments SN76489
except the APU has a 4th oscillator that can be used as a 4th square
wave or provided as an oscillator for the noise channel to generate
periodic noise.

APU PSG 4 sound channels:
- Square wave
- Square wave
- Square wave
- Square wave or noise with dedicated oscillator

The APU has 5 internal registers that control the sound of each channel:

There are 4 square wave registers, one for each channel.
```
-----------------------------------
| 4 bit volume | 10 bit frequency |
-----------------------------------
```

And one noise register, for the noise channel.
```
-----------------------------------
| 2 bit mode   | 2 bit frequency  |
-----------------------------------
```

The noise channel mode bits determine how it will be used:
- 00: muted
- 10: used as a normal square wave, muting noise
- 01: used as white noise, ignoring the square oscillator
- 11: combined with the square oscillator to produce periodic noise
