; German forum: http://www.purebasic.fr/german/viewtopic.php?t=746&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 03. November 2004
; OS: Windows
; Demo: No


; Show all running applications with their Icons + handle
; Zeige alle laufenden Applikationen mit ihren Icons + Handle

If OpenWindow(0, 0, 0, 550, 260, "Running Applications", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)

  If CreateGadgetList(WindowID(0))
    ListIconGadget(0, 10, 10, 530, 240, "Running Application", 415)
    AddGadgetColumn(0, 1, "Icon handle", 110)
    currWnd = GetWindow_(WindowID(0), #GW_HWNDFIRST)

    While currWnd <> 0
      txtLength = GetWindowTextLength_(currWnd)
      listItem$ = Space(txtLength + 1)
      txtLength = GetWindowText_(currWnd, listItem$, txtLength + 1)
      hIcon = GetClassLong_(currWnd, #GCL_HICON)
      If txtLength > 0 And hIcon > 0
        AddGadgetItem(0, -1, listItem$ + Chr(10) + Str(GetClassLong_(currWnd, #GCL_HICON)), hIcon)
      EndIf
      currWnd = GetWindow_(currWnd, #GW_HWNDNEXT)
    Wend

  EndIf

EndIf

Repeat

  Event = WaitWindowEvent()

Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -