; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3127&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 13. December 2003
; OS: Windows
; Demo: Yes

Global MaxBoolean.l 

MaxBoolean = 100 

Global Dim Boolean.b(MaxBoolean / 8 + 1) 

Procedure SetStatus(Number.l, Status.l) 
  Protected Bit.l, Byte.l 
  Bit = 1 << (Number % 8) 
  Byte = Number / 8 
  
  If Status 
    Boolean(Byte) | Bit 
  Else 
    Boolean(Byte) | Bit 
    Boolean(Byte) ! Bit 
  EndIf 
EndProcedure 

Procedure GetStatus(Number.l) 
  Protected iBit.l, Bit.l, Byte.l 
  iBit = Number % 8 
  Bit = 1 << iBit 
  Byte = Number / 8 
  
  Bit = (Boolean(Byte) & Bit) >> iBit 
  ProcedureReturn Bit 
EndProcedure 

SetStatus(100, 1) 
SetStatus(99, 0) 
SetStatus(98, 1) 

Debug GetStatus(100) 
Debug GetStatus(99) 
Debug GetStatus(98)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
