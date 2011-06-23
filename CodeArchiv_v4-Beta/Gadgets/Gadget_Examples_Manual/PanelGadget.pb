; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 10. May 2003
; OS: Windows
; Demo: Yes

; Shows using of several panels...
If OpenWindow(0,0,0,322,220,"PanelGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  PanelGadget     (0,8,8,306,203)
    AddGadgetItem (0,-1,"Panel 1")
      PanelGadget (1,5,5,290,166)
        AddGadgetItem(1,-1,"Sub-Panel 1")
        AddGadgetItem(1,-1,"Sub-Panel 2")
        AddGadgetItem(1,-1,"Sub-Panel 3")
      CloseGadgetList()
    AddGadgetItem (0,-1,"Panel 2")
      ButtonGadget(1, 10, 15, 80, 24,"Button 1")
      ButtonGadget(2, 95, 15, 80, 24,"Button 2")
  CloseGadgetList()
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP