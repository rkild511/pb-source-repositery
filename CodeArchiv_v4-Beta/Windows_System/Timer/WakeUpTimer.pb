; German forum: 
; Author; Unknown (updated for PB4.00 by blbltheworm)
; Date: 12. February 2003
; OS: Windows
; Demo: No

If OpenWindow(0, 10, 10, 600, 400, "Timer", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    SetTimer_(WindowID(0),1,2000,0) 
    Text.s = "2 Sekunden sind vorbei" 
    ;Windowhandle,TimerID,Timeout,Timerproc 
    Repeat 
        EventID.l = WaitWindowEvent() 
        If EventID = #PB_Event_CloseWindow 
            Quit = 1 
        EndIf 
        If EventID = #WM_TIMER 
            KillTimer_(WindowID(0),1) 
            MessageRequester("Timer",Text,64) 
            Text = "in 5 Sekunden bin ich wieder da" 
            SetTimer_(WindowID(0),1,5000,0) 
        EndIf 
    Until Quit = 1 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -