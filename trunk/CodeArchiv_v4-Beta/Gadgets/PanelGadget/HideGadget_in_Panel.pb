; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3048&highlight=
; Author: CS2001 (updated for PB4.00 by blbltheworm)
; Date: 07. December 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,322,220,"PanelTest",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  PanelGadget     (0,8,8,306,175) 
  AddGadgetItem (0,-1,"Panel 1") 
  ButtonGadget(1, 10, 15, 80, 24,"Button in Panel") 
  AddGadgetItem (0,-1,"Panel 2") 
  CloseGadgetList() 
  ButtonGadget(2, 10, 190, 80, 24,"Button") 
  Repeat 
    WinEvent.l = WaitWindowEvent() 
    If WinEvent = #PB_Event_Gadget 
      Select EventGadget() 
        Case 1 
          HideGadget(1, 1) 
          SetGadgetState(0,GetGadgetState(0)) 
        Case 2 
          HideGadget(2, 1)  
      EndSelect 
    EndIf 
  Until WinEvent.l =#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
