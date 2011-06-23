; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2932&highlight=
; Author: PBfetischist (updated for PB4.00 by blbltheworm)
; Date: 26. November 2003
; OS: Windows
; Demo: No

; Search function for ComboBox

Procedure cbsuch(comboboxgadgetnr,suchstring.s)
  position = SendMessage_(GadgetID(comboboxgadgetnr),#CB_FINDSTRING,1,suchstring.s)
  ProcedureReturn = position
EndProcedure


OpenWindow(0,80,150,270,140,"ComboBoxSearch",#PB_Window_SystemMenu)
CreateGadgetList(WindowID(0))
ComboBoxGadget(0,10,40,250,100)
For x = 66 To 99 Step 3
  AddGadgetItem(0,-1,Str(x))
Next
Debug "87 befindet sich an Position " + Str(cbsuch(0,"87"))
SetGadgetState(0,cbsuch(0,"87"))
Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
