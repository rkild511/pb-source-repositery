; www.PureArea.net 
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm) 
; Date: 25. May 2003 
; OS: Windows, Linux 
; Demo: Yes 

  If OpenWindow(0, 200, 200, 200, 100, "MenuBar Example", #PB_Window_SystemMenu)
    If CreateMenu(0, WindowID(0))  ; here the menu creating starts....
      MenuTitle("Project")
        MenuItem(1, "Open")
        MenuBar()                 ; here the separator bar will be inserted
        MenuItem(4, "Close")
    EndIf
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -