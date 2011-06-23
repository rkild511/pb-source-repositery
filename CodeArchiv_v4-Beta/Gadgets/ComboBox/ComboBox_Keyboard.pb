; English forum:
; Author: Chose/ElChoni (updated for PB4.00 by blbltheworm)
; Date: 02. November 2002
; OS: Windows
; Demo: No


If OpenWindow(0,(GetSystemMetrics_(#SM_CXSCREEN)-300)/2,(GetSystemMetrics_(#SM_CYSCREEN)-300)/2,300,300, "ComboBoxGadget-Test",#PB_Window_MinimizeGadget)
  If CreateGadgetList(WindowID(0))
    TextGadget(3,5,40,200,17,"Hello")
    StringGadget(5, 5, 65, 200, 20, "testing TAB")
    ComboBoxGadget(4, 5, 5, 100, 120, #PB_ComboBox_Editable) 
      AddGadgetItem(4, -1, "Apples")
      AddGadgetItem(4, -1, "Bannas")
      AddGadgetItem(4, -1, "Cheries")
      AddGadgetItem(4, -1, "Grapes")
      AddGadgetItem(4, -1, "Pears")
  EndIf
  AddKeyboardShortcut(0, #PB_Shortcut_Return, 10)
  AddKeyboardShortcut(0, #PB_Shortcut_Tab, 11) ; Not working, should not work!!!
  Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 4
            SetGadgetText(3, GetGadgetText(4))
            ; Something 
        EndSelect
      Case #PB_Event_Menu ; We only have one shortcut
        Select EventMenu()
          Case 10
            SetGadgetText(5, GetGadgetText(4)+"[State="+Str(GetGadgetState(4))+"]")
          Case 11
            If GetFocus_()=GadgetID(5)
              SetActiveGadget(4)
            Else
              SetActiveGadget(5)
            EndIf
        EndSelect            
    EndSelect
  Until Event=#PB_Event_CloseWindow
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP