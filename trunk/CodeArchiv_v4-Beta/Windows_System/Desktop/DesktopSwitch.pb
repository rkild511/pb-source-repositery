; www.PureArea.net
; Author: DNA
; Date: 14. December 2006
; OS: Windows
; Demo: No


; Written and tested on WinXP Home

Enumeration
  #Window_0
  #List_DesktopName
EndEnumeration

;Auflisten der Desktops, zu denen auch gewechselt werden kann
;Aufruf durch: EnumDesktops_(GetProcessWindowStation_(), @EnumDesktopProc(), 0)
Procedure EnumDesktopProc(lpszDesktop.l, lParam.l)
  Protected Buffer.s = Space(lstrlen_(lpszDesktop))
  
  RtlMoveMemory_(@Buffer, lpszDesktop, lstrlen_(lpszDesktop))
  hDesktop = OpenDesktop_(Buffer, 0, #False, #DESKTOP_SWITCHDESKTOP)
  
  If hDesktop <> 0
    AddGadgetItem(#List_DesktopName, 0, Buffer)
    CloseDesktop_(hDesktop)
  Else
    Debug Buffer + " - nicht verfügbar, aber vorhanden"
  EndIf
  ProcedureReturn #True
EndProcedure

If OpenWindow(#Window_0, 0, 0, 200, 300, "Desktop Switcher", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  If CreateGadgetList(WindowID(#Window_0))
    ListViewGadget(#List_DesktopName, 10, 10, 180, 280)
  EndIf

  EnumDesktops_(GetProcessWindowStation_(), @EnumDesktopProc(), 0)

  Repeat
    Event = WaitWindowEvent()
    EventType = EventType()
    EventGadget = EventGadget()
    If EventType = #PB_EventType_LeftDoubleClick And EventGadget = #List_DesktopName
      hDesktop = OpenDesktop_(GetGadgetText(#List_DesktopName), 0, #False, #DESKTOP_SWITCHDESKTOP)
        SetThreadDesktop_(hDesktop)
        SwitchDesktop_(hDesktop)
        TerminateThread_(GetThreadDesktop_(GetCurrentThreadId_()), 0)
        CloseDesktop_(hDesktop)
      CloseDesktop_(hDesktop)
    ElseIf Event = #PB_Event_ActivateWindow
      ClearGadgetItemList(#List_DesktopName)
      EnumDesktops_(GetProcessWindowStation_(), @EnumDesktopProc(), 0)
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; Executable = DeskSwitch.exe
; DisableDebugger