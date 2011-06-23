; English forum: 
; Author: Cor (updated for PB3.93 by Andre)
; Date: 08. May 2003
; OS: Windows
; Demo: Yes

; Including Ogg sound files in exe
InitSound()
UseOGGSoundDecoder() 

L1=?IB2-?IB1 
CatchSound(0,?IB1,L1) 

PlaySound(0,1) 

MessageRequester("Ogg Player","Ogg file is playing...")

End 

IB1: 
IncludeBinary "purepower.ogg" 
IB2: 

; OGG sound file create with mp3 to ogg converter 
; http://www.ogg-converter.com 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -