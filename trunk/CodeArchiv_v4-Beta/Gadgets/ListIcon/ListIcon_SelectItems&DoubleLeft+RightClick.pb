; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13385&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 17. December 2004
; OS: Windows
; Demo: No

OpenWindow(0, 300, 300, 220, 250, "ListView Selected", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
CreateGadgetList(WindowID(0)) 
MyList.w = ListIconGadget(0, 10, 10, 200, 200, "Column 1", 180, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_GridLines | #PB_ListIcon_MultiSelect) 
For Row=0 To 20 
  AddGadgetItem(0,-1,"Row "+Str(Row)) 
Next 
Repeat 
  mess = WaitWindowEvent() 
  If EventType() = #PB_EventType_LeftClick And EventGadget() = 0 
    ; --> send a message to end the edit timer 
    SendMessage_(MyList, #LVM_EDITLABEL, -1, 0) 
    ;locate row that user just clicked 
    ListItem.w = SendMessage_(MyList, #LVM_GETNEXTITEM, -1, #LVNI_FOCUSED) 
    ; automated highlight row 1 thru 5 
    SetGadgetItemState(0, 1, 1) 
    SetGadgetItemState(0, 2, 1) 
    SetGadgetItemState(0, 3, 1) 
    SetGadgetItemState(0, 4, 1) 
    SetGadgetItemState(0, 5, 1) 
    ;refocus on row clicked above 
    SetGadgetItemState(0, ListItem, 1) 
  EndIf 
  ; --> Catch the double clicked row# 
  If EventType() = #PB_EventType_LeftDoubleClick And EventGadget() = 0 
    MessageRequester("Info", "Left DoubleClick on item #" + Str(ListItem), 0) 
    SetActiveGadget(0) 
  EndIf 
  ; --> Catch the right clicked row# 
  If EventType() = #PB_EventType_RightClick And EventGadget() = 0 
    ListItem.w = SendMessage_(MyList, #LVM_GETNEXTITEM, -1, #LVNI_FOCUSED) 
    MessageRequester("Info", "Right click on item #" + Str(ListItem), 0) 
    SetActiveGadget(0) 
  EndIf 
Until mess = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -