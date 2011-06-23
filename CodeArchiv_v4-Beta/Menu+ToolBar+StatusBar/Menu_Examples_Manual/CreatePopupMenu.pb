; www.PureArea.net 
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 26. May 2003 
; OS: Windows, Linux 
; Demo: Yes 

  If OpenWindow(0, 200, 200, 200, 120, "Popup-Menu Example", #PB_Window_SystemMenu)
    If CreatePopupMenu(0)      ; here the creating of the pop-up menu begins...
      MenuTitle("Project")     ; you can use any of the menu creating commands,
        MenuItem(1, "Open")    ; just like in a normal menu...
        MenuItem(2, "Save")
        MenuItem(3, "Save as")
        MenuItem(4, "Quit")
        MenuBar()
        OpenSubMenu("Recent files")
          MenuItem(5, "PureBasic.exe")
          MenuItem(6, "Test.txt")
        CloseSubMenu()
      MenuTitle("Edit")
      MenuTitle("Options")
    EndIf
    Repeat
      Select WaitWindowEvent()     ; check for window events
        Case #WM_RBUTTONDOWN       ; right mouse button was clicked =>
          DisplayPopupMenu(0,WindowID(0))  ; now display the popup-menu
        Case #PB_Event_Menu         ; an item of the popup-menu was clicked
          Select EventMenu()     ; get the clicked menu item...
            Case 1 : Debug "Menu: Open"
            Case 2 : Debug "Menu: Save"
            Case 3 : Debug "Menu: Save as"
            Case 4 : Quit = 1
            Case 5 : Debug "Menu: PureBasic.exe"
            Case 6 : Debug "Menu: Text.txt"
          EndSelect
        Case #PB_Event_CloseWindow
          Quit = 1
      EndSelect
    Until Quit = 1
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -