; English forum:
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 19. January 2003
; OS: Windows
; Demo: No


; PureBasic has MenuHeight(), but no MenuWidth(), so here's my own!


; MenuWidth() procedure by PB -- do whatever you want with it. :)
; This example demonstrates a window having the width of its menu.
; (It's not exactly the menu width, due to Windows OS limitations).
;
Procedure MenuWidth(WIndowID.l)
  MyMenu=GetMenu_(WIndowID) : ItemSize.RECT
  For ItemNum=0 To GetMenuItemCount_(MyMenu)-1
    GetMenuItemRect_(WIndowID,MyMenu,ItemNum,ItemSize)
    width+(ItemSize\right-ItemSize\left)
  Next
  ProcedureReturn width+GetSystemMetrics_(#SM_CYHSCROLL)
EndProcedure
;
If OpenWindow(0,100,200,0,GetSystemMetrics_(#SM_CYCAPTION),"test",#WS_VISIBLE|#PB_Window_SystemMenu) And CreateMenu(0,WindowID(0))
  MenuItem(0,"#1") : MenuItem(0,"No. Two") : MenuItem(0,"Number Three") : MenuItem(0,"IV")
  ResizeWindow(0,#PB_Ignore,#PB_Ignore,MenuWidth(WindowID(0)),MenuHeight()) : ShowWindow_(WindowID(0),#SW_SHOW)
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -