; English forum: 
; Author: PB (updated for PB3.93 by ts-soft)
; Date: 21. January 2003
; OS: Windows
; Demo: Yes


; Occurrences procedure by PB -- do what you want with it.
; Counts how many times a string exists in another string.
; Usage: r=Occurrences(source$,string$,case)
; Returns number of occurrences or 0 for none.
; Case must be 0 for off, or non-zero for on.

Procedure Occurrences(source$,string$,_Case)
  Repeat
    If _Case=0
      f=FindString(LCase(source$),LCase(string$),pos)
    Else
      f=FindString(source$,string$,pos)
    EndIf
    If f<>0 : r=r+1 : pos=f+Len(string$) : EndIf
  Until f=0
  ProcedureReturn r
EndProcedure
;
Debug Occurrences("This is a thing","th",0) ; Case-sense off.
Debug Occurrences("This is a thing","th",1) ; Case-sense on.
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -