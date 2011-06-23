; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1511&highlight=
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 07. July 2003
; OS: Windows
; Demo: Yes

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


CreateSprite(0, 20, 20, #PB_Sprite_Memory) 
StartDrawing(SpriteOutput(0)) 
  DrawingMode(4) 
  Circle(10, 10, 10, RGB(255, 255, 255)) 
  Plot(10, 10,RGB(200, 200, 200)) 
StopDrawing() 

CreateSprite(1, 50, 50, #PB_Sprite_Memory) 
StartDrawing(SpriteOutput(1)) 
  Box(0, 0, 50, 50, RGB(0, 0, 255)) 
StopDrawing()  

Structure Sprites 
  x.l 
  y.l 
  weg.l 
EndStructure 
Global NewList Sprite.Sprites() 


For i = 1 To 6 
  y = 280 
  x + 100 
  AddElement(Sprite()) 
  Sprite()\x = x 
  Sprite()\y = y 
Next i 

counter = 0 

Repeat 
  ExamineMouse() 
  xPos = MouseX()-10 
  yPos = MouseY()-10 
  StartSpecialFX() 
    ClearScreen(RGB(0,0,0)) 
    ResetList(Sprite()) 
    While NextElement(Sprite()) 
      DisplayTranslucentSprite(1, Sprite()\x, Sprite()\y, 200) 
      If SpriteCollision(0, xPos, yPos, 1, Sprite()\x, Sprite()\y) 
        If SpritePixelCollision(0, xPos, yPos, 1, Sprite()\x, Sprite()\y) 
          If text$ 
            text$ + " / " + Str(ListIndex(Sprite())) 
          Else 
            text$ = Str(ListIndex(Sprite())) 
          EndIf 
          If Sprite()\weg = 0 
            counter + 1 
            Sprite()\weg = 1 
          EndIf 
        EndIf 
      EndIf 
    Wend 
    DisplayTranslucentSprite(0, xPos, yPos, 200) 
  StopSpecialFX() 
  StartDrawing(ScreenOutput()) 
  DrawText(10, 10,"Zähler: " + Str(counter)) 
  If text$ 
      DrawText(Breite - 200, 10,"Kollision mit: " + text$) 
    text$ = "" 
  EndIf 
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
