; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13454&highlight= 
; Author: Sparkie (updated for PB 4.00 by Andre + edel) 
; Date: 23. December 2004 
; OS: Windows 
; Demo: No 

; Dynamically expanding combobox 
; make a combobox expand whilst it is being clicked so that the dropdown 
; menu is long enough to show data that is longer that the actual combobox.. 

If OpenWindow(0, 0, 0, 270, 240, "Resizable ComboBoxGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  TextGadget(0, 10, 10, 100, 20, "Items to view") 
  StringGadget(1, 120, 10, 50, 20, "8", #PB_String_Numeric) 
  ComboBoxGadget(2, 10, 40, 250, 100, #CBS_NOINTEGRALHEIGHT); -- Add #CBS_NOINTEGRALHEIGHT flag For WinXP 
  ; --> Get 3d border height 
  vEdge = GetSystemMetrics_(#SM_CYEDGE) 
  ; --> Number of items to view 
  itemsToView = Val(GetGadgetText(1)) 
  ; --> Get height of ComboBox selection field 
  cbSelectedItemHeight = SendMessage_(GadgetID(2), #CB_GETITEMHEIGHT, -1, 0) 
  ; --> get height of ComboBox item 
  cbListItemHeight = SendMessage_(GadgetID(2), #CB_GETITEMHEIGHT, 0, 0) 
  ; -- Resize adding 4 units of vEdge (2 for selection field and 2 for dropdown) 
  ResizeGadget(2, #PB_Ignore, #PB_Ignore, #PB_Ignore, cbSelectedItemHeight + (cbListItemHeight * itemsToView) + vEdge*4) 
  For a = 1 To 29 
    AddGadgetItem(2, -1, "ComboBox item " + Str(a)) 
  Next 
  Repeat 
    event = WaitWindowEvent() 
    If event = #PB_Event_Gadget And EventGadget() = 1 
      itemsToView = Val(GetGadgetText(1)) 
      If itemsToView > 0 And itemsToView < CountGadgetItems(2)+1 
        ResizeGadget(2, #PB_Ignore, #PB_Ignore, #PB_Ignore, cbSelectedItemHeight + (cbListItemHeight * itemsToView) + vEdge*4)  
      Else 
        MessageRequester("Error", "enter a number between 1 and " + Str(CountGadgetItems(2)), 0) 
        SetGadgetText(1, "8") 
      EndIf 
    EndIf 
  Until event = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP