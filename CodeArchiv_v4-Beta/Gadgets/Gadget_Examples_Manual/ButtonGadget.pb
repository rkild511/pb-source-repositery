; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

; Shows possible flags of ButtonGadget in action...
If OpenWindow(0,0,0,222,200,"ButtonGadgets",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  ButtonGadget(0, 10, 10, 200, 20, "Standard Button")
  ButtonGadget(1, 10, 40, 200, 20, "Left Button", #PB_Button_Left)
  ButtonGadget(2, 10, 70, 200, 20, "Right Button", #PB_Button_Right)
  ButtonGadget(3, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Button_MultiLine)
  ButtonGadget(4, 10,170, 200, 20, "Toggle Button", #PB_Button_Toggle)
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP