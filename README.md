# Nihirash's Midi Files - zx spectrum oriented midi format

**Kindly remind you:** This project is experimental. 

## Converter

Made on Python 3. Converts your midi files(any type) to NMF files. 

Prerequirements:
 
 * mido package(`pip3 install mido`)
 * Tkinter(on most UN*X systems and windows should be available by default, on macOS should be installed by `brew install python3-tk`)

 ### Usage

 Just execute `converter.py` select midi file - and you'll got converted file in same directory

 ## Player

Currently, player works with ZX Spectrum 128's midi output port(based on AY's GPIO). 

 ### esxDOS dot-command player

 Sources located at `esx-dos-player` directory. 

 It requires only `GNU Make` and `sjasmplus` for building dot-command for esxDOS.

 It's only basic idea of player and should be extended for later usage.

 ### esxDOS player for using on interrupts 

 To be done!

 # Legal info

 All music files belong to their authors, are taken from open sources and are used for educational purposes only.