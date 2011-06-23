; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9757&highlight=
; Author: sec (updated for PB 4.00 by Andre)
; Date: 06. March 2004
; OS: Windows
; Demo: No

; Get current machine IP adress and then set it in a variable. 
InitNetwork() 
b1.s=Hostname() 
r1.l=gethostbyname_(@b1) 
r2.l=PeekL(PeekL(PeekL(r1+12))) 
Debug r2 ; what do you need? 
Debug IPString(r2) ;ipv4 with dot
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableAsm