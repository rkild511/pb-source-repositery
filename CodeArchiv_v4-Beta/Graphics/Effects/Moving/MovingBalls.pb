; German forum: 
; Author: Pride (updated for PB4.00 by blbltheworm)
; Date: 03. October 2002
; OS: Windows
; Demo: Yes


Declare Move_Balls()
Declare Draw_Balls()

Global Dim ball_x.l(40)
Global Dim ball_y.l(40)
Global Dim ball_speed_x.l(40)
Global Dim ball_speed_y.l(40)

For b = 0 To 40
    ball_x(b) = Random(600)
    ball_y(b) = Random(500)
    ball_speed_x(b) = Random(15)
    ball_speed_y(b) = Random(15)
Next

If InitSprite() = 0
      MessageRequester("Error","Error: Dx7 or higher",0)
      End
EndIf
If InitKeyboard() = 0
      MessageRequester("Error","Error: Dx7 or higher",0)
      End
EndIf

If OpenScreen(800,600,16,"Moving BallZ")
    Repeat
       ClearScreen(RGB(255,255,255))
       ExamineKeyboard()
                Move_Balls()
                Draw_Balls()
       FlipBuffers()
    Until KeyboardPushed(#PB_Key_Escape)
Else
   MessageRequester("Error","Error: Cant open Fullscreen",0)
EndIf

Procedure Move_Balls()
For b = 0 To 40
   ball_x(b) = ball_x(b) + ball_speed_x(b)
   ball_y(b) = ball_y(b) + ball_speed_y(b)
     If ball_x(b) > 750     : ball_speed_x(b) =- ball_speed_x(b) :EndIf
     If ball_x(b) < 0       : ball_speed_x(b) =- ball_speed_x(b) :EndIf
     If ball_y(b) > 600     : ball_speed_y(b) =- ball_speed_y(b) :EndIf
     If ball_y(b) < 0       : ball_speed_y(b) =- ball_speed_y(b) :EndIf
Next
EndProcedure

Procedure Draw_Balls()
    StartDrawing(ScreenOutput())
      For b = 0 To 20     
        Circle(ball_x(b),ball_y(b),Random(40),Random(250))
      Next
    StopDrawing()
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger