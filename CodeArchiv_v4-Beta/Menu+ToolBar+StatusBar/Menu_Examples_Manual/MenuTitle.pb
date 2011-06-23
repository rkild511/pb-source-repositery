; www.PureArea.net 
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 26. May 2003 
; OS: Windows, Linux 
; Demo: Yes 

  If OpenWindow(0, 200, 200, 200, 100, "MenuTitle Example", #PB_Window_SystemMenu)
    If CreateMenu(0, WindowID(0))
      MenuTitle("Project")      ; normal menu title with following item
        MenuItem(1, "Open")  
        MenuItem(2, "Close")
      MenuTitle("&Edit")        ; menu title with underlined character, the underline
                                ; will only be displayed, when called with F10 key
        MenuItem(3, "Undo")
        MenuItem(4, "Redo")
      MenuTitle("About")        ; only menu title
    EndIf
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -