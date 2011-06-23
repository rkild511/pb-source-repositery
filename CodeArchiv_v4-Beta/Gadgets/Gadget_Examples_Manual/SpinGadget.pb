; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,140,70,"SpinGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  SpinGadget     (0,20,20,100,25,0,1000)
  SetGadgetState (0,5) : SetGadgetText(0,"5")   ; set initial value
  Repeat
    ev.l = WaitWindowEvent()
    If EventGadget() = 0
      SetGadgetText(0,Str(GetGadgetState(0)))
    EndIf
  Until ev.l = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP