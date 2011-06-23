; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 01. May 2003
; OS: Windows
; Demo: Yes

  If OpenWindow(3, 0, 244, 400, 369, "Wizard",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_WindowCentered ) 
    If CreateGadgetList(WindowID(3)) 
      ButtonGadget(308,20,100,300,20,"Klicke hier für den Text des ComboBoxgadgets") 
      ComboBoxGadget(309, 120, 190, 200, 160) 
        AddGadgetItem(309,-1,"eins") 
        AddGadgetItem(309,-1,"zwei") 
        AddGadgetItem(309,-1,"drei") 
        AddGadgetItem(309,-1,"vier") 
        AddGadgetItem(309,-1,"fünf") 
        AddGadgetItem(309,-1,"sechs") 
        AddGadgetItem(309,-1,"sieben") 
        SetGadgetState(309,0) 
      
      Repeat 
        eventID3.l=WaitWindowEvent() 
        Select eventID3 
          Case #PB_Event_Gadget 
            Select EventGadget() 
              Case 308 
                MessageRequester("test",GetGadgetText(309),#PB_MessageRequester_Ok) 
            EndSelect 
          Case #PB_Event_CloseWindow 
            closewin3=1  
        EndSelect 
      Until closewin3 
      CloseWindow(3) 
    EndIf 
  EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP