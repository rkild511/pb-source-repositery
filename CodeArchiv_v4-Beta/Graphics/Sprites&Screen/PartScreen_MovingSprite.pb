; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7346
; Author: Motu23 (updated for PB4.00 by blbltheworm)
; Date: 26. August 2003
; OS: Windows
; Demo: Yes

; Example for starting a splitscreen game/application...
; Move the box with cursor keys! Esc to end.
InitSprite()
InitKeyboard()
OpenScreen(800,600,16,"Test Clip")

CreateSprite(0,64,64,0)
StartDrawing(SpriteOutput(0))
Box(0,0,64,64,255+255*256)
Line(0,0,64,64,255)
StopDrawing()

Global Dim Sprite_Width.l(100) ; Spritewidht will return cliped lenght !
Global Dim Sprite_Height.l(100) ; So I use an array instead of the function.

Sprite_Width.l(0) = SpriteWidth(0)
Sprite_Height.l(0) = SpriteHeight(0)

; BTW: This way is 4 times faster than calling Spritewidht(Nr) when you
; need It

Procedure Display_TransparentSprite(Sprite_Nr.l,PosX.l,PosY.l, MinX.l,MinY.l,MaxX.l,MaxY.l)
  LongX.l = Sprite_Width(Sprite_Nr.l)
  LongY.l = Sprite_Height(Sprite_Nr.l)
  Clip_X1 = 0
  Clip_Y1 = 0
  Clip_X2 = LongX.l
  Clip_Y2 = LongY.l
  If PosX.l < MinX.l
    Clip_X1.l = MinX.l - PosX.l
    PosX.l + Clip_X1.l
  ElseIf PosX.l + LongX.l > MaxX
    Clip_X2.l = LongX.l - ((PosX.l + LongX.l)-MaxX)
  EndIf
  
  If PosY.l < MinY.l
    Clip_Y1.l = MinY.l - PosY.l
    PosY.l + Clip_Y1.l
  ElseIf PosY.l + LongY.l > MaxY
    Clip_Y2.l = LongY.l - ((PosY.l + LongY.l)-MaxY)
  EndIf
  ClipSprite(Sprite_Nr.l,Clip_X1.l,Clip_Y1.l,Clip_X2.l,Clip_Y2.l)
  DisplayTransparentSprite(Sprite_Nr.l,PosX.l,PosY.l)
EndProcedure


HeroX = 200
HeroY = 200

Repeat
  
  ExamineKeyboard()
  If KeyboardPushed(200): HeroY - 1: EndIf
  If KeyboardPushed(203): HeroX - 1: EndIf
  If KeyboardPushed(205): HeroX + 1: EndIf
  If KeyboardPushed(208): HeroY + 1: EndIf
  
  ClearScreen(RGB(0,0,0))
  StartDrawing(ScreenOutput())
  Line(100,100,300,0,255)
  Line(100,100,0,200,255)
  Line(400,300,0,-200,255)
  Line(400,300,-300,0,255)
  StopDrawing()
  Display_TransparentSprite(0,HeroX,HeroY,100,100,400,300)
  FlipBuffers()
  
Until KeyboardReleased(1)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
