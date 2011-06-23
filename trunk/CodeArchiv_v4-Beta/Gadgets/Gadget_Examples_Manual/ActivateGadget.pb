; http://www.purearea.net
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 16. August 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,270,140,"ActivateGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  StringGadget  (0,10, 10,250,20,"bla bla...")
  ComboBoxGadget(1,10, 40,250,100)
  For a=1 To 5 : AddGadgetItem(1,-1,"ComboBox item "+Str(a)) : Next
  SetGadgetState(1,2)                ; set (beginning with 0) the third item as active one
  ButtonGadget  (2,10, 90,250,20,"Activate StringGadget")
  ButtonGadget  (3,10,115,250,20,"Activate ComboBox")
  Repeat
    ev.l = WaitWindowEvent()
    If ev.l = #PB_Event_Gadget
      gad.l = EventGadget()
      Select gad
        Case 2 : SetActiveGadget(0)   ; Activate StringGadget
        Case 3 : SetActiveGadget(1)   ; Activate ComboBoxGadget
      EndSelect
    EndIf
  Until ev.l=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP