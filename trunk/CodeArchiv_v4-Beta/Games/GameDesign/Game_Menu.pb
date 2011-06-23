; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2330&highlight=
; Author: Rob (updated for PB 4.00 by Andre)
; Date: 10. October 2003
; OS: Windows
; Demo: Yes

Declare menu() 

Procedure level() 
  Repeat 
    ExamineKeyboard() 
    
    StartDrawing(ScreenOutput()) 
      FrontColor(RGB(255,0,0)) 
      DrawingMode(1) 
      DrawText(10, 10, "Enter für Menü") 
    StopDrawing() 
    
    FlipBuffers() 
    ClearScreen(RGB(0,0,0)) 
  Until KeyboardPushed(#PB_Key_Return) 
  menu() 
EndProcedure 


Procedure menu() 
  Repeat 
    ExamineKeyboard() 
    
    StartDrawing(ScreenOutput()) 
      FrontColor(RGB(255,255,255))
      DrawingMode(1) 
      DrawText(10, 10, "1 für Level, Esc für Ende") 
    StopDrawing() 
    
    If KeyboardPushed(1) : key=27 : EndIf 
    If KeyboardPushed(#PB_Key_1) : key=1 : EndIf 
    
    FlipBuffers() 
    ClearScreen(RGB(0,0,0)) 
  Until key=1 Or key=27 

  If key=27 
    End 
  Else 
    level() 
  EndIf 
  
EndProcedure 



InitSprite() 
InitKeyboard() 
OpenScreen(640,480,16,"Level") 

menu()
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
