; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7136&highlight=
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 08. August 2003
; OS: Windows
; Demo: Yes

Procedure Mythread(sleeptime)
  Delay(sleeptime)
  MessageRequester("Info","delayed Task",0)
EndProcedure

scheduletime=5000  ;5 seconds delay
ThreadID = CreateThread(@Mythread(), scheduletime)
If OpenWindow(0, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  Repeat
    EventID.l = WaitWindowEvent()
    If EventID = #PB_Event_CloseWindow  ; If the user has pressed on the close button
      Quit = 1
    EndIf
  Until Quit = 1
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
