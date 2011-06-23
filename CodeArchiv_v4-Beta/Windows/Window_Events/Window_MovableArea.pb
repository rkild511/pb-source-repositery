; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2450&highlight=
; Author: J-The-Grey (updated for PB4.00 by blbltheworm)
; Date: 04. October 2003 
; OS: Windows
; Demo: No


; Kill with debugger!

InitMouse() 
If InitSprite() 

   hwnd = OpenWindow(0, 200, 200, 300, 300, "...", #PB_Window_BorderLess) 
   If OpenWindowedScreen(hwnd,0,0,300,300,0,0,0) 
      StartDrawing(ScreenOutput()) 
       FrontColor(RGB(128,0,128)) 
       Box(50,50,200,50) 
      StopDrawing() 
      FlipBuffers() 
      
      Repeat 
        Select WaitWindowEvent() 
          Case #PB_Event_CloseWindow 
            End 
          Case #WM_LBUTTONDOWN 
          If WindowMouseX(0) >= 50 And WindowMouseX(0) <= 250 And WindowMouseY(0) >= 50 And WindowMouseY(0) <= 100 
              SendMessage_(hwnd, #WM_NCLBUTTONDOWN, #HTCAPTION, 0) 
          EndIf 
        EndSelect 
      ForEver 
   EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
