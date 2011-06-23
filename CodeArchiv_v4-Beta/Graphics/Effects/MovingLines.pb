; www.PureArea.net
; Author: davetea (updated for PB 4.00 by Andre)
; Date: 24. January 2004
; OS: Windows
; Demo: Yes


; kleiner Bildschirmschoner
; Autor: DAVETEA, davetea@freenet.de
; www.programmierschule-dortmund.de
; Viel Spass mit dem Skript. 
; Wenn einer es erweitert/verändert, würde ich mich über eine Mail freuen.
; Grueße, Davetea

InitSprite()
InitKeyboard()
InitMouse()
#SW = 1024 ;Konstante für Bilschirmbreite
#SH = 768  ;Konstante für Bilschirmbreite
#ScreenName = "Linien"

summe = 1   ;jeweils 4 punkt- bzw. Spiegelsymmetrische Linien 
speed.w = 3 ;maximaler Abstand der Linienendpunkte
tick.w = 0  ; Zeitgeber
r.w = 0 ;rot-Anteil, wird hier nur einmal gebraucht,
          ; sollte allerdings zur Veränderung des Skriptes nicht als Konstante
          ; deklariert werden
g.w = 0 ; dito
b.w = 251 
ckb.w = -1 ; vermindert den blau-Wert um 1 pro Schleifendurchlauf

Global Dim dir.w(1)
dir(0) = speed
dir(1) = -speed

Global Dim x.w(summe)  ;x-Koordinate 
Global Dim y.w(summe)  ;y-Koordinate
Global Dim dx.w(summe) ;x-Verschiebung (abhängig von speed)
Global Dim dy.w(summe) ;y-Verschiebung (abhängig von speed)

For i.w = 0 To summe Step 2
  x(i) = Random(#SW) 
  y(i) = Random(#SH) 
  x(i+1) = Random(#SW) 
  y(i+1) = Random(#SH) 
  dx(i) = dir(Random(1))-Random(speed-1)
  dy(i) = dir(Random(1))-Random(speed-1)
  dx(i+1) = dir(Random(1))-Random(speed-1)
  dy(i+1) = dir(Random(1))-Random(speed-1)
Next 

  
  If OpenScreen(#SW,#SH,32,#ScreenName) = 0
    If OpenScreen(#SW,#SH,24,#ScreenName) = 0
      If OpenScreen(#SW,#SH,16,#ScreenName) = 0
        MessageRequester("ERROR","Cant open "+Str(#SW)+"x"+Str(#SH)+" Screen",0):End
  EndIf:EndIf:EndIf ; Öffnet den ersten möglichen Bildschirm 

ClearScreen(RGB(0,0,0))
FlipBuffers()
ClearScreen(RGB(0,0,0))

Repeat
  tick+1            ; alle 1500 Durchläufe wird der Bildschirmhintergrund geändert
  If tick = 1500
    ClearScreen(RGB(0,0,255))
  EndIf
  If tick = 3000
    ClearScreen(RGB(0,0,0))
    tick = 0
  EndIf
  
  StartDrawing(ScreenOutput()) 
  For i.w = 0 To summe Step 2  ; für jeweils eine Linie werden 
    x(i) + dx(i)                ; Koordinaten ermittelt und um dx/dy verändert
        y(i) + dy(i)
        x(i+1) + dx(i+1)
        y(i+1) + dy(i+1) 
      If x(i) <= 0 Or x(i) >= #SW ;Richtungswechsel bei Berührung des Bilschirmrandes
        dx(i) = -dx(i)
      EndIf 
      If y(i) <= 0 Or y(i) >= #SH 
        dy(i) = -dy(i)
      EndIf
      If x(i+1) <= 0 Or x(i+1) >= #SW
        dx(i+1) = -dx(i+1)
      EndIf 
      If y(i+1) <= 0 Or y(i+1) >= #SH
        dy(i+1) = -dy(i+1)
      EndIf
      LineXY(x(i),y(i),x(i+1),y(i+1), RGB(r,g,b))  
      LineXY(#SW-x(i),#SH-y(i),#SW-x(i+1),#SH-y(i+1), RGB(r,g,b)) 
      LineXY(x(i),#SH-y(i),x(i+1),#SH-y(i+1), RGB(r,g,b)) 
      LineXY(#SW-x(i),y(i),#SW-x(i+1),y(i+1), RGB(r,g,b)) 
    Next 
    
    b+ckb       ; Blau-Anteil pendelt zwischen 3 und 252  
    If b=3
      ckb = -ckb
    EndIf
    If b=252
      ckb = -ckb
    EndIf 

  StopDrawing()
   FlipBuffers() 
   ExamineKeyboard()
   ExamineMouse()
  Delay(10)
Until KeyboardPushed(#PB_Key_All) Or MouseButton(1) <> 0 Or MouseButton(2) <> 0
CloseScreen()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger