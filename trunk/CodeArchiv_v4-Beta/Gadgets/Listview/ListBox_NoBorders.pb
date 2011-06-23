; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2904&postdays=0&postorder=asc&start=10
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 30. November 2003
; OS: Windows
; Demo: No

Global hwnd.l,LV.l
Global ReUsableBrush.l

Procedure SetColor(TxtColor,wParam,lParam)
  If ReUsableBrush
    DeleteObject_(ReUsableBrush)
  EndIf
  ReUsableBrush = CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE))
  SetBkMode_(wParam, #TRANSPARENT)
  SetTextColor_(wParam,TxtColor)
  Result = ReUsableBrush
  ProcedureReturn Result
EndProcedure

Procedure WindowCallback(WindowID, message, wParam, lParam)
  Result = #PB_ProcessPureBasicEvents
  Select message
  Case #WM_CTLCOLORLISTBOX
    Result = SetColor(RGB(0,0,255),wParam,lParam)
  EndSelect
  ProcedureReturn Result
EndProcedure

If OpenWindow(0,0,0,270,140,"Listbox ohne Scrollbalken",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  hwnd = WindowID(0)
  LV = CreateWindowEx_(0,"Listbox","",#WS_CHILD|#WS_VISIBLE|#LBS_NOTIFY   ,10,10,200,120,WindowID(0),0,GetModuleHandle_(0),0)
  SendMessage_(LV,#WM_SETFONT,GetStockObject_(#DEFAULT_GUI_FONT),1)
  For a = 1 To 100
    SendMessage_(LV,#LB_ADDSTRING,0,"Item "+Str(a)+" vom Listview")
  Next
  SetWindowCallback(@WindowCallback())
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
