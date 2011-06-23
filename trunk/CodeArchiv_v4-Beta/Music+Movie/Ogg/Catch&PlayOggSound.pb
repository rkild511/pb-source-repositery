; www.purearea.net
; Author: Andre
; Date: 28. March 2005
; OS: Windows
; Demo: Yes

If InitSound()
  UseOGGSoundDecoder()
  length = ?End_snda - ?Start_snda
  CatchSound(0, ?Start_snda,length)
  PlaySound(0,0)
  MessageRequester("Music","Playing ogg file...")
EndIf


DataSection
  Start_snda:
    IncludeBinary "purepower.ogg"
  End_snda:
EndDataSection 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -