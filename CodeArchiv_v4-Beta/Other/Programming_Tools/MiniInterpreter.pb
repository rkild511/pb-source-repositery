; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1595&highlight=
; Author: Leo (updated for PB 4.00 by Andre)
; Date: 15. January 2005
; OS: Windows
; Demo: Yes


; Kleiner Interpreter .. (allerdings extra ohne Tokens Einteilung, Schleifen 
; und If...)


;/ 
;/[Console pur] Interpreter 
;/ 

;{-Vars etc. 
Structure StringVar 
  Name.s 
  Wert.s 
EndStructure 
Global NewList Strings.StringVar() 
Global NewList Lines.s() 
;} 

;{-Proceduren 
Procedure.s GetParam(str.s) ;Gibt einen Parameter zurück 
  tPos.l = FindString(str," ",0) 
  ProcedureReturn LTrim(Mid(str,tPos,Len(str)-tPos+1)) 
EndProcedure 

Procedure.s GetSecondParam(str.s) ;Gibt den zweiten Parameter zurück von 2en 
  tPos.l = FindString(str,",",0) 
  ProcedureReturn LTrim(Mid(str,tPos+1,Len(str)-tPos)) 
EndProcedure 

Procedure.s GetFirstParam(str.s) ;Gibt den ersten Parameter zurück von 2en 
  tPos.l = FindString(str,",",0) 
  tProPos.l = FindString(str," ",0) 
  ProcedureReturn LTrim(Mid(str,tProPos,tPos-tProPos)) 
EndProcedure 

Procedure.s GetBefehl(str.s) ;Gibt den Befehls Namen zurück 
  tPos.l = FindString(str," ",0) 
  If tPos 
    ProcedureReturn RTrim(Mid(str,0,tPos)) 
  Else 
    ProcedureReturn str 
  EndIf 
EndProcedure 

Procedure.s GetStringWert(str.s) ;Gibt den Wert des Strings zurück 
  ForEach Strings() 
    If Strings()\Name = str 
      ProcedureReturn Strings()\Wert 
    EndIf 
  Next 
EndProcedure 

Procedure UseString(str.s) 
  ForEach Strings() 
    If Strings()\Name = str 
      ProcedureReturn 1 
    EndIf 
  Next 
  ProcedureReturn 0 
EndProcedure 
;} 

;{-File einlesen 
If ReadFile(0,"MiniInterpreter-Test.int") 
  While Eof(0) = 0 
    str.s = ReadString(0) 
    If Mid(str,0,1) <> ";" And str <> "" 
      AddElement(Lines()) 
      Lines() = str 
    EndIf 
  Wend 
  CloseFile(0) 
Else 
  Debug "MiniInterpreter-Test.int file not found!"
EndIf 
;} 

;-Interpretieren 

OpenConsole() 

CallDebugger 

ForEach Lines() 
  Befehl.s = GetBefehl(Lines()) 
  Debug Befehl
  
  Select Befehl.s 
    Case "STRING" 
      If UseString(GetFirstParam(Lines())) = 0 
        AddElement(Strings()) 
        Strings()\Name = GetFirstParam(Lines()) 
        Strings()\Wert = GetSecondParam(Lines()) 
      Else 
        Strings()\Wert = GetSecondParam(Lines()) 
      EndIf 
    Case "DEBUGSTRING" 
      Print(GetStringWert(GetParam(Lines()))) 
    Case "INPUT" 
      UseString(GetParam(Lines())) 
      Strings()\Wert = Input() 
    Case "INPUTCLEAR" 
      Input() 
    Case "NLINE" 
      PrintN("") 
    Case "DELAY" 
      Delay(Val(GetParam(Lines()))) 
    Case "GOTO" 
      SelectElement(Lines(),Val(GetParam(Lines()))) 
  EndSelect 
Next 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --