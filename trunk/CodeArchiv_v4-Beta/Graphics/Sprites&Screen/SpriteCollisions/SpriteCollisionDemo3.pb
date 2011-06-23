; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8594&highlight=
; Author: Psychophanta (updated for PB4.00 by blbltheworm)
; Date: 09. December 2003
; OS: Windows
; Demo: Yes

; [release of 27-Dec-2003]

;-INITS: 
#bitplanes=32:#RX=1024:#RY=768 
#BallsType1=63;<-Objects per line 
#lines=1 
If InitMouse()=0 Or InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("Error","Can't open DirectX",0) 
  End 
EndIf 
Structure balls 
  sprite.w;<-#Sprite 
  x.f:y.f;<-coordenadas instantáneas 
  dirX.f:dirY.f;<-Vector director 
  CentreX.w:CentreY.w;<-centro geométrico 
  Mass.f;<-masa 
  Kinetic.f;<-energía cinética 
EndStructure 
Global NewList Capsule.balls():Cursor.balls 

;-FUNCTIONS: 
Procedure Shock(*a.balls) 
  DiffX.f=Capsule()\x+Capsule()\CentreX-*a\x-*a\CentreX:DiffY.f=Capsule()\y+Capsule()\CentreY-*a\y-*a\CentreY;<-rectángulo que forman las posiciones de los colisionantes 
  ;There are several possible collision-consequence vector modules: 
  ;ModuloObjeto1.f=Sqr(1+Pow(*a\Mass/Capsule()\Mass,2)) 
  ;ModuloObjeto0.f=Sqr(1+Pow(Capsule()\Mass/*a\Mass,2)) 
  ModuloObjeto1.f=*a\Mass/(*a\Mass+Capsule()\Mass) 
  ModuloObjeto0.f=Capsule()\Mass/(*a\Mass+Capsule()\Mass) 
  ;*a\Kinetic=(Pow(*a\dirX,2)+Pow(*a\dirY,2))**a\Mass/2;<-(m/2)*v^2 
  ;Capsule()\Kinetic=(Pow(Capsule()\dirX,2)+Pow(Capsule()\dirY,2))*Capsule()\Mass/2;<-(m/2)*v^2 
  ;ModuloObjeto1.f=*a\Kinetic/(*a\Kinetic+Capsule()\Kinetic) 
  ;ModuloObjeto0.f=Capsule()\Kinetic/(*a\Kinetic+Capsule()\Kinetic) 
  ;ModuloObjeto1.f=*a\Kinetic/Sqr(Pow(*a\Kinetic,2)+Pow(Capsule()\Kinetic,2)) 
  ;ModuloObjeto0.f=Capsule()\Kinetic/Sqr(Pow(*a\Kinetic,2)+Pow(Capsule()\Kinetic,2)) 
  ;...and could be more and more... 
  Capsule()\dirX+DiffX*ModuloObjeto1/Sqr(DiffX*DiffX+DiffY*DiffY) 
  Capsule()\dirY+DiffY*ModuloObjeto1/Sqr(DiffX*DiffX+DiffY*DiffY) 
  *a\dirX-DiffX*ModuloObjeto0/Sqr(DiffX*DiffX+DiffY*DiffY) 
  *a\dirY-DiffY*ModuloObjeto0/Sqr(DiffX*DiffX+DiffY*DiffY) 
EndProcedure 

Procedure CreateCapsuleSprite(t,c1,c2,c3) 
  CreateSprite(t,16,16) 
  StartDrawing(SpriteOutput(t)) 
  BackColor(RGB(0,0,0)) 
  Circle(8,8,8,c1) 
  Circle(8,9,7,c2) 
  Circle(7,8,6,0) 
  Box(4,8,2,3,c3):Box(5,9,2,3,c3) 
  Box(10,5,1,2,c3) 
  StopDrawing() 
EndProcedure 

;-MOREINITS 
If OpenScreen(#RX,#RY,#bitplanes,"Space Caps")=0:End:EndIf 
CreateCapsuleSprite(0,$00bece,$007d7b,$00e7f7) 
Cursor\sprite=0 
Cursor\CentreX=SpriteWidth(0)/2:Cursor\CentreY=SpriteHeight(0)/2 
Cursor\Mass=(SpriteWidth(0)+SpriteHeight(0))/2/16 
t.w=1:g.b=1 
While g<=#lines 
  While t<=g*#BallsType1 
    CreateCapsuleSprite(t,$bd00ce,$84008c,$e700f7) 
    AddElement(Capsule()):Capsule()\sprite=t 
    Capsule()\CentreX=SpriteWidth(t)/2:Capsule()\CentreY=SpriteHeight(t)/2 
    Capsule()\Mass=(SpriteWidth(t)+SpriteHeight(t))/2/16 
    Capsule()\x=(t-(g-1)*#BallsType1)*#RX/(#BallsType1+1)-Capsule()\CentreX:Capsule()\y=g*50 
    t.w+1 
  Wend 
  g+1 
Wend 
mouseX=400:mouseY=400 
Cursor\x=mouseX:Cursor\y=mouseY 
MouseLocate(mouseX,mouseY) 

;-MAIN: 
Repeat 
  ExamineKeyboard() 
  ExamineMouse() 
  ClearScreen(RGB(0,0,0)) 
  ; Cursor position and vector: 
  prevmouseX=mouseX:prevmouseY=mouseY;<-previous mouse coordinates 
  mouseX=MouseX():mouseY=MouseY();<-current mouse coordinates 
  If mouseX<>prevmouseX Or mouseY<>prevmouseY;If mouse is moved: 
    Cursor\dirX=mouseX-prevmouseX:Cursor\dirY=mouseY-prevmouseY 
    mouseX=Cursor\x+Cursor\dirX:mouseY=Cursor\y+Cursor\dirY 
    MouseLocate(mouseX,mouseY) 
  EndIf 
  Cursor\x+Cursor\dirX:Cursor\y+Cursor\dirY 
  ; Cursor-Screen limits: 
  If Cursor\x<=-Cursor\CentreX:Cursor\dirX=Abs(Cursor\dirX):EndIf 
  If Cursor\x+Cursor\CentreX>=#RX:Cursor\dirX=-Abs(Cursor\dirX):EndIf 
  If Cursor\y<=-Cursor\CentreY:Cursor\dirY=Abs(Cursor\dirY):EndIf 
  If Cursor\y+Cursor\CentreY>=#RY:Cursor\dirY=-Abs(Cursor\dirY):EndIf 
  ForEach Capsule() 
  ; Capsule-Screen limits: 
    If Capsule()\x<=-Capsule()\CentreX:Capsule()\dirX=Abs(Capsule()\dirX):EndIf 
    If Capsule()\x+Capsule()\CentreX>=#RX:Capsule()\dirX=-Abs(Capsule()\dirX):EndIf 
    If Capsule()\y<=-Capsule()\CentreY:Capsule()\dirY=Abs(Capsule()\dirY):EndIf 
    If Capsule()\y+Capsule()\CentreY>=#RY:Capsule()\dirY=-Abs(Capsule()\dirY):EndIf 
  ; Capsule-moving: 
    Capsule()\x+Capsule()\dirX:Capsule()\y+Capsule()\dirY 
  ; collision: 
    *i.balls=@Capsule() 
    While NextElement(Capsule()) 
      If SpritePixelCollision(*i\sprite,*i\x,*i\y,Capsule()\sprite,Capsule()\x,Capsule()\y) 
        Shock(*i) 
      EndIf 
    Wend 
    ChangeCurrentElement(Capsule(),*i) 
    If SpritePixelCollision(Cursor\sprite,Cursor\x,Cursor\y,Capsule()\sprite,Capsule()\x,Capsule()\y) 
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
; DisableDebugger
