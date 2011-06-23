; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8594&highlight=
; Author: Psychophanta (updated for PB4.00 by blbltheworm)
; Date: 02. December 2003
; OS: Windows
; Demo: Yes

; [release from 09-Jan-2004]

; In this one move mouse to use the small ball to hit the big one, And if you
; left kept still the mouse, you will see how 2 only objects in a small space,
; generate a virtual chaotic world (You can left it during hours and can't watch
; a repeated sequence).
; Should be nice as screensaver.
; Note that when collide, a sprite mount over the other to virtually absorb kinetics
; and maintain on screen always the same movement amount (even in this demo that's
; not made as in natural world!)

;-INITS:
#bitplanes=32:#RX=1024:#RY=768
If InitMouse()=0 Or InitSprite()=0 Or InitKeyboard()=0
  MessageRequester("Error","Can't open DirectX",0)
  End
EndIf
If OpenScreen(#RX,#RY,#bitplanes,"Balls")=0:End:EndIf
CreateSprite(0,32,32)
StartDrawing(SpriteOutput(0))
BackColor(RGB(0,0,0))
Circle(16,16,16,$1FD0CE)
StopDrawing()
CreateSprite(1,128,128)
StartDrawing(SpriteOutput(1))
BackColor(RGB(0,0,0))
Circle(64,64,64,$C0EA51)
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
  prevmouseX=mouseX:prevmouseY=mouseY
  mouseX=MouseX():mouseY=MouseY()
  If mouseX<>prevmouseX Or mouseY<>prevmouseY
    dirCursorX.f=mouseX-prevmouseX:dirCursorY.f=mouseY-prevmouseY;<-vector director del movimiento de Cursor
    mouseX=CursorX.f+dirCursorX.f:mouseY=CursorY.f+dirCursorY.f
    MouseLocate(mouseX,mouseY)
  EndIf
  CursorX.f+dirCursorX.f:CursorY.f+dirCursorY.f
  If CursorX.f<=-CursorCentreX:dirCursorX.f=Abs(dirCursorX.f):EndIf
  If CursorX.f+CursorCentreX>=#RX:dirCursorX.f=-Abs(dirCursorX.f):EndIf
  If CursorY.f<=-CursorCentreY:dirCursorY.f=Abs(dirCursorY.f):EndIf
  If CursorY.f+CursorCentreY>=#RY:dirCursorY.f=-Abs(dirCursorY.f):EndIf
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
  EndIf
  FlipBuffers()
Until KeyboardPushed(#PB_Key_All)
CloseScreen()
End

Shock:
  CursorKinetic.f=(Pow(dirCursorX,2)+Pow(dirCursorY,2))*CursorMass/2;<-(m/2)*v^2 de Cursor
  BallKinetic.f=(Pow(dirBallX,2)+Pow(dirBallY,2))*BallMass/2;<-(m/2)*v^2 de Ball
  DiffX.f=BallX.f+BallCentreX-CursorX.f-CursorCentreX:DiffY.f=BallY.f+BallCentreY-CursorY.f-CursorCentreY;<-rectángulo que forman las posiciones de los colisionantes
  Modulo.f=CursorKinetic.f/Sqr(Pow(CursorKinetic.f,2)+Pow(BallKinetic.f,2))
  Gosub get
  dirBallX.f+VX.f:dirBallY.f+VY.f
  Modulo.f=BallKinetic.f/Sqr(Pow(CursorKinetic.f,2)+Pow(BallKinetic.f,2))
  Gosub get
  dirCursorX.f-VX.f:dirCursorY.f-VY.f
Return

get:
  VX.f=DiffX*Modulo/Sqr(DiffX*DiffX+DiffY*DiffY)
  VY.f=DiffY*Modulo/Sqr(DiffX*DiffX+DiffY*DiffY)
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
