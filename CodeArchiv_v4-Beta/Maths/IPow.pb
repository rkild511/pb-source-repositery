; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7676
; Author: jack (updated for PB 4.00 by Deeem2031)
; Date: 30. September 2003
; OS: Windows
; Demo: Yes


; Pow function for integers
Procedure.l iPow(x.l,y.l)
  ;by bitRAKE  Win32ASM Community messageboard
  ;thanks bitRAKE
  ! PUSH Ebx
  ! MOV ebx,[p.v_y+4]
  ! MOV ecx,[p.v_x+4]
  ! MOV eax, 1
  ! JMP _a
  ! _2: XCHG eax, ecx
  ! IMUL eax
  ! XCHG eax, ecx
  ! _a: SHR ebx, 1
  ! JNC _3
  ! IMUL ecx
  !_3: JNE _2
  ! POP Ebx
  ProcedureReturn
EndProcedure

Debug iPow(2,8)
Debug iPow(5,4)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
; EnableXP
