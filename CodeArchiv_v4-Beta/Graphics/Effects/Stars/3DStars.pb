; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3600&highlight=
; Author: Volker Schmid (updated for PB 4.00 by Andre)
; Date: 07. June 2005
; OS: Windows
; Demo: Yes


; Just use X, Y and Z keys to change the stars movement.
; With the mouse the vanishing point of the perspective can be changed.


; Nachfolgend mein Sterne-Code, allerdings ist dieser 3D.

; Mit der Maus kann man den Fluchtpunkt der Perspektive ändern.
; Mit den Tasten X, Y und Z kann man die Sterne bewegen.
; Ein Tastendruck schaltet die jeweilige Richtung ein/aus.
;
; Als Standard startet es mit einer Z-Bewegung.
;
; HINWEIS: je nach Tastaturlayout können die Tasten Y und Z vertauscht
; reagieren (deutsch/englisch).
;


; 3D-Stars (V. Schmid)
Dim Punkte.f(2000,3)    ; Punkte mit X,Y und Z Koordinaten
Dim BildPixel.l(2000,2) ; Berechnete Bildpunkte
Dim d.l(3)              ; Hilfsvariable
Dim Fluchtpunkt.f(3)    ; Fluchtpunktkoordinaten (X,Y,Z)
;
Global PKTAnz.l
Global Counter.f
;
PKTAnz.l = 2000
; Sterne generieren (zufällige Koordinaten)
For x.l = 1 To PKTAnz.l
  Punkte(x.l, 1) = Random(2000) - 1000 ; X
  Punkte(x.l, 2) = Random(2000) - 1000 ; Y
  Punkte(x.l, 3) = Random(2000) ; Z
Next
;
If InitKeyboard() = 0 Or InitMouse() = 0 Or InitSprite() = 0
  MessageRequester("Error", "Kann nicht initialisieren!")
  End
EndIf
;
; Initialisieren
Fluchtpunkt(1) = 0    ; X
Fluchtpunkt(2) = 0    ; Y
Fluchtpunkt(3) = 2000 ; Z
ZEbene.l = 1540
; Welche Richtung wird gerade bewegt?
BewegeX.b = 0
BewegeY.b = 0
BewegeZ.b = 1
;

ExamineDesktops()
Width = DesktopWidth(0)
Height = DesktopHeight(0)
Depth = DesktopDepth(0)
If OpenScreen(Width, Height, Depth, "Stars")
  xOffset.l = Width / 2
  yOffset.l = Height / 2

  Repeat
    FlipBuffers()
    ClearScreen(RGB(0,0,0))

    ; Sterne bewegen
    For x.l = 1 To PKTAnz.l
      ; Z-Koordinaten der Sterne
      If BewegeZ.b = 1
        Punkte(x.l, 3) = Punkte(x.l, 3) + 5
        If Punkte(x.l, 3) > 2000: Punkte(x.l, 3) = 0: EndIf
      EndIf
      ; Y-Koordinaten der Sterne
      If BewegeY.b = 1
        Punkte(x.l, 2) = Punkte(x.l, 2) + 5
        If Punkte(x.l, 2) > 1000: Punkte(x.l, 2) = -1000: EndIf
      EndIf
      ; X-Koordinaten der Sterne
      If BewegeX.b = 1
        Punkte(x.l, 1) = Punkte(x.l, 1) - 5
        If Punkte(x.l, 1) < -1000: Punkte(x.l, 1) = 1000: EndIf
      EndIf
    Next

    ; Transfer der Sterne nach 2D
    For x.l = 1 To PKTAnz.l
      For j.l = 1 To 3
        d(j.l) = Fluchtpunkt(j.l) - Punkte(x.l, j.l)
      Next
      Lambda.f = (ZEbene.l - Punkte(x.l, 3)) / d(3)
      BildPixel(x.l, 1) = xOffset.l + Punkte(x.l, 1) + Lambda.f * d(1) ; X
      BildPixel(x.l, 2) = yOffset.l + Punkte(x.l, 2) + Lambda.f * d(2) ; Y
    Next

    ; Zeichnen der Sterne
    StartDrawing(ScreenOutput())
    Counter.f = Counter.f + 0.005
    If Counter.f > 3.1415 * 2: Counter.f = 0: EndIf
    For x.l = 1 To PKTAnz.l
      If BildPixel(x.l, 1) > 0 And BildPixel(x.l, 1) < (Width-1) And BildPixel(x.l, 2) > 0 And BildPixel(x.l, 2) < (Height-1)
        Farbe.l = Punkte(x.l, 3) / 8
        If Farbe.l > 100
          ; Stern
          Farbwert2.l = RGB(Farbe.l - 60,Farbe.l - 60,Farbe.l - 60)
          Plot(BildPixel(x.l, 1), BildPixel(x.l, 2), RGB(Farbe.l, Farbe.l, Farbe.l))
          Plot(BildPixel(x.l, 1) - 1, BildPixel(x.l, 2), Farbwert2.l)
          Plot(BildPixel(x.l, 1) + 1, BildPixel(x.l, 2), Farbwert2.l)
          Plot(BildPixel(x.l, 1), BildPixel(x.l, 2) - 1, Farbwert2.l)
          Plot(BildPixel(x.l, 1), BildPixel(x.l, 2) + 1, Farbwert2.l)
        Else
          ; Punkt
          Plot(BildPixel(x.l, 1), BildPixel(x.l, 2), RGB(Farbe.l, Farbe.l, Farbe.l))
        EndIf
      EndIf
    Next
    StopDrawing()

    ; Tastatur abfragen
    ExamineKeyboard()
    ExamineMouse()

    ; Tasten für Ein-Auschalten der Richtungen
    If KeyboardPushed(#PB_Key_X)
      BewegeX.b = BewegeX.b + 1: If BewegeX.b = 2: BewegeX.b = 0:EndIf
      Delay(150)
    EndIf

    If KeyboardPushed(#PB_Key_Y)
      BewegeY.b = BewegeY.b + 1: If BewegeY.b = 2: BewegeY.b = 0:EndIf
      Delay(150)
    EndIf

    If KeyboardPushed(#PB_Key_Z)
      BewegeZ.b = BewegeZ.b + 1: If BewegeZ.b = 2: BewegeZ.b = 0:EndIf
      Delay(150)
    EndIf

    ; Fluchtpunkt nach Maus ausrichten
    Fluchtpunkt(1) = Fluchtpunkt(1) + MouseDeltaX()
    Fluchtpunkt(2) = Fluchtpunkt(2) + MouseDeltaY()

    ; Fluchtpunkt(1) = Fluchtpunkt(1) + Sin(Counter.f)*2
    ; Fluchtpunkt(2) = Fluchtpunkt(2) + Cos(Counter.f)*2
    ; Fluchtpunkt(3) = Fluchtpunkt(3) + Sin(Counter.f)*2

  Until KeyboardPushed(#PB_Key_Escape)
  CloseScreen()
  End
Else
  MessageRequester("Error", "Kann Bildschirm nicht öffnen!")
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -