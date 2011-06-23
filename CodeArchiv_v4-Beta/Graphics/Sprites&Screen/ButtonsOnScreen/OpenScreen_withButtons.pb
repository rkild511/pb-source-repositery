; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1052&start=10
; Author: CS2001 (Additions by blbltheworm) (updated for PB4.00 by blbltheworm)
; Date: 18. May 2003
; OS: Windows
; Demo: No


If InitSprite() And InitKeyboard() And InitMouse() 
Else 
  End 
EndIf 
OpenScreen(800,600,16,"title") 

;<-Added by blbltheworm->
CreateSprite(0,14,14)            
StartDrawing(SpriteOutput(0))
  Box(0,0,14,14,RGB(255,0,255))
  LineXY(0,0,14,14,255)
  LineXY(14,0,0,14,255)
StopDrawing()

TransparentSpriteColor(0,RGB(255,0,255)) 
LoadImage(1,"..\..\Gfx\Game.bmp")
CreateSprite(1,800,600)
StartDrawing(SpriteOutput(1))
DrawImage(ImageID(1),0,0,800,600)
StopDrawing()
FreeImage(1)
;<-End of Added->

Repeat 
  ExamineMouse() 
  ExamineKeyboard() 
  DisplaySprite(1,0,0) 
  DisplayTransparentSprite(0,MouseX()-7,MouseY()-7) 
  StartDrawing(ScreenOutput()) 
  DrawingMode(1) 

  DrawText(31,500,"Kasten") 

  DrawText(201,500,"Kasten") 

  If MouseButton(1) And MouseX() > 30 And MouseX() < 230 And MouseY() > 475 And MouseY() < 525 
    start=GetTickCount_() 
    zeigen=1 
    letzer_button=1 
  EndIf 

  If MouseButton(1) And MouseX() > 200 And MouseX() < 400 And MouseY() > 475 And MouseY() < 525 
    start=GetTickCount_() 
    zeigen=1 
    letzer_button=2 
  EndIf 

  If zeigen=1 
    If letzer_button=1 
      DrawText(50,150,"Das ist ein schöner Kasten...") 
    EndIf 
    If letzer_button=2 
      DrawText(50,150,"Button 2") 
    EndIf 
    If start<GetTickCount_()-2000 
      zeigen=0 
    EndIf 
  EndIf 

  StopDrawing() 
  FlipBuffers() 

Until Quit=1 Or KeyboardReleased(1) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
