; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2639&highlight=
; Author: benpicco (updated for PB 4.00 by Andre)
; Date: 04. April 2005
; OS: Windows
; Demo: Yes

InitSprite()
InitSprite3D()
InitKeyboard()
OpenScreen(1024,768,16,"Test")
LoadSprite(1,"..\..\Graphics\Gfx\pfeil.bmp", #PB_Sprite_Texture)
LoadSprite(2,"..\..\Graphics\Gfx\kugel.bmp")
TransparentSpriteColor(1,RGB(255,0,255))
TransparentSpriteColor(2,RGB(255,0,255))
CreateSprite3D(1,1)
Sprite3DQuality(1)

Global x.w
Global y.w
Global trans.w
Global speed.w
Global plus.b
Global t.f
Global xs.f
Global sprite.b
Global ys.f
Global schies.b
Global g.f
g=-1   ;sonst fällt alles nach oben ^^
plus=1
speed=1

;---Anfang Code Template
; Drehen
Repeat
  ExamineKeyboard()
  If KeyboardPushed(#PB_Key_Left)
    winkel - 1
    If winkel <= 0
      winkel = 360
    EndIf
  EndIf
  If KeyboardPushed(#PB_Key_Right)
    winkel + 1
    If winkel >= 360
      winkel = 0
    EndIf
  EndIf

  ; Vorwärts
  If KeyboardPushed(#PB_Key_Up)
    x=x + Cos(winkel *(2*#PI/360)) * speed ; Grad zu Bogenmaß
    y=y + Sin(winkel *(2*#PI/360)) * speed
  EndIf

  ; Rückwärts
  If KeyboardPushed(#PB_Key_Down)
    x=x + Cos(winkel *(2*#PI/360)) * -speed
    y=y + Sin(winkel *(2*#PI/360)) * -speed
  EndIf
  ;---Ende Code Template

  If KeyboardReleased(#PB_Key_Add)
    speed=speed+1
  EndIf

  If KeyboardReleased(#PB_Key_Subtract)
    speed=speed-1
  EndIf

  If KeyboardReleased(#PB_Key_Space)
    schies=1
    t=0
    ;XVerschiebung=44*Sin(winkel/360*2*#pi)
    ;YVerschiebung=22*Cos(winkel/360*2*#pi)
    ;X1 = x + (44/2)
    ;Y1 = y + (44/2)
    ;KreisMittelX = X1 + XVerschiebung
    ;KreisMittelY = Y1 + YVerschiebung
    ;KreisX = KreisMittelX - (44/2)
    ;KreisY = KreisMittelY - (44/2)
    xs=x+22+22*Cos(winkel*3.1415927/180) - (7/2)
    ys=y+22+22*Sin(winkel*3.1415927/180) - (7/2)

  EndIf
  trans=trans+plus ; sieht cooler aus, find ich ;-)
  If trans=255
    plus=-1
  EndIf
  If trans=0
    plus=1
  EndIf
  If schies=1
    ; StartDrawing(ScreenOutput()); ich wollte wissen, was KreisX und Y ist, und wenn man das
    ; aktiviert und das clearscreen wegacht, entsteht nach einer 360° Drehung eine Elypse.
    ; Circle(KreisX,KreisY,22,RGB(255,255,255))
    ; StopDrawing()
    t=t+1
    xs=xs+speed*t*Cos((360-winkel)) ;Formeln aus dem Tafelwerk, muss ich mir nochmal ansehen...
    ys=ys+(-g/2)*Pow(t,2)+speed*t*Sin((360-winkel))
    DisplayTransparentSprite(2,xs,ys)
  EndIf

  Start3D()
  DisplaySprite3D(1,x,y,trans)
  RotateSprite3D(1,winkel,0)
  Stop3D()
  StartDrawing(ScreenOutput())
  DrawingMode(1)
  FrontColor(RGB(255,255,255))
  DrawText(920, 10, "Speed:"+Str(speed))
  DrawText(920, 25, Str(winkel)+"°")
  DrawText(920, 40, "X="+Str(xs))
  DrawText(920, 55, "Y="+Str(ys))
  StopDrawing()
  FlipBuffers()
  ClearScreen(RGB(0,0,0))
  If KeyboardPushed(#PB_Key_0)
    ClearScreen(RGB(0,0,0))
  EndIf
  If KeyboardPushed(#PB_Key_RightAlt)
    GrabSprite(0,0,0,1024,768)
    sprite=sprite+1
    SaveSprite(0,"Screenshot "+Str(sprite)+".bmp")
  EndIf
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -