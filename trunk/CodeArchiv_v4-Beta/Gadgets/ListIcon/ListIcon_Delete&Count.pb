; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=26011#26011
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 30. December 2003
; OS: Windows
; Demo: No

Procedure ListIcon_DeleteColumn(gadget,item) 
  ProcedureReturn SendMessage_(GadgetID(gadget),#LVM_DELETECOLUMN,item,0) 
EndProcedure 

Procedure ListIcon_GetColumnCount(gadget) 
  col.LV_COLUMN\mask = #LVCF_WIDTH 
  Repeat 
    a+1:x=SendMessage_(GadgetID(gadget),#LVM_GETCOLUMN,a,@col) 
  Until x = 0 
  ProcedureReturn a 
EndProcedure 

OpenWindow(0,0,0,300,100,"",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  ListIconGadget(1,0,0,300,100,"1", 100) 
    AddGadgetColumn(1,1,"2", 80) 
    AddGadgetColumn(1,2,"3", 80) 
    AddGadgetColumn(1,3,"4", 80) 

  Debug ListIcon_GetColumnCount(1) 
  
  ListIcon_DeleteColumn(1,1) 
  ListIcon_DeleteColumn(1,1) 

  Debug ListIcon_GetColumnCount(1) 
  
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
