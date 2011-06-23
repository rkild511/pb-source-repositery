; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9130&highlight=
; Author: paulr (updated for PB4.00 by blbltheworm)
; Date: 13. January 2004
; OS: Windows
; Demo: No


; Diables all input to the parent window, while the second window is opened

If OpenWindow(1, 300, 300, 100, 100, "Window 1", #PB_Window_SystemMenu ) 
  If CreateGadgetList(WindowID(1)) 
    ButtonGadget(1, 20, 35, 80, 30, "Click")      
  EndIf 
EndIf 

Repeat 

  EventID.l = WaitWindowEvent() 

  If EventID = #PB_Event_Gadget 

    WindowId = EventWindow() 
    GadgetID = EventGadget() 
    
    If WindowId = 1 And GadgetID = 1 
    
      EnableWindow_(WindowID(1), #False) 

      If OpenWindow(2, 370, 370, 100, 100, "Window 2", 0, WindowID(1)) 
        If CreateGadgetList(WindowID(2)) 
          ButtonGadget(1, 20, 35, 80, 30, "Close") 
        EndIf 
      EndIf 

    EndIf 

    If WindowId = 2 And GadgetID = 1 
      EnableWindow_(WindowID(1), #True) 
      CloseWindow(2) 
    EndIf 

  EndIf 

Until EventID = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
