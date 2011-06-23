; English forum: http://www.purebasic.fr/english/viewtopic.php?t=3811&postdays=0&postorder=asc&start=15
; Author: Rescator (updated for PB 4.00 by Andre)
; Date: 26. March 2005
; OS: Windows
; Demo: Yes

; NOTE! You will get various results due to the overhead of actually calling 
; procedures/functions like Delay() etc. 
; But the result variations should be within a few MHz, like most Mhz results. 
Procedure.l GetCpuMhz()
  Global int64val.LARGE_INTEGER
  !FINIT
  !rdtsc
  !MOV dword [v_int64val+4],Edx
  !MOV dword [v_int64val],Eax
  !FILD qword [v_int64val]
  Delay(1000)
  !rdtsc
  !MOV dword [v_int64val+4],Edx
  !MOV dword [v_int64val],Eax
  !FILD qword [v_int64val]
  !FSUBR st1,st0
  int64val\HighPart=0
  int64val\LowPart=1000000
  !FILD qword [v_int64val]
  !FDIVR st0,st2
  !fistp qword [v_int64val]
  ProcedureReturn int64val\LowPart
EndProcedure

Debug GetCpuMhz() ;This should be the aprox CPU cycles that occured during the last second.
Debug GetCpuMhz()
Debug GetCpuMhz()
Debug GetCpuMhz()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -