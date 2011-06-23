; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,140,110,"OptionGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  OptionGadget(0, 30, 20, 60, 20, "Option 1")
  OptionGadget(1, 30, 45, 60, 20, "Option 2")
  OptionGadget(2, 30, 70, 60, 20, "Option 3")
  SetGadgetState(1,1)   ; set second option as active one
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP