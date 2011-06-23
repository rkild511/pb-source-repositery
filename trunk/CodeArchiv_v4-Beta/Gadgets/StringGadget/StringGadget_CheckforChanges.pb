; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2314&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 17. September 2003
; OS: Windows
; Demo: No

OpenWindow(0,0,0,200,100,"String",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  StringGadget(1,10,10,180,20,"String") 
  
Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow : End 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 1 ; Gadget 1 
          If EventType() = #PB_EventType_Change 
            Beep_(800,10) 
          EndIf 
      EndSelect 
  EndSelect 
ForEver 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
