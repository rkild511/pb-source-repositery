; www.PureArea.net 
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm) 
; Date: 26. May 2003 
; OS: Windows, Linux 
; Demo: Yes 

  If OpenWindow(0, 200, 200, 200, 100, "GetMenuItemState Example", #PB_Window_SystemMenu)
    If CreateMenu(0, WindowID(0))
      MenuTitle("Project")
        MenuItem(1, "Changed")
        SetMenuItemState(0,1,1)    ; set check mark for the previously created menu item
    EndIf
    Repeat
      event.l = WaitWindowEvent()        ; wait for an event
      If event = #PB_Event_Menu           ; a menu event appeared
        If EventMenu() = 1             ; first menu item was clicked
          If GetMenuItemState(0,1) = 1   ; actual item state = check marked
            SetMenuItemState(0,1,0)         ; now remove the check mark
          Else                           ; actual item state = no check mark
            SetMenuItemState(0,1,1)         ; now set the check mark
          EndIf
        EndIf
      EndIf
    Until event = #PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -