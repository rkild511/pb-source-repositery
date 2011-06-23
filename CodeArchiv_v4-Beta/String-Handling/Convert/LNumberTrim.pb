; http://www.purebasic-lounge.de
; Author: Green Snake
; Date: 11. October 2006
; OS: Windows, Linux
; Demo: Yes


; Cut all numbers from a start of a string
; Entfernt alle Zahlen vom Anfang eines Strings

Structure Char
   c.c
EndStructure

Procedure.s LNumberTrim(String.s)
  Protected *Char.Char
  Protected NumberEnd.l
 
  *Char      = @String
  *CharStart = *Char
 
  While *Char\c <> #Null
   
    Select *Char\c
      Case '0' To '9'
        *Char + SizeOf(Char)
      Default
        *CharStart + (*Char - *CharStart)
        ProcedureReturn PeekS(*CharStart)
    EndSelect
   
  Wend
 
  ProcedureReturn ""
EndProcedure


;- Test 
Debug LNumberTrim("abcdef")           ; no numbers included
Debug LNumberTrim("1234abcdef")       ; leading numbers will be cutted

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -