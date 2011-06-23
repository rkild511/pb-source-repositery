; www.purearea.net
; Author: Art Sentinel (updated for PB4.00 by blbltheworm)
; Date: 29. July 2002
; OS: Windows
; Demo: No

;Art Sentinel, July 29, 2002
;HUGE thanks to El_Choni!
;Using PureBasic 3.20 (current)

;Initialize Environments
;empty for now..

;Set Variables and Constants
Global hhook.l
Global myRightClick.s
#WinW=760
#WinH=500
WinX.w=(GetSystemMetrics_(#SM_CXSCREEN)-#WinW)/2 ; Window centered horizontally.
WinY.w=(GetSystemMetrics_(#SM_CYSCREEN)-#WinH)/2 ; Window centered vertically.

;Declare Procedures
Procedure MouseProc(nCode, wParam, lParam)
  
  If wParam = #WM_RBUTTONDOWN ;Most ActiveX components are set to process the right-mousedown event.
    ;If you use #WM_RBUTTONUP, you will see a brief flash of the component's
    ;r-click menu before PureBasic processes the hooked. By using #WM_RBUTTONDOWN
    ;you do not allow the web page components to access the click event at all.
    result.b = 1
    myRightClick = "Disabled"
    
  Else
    
    result.b = 0
    
  EndIf
  
  ProcedureReturn result
  
EndProcedure

;Open Window and center it on screen
hInstance = GetModuleHandle_(0)

If OpenWindow(0, WinX, WinY, 760, 500, "Browser Test", #PB_Window_SystemMenu)
  
  WindowID = WindowID(0)
  
  ;Open Browser Gadget
  If CreateGadgetList(WindowID(0))
    
    WebGadget(0, 1, 1, 758, 498, "www.purearea.net")
    
  EndIf
  
  lpdwProcessId = GetWindowThreadProcessId_(WindowID, 0)
  hhook = SetWindowsHookEx_(#WH_MOUSE, @MouseProc(), hInstance, lpdwProcessId)
  
EndIf

;Main loop
Repeat
  
  EventID = WaitWindowEvent()
  
Until EventID = #PB_Event_CloseWindow

;Finish up
UnhookWindowsHookEx_(hhook)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -