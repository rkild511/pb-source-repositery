; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2124&highlight=
; Author: kutta (updated for PB4.00 by blbltheworm)
; Date: 29. August 2003
; OS: Windows
; Demo: Yes

InitSprite()
InitKeyboard()
InitMouse()
OpenScreen(1024,768,32,";-)")
LoadFont(0,"comic sans ms",100)
LoadFont(1,"comic sans ms",50)

CreateSprite(1,1024,768)
CreateSprite(2,1024,768)
TransparentSpriteColor(2,RGB(255,0,0))

StartDrawing(SpriteOutput(1))
DrawingFont(FontID(0))
FrontColor (RGB(255,255,255))
DrawingMode(3)
DrawText(0,200,"PURE IST COOL")
StopDrawing ()

StartDrawing(SpriteOutput(2))
DrawingFont(FontID(1))
FrontColor (RGB(0,0,255))
Box(0,0,1024,768)
FrontColor (RGB(255,255,255))
DrawingMode(3)
DrawText(200,200,"bitte rubbeln ...")
StopDrawing ()

Repeat
  ExamineMouse()
  ExamineKeyboard()
  
  StartDrawing(SpriteOutput(2))
  FrontColor (RGB(255,0,0))
  Circle(MouseX(),MouseY(), 50)
  StopDrawing()
  
  ClearScreen(RGB(0,0,0))
  DisplaySprite(1,0,0)
  DisplayTransparentSprite(2,0,0);gruen
  FlipBuffers()
  
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
