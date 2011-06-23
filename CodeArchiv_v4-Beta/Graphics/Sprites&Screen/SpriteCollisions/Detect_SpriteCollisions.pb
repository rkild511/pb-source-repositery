; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1511&highlight=
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 27. June 2003
; OS: Windows
; Demo: Yes


; Detect Sprite collisions easily ;)
; Feststellen von Sprite-Kollisionen
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

CreateSprite(0, 50, 50, #PB_Sprite_Memory) 
StartDrawing(SpriteOutput(0)) 
  Box(0, 0, 150, 150, RGB(255, 255, 255)) 
StopDrawing() 

CreateSprite(1, 50, 50, #PB_Sprite_Memory) 
StartDrawing(SpriteOutput(1)) 
  Box(0, 0, 50, 50, RGB(0, 0, 255)) 
StopDrawing()  

Structure Sprites 
  x.f 
  y.f 
EndStructure 
Global NewList Sprite.Sprites() 

For i = 1 To 77 
  x + 60 
  y + 7 
  If x > Breite - 50 
    x - Breite + 50 
  EndIf 
  If y > Hoehe - 50 
    y - Hoehe + 50 
  EndIf 
  AddElement(Sprite()) 
  Sprite()\x = x 
  Sprite()\y = y 
Next i 

Repeat 
  ExamineMouse() 
  xPos = MouseX()-25 
  yPos = MouseY()-25 
  StartSpecialFX() 
    ClearScreen(RGB(0,0,0)) 
    ResetList(Sprite()) 
    While NextElement(Sprite()) 
      DisplayTranslucentSprite(1, Sprite()\x, Sprite()\y, 200) 
      If SpriteCollision(0, xPos, yPos, 1, Sprite()\x, Sprite()\y) 
        If text$ 
          text$ + " / " + Str(ListIndex(Sprite())) 
        Else 
          text$ = Str(ListIndex(Sprite())) 
        EndIf 
      EndIf 
    Wend 
    DisplayTranslucentSprite(0, xPos, yPos, 200) 
  StopSpecialFX() 
  If text$ 
    StartDrawing(ScreenOutput()) 
      DrawText(10, 10,text$) 
    StopDrawing() 
    text$ = "" 
  EndIf 
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
