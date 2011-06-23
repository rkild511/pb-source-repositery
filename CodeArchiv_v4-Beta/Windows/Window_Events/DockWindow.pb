; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9472&highlight=
; Author: PB (updated for PB 4.00 by Andre)
; Date: 11. February 2004
; OS: Windows
; Demo: No

Procedure MyWindowCallback(WindowID,Message,wParam,lParam) 
  Result=#PB_ProcessPureBasicEvents 
  If Message=#WM_MOVE ; Main window is moving! 
    GetWindowRect_(WindowID(1),win.RECT) ; Store its dimensions in "win" structure. 
    x=win\left : y=win\top : w=win\right-win\left ; Get it's X/Y position and width. 
    SetWindowPos_(WindowID(2),0,x+w,y,0,0,#SWP_NOSIZE|#SWP_NOACTIVATE) ; Dock other window. 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

If OpenWindow(1,100,150,200,100,"Main  (Move me!)",#PB_Window_SystemMenu) 
  SetWindowCallback(@MyWindowCallback()) ; Set callback for this window. 
  If OpenWindow(2,305,150,200,100,"Follower",#PB_Window_SystemMenu) 
    SetActiveWindow(1) ; Give focus back to first window. 
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -