; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5150&highlight=
; Author: sharkpeter (updated for PB 4.00 by Andre)
; Date: 02. August 2004
; OS: Windows
; Demo: No


; Was passiert: ich übergebe dem Programm das 1. Wort des Hauptfensternamens
; des zu prüfenden Programms. Das Ergebnis kommt in eine *.tmp Datei. Diese
; lese ich nach Rückkehr wieder aus.
; Es sind noch ein paar zusätzliche Dinge mit abgelegt, z.B. die serielle
; Zeit um einen möglichen Zeitüberlauf abzufangen, wozu auch immer.
; Die Abfrage erfolgt logischer Weise vor dem Öffnen des Fensters.


;Author: LJ, GPI Date: 20. July 2003 Process Monitor By GPI
;Modified by Lance Jepsen
;Modified by Jens Haipeter 02.August 2004

;Abbruch ohne Übergabe
_startok.s=ProgramParameter()
If _startok="": End: EndIf

;Strukturen
Structure info
  handle.l
  process.l
  class$
  name$
EndStructure

;Listen
Global NewList info.info() : NewList AllHandle()

;Globale Variablen
Global _infomsg.s
Global _infotit.s
Global MessageID

;Variablen Wertzuweisung
_infotit.s="INFORMATION"
_infomsg.s="no message"
MessageID=0
status.s="no run"

;Proceduren
;Infobox
Procedure MessageBox()
  MessageRequester(_infotit.s,_infomsg.s,0)
  _infotit="INFORMATION"
  _infomsg="no message"
  MessageID=1
EndProcedure

;Windows Class bestimmen
Procedure.s GetClassName(handle)
  class$=Space(1024)
  GetClassName_(handle,@class$,Len(class$))
  ProcedureReturn Left(class$,Len(class$))
EndProcedure

;Name zum Handle
Procedure.s GetTitle(handle)
  name$=Space(1024)
  GetWindowText_(handle,@name$,Len(name$))
  ProcedureReturn Left(name$,Len(name$))
EndProcedure

;Listeneinträge erzeugen
Procedure AddInfo(handle)
  process=0: quit=0 : i=0
  GetWindowThreadProcessId_(handle,@process)
  Class$= GetClassName(handle)
  Name$ = GetTitle(handle)
  ResetList(info())
  Repeat
    If NextElement(info())
      If process < info()\process
        quit=1
      ElseIf process=info()\process
        If class$ < info()\class$
          quit=1
        ElseIf UCase(class$)=UCase(info()\class$)
          If name$ < info()\name$
            quit=1
          ElseIf UCase(name$)=UCase(info()\name$)
            If handle < info()\handle
              quit=1
            ElseIf handle=info()\handle
              quit=3
            EndIf
          EndIf
        EndIf
      EndIf
    Else
      quit=2
    EndIf
  Until quit
  If quit<3
    If quit=1: If PreviousElement(info())=0: ResetList(info()) :EndIf: EndIf
    AddElement(info())
    info()\handle=handle
    info()\process=process
    info()\class$=class$
    info()\name$=name$
  EndIf
EndProcedure

;Hauptschleife
If OpenWindow(0,10,10,10,10,"",#PB_Window_Invisible): EndIf; Alibifenster
ClearList(allhandle()): ClearList(info())
quit = 0 : handle = GetWindow_(WindowID(0),#GW_HWNDFIRST)
Repeat
  AddInfo(handle)
  x=GetWindow_(handle,#GW_CHILD)
  If x
    AddElement(allhandle())
    allhandle()=x
  EndIf
  x=GetWindow_(handle,#GW_HWNDNEXT)
  If x
    handle=x
  Else
    If LastElement(allhandle())
      handle=allhandle()
      DeleteElement(allhandle())
    Else
      quit=1
    EndIf
  EndIf
Until quit
ResetList(info())
While NextElement(info())
  If info()\class$="WindowClass_0"
    If Left(info()\name$,Len(_startok))=_startok
      _infomsg=Hex(info()\process)+Chr(13)+info()\class$+Chr(13)+info()\name$+Chr(13)
      _infomsg=_infomsg+Hex(info()\handle)+Chr(13)+Chr(13)+"Programm läuft bereits"
    EndIf
  EndIf
Wend
If _infomsg<>"no message"
  MessageBox()
  status="program run"
EndIf
;erzeugen einer Datei im Arbeitsverzeichnis
If OpenFile(1,"pgmstat.tmp")
  WriteStringN(1, status)
  WriteStringN(1, FormatDate("%yyyy-%mm-%dd/%hh:%ii:%ss",Date()))
  WriteStringN(1, Str(Date()))
  CloseFile(1)
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -