; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6251&highlight=
; Author: El_Choni (updated for PB4.00 by blbltheworm)
; Date: 26. May 2003
; OS: Windows
; Demo: No


; Original PB function TextWidth() needs a valid outputID
Procedure GetTextWidth(text$) 
  GetTextExtentPoint32_(GetDC_(0), text$, Len(text$), sz.SIZE) 
  ProcedureReturn sz\cx 
EndProcedure 

Debug GetTextWidth("Test-String")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
