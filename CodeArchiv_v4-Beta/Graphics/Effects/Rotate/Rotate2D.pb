; German forum:
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 15. October 2002
; OS: Windows
; Demo: No


Procedure RotateSprite(source,target,angle.f,scale)
  s.f=Sin(6.28318531/3600*angle):c.f=Cos(6.28318531/3600*angle)
  bitmap=CreateCompatibleBitmap_(GetDC_(0),SpriteWidth(source),SpriteHeight(source))
  dc=CreateCompatibleDC_(GetDC_(0))
  obj=SelectObject_(dc,bitmap)
  sid=SpriteOutput(source)
  workdc=StartDrawing(sid)
  BitBlt_(dc,0,0,SpriteWidth(source),SpriteHeight(source),workdc,0,0,13369376)
  transcolor=Point(SpriteWidth(source)-1,0);<-----transparente farbe oberes-rechtes pixel im sourcesprite
  StopDrawing()
  mx=SpriteWidth(source)/2:my=SpriteHeight(source)/2
  radius.f=Sqr(mx*mx + my*my)+1
  If scale=0
    If SpriteWidth(target)=0
      CreateSprite(target,SpriteWidth(source),SpriteHeight(source),0)
      TransparentSpriteColor(2,RGB(Red(transcolor),Green(transcolor),Blue(transcolor)))
      cl=1
    EndIf
    mx2=mx:my2=my
  Else
    If SpriteWidth(target)=0
      CreateSprite(target,radius*2,radius*2,0)
      TransparentSpriteColor(2,RGB(Red(transcolor),Green(transcolor),Blue(transcolor)))
      cl=1
    EndIf
    mx2=radius:my2=radius:diffmx=mx2-mx:diffmy=my2-my
  EndIf
  max=SpriteWidth(target):may=SpriteHeight(target)
  sid=SpriteOutput(target)
  workdc=StartDrawing(sid)
  Box(x, y, max, may,transcolor)
  For y=0 To SpriteHeight(source)-1
    For x=0 To SpriteWidth(source)-1
      RotateX.l = ((x - mx) * c - (y - my) * s) + mx + diffmx
      RotateY.l = ((x - mx) * s + (y - my) * c) + my + diffmy
      If RotateX>0 And RotateX<max-1 And RotateY>0 And RotateY<may-1
        color=GetPixel_(dc,x,y)
        Plot(RotateX,RotateY,color)
        If angle<>0 And angle<>900 And angle<>1800 And angle<>2700 And angle<>3600
          Plot(RotateX+1,RotateY,color);<--Das ist mein wahnsinnig komplizierter
          Plot(RotateX,RotateY+1,color);<--Antialiasing-Algorythmus *lol*
        EndIf
      EndIf
    Next x
  Next y
  StopDrawing()
  DeleteObject_(bitmap):DeleteObject_(obj):DeleteDC_(dc)
EndProcedure



If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 Or OpenScreen(800,600,32,"Rotate")=0
  MessageRequester("Error", "Can't open DirectX 7 Or later", 0):End
EndIf

LoadSprite(1,"..\..\Gfx\Geebee2.bmp",0);<--Probiert erst mal den hier (zu finden in 'PureBasic\Examples\Sources\Data')
CreateSprite(2,SpriteWidth(1)*2,SpriteHeight(1)*2)
TransparentSpriteColor(2,RGB(255,0,255))

Repeat
  ExamineMouse():ExamineKeyboard()
  ClearScreen(RGB(100,50,50))
  DisplayTransparentSprite(1,100,100)
  If count<3650
    If GetTickCount_()-zeit > 10
      RotateSprite(1,2,count,1)
      ;RotateSprite(source,target,angle,scale)
      ;source - Nummer des Quellsprite
      ;target - Nummer des (neuen)Zielsprite
      ;angle  - 0 - 3600 Zehntelgrad
      ;scale  - 0 = Zielsprite ist so groß wie Quellsprite
      ;         1 = Zielspritegröße richtet sich nach dem max Rotationsradius
      count+50
      zeit=GetTickCount_()
    EndIf
  EndIf
  DisplayTransparentSprite(2,300+count/20,100+count/20)
  StartDrawing(ScreenOutput())
  DrawText(10, 500,"Winkel= "+Str((count-50)/10)+" Grad")
  StopDrawing()
  FlipBuffers()
  Sleep_(1)
Until KeyboardPushed(#PB_Key_Escape)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger