; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8741&highlight=
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 04. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,216,150,178,108,"Click an item and enter any text in the stringgadget below.",#PB_Window_SystemMenu)
  If CreateGadgetList(WindowID(0))
    ListViewGadget(0,10,10,160,60)
    StringGadget(1,10,80,160,20,"")
      AddGadgetItem(0,-1,"Hello")
      AddGadgetItem(0,-1,"this")
      AddGadgetItem(0,-1,"is")
      AddGadgetItem(0,-1,"a")
      AddGadgetItem(0,-1,"test")
    
    Repeat
      event=WaitWindowEvent()
        If event=#PB_Event_Gadget
          Select EventGadget()
            Case 0
              SetGadgetText(1,GetGadgetText(0))
            Case 1
              item=GetGadgetState(0)
              SetGadgetItemText(0,item,GetGadgetText(1),0)
              SetGadgetState(0,item)
          EndSelect
        EndIf
    Until event=#PB_Event_CloseWindow
   
  EndIf
EndIf


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
