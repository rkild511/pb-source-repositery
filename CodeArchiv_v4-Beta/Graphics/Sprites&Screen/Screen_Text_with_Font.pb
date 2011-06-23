; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1362&highlight=
; Author: J-The-Grey (updated for PB4.00 by blbltheworm)
; Date: 15. June 2003
; OS: Windows
; Demo: Yes

InitSprite() 
InitKeyboard() 
OpenScreen(800,600,16,"") 
LoadFont(1,"Arial",40,#PB_Font_Underline) 


Repeat 
  ExamineKeyboard() 
  FlipBuffers() 

  StartDrawing(ScreenOutput()) 
    DrawingMode(1)
    DrawingFont(FontID(1)) 
    FrontColor(RGB(255,255,255)):DrawText(10,10,"Hallo") 
  StopDrawing() 
Until KeyboardPushed(1) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
