; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8730&highlight=
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 15. December 2003
; OS: Windows
; Demo: Yes


;SetSuspendState_(#False,#True,#False) ; Hibernate, Force, DisableWakeEvents. (doesn't work currently in PB directly)

If OpenLibrary(0,"powrprof.dll") And GetFunction(0,"SetSuspendState") 
  CallFunction(0,"SetSuspendState",#False,#True,#False) 
  CloseLibrary(0) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
