; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14549&highlight=
; Author: HeX0R
; Date: 25. March 2005
; OS: Windows, Linux
; Demo: Yes


; A single combobox, where we detect a change in index 
; (ie: the user selects a new entry in the combobox). 

; Eine einfache ComboBox, worin eine Änderung des Index überprüfen
; (d.h. der Anwender hat einen anderen Eintrag in der Combobox ausgewählt).

If OpenWindow(0,0,0,270,140,"ComboBoxGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  ComboBoxGadget(0,10,40,250,100) 
  For a=1 To 5 
    AddGadgetItem(0,-1,"ComboBox item "+Str(a)) 
  Next 
  SetGadgetState(0,2) 
  
  Active_Item.l = GetGadgetState(0) 
  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_CloseWindow 
        Break 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 0 
            If Active_Item <> GetGadgetState(0) 
              Active_Item = GetGadgetState(0) 
              Debug "Changed" 
              ;Do whatever you like... 
            EndIf 
        EndSelect 
    EndSelect 
  ForEver 
EndIf 
End 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP