; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3335&highlight=
; Author: zenturio (updated for PB4.00 by blbltheworm)
; Date: 07. January 2004
; OS: Windows
; Demo: No

#WM_CAPTURECHANGED=533 

Procedure WndProc(hhWnd, uMsg, wParam, lParam) 
Select uMsg 
    Case #WM_CAPTURECHANGED 
       Debug lParam 
       Debug "Mouse Capturechanged" 
       ProcedureReturn 0 
EndSelect 
ProcedureReturn DefWindowProc_(hhWnd,uMsg,wParam,lParam) 
EndProcedure 

hwnd = OpenWindow(1,10,10,300,300,"",#PB_Window_SystemMenu) 
SetCapture_(hwnd) 
SetWindowCallback(@WndProc()) 

Repeat 
   Select WaitWindowEvent() 
      Case #WM_LBUTTONDOWN  : A$ = "Left Mouse Button pressed" 
      Case #WM_LBUTTONUP    : A$ = "Left Mouse Button released" 
      Case #WM_MOUSEMOVE    : A$ = "Mouse has moved"      
      Case #PB_Event_CloseWindow: End 
   EndSelect 
   SetWindowText_(hwnd, A$): 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
