; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8578&highlight=
; Author: Johan_Haegg (updated for PB4.00 by blbltheworm)
; Date: 05. December 2003
; OS: Windows
; Demo: Yes

Procedure WCString(pattern.s, string.s, sens.b) 
  spos = 0 
  If sens.b = 0 
    pattern.s = UCase(pattern.s) 
    string.s = UCase(string.s) 
  EndIf 

  If Left(pattern.s, 1) = "*" 
    pos = FindString(pattern.s, "*", 2) 
    spos = FindString(string, Mid(pattern.s, 2, pos - 2), spos) 
    If spos = 0 
      ProcedureReturn 0 
    EndIf 
  Else 
    pos = FindString(pattern.s, "*", 1) - 1 
    If Left(string.s, pos) = Left(pattern.s, pos) 
      spos = pos + 1 
      pos + 1 
    EndIf 
    If spos = 0 
      ProcedureReturn 0 
    EndIf 
  EndIf 
  Repeat 
    opos = pos + 1 
    pos = FindString(pattern.s, "*", opos) 
    If pos = 0 
      Break 
    EndIf 
    spos = FindString(string, Mid(pattern.s, opos, pos-opos), spos) 
    If spos = 0 
      ProcedureReturn 0 
    EndIf 
  ForEver 
ProcedureReturn 1 
EndProcedure 

Debug WCString("*like*cookie*", "I like those cookies", 0) ; <- 1 
Debug WCString("*like*cookie*", "I Like those cookies", 1) ; <- 0 
Debug WCString("like*cookie*", "I like those cookies", 0)  ; <- 0 
Debug WCString("like*cookie*", "like those cookies", 0)    ; <- 1

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
