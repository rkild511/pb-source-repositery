; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3235&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 28. December 2003
; OS: Windows
; Demo: No

; GetAsyncKeyState_() gibt ein Word zurück. Beim umwandeln des Words in ein Long
; werden alle Bits des oberen Word auf 1 gesetzt, wenn das Vorzeichenbit des
; unteren Words 1 war.

; Das niederwertigste Bit ($1) zeigt an ob die Taste nach dem letzten Aufruf von
; GetAsyncKeyState_() gedrückt wurde, und das höchstwertige Bit des Words
; ($80000000) gibt an ob die Taste gerade *jetzt* gedrückt ist.

; Du kannst also verschiedene Checks machen:

If OpenWindow(0,200,200,450,200,"Test of the Shift key...",#PB_Window_SystemMenu)
  Repeat
    Sleep_(1) : ev=WindowEvent() ; Don't use WaitWindowEvent or we won't see the keypress.
    
    ; Here follow the different possibilities to check a key...
    If GetAsyncKeyState_(#VK_SHIFT) & $1
      ; Taste wurde seit dem letzten Aufruf
      ; von GetAsyncKeyState_() gedrückt
    EndIf
    
    If GetAsyncKeyState_(#VK_SHIFT) & $80000000
      ; Taste ist JETZT gerade gedrückt
    EndIf
    
    If GetAsyncKeyState_(#VK_SHIFT) & $80000001
      ; Taste ist JETZT gerade gedrückt
      ; ODER
      ; wurde seit dem letzten Aufruf von
      ; GetAsyncKeyState_() gedrückt
    EndIf
    
    If GetAsyncKeyState_(#VK_SHIFT) = -32767 ; $FFFFFFFF80000001
      ; Taste ist JETZT gerade gedrückt
      ; ODER
      ; wurde seit dem letzten Aufruf von
      ; GetAsyncKeyState_() gedrückt
    EndIf
    
  Until ev=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
