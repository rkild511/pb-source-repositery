; www.PureArea.net
; Author: Andre Beer / PureBasic Team (updated for PB 4.00 by Andre)
; Date: 28. February 2004
; OS: Windows
; Demo: Yes

If OpenWindow(0, 0, 0, 150, 60, "ToolBar", #PB_Window_SystemMenu |#PB_Window_ScreenCentered)
  If CreateToolBar(0, WindowID(0))
    ToolBarStandardButton(0, #PB_ToolBarIcon_New)
    ToolBarStandardButton(1, #PB_ToolBarIcon_Open)
    ToolBarStandardButton(2, #PB_ToolBarIcon_Save)
    ToolBarToolTip(0, 0, "New document")
    ToolBarToolTip(0, 1, "Open file")
    ToolBarToolTip(0, 2, "Save file")
  EndIf
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger