; English forum:
; Author: Berikco (updated for PB3.93 by Donald, updated for PB4.00 by blbltheworm)
; Date: 15. September 2002
; OS: Windows
; Demo: No

; By Beriko - Benny Sels - 15 sep 2002, updated 09 June 2003 by Andre Beer to work with PB3.70
; Diplay rounded SplashWindow
; Does not show in taskbar
; Movable
; Fade in/out

Global hwnd
Global transparent
Global Wait
TWait=5000
Global Start

Procedure MyWindowCallback(WindowId, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  Select WindowId
    Case 0 
      Default
      Select Message
        ;Case #WM_NCHITTEST
        ;  Result=#HTCAPTION
        Case #WM_TIMER
          Result=0
          Select wParam
            Case 1 ; fade in
              If transparent<255    
                transparent +1
              ElseIf transparent=255
                KillTimer_(hwnd,1)  ; stop, fade in ready
                SetTimer_(hwnd,2,TWait,0) ; set pause
              EndIf
              SetLayeredWindowAttributes_(hwnd,0,transparent,2)    ;
            Case 2  ; pause ready
              KillTimer_(hwnd,2)  
              SetTimer_(hwnd,3,3,0) ; set fade out
            Case 3  ; fade out
              If transparent>0    
                transparent -1
        ElseIf transparent=0
          KillTimer_(hwnd,3)
          Start=1 ; start main app
        EndIf
        SetLayeredWindowAttributes_(hWnd,0,transparent,2)    ;
      EndSelect
    EndSelect
  EndSelect
  ProcedureReturn Result 
EndProcedure 

hWnd= OpenWindow(2, 1,1, 291, 155, "",#PB_Window_BorderLess | #PB_Window_Invisible  | #WS_POPUP )
SetWindowPos_(hWnd,#HWND_TOPMOST,(GetSystemMetrics_(#SM_CXSCREEN)/2)-(WindowWidth(2)/2),(GetSystemMetrics_(#SM_CYSCREEN)/2)-(WindowHeight(2)/2),291,155, 0 )

If hWnd
  SetWindowLong_(hWnd,#GWL_EXSTYLE,$00080000|#WS_EX_PALETTEWINDOW)
  SetLayeredWindowAttributes_(hWnd,0,0,2)    ;completely transparent
  h = CreateRoundRectRgn_(3, 3, 290, 154, 20, 20)
  If  CatchImage(0, ?Logo) 
      If CreateGadgetList(WindowID(2))
      SetWindowRgn_(hWnd, h, True)
      ImageGadget(0, 0, 0, 0, 0, ImageID(0))
      SetWindowLong_(GadgetID(0),#WS_BORDER,0)
      HideWindow(2,0)
      SetWindowCallback(@MyWindowCallback()) 
      SetTimer_(hWnd,1,3,0) 
      Repeat
        WaitWindowEvent()
      Until Start=1 ; wait until splashwindow finished
      CloseWindow(1)
      hWnd= OpenWindow(1, 200, 200, 673, 155 ,"PB App",#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      Repeat
      Until WaitWindowEvent()=#PB_Event_CloseWindow 
      EndIf
  EndIf
EndIf

End   
Logo: IncludeBinary "..\..\Graphics\Gfx\PB_rounded.bmp"

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; UseIcon = F:\PureBasic\RAIDmon\Blueberry.ico
; Executable = F:\PureBasic\SplashWindow\SplashWindow.EXE
; DisableDebugger