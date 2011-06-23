; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7662&highlight=
; Author: sec
; Date: 27. September 2003
; OS: Windows
; Demo: No

buffer.s = Space(1024)   ;buffer for string 

; Get And display the name of the computer. 
bufsize.l = 1024 
GetComputerName_(@buffer, @bufsize) 
MessageRequester("Computer name: ", buffer, #MB_OK); 

;Debug bufsize 

;Get And display the user name. 
bufsize.l = 1024 
GetUserName_(@buffer, @bufsize) 
MessageRequester("User name: ", buffer, #MB_OK); 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
