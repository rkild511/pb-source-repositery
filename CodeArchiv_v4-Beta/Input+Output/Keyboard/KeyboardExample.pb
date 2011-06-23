; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003 
; OS: Windows, Linux 
; Demo: Yes

;==========================================
WEvent.l
EventMenu.l
Quit.l

Quit = #False
If OpenWindow(0, 0, 0, 320, 240, "", 0)
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, 99)
  AddKeyboardShortcut(0, #PB_Shortcut_C, 100)
  AddKeyboardShortcut(0, #PB_Shortcut_C | #PB_Shortcut_Control, 101)
  AddKeyboardShortcut(0, #PB_Shortcut_C | #PB_Shortcut_Alt, 102)
  AddKeyboardShortcut(0, #PB_Shortcut_C | #PB_Shortcut_Control | #PB_Shortcut_Alt, 103)
  Repeat
    WEvent = WaitWindowEvent()
    Select WEvent
      Case #PB_Event_Menu
        EventMenu = EventMenu()
        Select EventMenu
          Case 99
            Quit = #True
          Case 100
            Debug "C"
          Case 101
            Debug "CTRL-C"
          Case 102
            Debug "ALT-C"
          Case 103
            Debug "ALT-CTRL-C"
          Default
        EndSelect
      Default
    EndSelect
  Until Quit
EndIf

End
;==========================================

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -