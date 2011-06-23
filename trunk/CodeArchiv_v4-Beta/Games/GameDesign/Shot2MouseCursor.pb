; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8801&highlight=
; Author: DriakTravo (updated for PB4.00 by blbltheworm)
; Date: 20. December 2003
; OS: Windows
; Demo: Yes


; Press left mousebutton to shot into direction of mouse-cursor, right mousebutton to exit...
; Linke Maustaste drücken, um in die Richtung des Mauscursors zu schiessen, rechte Maustaste zum Beenden...

InitSprite() 
InitMouse() 

OpenScreen(800,600,32,"") 

Structure bullet 
  X.f 
  Y.f 
  XS.f 
  YS.f 
EndStructure 

Global NewList bullets.bullet() 

Procedure Addbullet(X.f,Y.f,XS.f,YS.f) 
  AddElement(bullets()) 
  bullets()\X = X 
  bullets()\Y = Y 
  bullets()\XS = XS 
  bullets()\YS = YS 
EndProcedure 

Global mouseangle, BulletSpeed 
BulletSpeed = 20 

Procedure.f GetMouseAngle() 
  ExamineMouse() 
  x1 = 400 
  y1 = 300 
  x2 = MouseX() 
  y2 = MouseY() 
  a.f = x2-x1 
  b.f = y2-y1 
  c.f = Sqr(a*a+b*b) 
  winkel.f = ACos(a/c)*57.29577 
  If y1 < y2 : winkel=360-winkel : EndIf 
  ProcedureReturn winkel+90 
EndProcedure 

Repeat 
  ClearScreen(RGB(0,0,0)) 
  ExamineMouse() 
  
  If CountList(bullets()) > 1 
    ResetList(bullets()) 
    While NextElement(bullets()) 
      StartDrawing(ScreenOutput()) 
        Line(bullets()\X,bullets()\Y,bullets()\XS,bullets()\YS,RGB(Random(150),Random(255),0)) 
      StopDrawing() 
      bullets()\X + bullets()\XS 
      bullets()\Y + bullets()\YS 
      If bullets()\X > 800 + bullets()\XS 
        DeleteElement(bullets()) 
      ElseIf bullets()\X < 0 - bullets()\XS 
        DeleteElement(bullets()) 
      ElseIf bullets()\Y > 600 + bullets()\YS 
        DeleteElement(bullets()) 
      ElseIf bullets()\Y < 0 - bullets()\YS 
        DeleteElement(bullets()) 
      EndIf 
    Wend 
  EndIf 
  
  StartDrawing(ScreenOutput()) 
    Circle(MouseX(),MouseY(),2,RGB(0,255,255)) 
  StopDrawing() 
  
  If MouseButton(2) = 1 
    End 
  ElseIf MouseButton(1) = 1 
    Angle.f = GetMouseAngle() 
    SpeedX.f = Sin(Angle*(3.14/180))*BulletSpeed 
    SpeedY.f = Cos(Angle*(3.14/180))*Bulletspeed 
    dudecounter + 1 
    If dudecounter = 10 
      dudecounter = 0 
      Addbullet(400,300,SpeedX,SpeedY) 
      Angle.f = GetMouseAngle()+10 
      SpeedX.f = Sin(Angle*(3.14/180))*Bulletspeed 
      SpeedY.f = Cos(Angle*(3.14/180))*Bulletspeed 
      Addbullet(400,300,SpeedX,SpeedY) 
      Angle.f = GetMouseAngle()+350 
      SpeedX.f = Sin(Angle*(3.14/180))*Bulletspeed 
      SpeedY.f = Cos(Angle*(3.14/180))*Bulletspeed 
      Addbullet(400,300,SpeedX,SpeedY) 
      Beep_(500,1) 
    EndIf 
  EndIf 
  
  FlipBuffers() 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
