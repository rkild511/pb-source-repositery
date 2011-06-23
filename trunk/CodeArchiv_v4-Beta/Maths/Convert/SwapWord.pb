; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2827&highlight=
; Author: NicTheQuick
; Date: 11. December 2003
; OS: Windows
; Demo: Yes

Procedure SwapWord2(wordy.w) 
  wordy = wordy >> 8 + wordy << 8 
  ProcedureReturn wordy 
EndProcedure 

i.w = $1020 
Debug Hex(i) 
o = SwapWord2(i) 
Debug Hex(o)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
