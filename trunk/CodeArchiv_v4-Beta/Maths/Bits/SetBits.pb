; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2842&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 16. November 2003
; OS: Windows
; Demo: Yes

Procedure SetBitFalse(Long.l, Bit.l)
  Bit = 1 << Bit 
  ProcedureReturn (Long | Bit) & ~Bit 
EndProcedure 

Procedure SetBitTrue(Long.l, Bit.l) 
  Bit = 1 << Bit 
  ProcedureReturn Long | Bit 
EndProcedure 

a.l = %1111011 

Debug Bin(SetBitTrue(a, 2)) 
Debug Bin(SetBitTrue(a, 7))

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
