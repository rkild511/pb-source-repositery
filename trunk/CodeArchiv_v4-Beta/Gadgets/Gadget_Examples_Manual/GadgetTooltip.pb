; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,270,100,"GadgetTooltip",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  ButtonGadget(0,10,30,250,30,"Button with Tooltip")
  GadgetToolTip(0,"Tooltip for Button")
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP