; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8057&highlight=
; Author: V2  (example by Andre, updated for PB4.00 by blbltheworm)
; Date: 26. October 2003
; OS: Windows
; Demo: No

;- Function
Procedure SetProgressbarRange(Gadget.l, Minimum.l, Maximum.l)
  ;? SetProgressbarRange(#progressbar, 0, 100)
  PBM_SETRANGE32 = $400 + 6
  SendMessage_(GadgetID(Gadget), PBM_SETRANGE32, Minimum, Maximum)
EndProcedure

;- Example
If OpenWindow(0,100,150,320,160,"SetProgressBarRange Test",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  ProgressBarGadget(0,10,30,250,30,0,100)   ; original range from 0-100
  ButtonGadget(1,30,80,150,20,"Change ProgressBarRange")
  SetGadgetState(0,50)
  Repeat
    ev.l = WaitWindowEvent()
    If ev = #PB_Event_Gadget
      Select EventGadget()
      Case 1
        SetProgressbarRange(0,0,500)    ; here we set the new range from 0-500
      EndSelect
    EndIf
  Until ev=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
