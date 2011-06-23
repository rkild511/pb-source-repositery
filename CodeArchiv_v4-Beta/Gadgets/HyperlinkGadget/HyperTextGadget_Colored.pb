; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2955&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 29. November 2003
; OS: Windows
; Demo: No

Global Static2.l 
Global ReUsableBrush,a.l 

#winMain=1

Procedure IsMouseOver(wnd) 
    GetWindowRect_(wnd,re.RECT) 
    GetCursorPos_(pt.POINT) 
    Result = PtInRect_(re,pt\x,pt\y) 
    ProcedureReturn Result 
EndProcedure 

Procedure SetColor(TxtColor,BkColor,wParam ,lParam ) 
Shared ReUsableBrush 
    DeleteObject_(ReUsableBrush) 
    ReUsableBrush = GetStockObject_(#HOLLOW_BRUSH) 
    SetBkColor_(wParam,BkColor) 
    SetTextColor_(wParam,TxtColor) 
    SetBkMode_(wParam,#TRANSPARENT) 
    Result  =  ReUsableBrush 
    ProcedureReturn Result 
EndProcedure 

Procedure WindowCallback(WindowID, message, wParam, lParam) 
    Result = #PB_ProcessPureBasicEvents 
    Select message 
    Case #WM_LBUTTONUP 
        If IsMouseOver(Static2) 
            ShellExecute_(0,"open","http:\\www.ampsoft.org",0,0,#SW_SHOWNORMAL) 
        EndIf 
    Case   #WM_MOUSEMOVE 
        GetCursorPos_(pt.POINT) 
        GetWindowRect_(Static2,re.RECT) 
        If PtInRect_(re,pt\x,pt\y) 
            a = 1 
            SetWindowText_(Static2,"www.ampsoft.org") 
            SetCursor_(LoadCursor_(0,32649)) 
        Else 
            a = 0 
            SetWindowText_(Static2,"www.ampsoft.org") 
            SetCursor_(LoadCursor_(0,#IDC_ARROW)) 
        EndIf 
        InvalidateRect_(WindowID(#winMain),0,0) 
    Case #WM_CTLCOLORSTATIC 
        If lParam = Static2 
            If a 
                Result = SetColor(RGB(255,0,0),RGB(255,255,255),wParam,lParam) 
            Else 
                Result = SetColor(RGB(0,0,255),RGB(255,255,255),wParam,lParam) 
            EndIf 
        EndIf 
    EndSelect 
    ProcedureReturn Result 
EndProcedure 

If OpenWindow(#winMain, 10, 150, 640,180, "MouseOver", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    If CreateGadgetList(WindowID(#winMain)) 
        Static2 = TextGadget(0, 10,10,220,24,"") 
    EndIf 
    SetWindowCallback(@WindowCallback()) 
    SendMessage_(WindowID(#winMain),#WM_MOUSEMOVE,0,0) 
    Repeat 
        EventID.l = WaitWindowEvent() 
        If EventID = #PB_Event_CloseWindow 
            Quit = 1 
        EndIf 
    Until Quit = 1 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
