; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 03. May 2003
; OS: Windows
; Demo: No

hWnd1.l = OpenWindow(1, 10, 10, 300, 300, "Hallo", #PB_Window_SystemMenu | #WS_OVERLAPPEDWINDOW) 
hWnd2.l = CreateWindowEx_(0, "Static", "owned Window", #WS_VISIBLE | #WS_OVERLAPPEDWINDOW, 20, 20, 100, 100, hWnd1, 0, GetModuleHandle_(0), 0) 

Repeat 
  event = WaitWindowEvent() 
Until event = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -