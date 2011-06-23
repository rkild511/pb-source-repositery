; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7508&highlight= 
; Author: jack (updated for PB 4.00 by Deeem2031)
; Date: 12. September 2003 
; OS: Windows
; Demo: Yes

Procedure.f atan2(y.f,x.f) 
;atan2 procedure by Paul Dixon 
;http://www.powerbasic.com/support/forums/Forum4/HTML/009180.html 
;adapted to PureBasic by Jack 
! fld dword [p.v_y]     ;load y 
! fld dword [p.v_x]   ;load x 
! fpatan              ;get atan(y/x), put result in ST1. then pop stack to leave result in ST0 
! ftst                ;test ST0 (that's the top of stack) against zero 
! fstsw ax            ;put result of test into AX 
! sahf                ;get the FPU flags into the CPU flags 
! jae @@skip          ; if above or equal then skip the add 2*pi code 
! fldpi               ;get pi 
! fadd st1,st0        ;add pi to result 
! faddp st1,st0       ;and again, for 2pi, then pop the now unneeded pi from st0 
! @@skip: 
ProcedureReturn 
EndProcedure 
  

; Example usage 
x.f=-0.1 
y.f=-0.1 
z.f=57.29578*atan2(y,x) ;multiply by 57.29578 to get degrees 
Debug z.f
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
