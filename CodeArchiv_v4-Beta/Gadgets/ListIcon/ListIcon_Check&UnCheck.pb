; http://www.purearea.net
; Author: Andre (updated for PB4.00 by blbltheworm)
; Date: 03. November 2003
; OS: Windows
; Demo: Yes

Enumeration
#Text
#List
#Button
EndEnumeration

; Shows possible flags of ListIconGadget in action...
If OpenWindow(0,0,0,320,205,"ListIconGadgets",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  ; left column
  TextGadget    (#Text  , 10, 10, 300, 20, "ListIcon with Checkbox", #PB_Text_Center)
  ListIconGadget(#List  , 10, 30, 300,140, "Column 1",100, #PB_ListIcon_CheckBoxes)  ; ListIcon with checkbox
  ButtonGadget  (#Button, 10,180, 300, 20, "Check/Uncheck ListIcon Rows")
  check = #False
  For a=2 To 4          ; add 3 more columns to each listicon
    AddGadgetColumn(#List,a,"Column "+Str(a),65)
  Next
  For a=0 To 5          ; add 4 items to each line of the listicons
    AddGadgetItem(#List,a,"Item 1"+Chr(10)+"Item 2"+Chr(10)+"Item 3"+Chr(10)+"Item 4")
  Next
  Repeat
    EventID = WaitWindowEvent()
    Select EventID
    Case #PB_Event_Gadget
      Select EventGadget()
      Case #Button
        If check = #False          ; ListIcon entries not checked, check them now :)
          For a = 0 To 5
            SetGadgetItemState(#List,a,#PB_ListIcon_Checked)
          Next
          check = #True
        Else                       ; ListIcon entries checked, uncheck them now...
          For a = 0 To 5
            SetGadgetItemState(#List,a,0)
          Next
          check = #False
        EndIf
      EndSelect
    EndSelect
  Until EventID = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP