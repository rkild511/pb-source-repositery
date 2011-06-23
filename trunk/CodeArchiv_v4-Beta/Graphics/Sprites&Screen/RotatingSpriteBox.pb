; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1518&highlight=
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 27. June 2003
; OS: Windows
; Demo: Yes


; Rotating box, where the included line "looks" to the virtual mouse cursor

; Beispiel auf die Frage:
; Wie schaffe ich es, dass ein 3D-Sprite mittels dem RotateSprite3D() Befehl
; immer in die Richtung meiner Maus Position schaut?

Procedure.l gATan(a.w, b.w) 
  winkel.l = ATan(a/b)*57.2957795 
  If b < 0 
    winkel + 180 
  EndIf 
  If winkel < 0 : winkel + 360 : EndIf 
  If winkel > 359 : winkel - 360 : EndIf 
  ProcedureReturn winkel 
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


CreateSprite(0, 50, 50, #PB_Sprite_Texture) 
StartDrawing(SpriteOutput(0)) 
  Box(0, 0, 50, 50, RGB(55, 55, 55)) 
  FrontColor(RGB(100,100,100)) 
  DrawingMode(1) 
  DrawText(10, 10,"CK") 
StopDrawing() 

Sprite3DQuality(1) 

CreateSprite3D(0, 0) 

Repeat 
  ClearScreen(RGB(0,0,0)) 
  ExamineMouse() 
  ; a = grün 
  a.w = MouseY() - Hoehe/2 
  ; b = rot 
  b.w = MouseX() - Breite/2 
  winkel.l = gATan(a, b) 

  Start3D() 
    RotateSprite3D(0, Winkel, 0) 
    DisplaySprite3D(0, Breite/2 - 25, Hoehe/2 - 25) 
  Stop3D() 
  
  StartDrawing(ScreenOutput()) 
    ; a = grün 
    LineXY(MouseX(), MouseY(), MouseX(), Hoehe/2, $00F000) 
    ; b = rot 
    LineXY(MouseX(), Hoehe/2, Breite/2, Hoehe/2, $0000F0) 
    ; c = blau 
    LineXY(Breite/2, Hoehe/2, MouseX(), MouseY(),$500000) 
    DrawingMode(1) 
    FrontColor(RGB(255,0,0)) 
    DrawText(MouseX(), Hoehe/2 + 1,"b: " + Str(b)) 
    FrontColor(RGB(0,255,0)) 
    DrawText(MouseX() + 1, MouseY(),"a: " + Str(a)) 
    FrontColor(RGB(255,255,255)) 
    DrawText(Breite/2, Hoehe/2 + 25,Str(winkel) + " Grad") 
  StopDrawing() 
  FlipBuffers() 
  
  If ExamineKeyboard() 
    If KeyboardPushed(#PB_Key_Escape) 
      Quit = 1 
    EndIf 
  EndIf 
  Delay(10) 
Until Quit 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
