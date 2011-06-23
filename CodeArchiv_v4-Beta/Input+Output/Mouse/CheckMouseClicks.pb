; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 17. February 2003
; OS: Windows
; Demo: No

; Debug aktivieren !! 

OpenWindow(1,0,0,100,100,"Test",#PB_Window_ScreenCentered) 

Debug "Bitte drücken sie eine beliebige Taste!"+Str(rr) 
Repeat 

      Select WaitWindowEvent() 


      Case #WM_MOUSEMOVE 
            Debug "#WM_MOUSEMOVE " + Str(EventwParam()) 
            Debug "#WM_MOUSEMOVE " + Str(EventlParam()) 


      Case #WM_LBUTTONDBLCLK  
            Debug "#WM_LBUTTONDBLCLK " + Str(EventwParam()) 
            Debug "#WM_LBUTTONDBLCLK " + Str(EventlParam()) 

      Case #WM_LBUTTONDOWN  
            Debug "#WM_LBUTTONDOWN " + Str(EventwParam()) 
            Debug "#WM_LBUTTONDOWN " + Str(EventlParam()) 

      Case #WM_LBUTTONUP  
            Debug "#WM_LBUTTONUP " + Str(EventwParam()) 
            Debug "#WM_LBUTTONUP " + Str(EventlParam()) 

      Case #WM_RBUTTONDOWN  
            Debug "#WM_RBUTTONDOWN " + Str(EventwParam()) 
            Debug "#WM_RBUTTONDOWN " + Str(EventlParam()) 

      Case #WM_RBUTTONUP 
            Debug "#WM_RBUTTONUP" + Str(EventwParam()) 
            Debug "#WM_RBUTTONUP" + Str(EventlParam()) 

      Case #WM_MBUTTONDBLCLK 
            Debug "#WM_MBUTTONDBLCLK " + Str(EventwParam()) 
            Debug "#WM_MBUTTONDBLCLK " + Str(EventlParam()) 
            
      Case #WM_NCMOUSEMOVE 
            Debug "#WM_NCMOUSEMOVE " + Str(EventwParam()) 
            Debug "#WM_NCMOUSEMOVE " + Str(EventlParam()) 

      Case #WM_NCLBUTTONDBLCLK 
            Debug "#WM_NCLBUTTONDBLCLK " + Str(EventwParam()) 
            Debug "#WM_NCLBUTTONDBLCLK " + Str(EventlParam()) 



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

Sleep_(100) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -