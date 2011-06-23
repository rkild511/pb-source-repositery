; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,250,105,"Disable/enable buttons...",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  ButtonGadget(0,10,15,230,30,"Disabled Button") : DisableGadget(0,1)
  ButtonGadget(1,10,60,230,30,"Enabled Button") : DisableGadget(1,0)
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP