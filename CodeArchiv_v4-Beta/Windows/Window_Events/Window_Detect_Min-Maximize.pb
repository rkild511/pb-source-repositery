; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 18. April 2003
; OS: Windows
; Demo: Yes

Procedure WinCallback(WindowId, Message, wParam, lParam) 
  Result.l = #PB_ProcessPureBasicEvents 
    If Message = #WM_SIZE 
      Select wParam 
        Case #SIZE_MINIMIZED: 
          MessageRequester("Mitteilung","Programm wurde deaktiviert!",0) 
        Case #SIZE_RESTORED: 
          MessageRequester("Mitteilung","Programm wurde aktiviert!",0) 
      EndSelect 
    EndIf 
  ProcedureReturn Result    
EndProcedure 

hwnd=OpenWindow(1,100,100,300,300,"Test",#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar) 

SetWindowCallback(@WinCallback()) 

Repeat 
  EventID.l =  WaitWindowEvent() 

Until EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -