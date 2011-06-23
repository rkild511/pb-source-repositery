; German forum:
; Author: Helge
; Date: 06. August 2002
; OS: Windows
; Demo: No


NeedHolder= MessageRequester("Admin","Want me to hold your beer for you?", #MB_YESNO + #MB_ICONQUESTION) 
If NeedHolder = 6
  mciSendString_( "set cdaudio door open", "", 0,0)
  MessageRequester("Admin","Wait, we see that you have already been using your CDRom as a beer holder and have spilled! ?? " +Chr(13)+"We regret that we must retract our offer and your CDTray!", 0)
  mciSendString_( "set cdaudio door closed", "", 0,0)
EndIf 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
; EnableXP
; Executable = M:\Documents and Settings\fred\Bureau\Gadget.exe