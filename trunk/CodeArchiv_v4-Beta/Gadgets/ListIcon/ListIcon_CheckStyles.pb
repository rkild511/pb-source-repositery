; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2265&postdays=0&postorder=asc&start=10
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 14. September 2003
; OS: Windows
; Demo: No

#LVM_FIRST = $1000 
#LVM_GETEXTENDEDLISTVIEWSTYLE = (#LVM_FIRST + 55) 

Procedure GETEXTENDEDLISTVIEWSTYLE(gadget) 
  ProcedureReturn SendMessage_(GadgetID(gadget),#LVM_GETEXTENDEDLISTVIEWSTYLE,0,0) 
EndProcedure 

OpenWindow(0,0,0,400,400,"Da Style",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  ListIconGadget(1,  0,  0,200,200,"1",196) 
  ListIconGadget(2,200,  0,200,200,"2",196,#PB_ListIcon_CheckBoxes) 
  ListIconGadget(3,  0,200,200,200,"3",196,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect) 
  ListIconGadget(4,200,200,200,200,"4",196,#PB_ListIcon_MultiSelect|#PB_ListIcon_HeaderDragDrop) 

  For i = 1 To 4 
    For j = 1 To 20 
      AddGadgetItem(i,-1,"ListIcon "+Str(i)+", Entry "+Str(j)) 
    Next j 
  Next i 

  Debug GETEXTENDEDLISTVIEWSTYLE(1) 
  Debug GETEXTENDEDLISTVIEWSTYLE(2) 
  Debug GETEXTENDEDLISTVIEWSTYLE(3) 
  Debug GETEXTENDEDLISTVIEWSTYLE(4) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
