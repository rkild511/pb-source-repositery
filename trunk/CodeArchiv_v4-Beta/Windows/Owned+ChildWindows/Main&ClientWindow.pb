; German forum: http://www.purebasic.fr/german/viewtopic.php?t=901&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 16. November 2004
; OS: Windows
; Demo: No


Procedure Win1(value) 
  OpenWindow(1,0,0,400,200,"Child",#PB_Window_SystemMenu|#PB_Window_WindowCentered,WindowID(0)) 
    CreateGadgetList(WindowID(1)) 
    ButtonGadget(1,290,170,100,20,"Schließen") 
  
  ; HauptFenster de-aktivieren 
  EnableWindow_(WindowID(0),0) 

  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_CloseWindow 
        If EventWindow() = 1 ; Child schliessen 
          close = 1 
        EndIf 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 1               ; Child schliessen 
            close = 1 
        EndSelect 
    EndSelect 
  Until close 

  ; HauptFenster re-aktivieren 
  EnableWindow_(WindowID(0),1) 

EndProcedure 


OpenWindow(0,0,0,300,300,"Hauptfenster",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  ButtonGadget(0,10,10,100,20,"Fenster öffnen") 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      If EventWindow() = 0 ; Hauptfenster schliessen 
        Break 
      EndIf 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 0 
          CreateThread(@Win1(),0) 
      EndSelect 
  EndSelect 
ForEver
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP