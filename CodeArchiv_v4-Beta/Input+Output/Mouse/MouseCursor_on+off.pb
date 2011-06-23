; http://www.purearea.net
; Author: Andre Beer / PureBasic Team  (updated for PB4.00 by blbltheworm)
; Date: 27. September 2003
; OS: Windows
; Demo: No

If OpenWindow(0,0,0,180,120,"ShowCursor on/off",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  TextGadget(0,10,10,160,50,"The mouse cursor is on.")
  ButtonGadget(1,10,80,160,30,"Hide mouse cursor")
  Repeat
    ev.l= WaitWindowEvent()
    If ev = #PB_Event_Gadget
      If EventGadget()=1
        ShowCursor_(0)    ; <=== hide the mouse cursor
        SetGadgetText(0,"The mouse cursor is off. Wait 3 seconds, and the cursor will be back...")
        While WindowEvent() : Wend  
        Delay(3000)
        ShowCursor_(1)    ; <=== show the mouse cursor
        SetGadgetText(0,"The mouse cursor is on.")
      EndIf
    EndIf
  Until ev = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP