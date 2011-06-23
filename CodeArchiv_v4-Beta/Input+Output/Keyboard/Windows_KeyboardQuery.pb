; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 09. February 2003
; OS: Windows
; Demo: Yes

OpenWindow(1,0,0,100,100,"Test",#PB_Window_ScreenCentered) 

Debug "Bitte drücken sie eine beliebige Taste!"+Str(rr) 
Repeat 

      Select WaitWindowEvent() 
      
      Case #WM_ACTIVATE 
            Debug "#WM_ACTIVATE " +Str(EventwParam()) 
            Debug "#WM_ACTIVATE " +Str(EventlParam()) 
      Case #WM_CHAR 
            Debug "#CHAR w:    " + Str(EventwParam()) 
            Debug "#CHAR l:    " + Str(EventlParam()) 
      Case #WM_DEADCHAR 
            Debug "#DEADCHAR:   " + Str(EventwParam()) 
      Case #WM_KEYDOWN 
            Debug "#KEYDOWN: " + Str(EventwParam()) 
            Debug "#KEYDOWN: " + Str(EventlParam()) 
      Case #WM_KEYUP 
            Debug "#KEYUP:   " + Str(EventwParam()) 
      Case #WM_SYSCHAR 
            Debug "#SYSCHAR:   " + Str(EventwParam()) 
      Case #WM_SYSDEADCHAR  
            Debug "#SYDEADSCHAR:   " + Str(EventwParam()) 
      Case #WM_SYSKEYDOWN 
            Debug "#SYSKEYDOWN:   " + Str(EventwParam()) 
      Case #WM_SYSKEYUP 
            Debug "#SYSKEYUP:   " + Str(EventwParam()) 
      EndSelect 
ForEver 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -