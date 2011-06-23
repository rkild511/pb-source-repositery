; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2827&highlight=
; Author: neotoma + NicTheQuick
; Date: 11. November 2003
; OS: Windows
; Demo: Yes

Procedure SwapLong(longy.l) 
  MOV   Eax, longy 
  BSWAP Eax 
  ProcedureReturn 
EndProcedure

i.l = $01020304 
Debug(Hex(i)) 
o = SwapLong(i) 
Debug(Hex(o))
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
