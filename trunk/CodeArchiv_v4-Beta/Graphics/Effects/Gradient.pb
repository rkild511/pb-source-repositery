; German forum:
; Author: Andreas Miethe (updated for PB4.00 by blbltheworm)
; Date: 12. December 2002
; OS: Windows
; Demo: No

;##############################
;Einfacher Farbverlauf
;Andreas Miethe Dezember 2002
;##############################

Declare Gradient(FirstColor.l,LastColor.l,Colors.l,Direction.l)
Global hWnd.l,BackImage.l,hBrush.l
Global ScreenWidth.l,ScreenHeight.l
ScreenWidth  = GetSystemMetrics_(#SM_CXSCREEN)
ScreenHeight = GetSystemMetrics_(#SM_CYSCREEN)

Procedure WindowCallback(WindowID, Message, wParam, lParam)
    Result = #PB_ProcessPureBasicEvents
    Select Message
    Case #WM_CLOSE
        DeleteObject_(BackImage)
        DeleteObject_(hBrush)
    EndSelect
    ProcedureReturn Result
EndProcedure

Procedure Gradient(FirstColor.l,EndColor.l,Colors.l,Direction.l)
    Protected r.l,g.l,b.l,reddif.l,greendif.l,bluedif.l,h.l,w.l,i.l,rt.l,gt.l,bt.l
    If Colors < 8 : Colors = 8:EndIf
        reddif   = Red(EndColor) - Red(FirstColor)
        greendif = Green(EndColor) - Green(FirstColor)
        bluedif  = Blue(EndColor) - Blue(FirstColor)
        h  = WindowHeight(0)
        w  = WindowWidth(0)
        rt = Red(FirstColor)
        gt = Green(FirstColor)
        bt = Blue(FirstColor)
        If BackImage : DeleteObject_(BackImage):EndIf
            BackImage = CreateImage(0, w,h)
            StartDrawing(ImageOutput(0))
            While i < Colors
                r = rt +  MulDiv_(i,reddif,Colors)
                g = gt +  MulDiv_(i,greendif,Colors)
                b = bt +  MulDiv_(i,bluedif,Colors)
                BackColor = RGB(r,g,b)
                If Direction = 1
                    Box(MulDiv_(i,w,Colors),0,MulDiv_(i+2,w,Colors),h,BackColor)
                Else
                    Box(0,MulDiv_(i,h,Colors),w,MulDiv_(i+2,h,Colors),BackColor)
                EndIf
                i = i + 1
            Wend
            StopDrawing()
            If hBrush : DeleteObject_(hBrush):EndIf
                hBrush = CreatePatternBrush_(BackImage)
                SetClassLong_(hWnd,#GCL_HBRBACKGROUND,hBrush)
                InvalidateRect_(hWnd,0,1)
EndProcedure

hWnd = OpenWindow(0, 0, 0,ScreenWidth,ScreenHeight, "Gradient",#WS_POPUP|#WS_VISIBLE|#WS_CLIPSIBLINGS)
If hWnd
    SetWindowCallback(@WindowCallback())
    Gradient(RGB(0,255,255),RGB(0,0,0),255,0)
    If CreateGadgetList(WindowID(0))
        ButtonGadget(1,20,20,80,24,"Ende")
    EndIf
    ShowWindow_(hWnd,#SW_SHOWNORMAL)
    Repeat
        EventID.l = WaitWindowEvent()
        If EventID = #PB_Event_CloseWindow
            Quit = 1
        EndIf
        If EventID = #PB_Event_Gadget
            Select EventGadget()
            Case 1
                SendMessage_(hWnd,#WM_CLOSE,0,0)
            EndSelect
        EndIf
    Until Quit = 1
EndIf
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = K:\Pure-Basic\Gradient\Gradient.exe
; DisableDebugger