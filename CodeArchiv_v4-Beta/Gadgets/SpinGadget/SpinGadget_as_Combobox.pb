; English forum:
; Author: ebs (updated for PB4.00 by blbltheworm)
; Date: 22. June 2003
; OS: Windows
; Demo: Yes

;GADGET IDs
#Spin0=0
;WINDOW ID
#Window1=0

Global Dim SpinList.s(4)

SpinList(0) = "Item Number One"
SpinList(1) = "Second Item"
SpinList(2) = "Item #3"
SpinList(3) = "4th Item"
SpinList(4) = "Item Five (last)"

;WINDOW
OpenWindow(#Window1,243,130,280,131,"Spin",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_TitleBar|#PB_Window_ScreenCentered)
CreateGadgetList(WindowID(#Window1))

SpinGadget(#Spin0,20,16,120,24,0,4)
SetGadgetText(#Spin0,SpinList(0))
WindowEvent()


;EVENT LOOP
Repeat
  EventID=WaitWindowEvent()
    Select EventID
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Spin0
            SetGadgetText(#Spin0,SpinList(GetGadgetState(#Spin0)))
            WindowEvent()
        EndSelect
    EndSelect
Until EventID=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP