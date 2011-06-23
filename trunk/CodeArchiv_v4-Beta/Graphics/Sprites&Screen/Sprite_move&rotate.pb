; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm + Andre)
; Date: 31. January 2003
; OS: Windows
; Demo: Yes

InitSprite() : InitSprite3D() : InitKeyboard() : InitMouse() 
OpenScreen(1024,768,16,"rotating shit"); : SetFrameRate(60) 

LoadSprite(0,"..\Gfx\Geebee2.bmp",#PB_Sprite_Texture); sprite als texture laden damit man das sprite selbst rotieren kann 

Sprite_Width = SpriteWidth(0) / 2; damit des sprite zentriert auf seiner position gezeichnet wird 
Sprite_Height = SpriteHeight(0) / 2 

TransparentSpriteColor(0,RGB(255,0,255)); eventuell auch transparent 
CreateSprite3D(0,0); 3d-sprite aus dem sprite machen 

Grad.w = 0            ; Grad von 0° - 360° 
Mittelpunkt_x.w = 400 ; Mittelpunkt x 
Mittelpunkt_y.w = 400 ; Mittelpunkt y 
Abstand_x.w = 200 ; Abstand x          wenn die Abstände unterschielich (z.b. 50%) sind, is es ne schöne elipse statt n kreis 
Abstand_y.w = 200 ; Abstand y 
Pos_x.w = 0 ; aktuelle Position x des Sprites 
Pos_y.w = 0 ; aktuelle Position y des Sprites 

Repeat 
  ExamineKeyboard() 
  ClearScreen(RGB(0,0,0)) 

  If Grad >0 :  Grad = Grad - 1       ; Grad immer schön im Kreis rumdrehen 
  Else       :  Grad = 360  :  EndIf 

  ; neue Position des Sprites berechnen 
  shit_x.w = (Abstand_x * Cos(Grad * (2*3.14159265/360))) 
  Pos_x = Mittelpunkt_x + shit_x 
  shit_y.w = (Abstand_y * Sin(Grad * (2*3.14159265/360))) 
  Pos_y = Mittelpunkt_y + shit_y 

  Start3D() 
    RotateSprite3D(0, Grad ,0)                                        ; Sprite selbst auch noch rotieren 
    DisplaySprite3D(0, Pos_x - Sprite_Width , Pos_y - Sprite_Height ) ; und zeichnen 
  Stop3D() 

  StartDrawing(ScreenOutput()) : DrawingMode(1) 
  FrontColor(RGB(255,255,255)) : Plot( Mittelpunkt_x , Mittelpunkt_y ) ; damit du weisst das der mittelpunkt wirklich existiert ;) 
  StopDrawing() 

  FlipBuffers()  
Until KeyboardPushed(#PB_Key_Escape) 
CloseScreen() 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -