; German forum: 
; Author: Pride (updated for PB4.00 by blbltheworm)
; Date: 04. October 2002
; OS: Windows
; Demo: Yes

Declare jump_circles()
Declare move_circles()
Declare draw_circles()

Global x        :      x = 0
Global y        :      y = 330
Global jump     :   jump = 0
Global angle.f  :  angle = 0
Global jspeed.f : jspeed = 0.1   
Global height   : height = 100
Global speed    : speed =  4

If InitSprite() = 0
    MessageRequester("Error","Error: DX7 or higher",0)
EndIf
If InitKeyboard() = 0
    MessageRequester("Error","Error: DX7 or higher",0)
EndIf
 If OpenScreen(800,600,16,"Kosinus Jump")   
  Repeat
    FlipBuffers()

    If IsScreenActive()
       ExamineKeyboard()
       ClearScreen(RGB(255,255,255))         
         move_circles()
         jump_circles()
         draw_circles()
    Else
      Delay(10)
    EndIf

  Until KeyboardPushed(#PB_Key_Escape)
Else
  MessageRequester("Error","Error: Cant open Fullscreen",0)
EndIf 

Procedure move_circles()
         x = x + speed
         If x > 800
            speed =- speed
         ElseIf x < 0
            speed =- speed
         EndIf
EndProcedure
Procedure jump_circles()
      angle = angle + jspeed
      y1= Sin(angle)*height
      y = Cos(angle)*height
EndProcedure
Procedure draw_circles()
   StartDrawing(ScreenOutput())   
         Line(0,350,800,0,RGB(255,0,0))
         Circle(x,350-y,Random(30),RGB(0,Random(255),0))
         Circle(x,350-y1,Random(10),RGB(Random(255),0,0))
         Circle(800-x,350-y1,Random(10),RGB(Random(255),0,0))
         Circle(800-x,350-y,Random(60),RGB(0,0,Random(255)))
   StopDrawing()
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger