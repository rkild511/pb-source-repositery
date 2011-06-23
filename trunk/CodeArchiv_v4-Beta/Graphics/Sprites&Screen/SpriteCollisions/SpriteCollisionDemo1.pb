; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8594&highlight=
; Author: Psychophanta (updated for PB4.00 by blbltheworm)
; Date: 02. December 2003
; OS: Windows
; Demo: Yes

; [release from 09-Jan-2004]

;-INITS:
#bitplanes=32:#RX=1024:#RY=768
If InitMouse()=0 Or InitSprite()=0 Or InitKeyboard()=0
  MessageRequester("Error","Can't open DirectX",0)
  End
EndIf
If OpenScreen(#RX,#RY,#bitplanes,"Balls")=0:End:EndIf
CreateSprite(0,128,128)
StartDrawing(SpriteOutput(0))
BackColor(RGB(0,0,0))
Circle(64,64,64,$1FD0DE)
StopDrawing()
CreateSprite(1,32,32)
StartDrawing(SpriteOutput(1))
BackColor(RGB(0,0,0))
Circle(16,16,16,$E0EA81)
StopDrawing()
TransparentSpriteColor(0,RGB(0,0,0))
TransparentSpriteColor(1,RGB(0,0,0))
CursorCentreX.w=SpriteWidth(0)/2:CursorCentreY.w=SpriteHeight(0)/2;<-centro de Cursor
BallCentreX.w=SpriteWidth(1)/2:BallCentreY.w=SpriteHeight(1)/2;<-centro de Ball
CursorMass.f=(SpriteWidth(0)+SpriteHeight(0))/2/16;<-Sea la masa de Cursor 1/16 la media entre sus magnitudes horizontal y vertical
BallMass.f=(SpriteWidth(1)+SpriteHeight(1))/2/16;<-Sea la masa de Ball 1/16 la media entre sus magnitudes horizontal y vertical

mouseX=400:mouseY=400
BallX.f=200:BallY.f=200;<-Posición inicial de Ball
CursorX.f=mouseX:CursorY.f=mouseY
MouseLocate(mouseX,mouseY);<-Posición inicial de Cursor

;-MAIN:
Repeat
  ExamineKeyboard()
  ExamineMouse()
  ClearScreen(RGB(0,0,0))
  ; Cursor position and vector:
  prevCursorX.f=CursorX.f:prevCursorY.f=CursorY.f
  CursorX.f=MouseX():CursorY.f=MouseY()
  dirCursorX.f=CursorX.f-prevCursorX.f:dirCursorY.f=CursorY.f-prevCursorY.f
  ; Ball-Screen limits:
  If BallX.f<=-BallCentreX:dirBallX.f=Abs(dirBallX.f):EndIf
  If BallX.f+BallCentreX>=#RX:dirBallX.f=-Abs(dirBallX.f):EndIf
  If BallY.f<=-BallCentreY:dirBallY.f=Abs(dirBallY.f):EndIf
  If BallY.f+BallCentreY>=#RY:dirBallY.f=-Abs(dirBallY.f):EndIf
  ; Ball-moving
  BallX.f+dirBallX.f:BallY.f+dirBallY.f
  DisplayTransparentSprite(1,BallX.f,BallY.f)
  DisplayTransparentSprite(0,CursorX.f,CursorY.f)
  ; Ball-Cursor collision
  If SpritePixelCollision(0,CursorX.f,CursorY.f,1,BallX.f,BallY.f);Si hay colisión:
    Gosub Shock
    MouseLocate(dirCursorX+CursorX,dirCursorY+CursorY)
  EndIf
  FlipBuffers()
Until KeyboardPushed(#PB_Key_All)
CloseScreen()
End

Shock:
  CursorKinetic.f=(Pow(dirCursorX.f,2)+Pow(dirCursorY.f,2))*CursorMass.f/2;<-(m/2)*v^2 de Cursor
  BallKinetic.f=(Pow(dirBallX.f,2)+Pow(dirBallY.f,2))*BallMass.f/2;<-(m/2)*v^2 de Ball
  DiffX.f=BallX.f+BallCentreX-CursorX.f-CursorCentreX:DiffY.f=BallY.f+BallCentreY-CursorY.f-CursorCentreY
  Modulo.f=Sqr(BallKinetic.f+CursorKinetic.f)/2
  VX.f=DiffX*Modulo/Sqr(DiffX*DiffX+DiffY*DiffY)
  VY.f=DiffY*Modulo/Sqr(DiffX*DiffX+DiffY*DiffY)
  dirBallX.f+VX.f:dirBallY.f+VY.f
  dirCursorX.f-VX.f:dirCursorY.f-VY.f
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
