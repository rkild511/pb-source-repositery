; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6569&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 15. June 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,140,70,"SpinGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
    SpinGadget     (0,20,20,100,25,0,1000) 
    SetGadgetState (0,5) : SetGadgetText(0,"5")   ; Anfangswert festlegen 
    Repeat 
      ev.l = WaitWindowEvent() 
      If ev=#PB_Event_Gadget 
        If EventGadget() = 0 
          If GetGadgetState(0)<>Val(GetGadgetText(0)) ; hat sich was geändert? 
            If EventType()=#PB_EventType_Change ; = Eingabe in Textfeld 
              SetGadgetState(0,Val(GetGadgetText(0))) 
            Else 
              SetGadgetText(0,Str(GetGadgetState(0))) 
            EndIf 
          EndIf 
        EndIf 
      EndIf 
    Until ev.l = #PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
