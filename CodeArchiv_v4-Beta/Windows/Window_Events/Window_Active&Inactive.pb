; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: Yes

Global Menu 

Procedure WindowProc(hwnd,Msg,wParam,lParam) 
  Select Msg 
    Case #WM_ACTIVATE 
      If hwnd = WindowID(0) 
        If (wParam & $FFFF) = #WA_INACTIVE 
          SetGadgetText(0,"Inaktiv")
        Else 
          SetGadgetText(0,"Aktiv")
        EndIf 
      EndIf 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

OpenWindow(0,0,0,400,300,"Hide Menu",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
CreateGadgetList(WindowID(0)) 
TextGadget(0, 10, 10,250,20,"") 

SetWindowCallback(@WindowProc()) 

HideWindow(0,0) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -