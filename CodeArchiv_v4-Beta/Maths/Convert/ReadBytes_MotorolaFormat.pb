; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7088&highlight=
; Author: Freak
; Date: 01. August 2003
; OS: Windows
; Demo: Yes

Procedure.l PeekLMotorola(address.l) 
  !mov eax, [esp] 
  !mov eax, [eax] 
  !bswap eax 
  ProcedureReturn 
EndProcedure 

a.l = $10203040 
b.l = PeekLMotorola(@a) 

Debug Hex(b) 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
; EnableXP
