; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3334&highlight=
; Author: Rob (updated for PB4.00 by blbltheworm)
; Date: 04. January 2004
; OS: Windows
; Demo: Yes
 
InitSprite() 
InitKeyboard() 
OpenScreen(640,480,16,"Keboard") 

Repeat 
  ExamineKeyboard() 
  FlipBuffers() 
  ClearScreen(RGB(0,0,0)) 
  
  For i = 1 To 237 
    If KeyboardPushed(i):Break:EndIf 
  Next 
  
  StartDrawing(ScreenOutput()) 
  DrawText(10,10,"Taste: "+Str(i)) 
  StopDrawing() 
  
Until KeyboardPushed(1)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
