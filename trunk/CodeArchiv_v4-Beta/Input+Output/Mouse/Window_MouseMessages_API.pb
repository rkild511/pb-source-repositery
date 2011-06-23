; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 30. January 2003
; OS: Windows
; Demo: Yes

hWnd = OpenWindow(1,10,10,300,300,"",#PB_Window_SystemMenu) 

Repeat 
   Select WaitWindowEvent() 
      Case #WM_RBUTTONDOWN  : A$ = "Right Mouse Button pressed" 
      Case #WM_RBUTTONUP    : A$ = "Right Mouse Button released" 
      
      Case #WM_LBUTTONDOWN  : A$ = "Left Mouse Button pressed" 
      Case #WM_LBUTTONUP    : A$ = "Left Mouse Button released" 
      
      Case #WM_MOUSEMOVE    : A$ = "Mouse has moved" 
      
      Case #PB_Event_CloseWindow: End 
   EndSelect 
   SetWindowTitle(1, A$)
ForEver 


; These are the standard API mouse messages. 
; 
; WM_CAPTURECHANGED 
; WM_LBUTTONDBLCLK 
; WM_LBUTTONDOWN 
; WM_LBUTTONUP 
; WM_MBUTTONDBLCLK 
; WM_MBUTTONDOWN 
; WM_MBUTTONUP 
; WM_MOUSEACTIVATE 
; WM_MOUSEMOVE 
; WM_MOUSEWHEEL 
; WM_NCHITTEST 
; WM_NCLBUTTONDBLCLK 
; WM_NCLBUTTONDOWN 
; WM_NCLBUTTONUP 
; WM_NCMBUTTONDBLCLK 
; WM_NCMBUTTONDOWN 
; WM_NCMBUTTONUP 
; WM_NCMOUSEMOVE 
; WM_NCRBUTTONDBLCLK 
; WM_NCRBUTTONDOWN 
; WM_NCRBUTTONUP 
; WM_RBUTTONDBLCLK 
; WM_RBUTTONDOWN 
; WM_RBUTTONUP 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -