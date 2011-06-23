; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6883&highlight=
; Author: Thorsten (examples added by Andre)
; Date: 13. July 2003
; OS: Windows
; Demo: Yes

; Split long into two UNSIGNED .w words (0 To 65535) and reverse, coded by Danilo
Procedure LOWORD(Value) 
  ProcedureReturn Value & $FFFF 
EndProcedure 

Procedure HIWORD(Value) 
  ProcedureReturn (Value >> 16) & $FFFF 
EndProcedure 

Procedure MAKELONG(low, high) 
  ProcedureReturn low | (high<<16) 
EndProcedure 

; Split long into two SIGNED .w words (-32767 To +32768) and reverse, coded by Thorsten
Procedure.w LOWORDs(Value.l) 
  ProcedureReturn Value & $FFFF  
EndProcedure 

Procedure.w HIWORDs(Value.l) 
  ProcedureReturn (Value >> 16) & $FFFF 
EndProcedure 

Procedure MAKELONGs(low.w, high.w) 
  ProcedureReturn (high * $10000) | (low & $FFFF) 
EndProcedure 

Debug LOWORD(5000000)
Debug HIWORD(5000000)
Debug MAKELONG(19264, 76)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
