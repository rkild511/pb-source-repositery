; www.PureArea.net
; Author: Andre
; Date: 23. August 2003
; OS: Windows
; Demo: Yes


; "Zahlen erraten"
; GFA-BASIC Code von Günter Winkelmann
; Umsetzung in PureBasic von André Beer, 11.-23. August 2003


; Hier werden die später genau definierten Prozeduren deklariert.
; Dies kann man sich ersparen, wenn man den kompletten Prozedur-Code an den Anfang des Sourcecodes
; verschiebt, d.h. vor dessen erstem Aufruf...
Declare hinweis(b$)

#breite = 600    ; Breite des Fensters
#rand   = 30     ; linker Rand in Pixel
If OpenWindow(0,0,0,#breite,500,"Zahlen erraten...",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If LoadFont(0,"Arial",12,#PB_Font_Bold)
    SetGadgetFont(#PB_Default,FontID(0))
  EndIf
  If CreateGadgetList(WindowID(0))
    y = 20
    TextGadget(0,#rand,y,#breite-(#rand*2),20,"Denken Sie sich eine ganze Zahl zwischen 1 und 100",#PB_Text_Center)
    y + 25
    TextGadget(1,#rand,y,#breite-(#rand*2),20,"Multiplizieren die Zahl mit 5",#PB_Text_Center)
    y + 40
    TextGadget(2,#rand,y,#breite-(#rand*2),20,"Addieren Sie 24 dazu",#PB_Text_Center)
    y + 25
    TextGadget(3,#rand,y,#breite-(#rand*2),20,"Verdoppeln Sie das Ergebnis",#PB_Text_Center)
    y + 40
    TextGadget(4,#rand,y,#breite-(#rand*2),20,"Ziehen Sie 8 ab",#PB_Text_Center)
    y + 40
    TextGadget(5,#rand,y,#breite-(#rand*2),20,"Sagen Sie mir das Ergebnis:",#PB_Text_Center)
    y + 40
    StringGadget(6,225,y,150,25,"",#PB_String_Numeric)
    y + 30
    ButtonGadget(7,200,y,200,25,"Gedachte Zahl war:")
    y + 40
    TextGadget(8,#rand,y,#breite-(#rand*2),20,"",#PB_Text_Center)    ; Hierin wird später das Ergebnis ausgegeben
    y + 40
    ButtonGadget(9,200,y,200,25,"Noch einmal")
    y + 30
    ButtonGadget(10,200,y,200,25,"Programm beenden")
    y + 40
    TextGadget(11,#rand,y,#breite-(#rand*2),20,"Programm von Günter",#PB_Text_Center)
    y + 40
    StringGadget(12,125,y,350,30,"");,#PB_String_ReadOnly)
  Else
    MessageRequester("Fehler","Erstellen der Gadgets fehlgeschlagen!",#PB_MessageRequester_Ok)
    End
  EndIf
Else
  MessageRequester("Fehler","Öffnen des Programmfensters fehlgeschlagen!",#PB_MessageRequester_Ok)
  End
EndIf


; Hauptschleife zur Abfrage von Anwendereingaben
Repeat
  event.l = WaitWindowEvent()
  Select event
    Case #PB_Event_CloseWindow
      quit = #True
    Case #PB_Event_Gadget
      gad.l = EventGadget()
      Select gad
        Case 7     ; Schalter "Gedachte Zahl war:"
          exit = #False        ; mit dem Parameter break bestimmen wir bei den nachfolgenden If-Abfragen,
          ; ob der entsprechende Code ausgeführt wird oder nicht. Damit vermeiden
          ; wir die vielen "Goto" aus der GFA-Version.
          w$ = GetGadgetText(6)
          a = Val(w$)
          If a >= 0 And a <= 49           ; a liegt zwischen 0 und 49
            hinweis("Gedachte Zahl liegt nicht zwischen 1 - 100 !!")
            exit = #True
          EndIf
          If a >= 1041 And a <= 1000000   ; a liegt zwischen 1041 und 1000000
            hinweis("Gedachte Zahl liegt nicht zwischen 1 - 100 !!")   ; originale "cc" Prozedur
            exit = #True
          EndIf
          If exit = #False   ; nur weiterarbeiten, wenn vorherige Bedingungen nicht zum Abbruch führten...
            If a >= 50 And a <= 99          ; a liegt zwischen 50 und 99
              v$=Left(w$,1)       ; <= die Left() Befehle unterscheiden sich anscheinend zwischen GFA- und
              ;    und PureBasic, in PB muss der 2. Parameter jedenfalls immer um eins
              ;    kleiner als in der GFA Version sein...
            EndIf
            If a >= 100 And a <= 999        ; a liegt zwischen 100 und 999
              v$=Left(w$,2)
            EndIf
            If a >= 1000 And a <= 1040      ; a liegt zwischen 1000 und 1040
              v$=Left(w$,3)
            EndIf
            If Right(w$,1)<>"0"
              hinweis("       Sie haben falsch gerechnet !!")   ; orginale "dd" Prozedur
              exit = #True
            EndIf
            c=Val(v$)
            z=c-4
            a$=Str(z)
            SetGadgetText(8,a$)    ; Ergebnis ausgeben
          EndIf
        Case 9     ; Schalter "Noch einmal"
          ; Das Fenster und die Gadgets müssen nicht neu aufgebaut werden,
          ; lediglich der Inhalt der String- und Text-Gadgets muss auf den
          ; Anfangsinhalt zurückgesetzt werden.
          SetGadgetText(6,"")   ; evtl. Inhalt des Stringgadgets mit der Zahleneingabe löschen
        Case 10    ; Schalter "Programm beenden"
          quit = #True
      EndSelect
  EndSelect
Until quit = #True

End


Procedure hinweis(b$)
  SetGadgetText(12,b$)    ; Text ausgeben
  SetGadgetText(8,"---")  ; Ergebnis "---" ausgeben
  While WindowEvent() : Wend    ; Diese Schleife wartet (einige Millisekunden), bis Windows alle seine offenen
  ; Nachrichten abgearbeitet hat. Nur dann wird der Inhalt des Stringgadgets
  ; richtig dargestellt.
  Delay(2000)             ; 2 Sekunden warten
  SetGadgetText(12,"")    ; Textinhalt löschen
  SetGadgetText(8,"")     ; Ergebnisfeld löschen
  SetGadgetText(6,"")     ; Eingabefeld löschen
EndProcedure



; Original GFA-BASIC Code
; DLGBASE UNIT
; DIALOG #1,0,0,400,300,"ZAHLEN ERRATEN"
;   PUSHBUTTON "GEDACHTE ZAHL WAR :", 1001,160,140,100,12,WS_TABSTOP
;   PUSHBUTTON "NOCH EINMAL", 1000,160,180,100,12,WS_TABSTOP
;   PUSHBUTTON "PROGRAMM SCHLIESSEN",1002,140,200,150,12,WS_TABSTOP
;   LTEXT " Denken Sie sich eine ganze Zahl zwischen 1 und 100",1003,100,10,240,12
;   LTEXT "Programm von Guenter ",1004,170,220,180,12,ws_border
;   LTEXT "Multiplizieren die Zahl mit 5 ",1005,160,26,200,12
;   EDITTEXT " " ,1006,180,120,60,12,ws_border |WS_TABSTOP
;   LTEXT " Addieren Sie 24 dazu",1007,160,46,200,12
;   EDITTEXT " ",1008,120,240,180,12,WS_BORDER
;   LTEXT " ",1009,40,66,50,12
;   LTEXT " Verdoppeln Sie das Ergebnis ",977,160,60,200,12
;   LTEXT " Ziehen Sie 8 ab",978,170,80,200,12
;   LTEXT " Sagen Sie mir das Ergebnis: ",978,160,100,140,12
;   LTEXT "   ",1010,200,166,50,12
; ENDDIALOG
; DLG FILL 1,RGB(192,192,192)
; SHOWDIALOG #1
; Repeat
;   GETEVENT
;
;   If MENU(11)=WM_COMMAND
;
;     Select MENU(12)
;     Case 1002
;       ende!=TRUE
;     Case 1000
;       Goto aaa
;     Case 1001
;
;       w$=_WIN$(DLGITEM(1,1006))
;
;       a%=Val(w$)
;       REM  v$=LEFT$(w$,3)
;       Select a%
;       Case 0 To 49
;         Gosub cc
;         Goto aaa
;       Case 1041 To 1000000
;         Gosub cc
;         Goto aaa
;       Case 50 To 99
;         v$=LEFT$(w$,2)
;       Case 100 To 999
;         v$=LEFT$(w$,3)
;       Case 1000 To 1040
;         v$=LEFT$(w$,4)
;       EndSelect
;       If RIGHT$(w$,1)<>"0"
;         Gosub dd
;         Goto aaa
;       EndIf
;       c=Val(v$)
;       z=c-4
;       a$=STR$(z)
;       _WIN$(DLGITEM(1,1010))= a$
;     EndSelect
;   EndIf
; Until ende!
; CLOSEDIALOG #1
; End
; Procedure cc
;   _WIN$(DLGITEM(1,1010))= "-"
;   b$="Gedachte Zahl liegt nicht zwischen 1 - 100 !!"
;   _WIN$(DLGITEM(1,1008))=b$
;   PAUSE 50
; Return
; Procedure dd
;   _WIN$(DLGITEM(1,1010))= "-"
;   b$= "       Sie haben falsch gerechnet !!"
;   _WIN$(DLGITEM(1,1008))=b$
;   PAUSE 50
; Return
;
;

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP