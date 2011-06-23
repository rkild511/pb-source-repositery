; English forum: 
; Author: El_Choni (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: Yes

If OpenWindow(0,150,150,300,200,"test",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(0))
  ComboBoxGadget(0,10,10,100,150,0)
  ButtonGadget(1,120,10,50,20,"test")
  For r=1 To 10 : AddGadgetItem(0,-1,Str(r)) : Next
  Repeat
    ev=WaitWindowEvent()
    If ev=#PB_Event_Gadget
      Select EventGadget()
        Case 0
          Debug "combo event -- selection: "+Str(GetGadgetState(0)+1)
        Case 1
          Debug "button event"
      EndSelect
    EndIf
  Until ev=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP