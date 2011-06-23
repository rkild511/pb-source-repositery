; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8594&highlight=
; Author: Psychophanta (updated for PB4.00 by blbltheworm)
; Date: 09. January 2004
; OS: Windows
; Demo: Yes

; For real objects elastic collision emulation (billiards, pinball...) this formule
; is the one which must be used: 
; (I've had there in Amiga BlitzBasic2, and i've translated to PB) 


;This example shows the way to make a "perfect elastic collision" between 2 spheric (with masses 
;centre same as geometrical centre) objects in the emptyness (no rub). 
;Perfect elastic collision in a closed system (closed system means no external forces but only the 
;two ones of the both colliding objects forces) mean no lossing kinetic energy from the closed system. 
;It is ideal, because in the reality there are always a kinetic energy lossing in rub, deformation, rotation, 
;heat, etc. 

;NOTE: you can add external forces (like gravities between objects, or absolute to all system) 
;      playing with dirX and dirY parameters. 

;         2003-12-25 (Psychophanta) (translated and updated from Amiga BlitzBasic2) 

;-INITS: 
#bitplanes=32:#RX=1024:#RY=768
If InitMouse()=0 Or InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("Error","Can't open DirectX",0) 
  End 
EndIf 
If OpenScreen(#RX,#RY,#bitplanes,"Balls")=0:End:EndIf 
CreateSprite(0,100,100) 
StartDrawing(SpriteOutput(0)) 
BackColor(RGB(0,0,0)) 
For t.l=50 To 1 Step -1:Circle(50,50,t,RGB(220-t*2,220-t*2,220-t*2)):Next 
StopDrawing() 
CreateSprite(1,128,128) 
StartDrawing(SpriteOutput(1)) 
BackColor(RGB(0,0,0)) 
For t.l=64 To 1 Step -1:Circle(64,64,t,RGB(200-t*2,240-t*2,240-t*2)):Next 
StopDrawing() 
TransparentSpriteColor(0,RGB(0,0,0)) 
TransparentSpriteColor(1,RGB(0,0,0)) 
CursorCentreX.w=SpriteWidth(0)/2:CursorCentreY.w=SpriteHeight(0)/2;<-centro de Cursor 
BallCentreX.w=SpriteWidth(1)/2:BallCentreY.w=SpriteHeight(1)/2;<-centro de Ball 
CursorDimension.w=(SpriteWidth(0)+SpriteHeight(0))/2 
BallDimension.w=(SpriteWidth(1)+SpriteHeight(1))/2 
CursorMass.f=4*#PI*Pow(CursorDimension.w/2,3)/3;<-masa de Cursor 
BallMass.f=4*#PI*Pow(BallDimension.w/2,3)/3;<-masa de Ball 

mouseX=Random(#RX):mouseY=Random(#RY);<-Posición inicial de Cursor 
BallX.f=Random(#RX):BallY.f=Random(#RY);<-Posición inicial de Ball 
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
  dirBallY.f+0.1;<-----------------gravity force to down 
  If BallY.f+BallCentreY>=#RY:dirBallY.f=-Abs(dirBallY.f)+0.1:EndIf;<---------bounce 
  ; Ball-Cursor collision 
  If SpritePixelCollision(0,CursorX.f,CursorY.f,1,BallX.f,BallY.f);Si hay colisión: 
    Gosub Shock 
    ;Reposicionamos el cursor: 
    CursorX.f+dirCursorX.f:CursorY.f+dirCursorY.f 
    Gosub PreserveDistance 
    MouseLocate(CursorX.f,CursorY.f) 
  EndIf 
  DisplayTransparentSprite(1,BallX.f,BallY.f) 
  DisplayTransparentSprite(0,CursorX.f,CursorY.f) 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_All) 
CloseScreen() 
End 
;-SUBROUTINES: 
Shock: 
;*;al momento de chocar tenemos: 
  ;ENTRADAS: Vectores directores de los movimientos ((dirCursorX,dirCursorY) y (dirBallX,dirBallY)) 
  ;          Masas de Ball y de Cursor (CursorMass y BallMass) 
;*;Debemos calcular: 
  ;SALIDAS: Nuevo vector director de los movimientos de Ball y de Cursor ((dirCursorX,dirCursorY) y (dirBallX,dirBallY)). 
  
;*;COMPONENTES POR CONTACTO: 
  ;Es un vector que está en la línea de choque (recta normal a la recta tangente, en el punto de contacto, sobre la superficie contra la que se choca). 
  ;Obtenemos su sentido y dirección, que viene marcado por la diferencia de coordenadas de cada objeto al momento de chocar: 
  DiffX.f=BallX.f+BallCentreX-CursorX.f-CursorCentreX:DiffY.f=BallY.f+BallCentreY-CursorY.f-CursorCentreY;<-Vector de contacto Cursor->Ball 
  ;su módulo depende de la componente de la cantidad de movimiento con respecto a la linea de choque (DiffX,DiffY) (proyección del vector (dirX,dirY) sobre el (DiffX,DiffY)): 
  K.f=(DiffX.f*dirCursorX.f+DiffY.f*dirCursorY.f)/(DiffX.f*DiffX.f+DiffY.f*DiffY.f);<-constante de proyección del actual vector del movimiento de Cursor sobre la línea de choque 
  dirCursorXK.f=K.f*DiffX.f:dirCursorYK.f=K.f*DiffY.f;<-vector componente en línea de choque de la velocidad de Cursor. 

  K.f=(-DiffX.f*dirBallX.f-DiffY.f*dirBallY.f)/(-DiffX.f*-DiffX.f+-DiffY.f*-DiffY.f);<-constante de proyección del actual vector del movimiento de Ball sobre la línea de choque. 
  dirBallXK.f=K.f*-DiffX.f:dirBallYK.f=K.f*-DiffY.f;<-vector componente en línea de choque de la velocidad de Ball. 

  CX.f=(2*BallMass.f*dirBallXK.f+CursorMass.f*dirCursorXK.f-BallMass.f*dirCursorXK.f)/(CursorMass.f+BallMass.f) 
  CY.f=(2*BallMass.f*dirBallYK.f+CursorMass.f*dirCursorYK.f-BallMass.f*dirCursorYK.f)/(CursorMass.f+BallMass.f) 
  BX.f=(2*CursorMass.f*dirCursorXK.f+BallMass.f*dirBallXK.f-CursorMass.f*dirBallXK.f)/(CursorMass.f+BallMass.f) 
  BY.f=(2*CursorMass.f*dirCursorYK.f+BallMass.f*dirBallYK.f-CursorMass.f*dirBallYK.f)/(CursorMass.f+BallMass.f) 
  
;*;Ahora obtener el vector resultante para el movimiento de Ball: 
  ;Se mantiene la componente perpendicular a la linea de choque del movimiento de Ball (componente que no afecta al choque): 
  dirBallX.f-dirBallXK.f+BX.f:dirBallY.f-dirBallYK.f+BY.f;<-se suman, obteniendo el vector buscado. 

;*;Finalmente obtener el vector director resultante para el movimiento de Cursor: 
  ;Se mantiene la componente perpendicular a la linea de choque del movimiento de Cursor (componente que no afecta al choque): 
  dirCursorX.f-dirCursorXK.f+CX.f:dirCursorY.f-dirCursorYK.f+CY.f;<-se suman, obteniendo el vector buscado. 
Return 
PreserveDistance: 
  Distance.f=Sqr(DiffX.f*DiffX.f+DiffY.f*DiffY.f) 
  Clip.f=(CursorDimension/2+BallDimension/2)-Distance.f 
  If Clip.f>0:Clip.f/2 
    BallX.f+DiffX.f*Clip.f/Distance.f 
    BallY.f+DiffY.f*Clip.f/Distance.f 
    CursorX.f-DiffX.f*Clip.f/Distance.f 
    CursorY.f-DiffY.f*Clip.f/Distance.f 
  EndIf 
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
