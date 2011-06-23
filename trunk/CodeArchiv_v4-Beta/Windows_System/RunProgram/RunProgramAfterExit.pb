; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9120&highlight=
; Author: Kale (updated for PB4.00 by blbltheworm)
; Date: 11. January 2004
; OS: Windows
; Demo: Yes

Global Quit.l 

Procedure WindowCallback(hWnd, Message, wParam, lParam) 
  result = #PB_ProcessPureBasicEvents 
  Select Message 
    Case #WM_CLOSE 
      RunProgram("calc.exe") 
      Quit = 1 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

OpenWindow(1, 0, 0, 500, 300, "Close to open Calculator...", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 

SetWindowCallback(@WindowCallback()) 

Repeat 
  EventID = WaitWindowEvent() 
Until Quit = 1 
End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
