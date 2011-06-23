; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7644&highlight=
; Author: merendo (updated for PB4.00 by blbltheworm)
; Date: 24. September 2003
; OS: Windows
; Demo: Yes

Declare Marquee(image,width,text$,color,speed.f) 

If InitSprite() And InitKeyboard() And InitMouse() And OpenScreen(640,480,16,"Marquee") 
  text$="Hallo das ist ein kleiner Test mit ein bisschen Lauftext und Pfeffer dazu!!!" 
  CreateImage(0,200,30) 
Repeat 
  Sleep_(2) 
  ExamineKeyboard() 
  ExamineMouse() 
  ClearScreen(RGB(0,0,0)) 
  Marquee(0,200,text$,16777215,0.5) 
  StartDrawing(ScreenOutput()) 
  DrawImage(ImageID(0),MouseX(),MouseY()) 
  StopDrawing() 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_All) 
EndIf 


Procedure Marquee(image,width,text$,color,speed.f) 
  Global x.f 
  x.f-speed 
  StartDrawing(ImageOutput(image)) 
  DrawingMode(1) 
    Box(0,0,width,30,0) 
    FrontColor(RGB(Red(color),Green(color),Blue(color))) 
    If x<-TextWidth(text$):x=width:EndIf 
    DrawText(x,0,text$) 
  StopDrawing() 
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
