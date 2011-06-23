; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,180,50,"IPAddressGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  IPAddressGadget(0, 10, 15, 160, 20)
  SetGadgetState(0,MakeIPAddress(127,0,0,1))   ; set a valid ip address
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP