; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,320,250,"Frame3DGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  Frame3DGadget(0,10, 10,300,50,"Frame3DGadget Standard")
  Frame3DGadget(1,10, 70,300,50,"Frame3DGadget Single",#PB_Frame3D_Single)
  Frame3DGadget(2,10,130,300,50,"Frame3DGadget Double",#PB_Frame3D_Double)
  Frame3DGadget(3,10,190,300,50,"Frame3DGadget Flat",#PB_Frame3D_Flat)
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP