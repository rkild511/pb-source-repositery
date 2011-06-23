; www.PureArea.net 
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm) 
; Date: 25. May 2003 
; OS: Windows, Linux 
; Demo: Yes 

  If OpenWindow(0, 200, 200, 200, 100, "MenuItem Example", #PB_Window_SystemMenu)
    If CreateMenu(0, WindowID(0))
      MenuTitle("Project")
        MenuItem(1, "Open")    ; normal item
        MenuItem(2, "&Save")   ; item with underscore, the underscore will only be 
                               ; displayed, if menu is called with F10 + arrow keys
        MenuItem(3, "Quit"+Chr(9)+"Esc")   ; item with separate shortcut text
    EndIf
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP