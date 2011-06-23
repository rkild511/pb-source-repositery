; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8744&highlight=
; Author: DriakTravo (updated for PB4.00 by blbltheworm)
; Date: 15. December 2003
; OS: Windows
; Demo: Yes


InitSprite() 
InitKeyboard() 

OpenFile(0,"scncmds.txt") 
  ScreenW = 640 
  ScreenH = 480 
  Deb = 16 
CloseFile(0) 


Global ShakeX.l, ShakeY.l, PowerX.l, PowerY.l 
Global PlayerX, PlayerY, PlayerSpeedY.l, PlayerSpeedX.l 

PlayerX = (ScreenW/2)-5 
PlayerY = 15 

Procedure ShakeScreen(PowerX2,PowerY2) 
  PowerX = PowerX2 
  PowerY = PowerY2 
EndProcedure 

Procedure ScreenReset() 
  ShakeX = 0 
  ShakeY = 0 
EndProcedure 

Procedure UpdateShake() 
  If PowerX <> 0 
    If PowerY <> 0 
      ShakeX = Random((PowerX*2))-PowerX 
      ShakeY = Random((PowerY*2))-PowerY 
    EndIf 
  EndIf 

  If PowerX > 0 
    PowerX - 1 
  EndIf 
  If PowerY > 0 
    PowerY - 1 
  EndIf 
EndProcedure 

Structure dot 
  X.l 
  Y.l 
  XS.l 
  YS.l 
EndStructure 

Global NewList dot.dot() 

OpenScreen(640,480,Deb,"Screen Boom") 

ClearScreen(RGB(0,0,0)) 
StartDrawing(ScreenOutput()) 
  Box(0,0,100,100,RGB(150,255,0)) 
StopDrawing() 
GrabSprite(0,0,0,10,10) 
GrabSprite(1,0,0,100,100) 

Procedure UpdatePlayer() 
  ExamineKeyboard() 
  PlayerSpeedY = 0 
  PlayerSpeedX = 0 
  If KeyboardPushed(#PB_Key_Up) 
    PlayerSpeedY = -3 
  EndIf 
  If KeyboardPushed(#PB_Key_Down) 
    PlayerSpeedY = 3 
  EndIf 
  If KeyboardPushed(#PB_Key_Left) 
    PlayerSpeedX = -3 
  EndIf 
  If KeyboardPushed(#PB_Key_Right) 
    PlayerSpeedX = 3 
  EndIf 
  PlayerY + PlayerSpeedY 
  PlayerX + PlayerSpeedX 
EndProcedure 

Procedure AddDot(X,Y) 
  AddElement(Dot()) 
  Dot()\X = X 
  Dot()\Y = Y 
  Dot()\XS = 0 
  Dot()\YS = 0 
EndProcedure 

Procedure UpdateDots() 
  If CountList(Dot()) > 0 
    ResetList(Dot()) 
    While NextElement(Dot()) 
      ;StartDrawing(ScreenOutput()) 
      ;  Box(Dot()\X,Dot()\Y,10,10,RGB(255,255,255)) 
      ;StopDrawing() 
      DisplaySprite(0,Dot()\X,Dot()\Y) 
      Dot()\X + Dot()\XS 
      Dot()\Y + dot()\YS 
      If SpriteCollision(0,Dot()\X,Dot()\Y,1,PlayerX,PlayerY) 
        ShakeScreen(10,10) 
        If PlayerSpeedY < 0 
          Dot()\YS = -3 
          Dot()\XS = Random(2)-1 
        EndIf 
        If PlayerSpeedY > 0 
          Dot()\YS = 3 
          Dot()\XS = Random(2)-1 
        EndIf 
        If PlayerSpeedX < 0 
          Dot()\XS = -3 
          Dot()\YS = Random(2)-1 
        EndIf 
        If PlayerSpeedX > 0 
          Dot()\XS = 3 
          Dot()\YS = Random(2)-1 
        EndIf 
        If PlayerSpeedX = 0 And PlayerSpeedY = 0 
          If Dot()\Xs > 0 
            Dot()\Xs = -(Dot()\Xs ) 
          EndIf 
          If Dot()\Xs < 0 
            Dot()\Xs = -(Dot()\Xs ) 
          EndIf 
          If Dot()\Ys > 0 
            Dot()\Ys = -(Dot()\Ys ) 
          EndIf 
          If Dot()\Ys < 0 
            Dot()\Ys = -(Dot()\Ys ) 
          EndIf 
          
        EndIf 
      EndIf 
      If Dot()\X > 639 
        Dot()\XS = -(Dot()\XS) 
        Dot()\YS + Random(2)-1 
      EndIf 
      If Dot()\X < 1 
        Dot()\XS = -(Dot()\XS) 
        Dot()\YS + Random(2)-1 
      EndIf 
      If Dot()\Y < 1 
        Dot()\YS = -(Dot()\YS) 
        Dot()\XS + Random(2)-1 
      EndIf 
      If Dot()\Y > 479 
        Dot()\YS = -(Dot()\YS) 
        Dot()\XS + Random(2)-1 
      EndIf 
    Wend 
  EndIf 
EndProcedure 

Procedure DrawContent() 
  ClearScreen(RGB(0,0,0)) 
  UpdateDots() 
  DisplaySprite(1,PlayerX+ShakeX,PlayerY+shakeY) 
  FlipBuffers() 
EndProcedure 

For X = 1 To 2 
  For Y = 1 To 2 
    AddDot(X+100,Y+100) 
  Next Y 
Next X 
  
Repeat 
  
  ScreenReset() 
  UpdateShake() 
  UpdatePlayer() 
  DrawContent() 
  
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_Escape) 
    End 
  EndIf 
  If KeyboardReleased(#PB_Key_Space) 
    ShakeScreen(50,50) 
  EndIf 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
