; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6522&highlight=
; Author: tinman (updated for PB3.93 by ts-soft, updated + extended for PB4.00 by Deeem2031 & remi_meier)
; Date: 13. June 2003
; OS: Windows
; Demo: Yes


; Nasty hack for freeing strings
; Possibly useful for those who have large amounts of dynamic data. 

Procedure FreeString_ASM(*free_me.string) 
  !MOV edx, 0 
  !LEA ecx, [p.p_free_me] 
  !CALL SYS_FastAllocateStringFree 
  ProcedureReturn 
EndProcedure

test1.s = "hallooooooo" 
Debug test1

FreeString_ASM(@test1)
Debug test1



Procedure FreeString(*free_me.String) 
  Protected s.String 
  PokeL(@s, *free_me) 
EndProcedure 

test2.s = "PureBasic" 
Debug test2

FreeString(@test2)
Debug test2


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
