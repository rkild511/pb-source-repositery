; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3588&highlight=
; Author: Topsoft (updated for PB 4.00 by Andre)
; Date: 01. February 2004
; OS: Windows
; Demo: No

bufflen = $FF 
*memid = AllocateMemory(bufflen) 

bufflen = GetLogicalDriveStrings_(bufflen,*memid) 

i = 0 
While i < bufflen 
     Lw.s = PeekS(*memid+i) 
     i + 4 
     LwT = GetDriveType_ (@Lw) 
     If LwT = #DRIVE_CDROM 
          Lw + "  Ich kann CD´s lesen" 
     ElseIf LwT = #DRIVE_FIXED 
          Lw + "  Ich bin eine HDD" 
     EndIf 
     Debug Lw 
Wend      
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -