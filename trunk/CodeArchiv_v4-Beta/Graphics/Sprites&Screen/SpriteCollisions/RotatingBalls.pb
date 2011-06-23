; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9228&highlight=
; Author: Psychophanta
; Date: 20. January 2004
; OS: Windows
; Demo: Yes

#bitplanes=32:#RX=1024:#RY=768
If InitMouse()=0 Or InitSprite()=0 Or InitKeyboard()=0 Or InitSprite3D()=0
  MessageRequester("Error","Can't open DirectX",0)
  End
EndIf
If OpenScreen(#RX,#RY,#bitplanes,"Balls")=0:End:EndIf
CreateSprite(0,64,64,#PB_Sprite_Texture)
StartDrawing(SpriteOutput(0))
BackColor(RGB(0,0,0))
For t.l=32 To 1 Step -1:Circle(32,32,t,RGB(220-t*2,220-t*2,220-t*2)):Next
Line(32,0,0,64,$0):Line(0,32,64,0,$0)
FillArea(33,31,0,$99AAAA):FillArea(31,33,0,$AAAAAA)
StopDrawing()
CreateSprite3D(0,0):ZoomSprite3D(0,100,100)
CreateSprite(1,128,128,#PB_Sprite_Texture)
StartDrawing(SpriteOutput(1))
BackColor(RGB(0,0,0))
For t.l=64 To 1 Step -1:Circle(64,64,t,RGB(200-t*2,240-t*2,240-t*2)):Next
Line(64,0,0,128,$0):Line(0,64,128,0,$0)
FillArea(65,63,0,$99BB99):FillArea(63,65,0,$99AAAA)
StopDrawing()
CreateSprite3D(1,1):ZoomSprite3D(1,128,128)

CursorCentreX.w=SpriteWidth(0)/2:CursorCentreY.w=SpriteHeight(0)/2;<-centro de Cursor
BallCentreX.w=SpriteWidth(1)/2:BallCentreY.w=SpriteHeight(1)/2;<-centro de Ball
CursorDimension.w=(SpriteWidth(0)+SpriteHeight(0))/2
BallDimension.w=(SpriteWidth(1)+SpriteHeight(1))/2
CursorMass.f=4*#PI*Pow(CursorDimension.w/2,3)/3;<-masa de Cursor
BallMass.f=4*#PI*Pow(BallDimension.w/2,3)/3;<-masa de Ball

mouseX=Random(#RX-50):mouseY=Random(#RY-50);<-Posición inicial de Cursor
BallX.f=Random(#RX-50):BallY.f=Random(#RY-50);<-Posición inicial de Ball
CursorX.f=mouseX:CursorY.f=mouseY
MouseLocate(mouseX,mouseY);<-Posicionamiento del Cursor
dirCursorX.f=Random(600000)/100000+1:dirCursorY.f=Random(600000)/100000+1
dirBallX.f=Random(600000)/100000+1:dirBallY.f=Random(600000)/100000+1

;-MAIN:
Repeat
  ExamineKeyboard()
  ExamineMouse()
  ClearScreen(RGB(0,0,0))
  ; Cursor position and vector:
  prevCursorX.f=CursorX.f:prevCursorY.f=CursorY.f;<-Coordenadas anteriores de Cursor
  CursorX.f=MouseX():CursorY.f=MouseY();<-Coordenadas actuales de Cursor
  dirCursorX.f=CursorX.f-prevCursorX.f:dirCursorY.f=CursorY.f-prevCursorY.f;<-vector director del movimiento de Cursor
  ; Ball-moving
  BallX.f+dirBallX.f:BallY.f+dirBallY.f;<-Coordenadas actuales de Ball (se suma a las anteriores el vector director)
  ; Ball-Screen limits:
  If BallX.f<=-BallCentreX:dirBallX.f=Abs(dirBallX.f):EndIf
  If BallX.f+BallCentreX>=#RX:dirBallX.f=-Abs(dirBallX.f):EndIf
  If BallY.f<=-BallCentreY:dirBallY.f=Abs(dirBallY.f):EndIf
  dirBallY.f+0.1
  If BallY.f+BallCentreY>=#RY:dirBallY.f=-Abs(dirBallY.f)+0.1
  EndIf
  ; Ball-Cursor collision
  If SpritePixelCollision(0,CursorX.f,CursorY.f,1,BallX.f,BallY.f);Si hay colisión:
    Gosub Shock
    ;Reposicionamos el cursor:
    CursorX.f+dirCursorX.f:CursorY.f+dirCursorY.f
    Gosub PreserveDistance
    MouseLocate(CursorX.f,CursorY.f)
  EndIf
  ; Rotation:
  Ballangle.f+Ballanglefactor.f:RotateSprite3D(1,Ballangle.f,0)
  Cursorangle.f+Cursoranglefactor.f:RotateSprite3D(0,Cursorangle.f,0)
  ; Displaying:
  Start3D()
  DisplaySprite3D(0,CursorX.f,CursorY.f,255)
  DisplaySprite3D(1,BallX.f,BallY.f,255)
  Stop3D()
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
CloseScreen()
End
;-SUBROUTINES:
Shock:
DiffX.f=BallX.f+BallCentreX-CursorX.f-CursorCentreX:DiffY.f=BallY.f+BallCentreY-CursorY.f-CursorCentreY;<-Vector de contacto Cursor->Ball
K.f=(DiffX.f*dirCursorX.f+DiffY.f*dirCursorY.f)/(DiffX.f*DiffX.f+DiffY.f*DiffY.f);<-constante de proyección del actual vector del movimiento de Cursor sobre la línea de choque
dirCursorXK.f=K.f*DiffX.f:dirCursorYK.f=K.f*DiffY.f;<-vector componente en línea de choque de la velocidad de Cursor.
K.f=(-DiffX.f*dirBallX.f-DiffY.f*dirBallY.f)/(-DiffX.f*-DiffX.f+-DiffY.f*-DiffY.f);<-constante de proyección del actual vector del movimiento de Ball sobre la línea de choque.
dirBallXK.f=K.f*-DiffX.f:dirBallYK.f=K.f*-DiffY.f;<-vector componente en línea de choque de la velocidad de Ball.
CX.f=(2*BallMass.f*dirBallXK.f+CursorMass.f*dirCursorXK.f-BallMass.f*dirCursorXK.f)/(CursorMass.f+BallMass.f)
CY.f=(2*BallMass.f*dirBallYK.f+CursorMass.f*dirCursorYK.f-BallMass.f*dirCursorYK.f)/(CursorMass.f+BallMass.f)
BX.f=(2*CursorMass.f*dirCursorXK.f+BallMass.f*dirBallXK.f-CursorMass.f*dirBallXK.f)/(CursorMass.f+BallMass.f)
BY.f=(2*CursorMass.f*dirCursorYK.f+BallMass.f*dirBallYK.f-CursorMass.f*dirBallYK.f)/(CursorMass.f+BallMass.f)
Cursoranglefactor.f=-((dirBallX.f-dirCursorX.f)*DiffY.f-(dirBallY.f-dirCursorY.f)*DiffX.f)/(CursorDimension+BallDimension)
Ballanglefactor.f=-((dirCursorX.f-dirBallX.f)*-DiffY.f-(dirCursorY.f-dirBallY.f)*-DiffX.f)/(CursorDimension+BallDimension)
dirBallX.f-dirBallXK.f+BX.f:dirBallY.f-dirBallYK.f+BY.f;<-se suman, obteniendo el vector buscado.
dirCursorX.f-dirCursorXK.f+CX.f:dirCursorY.f-dirCursorYK.f+CY.f;<-se suman, obteniendo el vector buscado.
Return
PreserveDistance:
Distance.f=Sqr(DiffX.f*DiffX.f+DiffY.f*DiffY.f);<-Distancia entre los objetos en el instante del contacto.
Clip.f=(CursorDimension/2+BallDimension/2)-Distance.f
If Clip.f>0:Clip.f/2
  BallX.f+DiffX.f*Clip.f/Distance.f
  BallY.f+DiffY.f*Clip.f/Distance.f
  CursorX.f-DiffX.f*Clip.f/Distance.f
  CursorY.f-DiffY.f*Clip.f/Distance.f
EndIf
Return

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger