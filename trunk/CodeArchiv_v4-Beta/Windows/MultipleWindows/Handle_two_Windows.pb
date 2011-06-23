; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6885&highlight=
; Author: ricardo (updated for PB4.00 by blbltheworm)
; Date: 12. July 2003
; OS: Windows
; Demo: Yes


; In resume there are 2 important things: 

; 1.- Check which window receives the #PB_Event_CloseWindow by using the EventWindowID()
; that let you know which one was. 

; 2.- The Gadgets of you additional windows must have different number ids from the
; ones of the main window, then it could be handled in the same event loop. 

Procedure AnotherWindow() 
  If OpenWindow(1,100,150,250,200,"OtherWindow",#PB_Window_SystemMenu) 
    CreateGadgetList(WindowID(1)) 
    ButtonGadget(11,100,100,50,25,"Test") 
  EndIf 
EndProcedure 


If OpenWindow(0,0,0,450,200,"Test",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ButtonGadget(1,150,100,150,25,"Open another window") 
  Repeat 
    EventID=WaitWindowEvent() 
    
    Select EventID 
      
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 1 
          AnotherWindow() 
        Case 11;The gadget from the other window must have DIFFERENT ids 
          MessageRequester("click","Button from 2nd window",0) 
      EndSelect 
    Case #PB_Event_CloseWindow 
      If EventWindow()= 1 ;Here you detect if the window to close is your additional window 
        CloseWindow(1) 
      Else 
        Quit = 1 
      EndIf 
  EndSelect 
  
Until Quit = 1 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
