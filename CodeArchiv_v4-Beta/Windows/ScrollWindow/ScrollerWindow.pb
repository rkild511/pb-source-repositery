; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: Yes

OpenWindow(0,0,0,500,500,"TEST",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#WS_VSCROLL|#WS_HSCROLL)

Repeat
  EventID = WaitWindowEvent()
Until EventID = #PB_Event_CloseWindow

End
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -