; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm + Andre)
; Date: 22. November 2003
; OS: Windows
; Demo: No

#Window_0 = 0
#Gadget_0 = 0
#Gadget_2 = 1

Procedure WCB(wnd, Message, wParam, lParam)
  Result = #PB_ProcessPureBasicEvents
  Select Message
  Case #WM_GETMINMAXINFO
    GetWindowRect_(wnd,r.RECT)
    *pMinMax.MINMAXINFO = lParam
    *pMinMax\ptMinTrackSize\x=467
    *pMinMax\ptMinTrackSize\y=429
    *pMinMax\ptMaxTrackSize\x=GetSystemMetrics_(#SM_CXSCREEN)
    *pMinMax\ptMaxTrackSize\y=GetSystemMetrics_(#SM_CYSCREEN)
    Result = 0
  EndSelect
  ProcedureReturn Result
EndProcedure

Procedure Open_Window_0()
  If OpenWindow(#Window_0, 216, 0, 467, 402, "New window ( 0 )",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar|#PB_Window_MaximizeGadget |#PB_Window_MinimizeGadget  )
    SetWindowCallback(@WCB())
    If CreateGadgetList(WindowID(#Window_0))
      Frame3DGadget(#Gadget_0, 75, 80, 320, 250, "")
      TextGadget(#Gadget_2, 85, 150, 300, 70, "Minimalmaﬂe sollen bleiben"+Chr(13)+"Minimum size is set", #PB_Text_Center)
    EndIf
  EndIf
EndProcedure

Open_Window_0()
Repeat
  id=WaitWindowEvent()
  If id=#PB_Event_CloseWindow
    quit=1
  EndIf
Until quit=1
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP