; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows, Linux
; Demo: Yes


;just compile and run...
;press "M" key for testing...

; I tested it on all versions of Windows and here are the results:
;Win XP Pro: Works
;Win 2K Pro: Works
;Win ME: Works
;Win 98se: Works
;Win NT4: Works
;Win 95b: Works

;
; -------- Init and Open Window --------
;
    If OpenWindow(0, 100, 150, 320, 150, "PB - AddKeyboardShortcut() Example", #PB_Window_SystemMenu) = 0
      MessageRequester("PB - AddKeyboardShortcut() Example", "Could not open window!", 0)
      End
    EndIf
;
; -------- Create our MenuBar --------
;
    If CreateMenu(0, WindowID(0))
      MenuTitle("&File")
        MenuItem( 1, "&Load...")
        MenuItem( 2, "Save")
        MenuItem( 3, "Save As...")
        MenuBar()
        MenuItem( 4, "&Quit")
        ;
      MenuTitle("&Edit")
        MenuItem( 5, "Cut")
        MenuItem( 6, "Copy")
        MenuItem( 7, "Paste")
        ;
      MenuTitle("&Help")
        MenuItem( 8, "&About")
    EndIf
    ;
    ; -------- Add our Keyboard Shortcut -------
    ;
    AddKeyboardShortcut(0,#PB_Shortcut_M,8)     ; If pressed, set EventID to MenuItem 8 
;
; -------- Mainloop Check for events --------
;  
    Repeat
        ;
        ; -------- Select WindowEvents --------
        ;
        Select WaitWindowEvent()
          Case #PB_Event_Menu
            ;
            ; -------- Select MenuEvents --------
            ;
            Select EventMenu()              ; Check which menu was activated
              Case 8                          ; About
                MessageRequester("Hi Mike!", "AddKeyboardShortcut() seems to work nice!?", 0)
            Default
              MessageRequester("Info", "MenuItem: "+Str(EventMenu()), 0)
            EndSelect
            ;
            ; -------- End Select MenuEvents -------
            ;
          Case #WM_CLOSE                        ; #PB_EventCloseWindow
            quit = 1
        EndSelect
        ;
        ; -------- End Select WindowEvents --------
        ;
    Until quit = 1
;
End  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger