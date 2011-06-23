; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Global hwnd.l,OldProc.l 
hInstance = GetModuleHandle_(0) 

Procedure ChildCallback(Window, Message, wParam, lParam) 
Result = CallWindowProc_(OldProc,Window,Message,wParam,lParam) 
Select Message 
Case #WM_CLOSE 
  DestroyWindow_(Window) 
EndSelect 
ProcedureReturn Result 
EndProcedure 

hwnd.l = OpenWindow(0, 0,0,640,480, "Ich habe ein Kindfenster", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
If hwnd 

Style.l = #WS_POPUP|#WS_CHILD|#WS_CLIPCHILDREN|#WS_VISIBLE|#WS_CAPTION|#WS_SYSMENU|#WS_MAXIMIZEBOX|#WS_MINIMIZEBOX 
Child.l = CreateWindowEx_(0,"#32770","Ich bin das Kind",Style,0,0,320,240,0,0,hInstance,0) 
OldProc = SetWindowLong_(Child,#GWL_WNDPROC,@ChildCallback()) 
SetParent_(Child,hwnd) 

  Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow  ; If the user has pressed on the close button 
      Quit = 1 
    EndIf 
  Until Quit = 1 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger