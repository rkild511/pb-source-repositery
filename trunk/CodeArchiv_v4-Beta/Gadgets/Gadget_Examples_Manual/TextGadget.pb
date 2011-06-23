; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,270,160,"TextGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  TextGadget(0, 10, 10,250,20,"TextGadget Standard (Left)")
  TextGadget(1, 10, 70,250,20,"TextGadget Center",#PB_Text_Center)
  TextGadget(2, 10, 40,250,20,"TextGadget Right",#PB_Text_Right)
  TextGadget(3, 10,100,250,20,"TextGadget Border",#PB_Text_Border)
  TextGadget(4, 10,130,250,20,"TextGadget Center + Border",#PB_Text_Center|#PB_Text_Border)
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP