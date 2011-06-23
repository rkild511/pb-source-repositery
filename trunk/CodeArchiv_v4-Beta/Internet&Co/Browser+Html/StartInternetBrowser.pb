; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3113&highlight=
; Author: Rob (updated for PB4.00 by blbltheworm)
; Date: 12. December 2003
; OS: Windows
; Demo: Yes

#win = 0 
win=OpenWindow(#win,0,0,220,70,"Window",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

CreateGadgetList(win) 
ButtonGadget(0,80,40,50,25,"Browse") 
StringGadget(1,10,10,200,20,"http://www.robsite.de") 


Repeat 
  EventID = WaitWindowEvent() 
  
  Select EventID 
    Case #PB_Event_Gadget 
      
      Select EventGadget() 
        Case 0 
          RunProgram(GetGadgetText(1)) 

        
        
      EndSelect 
      
  EndSelect 

Until EventID = #PB_Event_CloseWindow 

CloseWindow(#win) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
