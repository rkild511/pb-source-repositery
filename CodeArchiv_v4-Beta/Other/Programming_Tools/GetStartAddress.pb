; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3143&highlight=
; Author: Stefan Moebius
; Date: 15. December 2003
; OS: Windows
; Demo: No

; Get the memory address of my running app...

Procedure GetStartAddress()
  Addr=GetCurrentEIP(0)
  If IsBadReadPtr_(Addr,1)=0
    Repeat
      Addr-1
    Until IsBadReadPtr_(Addr,1)
    Addr+1
  EndIf
  ProcedureReturn Addr
EndProcedure

Debug GetStartAddress()

Debug PeekS(GetStartAddress())

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
