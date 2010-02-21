This sdk is very very alpha, so you are free to play around with it. If someone could translate the import unit into c, I would gladly receive it, so I can distribute it in next releases.

What is in this sdk:

For now its only a DLL/SO that can interface with the ts2 client and perform tasks like switching channels, muting sound, and retrieving channel lists.

Files:

tsControl.exe ................... A demo application 
tsControl.dpr ................... The delphi source of the demo
TSRemote.dll / TSRemote.so.0.4 .. The dll / so that contains the interface code.
TsRemoteImport.pas .............. The delphi unit that can import the functions
                                  Look in the file to see the api calls available.

Have fun with it, And please report bugs, suggestions etc etc in our forums on www.teamspeak.org.
