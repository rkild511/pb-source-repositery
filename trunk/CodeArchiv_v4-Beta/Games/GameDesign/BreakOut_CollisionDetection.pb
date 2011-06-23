; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2699&highlight=
; Author: honk (updated for PB4.00 by blbltheworm)
; Date: 31. October 2003
; OS: Windows
; Demo: Yes

Global Dim diff_Kollision.w(3)
Global BallX.w : BallX = 10
Global BallY.w : BallY = 10
Global BallRateY.w : BallRateY = 4  ; Ball-Geschwindigkeit in Y-Richtung
Global BallRateX.w : BallRateX = 6  ; Ball-Geschwindigkeit in X-Richtung
Global BallDirY.w : BallDirY = -1   ; Y-Richtung
Global BallDirX.w : BallDirX = 1    ; X-Richtung
Global BallRadius.w : BallRadius = 10 ; Ball-Radius   ist in Wirklichkeit ein Rechteck ;)
Global BlockXL.w  ; Linke X-Kante des Blocks
Global BlockXR.w  ; Rechte X-Kante des Blocks
Global BlockYT.w  ; Obere Y-Kante des Blocks
Global BlockYB.w  ; Untere Y-Kante des Blocks
Procedure Ball_Block_Kollision()
  Shared BlockXL , BlockXR , BlockYT , BlockYB
  Shared BallX , BallY , BallDirX , BallDirY
  If BallX >= BlockXL-BallRadius And BallX <= BlockXR+BallRadius And BallY >= BlockYT-BallRadius And BallY <= BlockYB+BallRadius
    diff_XL=BallX-BlockXL : diff_XR=BlockXR-BallX : diff_YT=BallY-BlockYT : diff_YB=BlockYB-BallY
    diff_Kollision(0)=diff_XL : diff_Kollision(1)=diff_XR : diff_Kollision(2)=diff_YT : diff_Kollision(3)=diff_YB
    SortArray(diff_Kollision(),0)
    If diff_XL = diff_Kollision(0)
      BallDirX = -1
    ElseIf diff_XR = diff_Kollision(0)
      BallDirX = 1
    ElseIf diff_YT = diff_Kollision(0)
      BallDirY = -1
    ElseIf diff_YB = diff_Kollision(0)
      BallDirY = 1
    EndIf
  EndIf
EndProcedure
InitSprite() : InitKeyboard() : InitMouse() : OpenScreen(640,480,16,"Ball") : SetFrameRate(60)
CreateSprite(1,20,20,#PB_Sprite_Texture) : TransparentSpriteColor(1,RGB(0,0,0))
StartDrawing(SpriteOutput(1))
Box(0,0,20,20,RGB(0,0,0))
Circle(10,10,10,RGB(255,0,0))
StopDrawing()
CreateSprite(2,40,40,0)
StartDrawing(SpriteOutput(2))
Box(0,0,40,40,RGB(0,0,0))
StopDrawing()
MouseLocate(300,300)
Repeat
  ExamineKeyboard()
  ExamineMouse()
  ; Block positionieren
  BlockXL = MouseX()-20
  BlockXR = MouseX()+20
  BlockYT = MouseY()-20
  BlockYB = MouseY()+20
  ; Ball-Bewegung
  BallX = Int(BallX + BallRateX * BallDirX)
  BallY = Int(BallY + BallRateY * BallDirY)
  ; Ball-Screen Kollision
  If BallY <= 0
    BallDirY = 1
  EndIf
  If BallY >= 480
    BallDirY = -1
  EndIf
  If BallX <= 0
    BallDirX = 1
  EndIf
  If BallX >= 640
    BallDirX = -1
  EndIf
  ; Ball-Block Kollision
  Ball_Block_Kollision()
  
  ClearScreen(RGB(100,100,100))
  DisplayTransparentSprite(1,BallX-BallRadius,BallY-BallRadius)
  DisplaySprite(2,BlockXL,BlockYT)
  FlipBuffers()
Until KeyboardPushed(1)
CloseScreen()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
