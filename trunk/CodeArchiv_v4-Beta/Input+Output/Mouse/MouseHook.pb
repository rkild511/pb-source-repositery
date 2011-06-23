; English forum:
; Author: Unknown
; Date: 21. January 2003
; OS: Windows
; Demo: No

Global hhook
Procedure MouseProc(nCode, wParam, lParam)
  *ms.MOUSEHOOKSTRUCT = lParam
  SetGadgetText(0, "x: "+Str(*ms\pt\x))
  SetGadgetText(1, "y: "+Str(*ms\pt\y))
  If wParam = #WM_RBUTTONUP ; 205h
    result = 1
    MessageRequester("Message", "Right button up hooked", 0)
  Else
    result = 0
  EndIf
  ProcedureReturn result
EndProcedure
hInstance = GetModuleHandle_(0)
If OpenWindow(0, 0, 0, 300, 200, "Mouse hook example", #PB_Window_SystemMenu)
  WindowID = WindowID(0)
  If CreateGadgetList(WindowID)
    TextGadget(0, 4, 4, 48, 24, "x: ")
    TextGadget(1, 4, 32, 48, 24, "y: ")
  EndIf
  lpdwProcessId = GetWindowThreadProcessId_(WindowID, 0)
  hhook = SetWindowsHookEx_(#WH_MOUSE, @MouseProc(), hInstance, lpdwProcessId)
  Repeat
    EventID = WaitWindowEvent()
  Until EventID = #PB_Event_CloseWindow
EndIf
UnhookWindowsHookEx_(hhook)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -