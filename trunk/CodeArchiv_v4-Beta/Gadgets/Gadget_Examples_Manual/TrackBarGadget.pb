; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,320,200,"CheckBoxGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  TextGadget    (3, 10, 20,250, 20,"TrackBar Standard",#PB_Text_Center)
  TrackBarGadget(0, 10, 40,250, 20,0,10000)
  SetGadgetState(0, 5000)
  TextGadget    (4, 10,100,250, 20,"TrackBar Ticks",#PB_Text_Center)
  TrackBarGadget(1, 10,120,250, 20,0,10000,#PB_TrackBar_Ticks)
  SetGadgetState(1, 3000)
  TextGadget    (5, 90,180,200, 20,"TrackBar Vertical",#PB_Text_Right)
  TrackBarGadget(2,270, 10, 20,170,0,10000,#PB_TrackBar_Vertical)
  SetGadgetState(2, 8000)
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP