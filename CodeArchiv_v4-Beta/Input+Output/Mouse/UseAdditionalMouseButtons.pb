; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2635&highlight=
; Author: Danilo
; Date: 23. October 2003
; OS: Windows
; Demo: No

#WM_XBUTTONDOWN   = $20B 
#WM_XBUTTONUP     = $20C 
#WM_XBUTTONDBLCLK = $20D 
#XBUTTON1         = $1 
#XBUTTON2         = $2 

Procedure WindowProc(hWnd,Msg,wParam,lParam) 
  Select Msg 
    Case #WM_XBUTTONDOWN 
      SetWindowText_(hWnd,"Button "+Str((wParam>>16)&$FFFF)+" down") 
    Case #WM_XBUTTONUP 
      SetWindowText_(hWnd,"Button "+Str((wParam>>16)&$FFFF)+" up") 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

OpenWindow(1,200,200,200,100,"",#PB_Window_SystemMenu) 
  SetWindowCallback(@WindowProc()) 
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 
 

; Damit kann man 2 Extra-MouseButtons abfragen. 
; 
; Dazu: 
; WM_LBUTTON... = linke MausTaste 
; WM_RBUTTON... = rechte MausTaste 
; WM_MBUTTON... = mittlere MausTaste 
; ...macht ingesamt schonmal 5. 
; 
; Je nachdem wie der Treiber konfiguriert ist könnte man evtl. 
; noch etwas über WM_APPCOMMAND bekommen, falls eine 
; Multimedia-Funktion ausgeführt wird.
; 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
