; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1655&highlight=
; Author: Unimatrix Zero (updated for PB 4.00 by Andre)
; Date: 16. January 2005
; OS: Windows
; Demo: Yes

; aktuelle Kalenderwoche ermitteln
Procedure KW(ldate) 
  Protected fwd,days,wnr 
  fwd = DayOfWeek(Date(Year(ldate), 1, 1, 0, 0, 0)) 
  If fwd = 0 : fwd = 7 : EndIf 
  days = (ldate - Date(Year(ldate), 1, 1, 0, 0, 0)) / 86400 
  wnr = Round((days - (8 - fwd)) / 7, 0) + 1 
  If fwd <= 4 : wnr + 1 : EndIf 
  If wnr = 0 
    KW(Date(Year(ldate) - 1, 12, 31, 0, 0, 0)) 
    ProcedureReturn 
  ElseIf wnr = 53 And DayOfWeek(Date(Year(ldate) - 1, 12, 31, 0, 0, 0)) <= 3 
    wnr = 1 
  EndIf 
  ProcedureReturn wnr 
EndProcedure 

Debug KW(ParseDate("%dd.%mm.%yyyy","03.12.2002")) 
Debug KW(ParseDate("%dd.%mm.%yyyy","25.12.2002")) 
Debug KW(ParseDate("%dd.%mm.%yyyy","30.12.2002")) 
Debug KW(Date())  ; this week


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -