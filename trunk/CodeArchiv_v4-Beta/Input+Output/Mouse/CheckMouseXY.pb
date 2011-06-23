; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: Yes

If OpenWindow(1, 100, 100, 80, 80, "Fenster 1", #PB_Window_SystemMenu) 

   CreateGadgetList(WindowID(1)) 
   TextGadget(1,20,20,100,13,"") 


   If OpenWindow(2, 250, 100, 80, 80, "Fenster 2", #PB_Window_SystemMenu) 

      CreateGadgetList(WindowID(2)) 
      TextGadget(11,20,20,100,13,"") 


      Repeat 

         EventID.l = WaitWindowEvent() 

         SetGadgetText( 1,"x: "+Str(WindowMouseX(2))+", y: "+Str(WindowMouseY(2))) 
         SetGadgetText(11,"x: "+Str(WindowMouseX(2))+", y: "+Str(WindowMouseY(2))) 

      Until EventID=#PB_Event_CloseWindow 
      CloseWindow(2) 

      Repeat 

         EventID.l = WaitWindowEvent() 

         SetGadgetText( 1,"x: "+Str(WindowMouseX(2))+", y: "+Str(WindowMouseY(2))) 
         SetGadgetText(11,"x: "+Str(WindowMouseX(2))+", y: "+Str(WindowMouseY(2))) 

      Until EventID=#PB_Event_CloseWindow 

      
      If OpenWindow(3, 100, 250, 80, 80, "Fenster 3", #PB_Window_SystemMenu) 

         CreateGadgetList(WindowID(3)) 
         TextGadget(11,20,20,100,13,"") 

         Repeat 

            EventID.l = WaitWindowEvent() 

            SetGadgetText( 1,"x: "+Str(WindowMouseX(3))+", y: "+Str(WindowMouseY(3))) 
            SetGadgetText(11,"x: "+Str(WindowMouseX(3))+", y: "+Str(WindowMouseY(3))) 

         Until EventID=#PB_Event_CloseWindow 
      
      EndIf 


   EndIf 

EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger