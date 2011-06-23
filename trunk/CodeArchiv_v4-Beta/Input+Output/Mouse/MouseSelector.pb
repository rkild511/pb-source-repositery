; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2914&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 24. November 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 24.11.2003 - german forum 
; 
Procedure OnMouseSelection(x,y,width,height) 
  Debug "-----" 
  Debug "Selected:" 
  Debug "X     : "+Str(x) 
  Debug "Y     : "+Str(y) 
  Debug "Width : "+Str(width) 
  Debug "Height: "+Str(height) 
EndProcedure 


Procedure DrawMouseSelector(hWnd) 
  Shared WindowProc_MouseSelectStartX, WindowProc_MouseSelectLastX 
  Shared WindowProc_MouseSelectStartY, WindowProc_MouseSelectLastY 
  Shared WindowProc_MouseSelectRect.RECT 

  If WindowProc_MouseSelectStartX > WindowProc_MouseSelectLastX 
    WindowProc_MouseSelectRect\left   = WindowProc_MouseSelectLastX 
    WindowProc_MouseSelectRect\right  = WindowProc_MouseSelectStartX 
  Else 
    WindowProc_MouseSelectRect\left   = WindowProc_MouseSelectStartX 
    WindowProc_MouseSelectRect\right  = WindowProc_MouseSelectLastX 
  EndIf 
  If WindowProc_MouseSelectStartY > WindowProc_MouseSelectLastY 
    WindowProc_MouseSelectRect\top    = WindowProc_MouseSelectLastY 
    WindowProc_MouseSelectRect\bottom = WindowProc_MouseSelectStartY 
  Else 
    WindowProc_MouseSelectRect\top    = WindowProc_MouseSelectStartY 
    WindowProc_MouseSelectRect\bottom = WindowProc_MouseSelectLastY 
  EndIf 

  hDC = GetDC_(hWnd) 
    DrawFocusRect_(hDC,@WindowProc_MouseSelectRect) 
  ReleaseDC_(hWnd,hDC) 
  ;UpdateWindow_(hWnd) ; Win9x fix? 
EndProcedure 


Procedure WindowProc(hWnd,Msg,wParam,lParam) 
  Shared WindowProc_MouseSelect 
  Shared WindowProc_MouseSelectStartX, WindowProc_MouseSelectLastX 
  Shared WindowProc_MouseSelectStartY, WindowProc_MouseSelectLastY 
  Shared WindowProc_MouseSelectRect.RECT 

  Select Msg 
    Case #WM_LBUTTONDOWN 
      WindowProc_MouseSelect  = 1 
      WindowProc_MouseSelectStartX = lParam&$FFFF 
      WindowProc_MouseSelectStartY = (lParam>>16)&$FFFF 
      GetClientRect_(hWnd,winrect.RECT) 
      MapWindowPoints_(hWnd,0,winrect,2) 
      ClipCursor_(winrect) 
    Case #WM_LBUTTONUP 
      If WindowProc_MouseSelect > 1 
        DrawMouseSelector(hWnd) 
        If WindowProc_MouseSelectRect\left <> WindowProc_MouseSelectRect\right And WindowProc_MouseSelectRect\top <> WindowProc_MouseSelectRect\bottom 
          OnMouseSelection(WindowProc_MouseSelectRect\left,WindowProc_MouseSelectRect\top,WindowProc_MouseSelectRect\right-WindowProc_MouseSelectRect\left,WindowProc_MouseSelectRect\bottom-WindowProc_MouseSelectRect\top) 
          SetCapture_(0) 
        EndIf 
      EndIf 
      ClipCursor_(0) 
      WindowProc_MouseSelect = 0 
    Case #WM_MOUSEMOVE 
      If WindowProc_MouseSelect > 0 And wParam & #MK_LBUTTON 
        If WindowProc_MouseSelect > 1 
          DrawMouseSelector(hWnd) 
        Else 
          WindowProc_MouseSelect + 1 
        EndIf 
        WindowProc_MouseSelectLastX = lParam&$FFFF 
        WindowProc_MouseSelectLastY = (lParam>>16)&$FFFF 
        DrawMouseSelector(hWnd) 
        SetCapture_(hWnd) 
      EndIf 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 



OpenWindow(0,0,0,400,400,"Mega Mouse Selector",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
  SetWindowCallback(@WindowProc()) 
HideWindow(0,0) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
