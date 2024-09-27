# *Pac-Mario*   &nbsp; <img src="https://w7.pngwing.com/pngs/517/871/png-transparent-8-bit-super-mario-illustration-super-mario-bros-new-super-mario-bros-video-game-sprite-angle-super-mario-bros-text-thumbnail.png" width="4%">   &ensp;   <img src="https://upload.wikimedia.org/wikipedia/commons/a/a8/Original_PacMan.png" width="4%">
*Pac-Mario* is a *assembly* game developed for the [*RISC-V* architecture](https://riscv.org/). The game is a mix between *Pacman*😶 and *Mario*🍄, where the player must collect all coins in the map to win. You can also collect power-ups that allow you to eat the ghosts for a limited time. The game has 2 levels, each one with a different map. This project was developed for the discipline *ISC* (*"Introdução aos Sistemas Computacionais"*, or *Introduction to Computer Systems* in english) at *UnB*. Although the game is simple, it was a great opportunity to learn about the [*RISC-V* architecture](https://riscv.org/) and the *assembly* language. I know it's a college project but it turns out to be a really nice game. Give it a try! 😁

    Happy gaming! 👾

## How to play 🎮
- 1. Press the ```<>Code``` button above and choose a clone option.

        If you have git installed, you can run the following command:
        ```bash
        git clone https://github.com/danhollenbach/ISC_Project_2024.1-PacMario.git
        ```
    ### For Windows <img src="https://cdn.icon-icons.com/icons2/2170/PNG/512/microsoft_logo_brand_windows_icon_133246.png" width="2%">:
    - 1. Open the game folder in your file explorer.
    - 2. Drag and drop *game.s* file to *fpgrars-x86_64-pc-windows-gnu* and wait for game to boot.
    - 3. Or you can open the terminal in the game directory and run:
        ```bash
        ./fpgrars-windows.exe main.s
        ```

    ### For Linux <img src="https://cdn.pixabay.com/photo/2017/01/31/15/33/linux-2025130_1280.png" width="2%">:
    - 1. Open terminal from the game directory and run:
        ```bash
        ./fpgrars-linux main.s
        ```
    *obs*. 
    - Download the [linux version of the fpgrars](https://github.com/LeoRiether/FPGRARS) if you don't have it yet.
    - MIDI is tricky on linux, and it's suggested you configure a MIDI daemon for your system if you want to have sound. See https://wiki.archlinux.org/title/MIDI#Software_playback .

       

    #### *Done!*

    Now you're all set! Have fun playing!!


## Game Instructions 📜
- [W],  [A],  [S],  [D] &nbsp; -> &nbsp; Move the character.
- [M] &nbsp; -> &nbsp; Skip level, if you're stuck.

