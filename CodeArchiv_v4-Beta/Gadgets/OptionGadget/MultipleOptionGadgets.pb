; www.PureArea.net
; Author: Andre Beer
; Date: 15. November 2005
; OS: Windows
; Demo: Yes

  If OpenWindow(0,0,0,300,110,"OptionGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
   ContainerGadget(0,10,10,100,100)
    OptionGadget(1, 10, 10, 80, 20, "Option1 - 1")
    OptionGadget(2, 10, 35, 80, 20, "Option1 - 2")
    OptionGadget(3, 10, 60, 80, 20, "Option1 - 3")
   CloseGadgetList()
   
   ContainerGadget(4,140,10,100,100)
    OptionGadget(5, 10, 10, 80, 20, "Option2 - 1")
    OptionGadget(6, 10, 35, 80, 20, "Option2 - 2")
    OptionGadget(7, 10, 60, 80, 20, "Option2 - 3")
   CloseGadgetList()
    
    SetGadgetState(1,1)   ; wir setzen die zweite Option als aktiv
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
  EndIf


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP