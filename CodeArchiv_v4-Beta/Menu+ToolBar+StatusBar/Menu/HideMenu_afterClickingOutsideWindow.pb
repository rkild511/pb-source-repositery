; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2519&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 10. October 2003
; OS: Windows
; Demo: Yes


; Menu, which will be hided after clicking outside the window
; Menü, welches nach einen Klick ausserhalb des Fensters verschwindet.

Global Menu 

Procedure WindowProc(hWnd,Msg,wParam,lParam) 
  Select Msg 
    Case #WM_ACTIVATE 
      If hWnd = WindowID(0) 
        If (wParam & $FFFF) = #WA_INACTIVE 
         ;With API
          ;SetMenu_(hWnd,0) 
         ;With PB
          HideMenu(1,1)
        Else 
          ;SetMenu_(hWnd,Menu) 
          HideMenu(1,0)
        EndIf 
      EndIf 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

OpenWindow(0,0,0,400,300,"Hide Menu",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible) 

  SetWindowCallback(@WindowProc()) 

  Menu = CreateMenu(1,WindowID(0)) 
    MenuTitle("File") 
      MenuItem(100,"New") 
      MenuItem(101,"Open") 
      MenuItem(102,"Save") 
      MenuBar() 
      MenuItem(103,"Close") 
    MenuTitle("Edit") 
      MenuItem(200,"Cut") 
      MenuItem(201,"Copy") 
      MenuItem(202,"Paste") 
    MenuTitle("Help") 
      MenuItem(300,"About...") 

HideWindow(0,0) 

Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
