; German forum: http://www.purebasic.fr/german/viewtopic.php?t=735&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 03. November 2004
; OS: Windows
; Demo: No

; 
; by Danilo, 03.11.2004 - german forum 
; 
Procedure WndProc(hWnd,Msg,wParam,lParam) 
  Static IsMinimized 
  Select Msg 
    Case #WM_SYSCOMMAND 
      Select wParam&$FFFFFFF0 
        Case #SC_MAXIMIZE 
          Beep_(800,100) 
          ProcedureReturn 0 
        Case #SC_MINIMIZE 
          If IsMinimized 
            ResizeWindow(0,#PB_Ignore,#PB_Ignore,400,400) 
          Else 
            ResizeWindow(0,#PB_Ignore,#PB_Ignore,400,0) 
          EndIf 
          IsMinimized!1 
          ProcedureReturn 0 
      EndSelect 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

#WINICONS = #PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget 
#WINFLAGS = #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#WINICONS 

OpenWindow(0,0,0,400,400,"xyz",#WINFLAGS) 
SetWindowCallback(@WndProc()) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -