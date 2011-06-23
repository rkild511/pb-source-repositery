; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. June 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,100,150,400,200,"Test",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(0))
  SpinGadget(1,20,20,100,20,1,10)
  SetGadgetState(1,5) : SetGadgetText(1,"5") ; Set initial value.
  Repeat
    ev=WaitWindowEvent()
    If ev=#PB_Event_Gadget
      SetGadgetText(1,Str(GetGadgetState(1)))
      WindowEvent() ; To stop looping events due to text change.
    EndIf
  Until ev=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP