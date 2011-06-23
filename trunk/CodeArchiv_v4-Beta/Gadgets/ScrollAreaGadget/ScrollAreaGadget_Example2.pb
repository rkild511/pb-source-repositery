; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2410&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 29. September 2003
; OS: Windows
; Demo: No

Procedure ScrollbarX() 
  ProcedureReturn GetSystemMetrics_(#SM_CXHSCROLL) 
EndProcedure 

Procedure ScrollbarY() 
  ProcedureReturn GetSystemMetrics_(#SM_CYVSCROLL) 
EndProcedure 


If OpenWindow (1,100,150,500,500,"test",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(1)) 
  ScrollAreaGadget(0,20,20,460,460,460-ScrollbarX(),1000,155) 
    ButtonGadget(1,0,  0  ,50,20,"Button 1") 
    ButtonGadget(3,0,980-4,50,20,"Button 3") 
    ButtonGadget(2,410-ScrollbarX()-4,  0  ,50,20,"Button 2")    ; '-4' is used because of the gadget border
    ButtonGadget(4,410-ScrollbarX()-4,980-4,50,20,"Button 4")     ;    - " -
  CloseGadgetList() 
EndIf 
; 
Repeat: Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
