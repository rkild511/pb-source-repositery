; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No


OpenWindow(1,0,0,300,300,"PB Test",#PB_Window_BorderLess|#PB_Window_ScreenCentered) 
   CreateGadgetList(WindowID(1)) 
   ButtonGadget(0,260,0,40,15,"Close") 
   ButtonGadget(1,200,0,60,15,"Minimize") 

Repeat 
   Event = WaitWindowEvent() 
   Select Event 
     Case #PB_Event_CloseWindow : End 
     Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 0 
               End 
          Case 1 
               ShowWindow_(WindowID(1),#SW_MINIMIZE) 
        EndSelect 
   EndSelect 
ForEver 

; Anstatt ButtonGadgets nimmst Du dann halt ButtonImageGadget() 
; und ein paar schoene Bilder fuer die Buttons...

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger