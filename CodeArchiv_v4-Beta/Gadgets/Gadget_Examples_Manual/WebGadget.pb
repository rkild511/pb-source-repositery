; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,600,300,"WebGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  WebGadget(0,10,10,580,280,"http://www.purebasic.com")
  ; Note: if you want to use a local file, change last parameter to "file://" + path + filename
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP