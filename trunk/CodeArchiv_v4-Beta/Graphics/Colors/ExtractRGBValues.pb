; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14506&highlight=
; Author: griz (updated for PB 4.00 by Andre)
; Date: 23. March 2005
; OS: Windows
; Demo: Yes


; Get the Red, Green, Blue parts of a RGB value by byte-shifting...
Procedure RGB2(r,g,b) 
  ProcedureReturn r | g << 8 | b << 16 
EndProcedure 

Procedure Red2(col) 
  ProcedureReturn col & $FF 
EndProcedure 

Procedure Green2(col) 
  ProcedureReturn col >> 8 & $FF 
EndProcedure 

Procedure Blue2(col) 
  ProcedureReturn col >> 16 & $FF 
EndProcedure 

num = 6696982 
Debug Str(Red2(num)) + ", " + Str(Green2(num)) + ", " + Str(Blue2(num)) 
Debug " = "+Str(RGB2(Red2(num), Green2(num), Blue2(num))) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -