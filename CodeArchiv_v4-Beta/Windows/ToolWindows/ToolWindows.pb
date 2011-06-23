; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1497&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 25. June 2003
; OS: Windows
; Demo: No


; 2 Tool-Fenster mit dem neuen optionalen Parameter #PB_WINDOW_TITLEBAR bei
; OpenWindow() öffnen, damit gehören diese zum ersten Fenster.

; Dadurch werden die Tool-Fenster nicht in der Taskleiste angezeigt 
; und bleiben immer über Deinem Hauptfenster. 
 
hWndMain = OpenWindow(0,0,0,400,400,"Main",#PB_Window_SystemMenu) 
  ShowWindow_(hWndMain,#SW_MAXIMIZE) 
  OpenWindow(1,50,100,300,200,"Tool 1",#PB_Window_TitleBar,WindowID(0)) 
  OpenWindow(2,50,350,400,200,"Tool 2",#PB_Window_TitleBar,WindowID(0)) 
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
