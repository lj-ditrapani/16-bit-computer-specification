1 Char per frame
----------------
```
5 letters per word
6 characters per word (5 letters + space)
100 words per minute would be 10 char per second or 1 char per frame
```

Design
------
```
Input is in the form of 7 bit ASCII characters
A single RAM cell contains the Keyboard input encoded as a 7 bit
ASCII character
The Keyboard input RAM cell
The input is $00 if no character is typed.
If multiple characters were typed during the previous frame, only the
first one is registered.
A registered ASCII character means the user completed the keystroke(s)
they pressed the key and released the key.
Input updated once per frame (10 times per second)
```
