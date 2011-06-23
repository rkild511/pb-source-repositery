; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=895&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 05. May 2003
; OS: Windows
; Demo: No

Global Button.l 

Procedure IsMouseOver(wnd) 
    GetWindowRect_(wnd,re.RECT) 
    re\left = re\left 
    re\top  = re\top 
    re\right  = re\right 
    re\bottom  = re\bottom 
    GetCursorPos_(pt.POINT) 
    Result = PtInRect_(re,pt\x,pt\y) 
    ProcedureReturn Result 
EndProcedure 

If OpenWindow(0, 200, 200, 480, 320, "MouseOver", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    CreateStatusBar(0, WindowID(0)) 
    If CreateGadgetList(WindowID(0)) 
        Button = ButtonGadget(0, 10,10,80,24,"OK") 
    EndIf 
    Repeat 
        EventID.l = WaitWindowEvent() 
        If IsMouseOver(Button) 
            StatusBarText(0, 0, "Maus über Button") 
        Else 
            StatusBarText(0, 0, "") 
        EndIf 
        If EventID = #PB_Event_CloseWindow 
            Quit = 1 
        EndIf 
    Until Quit = 1 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
