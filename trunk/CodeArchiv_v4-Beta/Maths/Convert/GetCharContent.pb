; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2138&postdays=0&postorder=asc&start=0
; Author: NicTheQuick
; Date: 29. August 2003
; OS: Windows
; Demo: Yes

; Get number of chars a value contains
Procedure MaxZiffern(Zahl.l) 
  Protected a.l, b.l 
  If Zahl < 0 : Zahl = -Zahl : EndIf 
  a = 1 
  Repeat 
    b + 1 
    a * 10 
    If Zahl < a 
      ProcedureReturn b 
    EndIf 
  ForEver 
EndProcedure 

; Get content of specified char in a value
Procedure Ziffer(Zahl.l, rPosition.l) 
  Protected a.l, MaxZ.l, Position.l 
  If Zahl < 0 : Zahl = -Zahl : EndIf 
  MaxZ = MaxZiffern(Zahl) 
  Position.l = MaxZ - rPosition 
  For a = 1 To Position 
    Zahl / 10 
  Next 
  ProcedureReturn Zahl - Zahl / 10 * 10 
EndProcedure 

Debug MaxZiffern(12345678) 
Debug Ziffer(12345678, 5)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
