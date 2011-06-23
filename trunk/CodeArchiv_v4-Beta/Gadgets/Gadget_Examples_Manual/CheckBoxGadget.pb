; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,270,130,"CheckBoxGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  CheckBoxGadget(0,10, 10,250,20,"CheckBox standard")
  CheckBoxGadget(1,10, 40,250,20,"CheckBox checked") : SetGadgetState(1,1)
  CheckBoxGadget(2,10, 70,250,20,"CheckBox right", #PB_CheckBox_Right)
  CheckBoxGadget(3,10,100,250,20,"CheckBox center", #PB_CheckBox_Center)
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP