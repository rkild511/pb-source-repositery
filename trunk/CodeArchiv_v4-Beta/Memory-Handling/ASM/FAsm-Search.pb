; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6191&highlight=
; Author: Justin
; Date: 20. May 2003
; OS: Windows
; Demo: Yes

;returns address of substring in string or 0 if not found 
!Extrn _strstr 
Procedure strstr(astr, asubstr) 
  Shared astr1 
  p.l 
  astr1=astr 
  PUSH asubstr 
  PUSH astr1 
  CALL _strstr 
  ADD esp, 8 ; now I'm sure 
  MOV p, eax 
  ProcedureReturn p 
EndProcedure 

Debug strstr(@"hello", @"l") 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
