; German forum:
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 18. April 2003
; OS: Windows
; Demo: No

hWnd = OpenWindow(0, 200, 200, 300, 300, "...", #PB_Window_BorderLess) 
Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
    Case #WM_LBUTTONDOWN 
      SendMessage_(hWnd, #WM_NCLBUTTONDOWN, #HTCAPTION, 0) 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -