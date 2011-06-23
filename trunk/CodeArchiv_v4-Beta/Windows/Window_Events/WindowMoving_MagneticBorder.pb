; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1116&postdays=0&postorder=asc&start=20
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 09. March 2005
; OS: Windows
; Demo: No


; Magnetisches Andocken an den Fensterrand

; 
; Workarea Border Magnet (2) 
; 
;   by Danilo, 9th March 2005 
; 
#MAGNET = 25 

Procedure WndProc(hWnd,Msg,wParam,lParam) 
  Static MouseOffsetX,MouseOffsetY 

  If hWnd = WindowID(0) 
    Select Msg 
      Case #WM_NCLBUTTONDOWN 
        GetWindowRect_(hWnd,rect.RECT) 
        MouseOffsetX = (lParam & $FFFF)       - rect\left 
        MouseOffsetY = ((lParam >> 16)&$FFFF) - rect\top 
      Case #WM_MOVING 
        *rect.RECT = lParam 
        If *rect 
          width  = *rect\right  - *rect\left 
          height = *rect\bottom - *rect\top 
          SystemParametersInfo_(#SPI_GETWORKAREA,0,rect.RECT,0) 

          GetCursorPos_(m.POINT) 
          *rect\left  = m\x - MouseOffsetX 
          *rect\top   = m\y - MouseOffsetY 
          *rect\right = *rect\left + width 
          *rect\bottom= *rect\top  + height 

          If *rect\left  < #MAGNET                  ; left 
            *rect\left = 0 : modified = 1 
          EndIf 
          If *rect\top  < #MAGNET                    ; top 
            *rect\top  = 0 : modified = 1 
          EndIf 
          If *rect\right > rect\right - #MAGNET      ; right 
            *rect\left = rect\right  - width  : modified = 1 
          EndIf 
          If *rect\bottom > rect\bottom - #MAGNET    ; bottom 
            *rect\top  = rect\bottom - height : modified = 1 
          EndIf 

          If modified 
            *rect\right  = *rect\left + width 
            *rect\bottom = *rect\top  + height 
          EndIf 
          ProcedureReturn #True 
        EndIf 
    EndSelect 
  EndIf 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 



OpenWindow(0,0,0,200,200,"Move me!",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  SetWindowCallback(@WndProc()) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger