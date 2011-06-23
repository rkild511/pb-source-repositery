; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9004&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 05. January 2004
; OS: Windows
; Demo: No

#Gadget_EC = 1 

OpenWindow(0,0,0,500,300,"",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  TrackBarGadget(#Gadget_EC, 250, 230, 80, 20, 0, 1, #PB_TrackBar_Ticks) 
  SetGadgetState(#Gadget_EC, 0) 
  ButtonGadget(2,10,10,100,20,"Button") 

loaded=#False 
Quit=#False 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #Gadget_EC 
          SetFocus_(WindowID(0)) 
      EndSelect 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
