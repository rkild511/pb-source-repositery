; www.PureArea.net 
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm) 
; Date: 26. May 2003 
; OS: Windows, Linux 
; Demo: Yes 

  If OpenWindow(0, 200, 200, 220, 100, "SubMenu Example", #PB_Window_SystemMenu)
    If CreateMenu(0, WindowID(0))
      MenuTitle("Project") 
        MenuItem(1, "Open")  
        MenuItem(2, "Close")
        MenuBar()
        OpenSubMenu("Recent files")       ; begin sub-menu
          MenuItem( 3, "C:\Autoexec.bat")
          MenuItem( 4, "D:\Test.txt")
        CloseSubMenu()                    ; end sub-menu
    EndIf
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -