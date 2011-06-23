; http://www.purebasic-lounge.de
; Author: Green Snake (changed to debug output by Andre)
; Date: 10. December 2006
; OS: Windows, Linux
; Demo: Yes

EnableExplicit

Procedure.s TTrim(String.s)
  ; Cut all #CRLF and Spaces from start of the string
  ; Schneidet alle #CRLFs und Spaces vom Anfang des Strings weg.
  Protected *Char.Character
  Protected *CharStart.l
  Protected Counter.l
 
  *Char      = @String
  *CharStart = *Char
  While *Char\c <> 0
    If *Char\c <> #CR And *Char\c <> #LF
      Break
    Else
      Counter + 1
    EndIf

    *Char + SizeOf(Character)
  Wend
 
  String = PeekS(*CharStart + Counter)
  ProcedureReturn String
EndProcedure

Procedure.s BTrim(String.s)
  ; Cut all #CRLF and Spaces from end of the string
  ; Schneidet alle #CRLFs und Spaces vom Ende des Strings weg.
  Protected *Char.Character
  Protected *CharStart.l
  Protected True.l
 
  *Char      = @String
  *CharStart = *Char
  While *Char\c <> 0
    If *Char\c <> #CR And *Char\c <> #LF
      True = #True
    Else
      If True = #True
        Break
      EndIf
    EndIf

    *Char + SizeOf(Character)
  Wend
 
  String = PeekS(*CharStart,*Char - *CharStart)
  ProcedureReturn String
EndProcedure


;- Test
Define Text$ = #CRLF$ + #CRLF$ + "      MOIN     -  " + #CRLF$ + #CRLF$

Debug "+" + Trim(BTrim(TTrim(Text$))) + "+"


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -