; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,270,140,"ComboBoxGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  ComboBoxGadget(0,10,10,250,100,#PB_ComboBox_Editable)
  AddGadgetItem(0,-1,"ComboBox editable...")
  ComboBoxGadget(1,10,40,250,100)
  For a=1 To 5 : AddGadgetItem(1,-1,"ComboBox item "+Str(a)) : Next
  SetGadgetState(1,2)    ; set (beginning with 0) the third item as active one
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP