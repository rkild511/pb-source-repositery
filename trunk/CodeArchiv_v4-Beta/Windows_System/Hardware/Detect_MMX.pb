; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6250&highlight=
; Author: El_Choni
; Date: 26. May 2003
; OS: Windows
; Demo: Yes

Procedure IsMMXSupported() ; Returns 8388608 if supported, 0 if not supported 
  result = 0 
  XOR EDX, EDX        ; Set edx to 0 just in case CPUID is disabled, not to get wrong results 
  MOV eax, 1          ; CPUID level 1 
  !CPUID              ; EDX = feature flag 
  AND edx, $800000    ; test bit 23 of feature flag 
  MOV result, edx     ; <>0 If MMX is supported 
  ProcedureReturn result 
EndProcedure 

Debug IsMMXSupported()
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
