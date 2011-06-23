; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1819&highlight=
; Author: ChaOsKid (updated for PB 4.00 by Andre)
; Date: 27. January 2005
; OS: Windows
; Demo: No


; Get actual item of a comboboxgadget
; Aktuelles Item eines Comboboxgadgets herausfinden

If OpenWindow(0,0,0,270,140,"ComboBoxGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  ComboBoxGadget(0,10,10,250,100) 
  For a=1 To 5 : AddGadgetItem(0,-1,"ComboBox 0 item "+Str(a)) : Next 
  ComboBoxGadget(1,10,40,250,100) 
  For a=1 To 5 : AddGadgetItem(1,-1,"ComboBox 1 item "+Str(a)) : Next 
  oldState0 = GetGadgetState(0) 
  oldState1 = GetGadgetState(1) 
  Repeat 
    event = WaitWindowEvent() 
    State = GetGadgetState(0) 
    If State <> oldState0 
      Debug "state 0: " + Str(State+1) 
      oldState0 = State 
    EndIf 
    State = GetGadgetState(1) 
    If State <> oldState1 
      Debug "state 1: " + Str(State+1) 
      oldState1 = State 
    EndIf 
  Until event = #PB_Event_CloseWindow 
EndIf 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP