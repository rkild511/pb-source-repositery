; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8739&highlight=
; Author: darklordz (updated for PB4.00 by blbltheworm)
; Date: 16. December 2003
; OS: Windows
; Demo: No


If OpenWindow(0, 100, 200, 195, 195, "Test Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    X.l = GetActiveWindow_() 
    A.s = Space(255) 

    Z.l = GetClassName_(X.l,@A,255) 
    Debug A.s 

    X.l = FindWindow_(A.s,"Test Window") 
    GetWindowText_(X.l,@A,255) 
    Debug A.s 
    
    Delay(2000) 
    Debug "Minimizing Window" 
    ShowWindow_(X.l,2) 
    Delay(2000) 
    Debug "Maximizing Window" ;added by blbltheworm
    ShowWindow_(X.l,3) 
    Delay(2000) 
    Debug "Restoring Window" 
    ShowWindow_(X.l,1) 

    Repeat 
        EventID.l = WaitWindowEvent() 
        Select EventID.l 
            Case #PB_Event_CloseWindow 
                Quit = 1 
        EndSelect 
    Until Quit = 1 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
