; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13466&highlight=
; Author: Blade (updated for PB 4.00 by Andre)
; Date: 24. December 2004
; OS: Windows
; Demo: Yes


; A small demo code about creating a universe shooter
; Ein kleiner Demo-Code zum Erstellen eines Weltraum-Ballerspiels
; ---------------------------------------------------------------
; Kontrolle:
; Links-Rechts Tasten zum Rotieren. Hoch-Runter für Schub. Linke STRG-Taste zum Feuern.
; Keine Gegner, nur unbekannte weiße Scheiben...


; I wanted to see how to make (2D) games with PB, so I took the "Waponez II" code 
; and started to edit it to meet my needs. 
; The idea was to replicate a game named Blitzeroids I did about 10-12 years ago 
; with Blitz2 for an AmigaFormat competition, but I haven't the free time I had 
; when I was younger, so I post here the code, could be useful to someone... 
; 
; The original WaponezII code is no more, and the main features are: 
; 
; - Use of 3D sprites 
; - "Motion blur" effect 
; - Collisions 
; - Acceleration / Friction 
; - fake "infinite universe" scrolling  
; 
; All the graphics are created at run-time using circles and lines, so don't 
; expect cool effects. 
; 
; CONTROL:
; left-right arrows to rotate, up-down for thrust, left control to fire. 
; no enemies, just unknown white discs...  

InitSprite() 
InitSprite3D() 
InitKeyboard() 

Global offx.f,offy.f 

; Screen and window opened 

OpenWindow(0,0,0,640,480,"Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget) 
OpenWindowedScreen(WindowID(0),0,0,640,480,1,0,0) 

;Create a sprite 3d 

CreateSprite(0,64,64,#PB_Sprite_Texture) 
StartDrawing(SpriteOutput(0)) 
Box(0,0,63,63,RGB(0,0,16)) 
StopDrawing() 
CreateSprite3D(0,0) 

CreateSprite(1,32,32,#PB_Sprite_Texture) 
StartDrawing(SpriteOutput(1)) 
Box(16+9,0,2,16,RGB(0,64,200)) 
Box(16-11,0,2,16,RGB(0,64,200)) 
Circle(16,16,16,RGB(0,64,200)) 
Circle(16,16,10,RGB(128,128,128)) 
Circle(16,24,8,RGB(0,0,0)) 
Circle(16,8,6,RGB(0,64,200)) 
StopDrawing() 
CreateSprite3D(1,1) 

CreateSprite(2,32,32,#PB_Sprite_Texture) 
StartDrawing(SpriteOutput(2)) 
Circle(16,16,3+1,RGB(128,125,22)) 
Circle(16,16,2+1,RGB(255,200,0)) 
Line(16,4,0,24,RGB(255,250,22)) 
Line(15,4,0,24,RGB(255,250,22)) 
Line(14,4,0,24,RGB(128,125,22)) 
Line(17,4,0,24,RGB(128,125,22)) 
StopDrawing() 
CreateSprite3D(2,2) 

CreateSprite(3,32,32,#PB_Sprite_Texture) 
StartDrawing(SpriteOutput(3)) 
Circle(16,16,2,RGB(128,128,128)) 
Circle(16,16,1,RGB(255,255,255)) 
StopDrawing() 
CreateSprite3D(3,3) 

CreateSprite(4,32,32,#PB_Sprite_Texture) 
StartDrawing(SpriteOutput(4)) 
Circle(16,16,15,RGB(128,128,128)) 
Circle(16,16,13,RGB(255,255,255)) 
StopDrawing() 
CreateSprite3D(4,4) 


Sprite3DQuality(1) 

xx.f=100 
yy.f=100 
xs.f=0 
ys.f=0 
ang.f=0 

Structure Bullet 
  x.f 
  y.f 
  Width.w 
  Height.w 
  angle.l 
  Image.w 
  SpeedX.f 
  SpeedY.f 
  life.w 
EndStructure 
Global NewList Bullet.Bullet() 
Procedure AddBullet(Sprite, x.f, y.f, angle,SpeedX.f, SpeedY.f) 
  AddElement(Bullet())            
  Bullet()\x      = x+SpeedX*2 
  Bullet()\y      = y+SpeedY*2 
  Bullet()\Width  = SpriteWidth(Sprite) 
  Bullet()\Height = SpriteHeight(Sprite) 
  Bullet()\Image  = Sprite 
  Bullet()\SpeedX = SpeedX 
  Bullet()\SpeedY = SpeedY 
  Bullet()\angle = angle 
  Bullet()\life = 60 
EndProcedure 


Structure Stars 
  x.f 
  y.f 
  depth.f 
EndStructure 
Global NewList Stars.Stars() 
Procedure AddStar(x.f, y.f, depth.f) 
  AddElement(Stars()) 
  Stars()\x = x 
  Stars()\y = y 
  Stars()\depth = depth 
EndProcedure 


Structure Objs 
  x.f 
  y.f 
EndStructure 
Global NewList Objs.Objs() 
Procedure AddObjs(x.f, y.f) 
  AddElement(Objs()) 
  Objs()\x = x 
  Objs()\y = y 
EndProcedure 


For n=1 To 50 
  AddStar(Random(640),Random(480),Random(100)/150+0.5) 
Next 
  
For n=1 To 35 
  AddObjs(Random(4000)-2000,Random(4000)-2000) 
Next 

offx.f=0 
offy.f=0 


Repeat 
  WEvent=WindowEvent() 
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_Escape) Or WEvent=#PB_Event_CloseWindow 
    Quit=#True 
  EndIf 
  
  If KeyboardPushed(#PB_Key_Left) 
    ang-5 
  EndIf 
  
  If KeyboardPushed(#PB_Key_Right) 
    ang+5 
  EndIf 
  
  If KeyboardPushed(#PB_Key_Up) 
    ys=ys+Sin(ang*3.1415/180)/6 
    xs=xs+Cos(ang*3.1415/180)/6 
  EndIf 
  
  If KeyboardPushed(#PB_Key_Down) 
    ys=ys-Sin(ang*3.1415/180)/12 
    xs=xs-Cos(ang*3.1415/180)/12 
  EndIf 
  
  xx+xs 
  yy+ys 


  ResetList(Objs()) 
  While NextElement(Objs()) 
    If Abs(xx-Objs()\x)<18 And Abs(yy-Objs()\y)<18 
      xs=-xs 
      ys=-ys 
    EndIf 
  Wend 
  
  offy=offy-(offy+yy-220)/40 
  offx=offx-(offx+xx-300)/40 

  xs*0.97 
  ys*0.97 
  
  If BulletDelay > 0 
    BulletDelay-1 
  EndIf 
  
  If KeyboardPushed(#PB_Key_LeftControl) 
    If BulletDelay = 0 
      BulletDelay = 3 
      AddBullet(2, xx , yy, ang ,Cos((ang+Random(11)-5)*3.1415/180)*6 , Sin((ang+Random(11)-5)*3.1415/180)*6) 
    EndIf 
  EndIf 
  
  
  If Start3D() 
    ZoomSprite3D(0,650,490) 
    DisplaySprite3D(0,0,0,60) 
    Gosub DisplayStars 
    Gosub DisplayObjs 
    Gosub DisplayBullets 
    RotateSprite3D(1,0,0) 
    ZoomSprite3D(1,32,32) 
    RotateSprite3D(1,ang,-1) 
    
    DisplaySprite3D(1,xx+offx,yy+offy) 
    
    Stop3D() 
  EndIf 
  
  
  FlipBuffers() 
  ;ClearScreen(0,0,0) 
  Delay(1) 
Until Quit=#True 
CloseWindow(0) 
End 

DisplayBullets: 
  ResetList(Bullet()) 
  While NextElement(Bullet())  ; Process all the bullet actualy displayed on the screen 
    Bullet()\life-1 
    If Bullet()\life=<0 
      DeleteElement(Bullet()) 
      Goto prossimosparo 
    Else 
      RotateSprite3D(Bullet()\Image,Bullet()\angle,0) 
      DisplaySprite3D(Bullet()\Image, Bullet()\x+offx, Bullet()\y+offy)   ; Display the bullet.. 
      Bullet()\y + Bullet()\SpeedY 
      Bullet()\x + Bullet()\SpeedX 
    EndIf 
    ; collisions 
    ResetList(Objs()) 
    While NextElement(Objs()) 
      If Abs(Bullet()\x-Objs()\x)<14 And Abs(Bullet()\y-Objs()\y)<14 
        Objs()\x+Bullet()\SpeedX/4 
        Objs()\y+Bullet()\SpeedY/4 
        DeleteElement(Bullet()) 
        Goto prossimosparo 
      EndIf 
    Wend 
    prossimosparo: 
  Wend 
  Return 
  
DisplayStars: 
  ResetList(Stars()) 
  While NextElement(Stars()) 
    Stars()\x-xs*Stars()\depth 
    Stars()\y-ys*Stars()\depth 
    If Stars()\x+offx>640:Stars()\x-640:EndIf 
    If Stars()\x+offx<0:Stars()\x+640:EndIf 
    If Stars()\y+offy>480:Stars()\y-480:EndIf 
    If Stars()\y+offy<0:Stars()\y+480:EndIf 
    
    DisplaySprite3D(3, Stars()\x+offx, Stars()\y+offy,Stars()\depth*550)   ; Display the bullet.. 
  Wend 
  Return 
  
DisplayObjs: 
  ResetList(Objs()) 
  While NextElement(Objs()) 
    Objs()\x-xs 
    Objs()\y-ys 
    DisplaySprite3D(4, Objs()\x+offx, Objs()\y+offy) 
  Wend 
  Return 
  
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -