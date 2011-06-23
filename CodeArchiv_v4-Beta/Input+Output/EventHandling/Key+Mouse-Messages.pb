; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=735&highlight=
; Author: bobobo (updated for PB4.00 by blbltheworm)
; Date: 23. April 2003
; OS: Windows
; Demo: No


;Autor : bobobo 
;----------------------------------------- 
;Tastatur und Mausmessages in Fenstern OHNE directX 
;dafür mit eventwParam und eventLParam (aber nur zur Anzeige für ganz Neugierige) 
;soweit ich weiß wird EventwParam und EventlParam irgendwann nicht mehr unterstützt 
;bis dahin gilt: 
;Solange die Maus im Fensterchen ist gibt es bei Bewegung derselben 
;diverse Mausmessages ..  Und .. Bei aktivem Fenster und Tastaturereignissen 
;gibt's Tastaturmessages (Taste runter und Tastehoch u.s.w.) 

;ömm ja .. Debug aktivieren !! 

OpenWindow(1,0,0,100,100,"Test",#PB_Window_ScreenCentered) 

Debug "Bitte drücken sie eine beliebige Taste!"+Str(rr) 
GetCursorPos_(st.POINT) 
Debug st\x 
Debug st\y 


Repeat 

      Select WaitWindowEvent() 

      Case #WM_MOUSEMOVE 
            Debug "#WM_MOUSEMOVEw " + Str(EventwParam()) 
            Debug "#WM_MOUSEMOVEl " + Str(EventlParam()) 
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
      Case #WM_MBUTTONDOWN 
            Debug "#WM_MBUTTONDOWN " + Str(EventwParam()) 
            Debug "#WM_MBUTTONDOWN " + Str(EventlParam()) 
      Case #WM_MBUTTONUP 
            Debug "#WM_MBUTTONUP " + Str(EventwParam()) 
            Debug "#WM_MBUTTONUP " + Str(EventlParam()) 
            
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
            Debug "#KEYDOWN(w): " + Str(EventwParam()) 
            Debug "#KEYDOWN(l): " + Str(EventlParam()) 
      Case #WM_KEYUP 
            Debug "#KEYUP(w):   " + Str(EventwParam()) 
            Debug "#KEYUP(l):   " + Str(EventlParam()) 
      Case #WM_SYSCHAR 
            Debug "#SYSCHAR:   " + Str(EventwParam()) 
      Case #WM_SYSDEADCHAR  
            Debug "#SYDEADSCHAR:   " + Str(EventwParam()) 
      Case #WM_SYSKEYDOWN 
            Debug "#SYSKEYDOWN:   " + Str(EventwParam()) 
      Case #WM_SYSKEYUP 
            Debug "#SYSKEYUP:   " + Str(EventwParam()) 
      EndSelect 
      Debug "-----------------" 
ForEver 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
