; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8999&highlight=
; Author: srod (updated for PB4.00 by blbltheworm)
; Date: 03. January 2004
; OS: Windows
; Demo: Yes


; The procedure governing the second window has its own eventloop for simplicity.
; I find it easier to keep a track of things this way.
Enumeration 
  #MainWindow 
  #SecondWindow 
EndEnumeration 

Enumeration 
  #Button1 
  #Button2 
  #Button3 
EndEnumeration 


Procedure SecondWindow() 
;The following OpenWindow() command uses the parentID paramater (see help file) which, together 
;with the corresponding event loop, forces this to be a Modal form. 
  OpenWindow(#SecondWindow,175,0,639,243,"Second Window",#PB_Window_SystemMenu|#PB_Window_TitleBar|#PB_Window_MinimizeGadget |#PB_Window_ScreenCentered, WindowID(#MainWindow)) 

  Repeat 
    EventID=WaitWindowEvent() 
  Until EventID=#PB_Event_CloseWindow And EventWindow() = #SecondWindow; Make sure the correct window is being closed! 
  CloseWindow(#SecondWindow) 
EndProcedure 


OpenWindow(#MainWindow,0,0,600,600,"", #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
CreateGadgetList(WindowID(#MainWindow)) 

;Add a couple of buttons. 
ButtonGadget(#Button1,320,116,125,30,"2nd Window") 
ButtonGadget(#Button2,320,156,125,30,"HIDE") 


;Main event loop. 
  Repeat 
    EventID=WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case #Button1; Bring up 2nd window. 
            SecondWindow() 
          Case #Button2; Hide first window and bring up 2nd window. 
            HideWindow(#MainWindow,1) 
            SecondWindow() 
            HideWindow(#MainWindow,0) 
        EndSelect 
    EndSelect 
  Until EventID=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
