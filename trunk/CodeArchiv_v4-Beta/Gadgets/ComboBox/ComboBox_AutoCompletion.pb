; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7269&highlight=
; Author: ebs (updated for PB4.00 by blbltheworm)
; Date: 23. August 2003
; OS: Windows
; Demo: No

#NONE = -1 

;- autocomplete specified combobox 
Procedure AutocompleteComboBox(ComboBox.l) 
  Shared LenTextSave.l 
  Shared GadgetSave.l 

  ; get text entered by user 
  TextTyped.s = UCase(GetGadgetText(ComboBox)) 
  LenTextTyped.l = Len(TextTyped) 
  
  ; skip if same gadget and same length or shorter text (backspace?) 
  If ComboBox = GadgetSave And LenTextTyped <= LenTextSave 
    LenTextSave = LenTextTyped 
  ElseIf LenTextTyped 
    GadgetSave = #NONE 
    ; search combo contents for item that starts with text entered 
    MaxItem.l = CountGadgetItems(ComboBox) - 1 
    For Item.l = 0 To MaxItem 
      If TextTyped = UCase(Left(GetGadgetItemText(ComboBox, Item, 0), LenTextTyped)) 
        ; found matching item 
        ; set combo state 
        SetGadgetState(ComboBox, Item) 
        ; select added text only 
        hComboEdit.l = ChildWindowFromPoint_(GadgetID(ComboBox), 5, 5) 
        SendMessage_(hComboEdit, #EM_SETSEL, LenTextTyped, -1) 
        ; save gadget number and text length for next pass 
        LenTextSave = LenTextTyped 
        GadgetSave = ComboBox 
        ; exit For loop 
        Item = MaxItem 
      EndIf 
    Next 
  EndIf 
EndProcedure 

If OpenWindow(0, 0, 0, 300, 300, "Autocompletion", #PB_Window_SystemMenu|#PB_Window_TitleBar) 
  If CreateGadgetList(WindowID(0)) 
    ComboBoxGadget(0, 10, 10, 200, 100, #PB_ComboBox_Editable) 
    AddGadgetItem(0, -1, "Autocomplete") 
    AddGadgetItem(0, -1, "Bernard") 
    AddGadgetItem(0, -1, "Car") 
    AddGadgetItem(0, -1, "Explorer") 
    AddGadgetItem(0, -1, "Fantastic") 
    AddGadgetItem(0, -1, "General protection error") 
    AddGadgetItem(0, -1, "Purebasic") 
    AddGadgetItem(0, -1, "Purepower") 
    AddGadgetItem(0, -1, "Purevisual") 
    AddGadgetItem(0, -1, "Question") 
    AddGadgetItem(0, -1, "Zas") 
  EndIf 
EndIf 

Repeat 
  Event = WaitWindowEvent() 
  Select Event 
    Case #PB_Event_Gadget 
      If EventGadget() = 0 
        AutocompleteComboBox(0) 
      EndIf 
  EndSelect 
Until Event = #PB_Event_CloseWindow 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
