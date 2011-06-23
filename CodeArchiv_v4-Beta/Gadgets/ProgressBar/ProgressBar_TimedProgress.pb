; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9504&highlight=
; Author: Kale (updated for PB 4.00 by Andre)
; Date: 14. February 2004
; OS: Windows
; Demo: Yes

#PROGRESS_TIME = 3500
OpenWindow(1, 0, 0, 300, 100, "Timed Progress...", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CreateGadgetList(WindowID(1))
ProgressBarGadget(1, 10, 10, 280, 50, 0, #PROGRESS_TIME / 10, #PB_ProgressBar_Smooth)
Time = ElapsedMilliseconds()
Repeat
  If GetGadgetState(1) < #PROGRESS_TIME / 10
    SetGadgetState(1, GetGadgetState(1) + 1)
    Delay(1)
  Else
    Debug "Time took to fill gadget: " + Str(ElapsedMilliseconds() - Time)
    End
  EndIf
Until WindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP