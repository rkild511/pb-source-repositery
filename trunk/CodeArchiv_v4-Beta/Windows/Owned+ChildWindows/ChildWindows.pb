; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No


; Window Constanten 
#Window  = 1 
#Frame1  = 2 
#Frame2  = 3 


; HauptFenster 
OpenWindow(#Window, 0, 0, 250, 400, "Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
CreateGadgetList(WindowID(#Window)) 

  ;Gadgets im Hauptfenster 
  ButtonGadget(1, 20, 20, 80, 20, "Frame1")  
  ButtonGadget(2, 120, 20, 80, 20, "Frame2") 


; Frame 1 
OpenWindow(#Frame1, 0, 50, 250, 300, "Frame1", #PB_Window_BorderLess) 
SetParent_(WindowID(#Frame1), WindowID(#Window))  ; Child Window 
CreateGadgetList(WindowID(#Frame1)) 
  
  ; Gadgets im Frame 1 
  Frame3DGadget(3, 10, 10, 100, 200, "Frame3d", 0) 
  ButtonGadget(4, 50, 250, 80, 20, "Button") 

; Frame 2 
OpenWindow(#Frame2, 0, 50, 250, 300, "Frame2", #PB_Window_BorderLess) 
SetParent_(WindowID(#Frame2), WindowID(#Window)) ; Child Window 
CreateGadgetList(WindowID(#Frame2))  

  ; Gadgets im Frame 2 
  StringGadget(5, 30, 30, 100, 20, "String") 
  Frame3DGadget(6, 30, 80, 100, 100, "Frame3d", 0) 


UseGadgetList(WindowID(#Window)) ; Gadgetlist fom Hauptfenster 

  ; weitere GAdgets im Hauptfenster 
  ButtonGadget(7, 150, 360, 80, 20, "Close Window") 


SetActiveWindow(#Frame1)   ; Frame1 wird zuerst angezeigt 
SetActiveWindow(#Window) 

; Loop 
Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 1: SetActiveWindow(#Frame1)   ; Frame 1 
                 SetActiveWindow(#Window)  
        Case 2: SetActiveWindow(#Frame2)   ; Frame 2 
                 SetActiveWindow(#Window) 
        Case 7: End 
      EndSelect 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger