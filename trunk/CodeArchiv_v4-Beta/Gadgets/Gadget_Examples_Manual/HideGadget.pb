; http://www.purearea.net
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 16. August 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,180,120,"HideGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  ButtonGadget(0,10,10,160,50,"Button 1")       : button = #True   ; Button is displayed
  ButtonGadget(1,10,80,160,30,"Hide Button 1")
  Repeat
    ev.l= WaitWindowEvent()
    If ev = #PB_Event_Gadget
      If EventGadget()=1
        If button = #True     ; ButtonGadget is displayed
          HideGadget(0,1)     ; => hide it
          button = #False
          SetGadgetText(1,"Show Button 1")
        Else                  ; ButtonGadget is hidden
          HideGadget(0,0)     ; => show it
          button = #True
          SetGadgetText(1,"Hide Button 1")
        EndIf
      EndIf
    EndIf
  Until ev = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP