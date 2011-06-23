; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8541&highlight=
; Author: Psychophanta
; Date: 29. November 2003
; OS: Windows
; Demo: Yes

Procedure xchEndian(e.l) 
  !mov eax,dword[esp] 
  !bswap eax 
  ProcedureReturn 
EndProcedure 

Debug Hex(xchEndian($DABAFA00))

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
