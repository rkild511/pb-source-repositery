; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5195&highlight=
; Author: Deeem2031 (based on code by Rosi, updated for PB 4.00 by Andre)
; Date: 30. July 2004
; OS: Windows
; Demo: Yes

; Mandala Polygon
; Mandala Vieleck

Procedure High(a,b):If a > b:ProcedureReturn a:Else:ProcedureReturn b:EndIf:EndProcedure

Procedure.s StrBN(a)
  result.s = Str(a)
  For i = 3 To Len(result)-1 Step 4
    result = Left(result,Len(result)-i)+"."+Right(result,i)
  Next
  ProcedureReturn result
EndProcedure

InitKeyboard() : InitMouse() : InitSprite()
#XXX=800
#YYY=#XXX/4*3
ecken=15
durchmesser=(#YYY-100)/2

If OpenWindow(0,0,0,#XXX,#YYY,"Mandala",#PB_Window_ScreenCentered|#PB_Window_SystemMenu)

  If OpenWindowedScreen(WindowID(0),0,0,#XXX,#YYY,0,0,0)
    font1=LoadFont(1,"fixedsys",10)
    font2=LoadFont(2,"Arial",16)
    Gosub zeichnen

    Repeat
      EventID=WindowEvent()
      If EventID = #PB_Event_Repaint:Gosub zeichnen:EndIf

      ExamineKeyboard()
      If KeyboardReleased(#PB_Key_Up)
        If ecken<10000
          ecken=ecken+1
        EndIf
        Gosub zeichnen
      EndIf
      If KeyboardReleased(#PB_Key_Down)
        If ecken>3
          ecken=ecken-1
        EndIf
        Gosub zeichnen
      EndIf
      If KeyboardReleased(#PB_Key_Space)
        ecken=20
        Gosub zeichnen
      EndIf

      Delay(10)
    Until EventID = #PB_Event_CloseWindow
  EndIf

EndIf

End


;- initialisiert und zeichnet Mandala
zeichnen:
Dim x.f(ecken)
Dim y.f(ecken)
linien=0
;/ berechnet die Eckpunkte
For w=1 To ecken
  winkel.f=w*(360/ecken)
  x.f(w)=Sin(winkel*(2*#PI/360))*durchmesser+#XXX/2
  y.f(w)=Cos(winkel*(2*#PI/360))*durchmesser+#YYY/2
Next

ClearScreen(RGB(0,0,0))

StartDrawing(ScreenOutput())
;/ verbindet die Eckpunkte
For w=1 To ecken-1
  xa=x(w) : ya=y(w)
  For i=w+1 To ecken
    LineXY(xa,ya,x(i),y(i),RGB(255,255,255))
    linien=linien+1 ; zählt Linien insgesamt
  Next
Next

ueberschneidungen = 0
;For i = 1 To ecken
For i2 = 1 To ecken-3
  ueberschneidungen + i2*((ecken - 3)-i2+1)
Next
;Next
ueberschneidungen * ecken / 4

;/ Textausgabe
j = High(Len(StrBN(ueberschneidungen)),Len(Str(linien)))

;DrawingMode(#PB_2DDrawing_Outlined)
DrawingFont(FontID(2))
DrawText(10, 8, "Mandala")
DrawingFont(FontID(1))
DrawText(10, 32, RSet(Str(ecken),j)+" Ecken")
DrawText(10, 46, RSet(StrBN(linien),j)+" linien")
DrawText(10, 60, RSet(StrBN((ecken*(ecken-3))/2),j)+" Diagonalen")
DrawText(10, 74, RSet(StrBN(ueberschneidungen),j)+" Überschneidungen")
DrawText(10, 542, "UP    - erhöht Eckpunktanzahl")
DrawText(10, 556, "DOWN  - senkt Eckpunktanzahl")
DrawText(10, 570, "SPACE - setzt Programm zurück")
StopDrawing()

FlipBuffers()
Return
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -