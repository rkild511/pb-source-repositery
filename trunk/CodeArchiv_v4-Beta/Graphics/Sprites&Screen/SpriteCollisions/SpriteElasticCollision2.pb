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
;   NOTE:  decrease #lines constant and/or number of objects if your computer is too slow. 
;   NOTE2: you can add external forces (like gravities between objects, or absolute to all) 
;          playing with dirX and dirY parameters. 

;         2003-12-25 (Psychophanta) (translated and updated from Amiga BlitzBasic2) 


;-INITS: 
#bitplanes=32:#RX=1024:#RY=768 
#BallsDiameter=76 
#lines=4 
If InitMouse()=0 Or InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("Error","Can't open DirectX",0) 
  End 
EndIf 

Structure balls 
  sprite.w;<-#Sprite 
  x.f:y.f;<-coordenadas instantáneas 
  dirX.f:dirY.f;<-Vector del movimiento (velocidad) 
  CentreX.w:CentreY.w;<-centro geométrico 
  Dimension.w 
  Mass.f;<-masa 
  Kinetic.f;<-energía cinética 
EndStructure 

Global NewList Capsule.balls()
Cursor.balls 

;-FUNCTIONS: 
Procedure Shock(*a.balls) 
;*;al momento de chocar tenemos: 
  ;ENTRADAS: Vectores directores de los movimientos ((dirX,dirY) para Objeto0 y (dirX,dirY) para Objeto1) 
  ;          Masas de Objeto1 y de Objeto0 (Objeto0 Mass y Objeto1 Mass) 
;*;Debemos calcular: 
  ;SALIDAS: Nuevo vector director de los movimientos de Objeto1 y de Objeto0 ((dirX,dirY) de Objeto0 y (dirX,dirY) de Objeto1). 

;*;COMPONENTES POR CONTACTO: 
  ;Es un vector que está en la línea de choque (recta normal a la recta tangente, en el punto de contacto, sobre la superficie contra la que se choca). 
  ;Obtenemos su sentido y dirección, que viene marcado por la diferencia de coordenadas de cada objeto al momento de chocar: 
  DiffX.f=Capsule()\x+Capsule()\CentreX-*a\x-*a\CentreX:DiffY.f=Capsule()\y+Capsule()\CentreY-*a\y-*a\CentreY;<-Vector de distancia 
  ;su módulo depende de la componente de la velocidad con respecto a la linea de choque (DiffX,DiffY) (proyección del vector (dirX,dirY) sobre el (DiffX,DiffY)): 
  K.f=(DiffX.f**a\dirX+DiffY.f**a\dirY)/(DiffX.f*DiffX.f+DiffY.f*DiffY.f);<-constante de proyección del actual vector del movimiento de Cursor sobre la línea de choque. 
  dirCursorXK.f=K.f*DiffX.f:dirCursorYK.f=K.f*DiffY.f;<-vector componente en línea de choque de la velocidad de Cursor. 
  
  K.f=(-DiffX.f*Capsule()\dirX-DiffY.f*Capsule()\dirY)/(-DiffX.f*-DiffX.f+-DiffY.f*-DiffY.f);<-constante de proyección del actual vector del movimiento de Ball sobre la línea de choque. 
  dirBallXK.f=K.f*-DiffX.f:dirBallYK.f=K.f*-DiffY.f;<-vector componente en línea de choque de la velocidad de Ball. 
  
  CX.f=(2*Capsule()\Mass*dirBallXK.f+*a\Mass*dirCursorXK.f-Capsule()\Mass*dirCursorXK.f)/(*a\Mass+Capsule()\Mass) 
  CY.f=(2*Capsule()\Mass*dirBallYK.f+*a\Mass*dirCursorYK.f-Capsule()\Mass*dirCursorYK.f)/(*a\Mass+Capsule()\Mass) 
  BX.f=(2**a\Mass*dirCursorXK.f+Capsule()\Mass*dirBallXK.f-*a\Mass*dirBallXK.f)/(*a\Mass+Capsule()\Mass) 
  BY.f=(2**a\Mass*dirCursorYK.f+Capsule()\Mass*dirBallYK.f-*a\Mass*dirBallYK.f)/(*a\Mass+Capsule()\Mass) 
  
;*;Ahora obtener el vector resultante para el movimiento de Ball: 
  ;Se mantiene la componente perpendicular a la linea de choque del movimiento de Ball (componente que no afecta al choque): 
  Capsule()\dirX-dirBallXK.f+BX.f:Capsule()\dirY-dirBallYK.f+BY.f;<-se suman, obteniendo el vector buscado. 
  
;*;Finalmente obtener el vector director resultante para el movimiento de Cursor: 
  ;Se mantiene la componente perpendicular a la linea de choque del movimiento de Cursor (componente que no afecta al choque): 
  *a\dirX-dirCursorXK.f+CX.f:*a\dirY-dirCursorYK.f+CY.f;<-se suman, obteniendo el vector buscado. 
  
;*;Preservar distancia: 
  Distance.f=Sqr(DiffX*DiffX+DiffY*DiffY) 
  Clip.f=(*a\Dimension/2+Capsule()\Dimension/2)-Distance.f 
  If Clip.f>0:Clip.f/2 
    Capsule()\x+DiffX.f*Clip.f/Distance.f 
    Capsule()\y+DiffY.f*Clip.f/Distance.f 
    *a\x-DiffX.f*Clip.f/Distance.f 
    *a\y-DiffY.f*Clip.f/Distance.f 
  EndIf 
EndProcedure 

Procedure CreateBallSprite(c.l,size.l,color.l) 
  CreateSprite(c,size,size) 
  StartDrawing(SpriteOutput(c)) 
  BackColor(RGB(0,0,0)):R.w=color&$FF:G.w=color>>8&$FF:b.w=color>>16&$FF 
  For t.l=size/2 To 1 Step -1 
    R+160/size:G+160/size:b+160/size:If R>255:R=255:EndIf:If G>255:G=255:EndIf:If b>255:b=255:EndIf 
    Circle(size/2,size/2,t,RGB(R,G,b)) 
  Next 
  StopDrawing() 
EndProcedure 

;-MOREINITS: 
If OpenScreen(#RX,#RY,#bitplanes,"Balls")=0:End:EndIf 
Cursor\sprite=0 
CreateBallSprite(Cursor\sprite,64,$009EAE) 
Cursor\CentreX=SpriteWidth(Cursor\sprite)/2:Cursor\CentreY=SpriteHeight(Cursor\sprite)/2;<-centro de Objeto0 
Cursor\Dimension=(SpriteWidth(Cursor\sprite)+SpriteHeight(Cursor\sprite))/2 
Cursor\Mass=4*#PI*Pow(Cursor\Dimension/2,3)/3;<-masa de Objeto0 

t.w=1:G.b=1 
BallsPerLine.w=#RX/#BallsDiameter-1;<-Número de Objeto1 por lineas 
While G<=#lines 
  While t<=G*BallsPerLine.w 
    AddElement(Capsule()) 
    *prev.balls=@Capsule() 
    Capsule()\sprite=t 
    CreateBallSprite(Capsule()\sprite,#BallsDiameter,$6DAE00) 
    Capsule()\CentreX=SpriteWidth(Capsule()\sprite)/2:Capsule()\CentreY=SpriteHeight(Capsule()\sprite)/2;<-centro de Objeto1 
    Capsule()\Dimension=(SpriteWidth(Capsule()\sprite)+SpriteHeight(Capsule()\sprite))/2 
    Capsule()\Mass=4*#PI*Pow(Capsule()\Dimension/2,3)/3;<-masa de Objeto1 
    If t%BallsPerLine.w=1:Capsule()\x=Capsule()\Dimension/2:Capsule()\y=G*50;<-Posición inicial de este Objeto1 
    Else:Capsule()\x=*prev\x+*prev\Dimension/2+Capsule()\Dimension/2:Capsule()\y=G*50;<-Posición inicial de este Objeto1 
    EndIf 
    t.w+1 
  Wend 
  G.b+1 
Wend 
mouseX=#RX/2:mouseY=#RY*4/5 
Cursor\x=mouseX:Cursor\y=mouseY 
MouseLocate(mouseX,mouseY);<-Posición inicial de Objeto0 
Cursor\dirX=Random(1000000)/100000-5:Cursor\dirY=-Random(4000000)/1000000+1 

;-MAIN: 
Repeat 
  ExamineKeyboard() 
  ExamineMouse() 
  ClearScreen(RGB(0,0,0)) 
  ; Cursor position and vector: 
  prevmouseX=mouseX:prevmouseY=mouseY;<-previous mouse coordinates 
  mouseX=MouseX():mouseY=MouseY();<-current mouse coordinates 
  If mouseX<>prevmouseX Or mouseY<>prevmouseY;If mouse is moved: 
    Cursor\dirX=mouseX-prevmouseX:Cursor\dirY=mouseY-prevmouseY;<-vector director del movimiento de Cursor 
    mouseX=Cursor\x+Cursor\dirX:mouseY=Cursor\y+Cursor\dirY;<-actualizamos las coordenadas del mouse 
    MouseLocate(mouseX,mouseY);<-y reposicionamos el mouse en las actuales coordenadas de Cursor 
  EndIf 
  Cursor\x+Cursor\dirX:Cursor\y+Cursor\dirY;<-que son estas (se suma el vector director a las anteriores) 
  ; Cursor-Screen limits: 
  If Cursor\x<=-Cursor\CentreX:Cursor\dirX=Abs(Cursor\dirX):EndIf 
  If Cursor\x+Cursor\CentreX>=#RX:Cursor\dirX=-Abs(Cursor\dirX):EndIf 
  If Cursor\y<=-Cursor\CentreY:Cursor\dirY=Abs(Cursor\dirY):EndIf 
  ;Cursor\dirY+0.1;<-------------Gravity to down 
  If Cursor\y+Cursor\CentreY>=#RY:Cursor\dirY=-Abs(Cursor\dirY);+0.1;<----bound 
  EndIf 
  ForEach Capsule() 
  ; Ball-Screen limits: 
    If Capsule()\x<=-Capsule()\CentreX:Capsule()\dirX=Abs(Capsule()\dirX):EndIf 
    If Capsule()\x+Capsule()\CentreX>=#RX:Capsule()\dirX=-Abs(Capsule()\dirX):EndIf 
    If Capsule()\y<=-Capsule()\CentreY:Capsule()\dirY=Abs(Capsule()\dirY):EndIf 
    ;Capsule()\dirY+0.1;<-------------Gravity to down 
    If Capsule()\y+Capsule()\CentreY>=#RY:Capsule()\dirY=-Abs(Capsule()\dirY);+0.1;<----bound 
    EndIf 
  ; Ball-moving: 
    Capsule()\x+Capsule()\dirX:Capsule()\y+Capsule()\dirY;<-Coordenadas actuales de Ball (se suma a las anteriores el vector director) 

  ; collision: 
    *i.balls=@Capsule() 
    While NextElement(Capsule()) 
      If SpritePixelCollision(*i\sprite,*i\x,*i\y,Capsule()\sprite,Capsule()\x,Capsule()\y);Si hay colisión: 
        Shock(*i) 
      EndIf 
    Wend 
    ChangeCurrentElement(Capsule(),*i) 
    If SpritePixelCollision(Cursor\sprite,Cursor\x,Cursor\y,Capsule()\sprite,Capsule()\x,Capsule()\y);Si hay colisión: 
      Shock(@Cursor) 
    EndIf 
    DisplayTransparentSprite(Capsule()\sprite,Capsule()\x,Capsule()\y) 
  Next 
  DisplayTransparentSprite(Cursor\sprite,Cursor\x,Cursor\y) 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_All) 
CloseScreen() 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
