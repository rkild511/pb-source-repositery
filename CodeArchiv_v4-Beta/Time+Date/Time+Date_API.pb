; www.purearea.net
; Author: Andre
; Date: 29. June 2003
; OS: Windows
; Demo: No

; Written for all PB users, which use Topos version (PB3.30)
; Commands for time & date are included in Date library of PB3.40+ as native commands
Procedure.s GetDateString()    ; Ermittels des aktuellen Systemdatum via WinAPI
  GetLocalTime_(@s.SYSTEMTIME)
  Month$ = Str(s\wMonth)
  Day$ = Str(s\wDay)
  If Len(Month$) = 1 : Month$ = "0"+Month$ : EndIf
  If Len(Day$) = 1 : Day$ = "0"+Day$ : EndIf
  Date$ = Day$+"."+Month$+"."+Str(s\wYear)
  ProcedureReturn Date$
EndProcedure

Procedure.s GetTimeString()   ; Ermitteln der Systemzeit via WinAPI
  GetLocalTime_(@s.SYSTEMTIME)
  Hour$ = Str(s\wHour)
  Minute$ = Str(s\wMinute)
  Second$ = Str(s\wSecond)
  If Len(Hour$) = 1 : Hour$ = "0"+Hour$ : EndIf
  If Len(Minute$) = 1 : Minute$ = "0"+Minute$ : EndIf
  If Len(Second$) = 1 : Second$ = "0"+Second$ : EndIf
  Time$ = Hour$+":"+Minute$+":"+Second$+" "
  ProcedureReturn Time$
EndProcedure

Datum$=GetDateString()
Zeit$ =GetTimeString()
Debug "Aktuelles Datum: "+Datum$
Debug "Aktuelle Zeit: "+Zeit$

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -