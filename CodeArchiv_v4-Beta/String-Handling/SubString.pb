; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6191&highlight=
; Author: Psychophanta
; Date: 23. November 2003
; OS: Windows
; Demo: Yes

; Work with addresses, this can be very useful to parse big files, loading them into a buffer.

;returns address of substring in string or 0 if not found 
!Extrn _strstr 
Procedure SubString(str$, substr$) 
  !CALL _strstr 
  !sub eax,dword[esp] 
  !inc eax 
  ProcedureReturn 
EndProcedure 

Debug SubString("Hello", "o")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
