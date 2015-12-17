# Risky-CLIPS
A CLIPS program that plays Risk. 

Made by [Bradley Rosenfeld](https://github.com/BoringCode), [Austin Munn](https://github.com/amunn33), [Matt Hall](https://github.com/matthalltu), and [Noah Drabinsky](https://github.com/ndrabins)

This project uses a knowledge based systems language in order to play the game of Risk. Python runs the tournament code and simply passed data back and forth between the CLIPS player code.

###Requirements
 - CLIPS must be installed and in your system $PATH. 
 - The Python application requires at least Python 3.
 - [TkInter](https://wiki.python.org/moin/TkInter)

##Running

Linux: `python3.4 AutomatedRiskPrecursorFinal.py`

Windows: Run `AutomatedRiskPrecursorFinal.py` in the Idle environment. Please note that ClipsWrapper.py assumes CLIPS is installed in `C:\Program Files (x86)\CLIPS\CLIPSDOS64.exe`.

##Development

Our player is located in `RiskyClipsMain.py`. This only handles moving data between the CLIPS process.

All of our player logic is contained in `logic/`. 
