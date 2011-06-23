; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1381&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 17. June 2003
; OS: Windows
; Demo: No

; Detect actual selected element in ListIcon and first selected element

Procedure SetGadgetStateLI(Gadget.l, State.l) 
  Protected a.l 
  For a = 0 To CountGadgetItems(Gadget) - 1 
    If a = State 
      SetGadgetItemState(Gadget, a, #PB_ListIcon_Selected) 
    Else 
      SetGadgetItemState(Gadget, a, 0) 
    EndIf 
  Next 
  SendMessage_(GadgetID(Gadget), #LVM_ENSUREVISIBLE, State, 1) 
EndProcedure 

Procedure GetGadgetStateLI(Gadget.l) 
  Protected a.l 
  For a = 0 To CountGadgetItems(Gadget) - 1 
    If GetGadgetItemState(Gadget, a) & #PB_ListIcon_Selected : ProcedureReturn a : EndIf 
  Next 
  ProcedureReturn -1 
EndProcedure 

If OpenWindow(0, 0, 0, 400, 700, "ListIcon-Choice", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    ListIconGadget(0, 0, 0, 400, 670, "Item", 396, #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_MultiSelect) 
    ButtonGadget(1, 0, 675, 400, 25, "Cursor / Choice") 
  EndIf 
  For a.l = 0 To 45 
    AddGadgetItem(0, a, "Item " + Str(a + 1)) 
  Next 
  Repeat 
    EventID.l = WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_CloseWindow 
        End 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 1 
            Cursor.l = GetGadgetState(0) 
            MessageRequester("Cursor", "Der Cursor ist auf dem Item #" + Str(Cursor + 1) + ".", 0) 
            Choice.l = GetGadgetStateLI(0) 
            MessageRequester("Markiert", "Das erste markierte Item ist #" + Str(Choice + 1) + ".", 0) 
        EndSelect 
    EndSelect 
  ForEver 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
