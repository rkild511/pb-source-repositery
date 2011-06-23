; www.PureArea.net
; Author: Andre Beer / PureBasic Team (updated for PB 4.00 by Andre)
; Date: 28. February 2004
; OS: Windows
; Demo: Yes

If OpenWindow(0, 0, 0, 150, 25, "ToolBar", #PB_Window_SystemMenu |#PB_Window_ScreenCentered)
  CreateImage(0,16,16)
  StartDrawing(ImageOutput(0))
  Box(0,0,16,16,RGB(255,255,255))
  Box(4,4,8,8,RGB(255,0,0))
  StopDrawing()
  CreateImage(1,16,16)
  StartDrawing(ImageOutput(1))
  Box(0,0,16,16,RGB(255,0,0))
  Box(4,4,8,8,RGB(255,255,255))
  StopDrawing()
  If CreateToolBar(0, WindowID(0))
    ToolBarImageButton(0,ImageID(0))
    ToolBarImageButton(1,ImageID(1))
  EndIf
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger