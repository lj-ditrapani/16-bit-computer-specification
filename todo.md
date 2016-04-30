Complete working web LJD 16-bit computer
----------------------------------------
- Make cpu an npm module and publish to npm (npm adduser, npm publish)
- Use browserify for assembler (and probably computer as well, maybe change cpu to use it too?)
- Redo assembler in CoffeeScript
- Integrate cpu with computer
- Maybe create a video tile-set creator program?
- Redo video
- Redo computer (integrate cpu and video)
- If the assembler is runnable in a browser, I can load an assembly program from a server, assemble it into an executable on the client side, and then run it on the client computer emulator.
- Change sound to audio in all files
- Create simplified acceptance testing set-up for whole computer
    - Load Binary RAM files from a directory into CPU RAM
    - Run program
    - Assert correct outputs (and RAM/registers/PC if necessary)
    - Binary files are stored in a folder
        - run static web server in folder
        - `python3 -m http.server`
        - `ruby2.0 -run -e httpd . -p 8000`
    - Load binary files through xmlHttpRequest
        - Load binary data into ArrayBuffer and wrap in Uint16Array
        - For testing, load binary files before tests are defined?
- Computer main loop
    - Frame interrupt vector
    - Shutdown if frame interrupt disabled AND halted (END)
- HTML/CSS/JS GUI interface
    - Load program from web server
    - Run program
    - Step program (if loaded but not already running)
    - Reset computer (clears ram/registers/PC)
- Keyboard input


Near term
---------
node.js express web-app that allows
- login
- Uploading new assembly programs
- Deleting assembly programs
- Updating assembly programs
- To run a program
    - download assembly program
    - assemble into executable
    - load executable into rom/ram


Future
------
- Storage
- Networking
- Video editor
    - Tile editor
    - Color editor
    - Grid editor (+ xy flip)
    - Sprite editor
- Audio
- Audio editor
