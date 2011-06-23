; German forum: 
; Author: NicTheQuick/Bobobo (updated for PB4.00 by blbltheworm) 
; Date: 14. January 2003
; OS: Windows
; Demo: Yes

OpenWindow(1,0,0,100,100,"Test",#PB_Window_ScreenCentered) 
Debug "Bitte drücken sie eine beliebige Taste!" 
Repeat 
      Select WaitWindowEvent() 
      Case #WM_CHAR 
            Debug "#CHAR:    " + Str(EventwParam()) 
      Case #WM_KEYDOWN 
            Debug "#KEYDOWN: " + Str(EventwParam()) 
      Case #WM_KEYUP 
            Debug "#KEYUP:   " + Str(EventwParam()) 
      Case #WM_DEADCHAR 
            Debug "#DEADCHAR:   " + Str(EventwParam()) 
      Case #WM_SYSCHAR 
            Debug "#SYSCHAR:   " + Str(EventwParam()) 
      Case       #WM_SYSKEYDOWN 
            Debug "#SYSKEYDOWN:   " + Str(EventwParam()) 
      Case       #WM_SYSKEYUP 
            Debug "#SYSKEYUP:   " + Str(EventwParam()) 
      EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -