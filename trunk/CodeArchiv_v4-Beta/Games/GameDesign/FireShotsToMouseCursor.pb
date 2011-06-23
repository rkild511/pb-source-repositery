; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1518&start=10
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 07. July 2003
; OS: Windows
; Demo: Yes


; Pressing left mousebutton fires a shot in the direction of the mouse cursor
; Drücken der Maustaste feuert einen Schuss in die Richtung des Mauspfeils

Structure Spieler 
  x.f 
  y.f 
  hGroesse.l 
  Geschwindigkeit.l 
  DrehGeschwindigkeit.l 
  Winkel.l 
  ZielWinkel.l 
EndStructure 

Structure Geschoss 
  x.f 
  y.f 
  GeschwindigkeitX.f 
  GeschwindigkeitY.f 
EndStructure 

Global NewList Geschoss.Geschoss() 

Procedure.l gATan(a.l, b.l) 
  Winkel.l = Int(ATan(a/b)*57.2957795) 
  If b < 0 
    Winkel + 180 
  EndIf 
  If Winkel < 0 : Winkel + 360 : EndIf 
  If Winkel > 359 : Winkel - 360 : EndIf 
  ProcedureReturn Winkel 
EndProcedure 

Procedure.f gSin(Winkel.l) 
   ; Eingabe: Winkel ( 0 - 360 ) 
   ; Ausgabe: Sinus vom Winkel 
   ProcedureReturn Sin(Winkel*0.01745329) 
EndProcedure 

Procedure.f gCos(winkel.l) 
   ; Eingabe: Winkel ( 0 - 360 ) 
   ; Ausgabe: Cosinus vom Winkel 
   ProcedureReturn Cos(winkel*0.01745329) 
EndProcedure 

Procedure neuesGeschoss(x.f, y.f, GeschwindigkeitX.f, GeschwindigkeitY.f) 
  AddElement(Geschoss()) 
  Geschoss()\x = x 
  Geschoss()\y = y 
  Geschoss()\GeschwindigkeitX = GeschwindigkeitX 
  Geschoss()\GeschwindigkeitY = GeschwindigkeitY 
EndProcedure 

If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 
  MessageRequester("Error", "DirectX 7 Fehler!", 0) 
  End 
EndIf 

Breite = 800 
Hoehe = 600 

If OpenScreen ( Breite, Hoehe,32,"Standard") = 0 
  MessageRequester("Error", "Es konnte kein Bildschirm aufgebaut werden", 0) 
  End 
EndIf 

If InitSprite3D() = 0 
  MessageRequester("DirectX fehler !", "Fehler", #PB_MessageRequester_Ok) 
  End 
EndIf 


CreateSprite(0, Breite, Hoehe) 

CreateSprite(1, 32, 32, #PB_Sprite_Texture) 
StartDrawing(SpriteOutput(1)) 
  Box(0, 0, 32, 32, RGB(55, 55, 55)) 
;  Circle(16, 16, 15, RGB(55, 55, 55)) 
  FrontColor(RGB(100,100,100)) 
  DrawingMode(1) 
  DrawText(7, 8,"CK") 
StopDrawing() 

CreateSprite(2, 32, 32, #PB_Sprite_Texture) 
StartDrawing(SpriteOutput(2)) 
  LineXY(1, 17, 16, 1, RGB(255, 255, 255)) 
  LineXY(16, 1, 31, 17, RGB(255, 255, 255)) 
  LineXY(20, 17, 31, 17, RGB(255, 255, 255)) 
  LineXY(10, 17, 1, 17, RGB(255, 255, 255)) 
  LineXY(10, 31, 10, 17, RGB(255, 255, 255)) 
  LineXY(20, 31, 20, 17, RGB(255, 255, 255)) 
  LineXY(10, 31, 20, 31, RGB(255, 255, 255)) 
  LineXY(10, 31, 10, 17, RGB(255, 255, 255)) 
  FillArea(16, 17, RGB(255, 255, 255), RGB(255, 255, 255)) 
StopDrawing() 

Sprite3DQuality(1) 
CreateSprite3D(1, 1) 
CreateSprite3D(2, 2) 

CreateSprite(10, 32, 32) 
StartDrawing(SpriteOutput(10)) 
  DrawingMode(4) 
  Circle(16, 16, 16, RGB(255, 255, 255)) 
  Plot(16, 16,RGB(200, 200, 200)) 
StopDrawing() 



Spieler1.Spieler 
Spieler1\hGroesse = 16 
Spieler1\x = Breite/2 - Spieler1\hGroesse 
Spieler1\y = Hoehe/2 - Spieler1\hGroesse 
Spieler1\Geschwindigkeit = 2 
Spieler1\Drehgeschwindigkeit = 2 
Spieler1\Winkel = 270 

Maus.Point 

Repeat 
  ExamineMouse() 
  ExamineKeyboard() 

  Maus\x = MouseX() - 16 
  Maus\y = MouseY() - 16 
  a.l = Maus\y - Spieler1\y 
  b.l = Maus\x - Spieler1\x 
  Spieler1\ZielWinkel = gATan(a, b) 
  
  If KeyboardPushed(#PB_Key_Left) Or KeyboardPushed(#PB_Key_A) 
    Spieler1\Winkel - Spieler1\Drehgeschwindigkeit 
  EndIf 
  If KeyboardPushed(#PB_Key_Right) Or KeyboardPushed(#PB_Key_D) 
    Spieler1\Winkel + Spieler1\Drehgeschwindigkeit 
  EndIf 
  ; 
  If KeyboardPushed(#PB_Key_Up) Or KeyboardPushed(#PB_Key_W) 
    Spieler1\x + (gCos(Spieler1\Winkel) * Spieler1\Geschwindigkeit) 
    Spieler1\y + (gSin(Spieler1\Winkel) * Spieler1\Geschwindigkeit) 
  EndIf 
  If KeyboardPushed(#PB_Key_Down) Or KeyboardPushed(#PB_Key_S) 
    Spieler1\x - (gCos(Spieler1\Winkel) * Spieler1\Geschwindigkeit) 
    Spieler1\y - (gSin(Spieler1\Winkel) * Spieler1\Geschwindigkeit) 
  EndIf 
  If Spieler1\x > Breite - 32 
    Spieler1\x = Breite - 32 
  EndIf 
  If Spieler1\x < 0 
    Spieler1\x = 0 
  EndIf 
  If Spieler1\y > Hoehe - 32 
    Spieler1\y = Hoehe - 32 
  EndIf 
  If Spieler1\y < 0 
    Spieler1\y = 0 
  EndIf 
  
  If MouseButton(1) 
    If Verzoegerung < 1 
      Verzoegerung = 10 
      Geschwindigkeit.l = 8 
      Geschossabstand.l = 33 
      GeschwindigkeitX.f = gCos(Spieler1\ZielWinkel) 
      GeschwindigkeitY.f = gSin(Spieler1\ZielWinkel) 
      neuesGeschoss(Spieler1\x + Spieler1\hGroesse + GeschwindigkeitX * Geschossabstand, Spieler1\y + Spieler1\hGroesse + GeschwindigkeitY * Geschossabstand, GeschwindigkeitX * Geschwindigkeit, GeschwindigkeitY * Geschwindigkeit) 
      ;patronenhülse malen 
      StartDrawing(SpriteOutput(0)) ;Grafiken werden direkt auf dem Hintergrundbildsprite gerendert 
        Plot(Int(Spieler1\x) + Random(Spieler1\hGroesse) + Spieler1\hGroesse/2, Int(Spieler1\y) + Random(Spieler1\hGroesse) + Spieler1\hGroesse/2, RGB(200, 120, 55)) 
      StopDrawing() 
    EndIf 
  EndIf 
  If Verzoegerung > 0 
    Verzoegerung - 1 
  EndIf 
  
  ;ClearScreen(0, 0, 0) 
  
  DisplaySprite(0, 0, 0) 

  Start3D() 
    RotateSprite3D(1, Spieler1\Winkel, 0) 
    DisplaySprite3D(1, Int(Spieler1\x), Int(Spieler1\y)) 
    RotateSprite3D(2, Spieler1\ZielWinkel, 0) 
    DisplaySprite3D(2, Int(Spieler1\x), Int(Spieler1\y), 20) 
  Stop3D() 
  
  DisplayTransparentSprite(10, Maus\x, Maus\y) 

  ; Geschosse rendern 
  StartDrawing(ScreenOutput()) ;Grafiken werden direkt auf dem Bildschirm gerendert 
    
    ResetList(Geschoss()) 
    While NextElement(Geschoss()) 
      If Geschoss()\x < 0 Or Geschoss()\y < 0 Or Geschoss()\x > Breite Or Geschoss()\y > Hoehe 
        DeleteElement(Geschoss()) 
      Else 
        Plot(Int(Geschoss()\x), Int(Geschoss()\y), RGB(200, 200, 200)) 
        LineXY(Int(Geschoss()\x - Geschoss()\GeschwindigkeitX*2), Int(Geschoss()\y - Geschoss()\GeschwindigkeitY*2), Geschoss()\x, Geschoss()\y, RGB(120, 100, 100)) 
        Geschoss()\x + Geschoss()\GeschwindigkeitX 
        Geschoss()\y + Geschoss()\GeschwindigkeitY 
      EndIf 
    Wend 
  StopDrawing() 
  
  FlipBuffers() 
    
  If KeyboardPushed(#PB_Key_Escape) 
    Quit = 1 
  EndIf 

  Delay(3) 
Until Quit 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
