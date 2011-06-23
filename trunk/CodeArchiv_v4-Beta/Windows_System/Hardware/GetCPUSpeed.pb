; English forum: http://www.purebasic.fr/english/viewtopic.php?t=3811&postdays=0&postorder=asc&start=15
; Author: jack (updated for PB4.00 by blbltheworm)
; Date: 26. September 2003
; OS: Windows
; Demo: No

; from PB forums by Hi-Toro 
; post http://purebasic.myforums.net/viewtopic.php?t=3811&highlight=utility 

; inline asm by jack 

Structure bit64 
  LowPart.l 
  HighPart.l 
EndStructure 
Procedure CPUSpeed() 
  OneMillion.l=1000000 
  Define.bit64 ulEAX_EDX, ulFreq, ulTicks, ulValue, ulStartCounter, ulResult 
  QueryPerformanceFrequency_(ulFreq) 
  QueryPerformanceCounter_(ulTicks) 
  ! fild qword [esp+12] ;ulFreq 
  ! fild qword [esp+20] ;ulTicks 
  ! faddp st1,st0       ;ST0=ulFreq+ulTicks 
  ! fistp qword [esp+28];ST0->ulValue 
  ;ulValue\LowPart = ulTicks\LowPart + ulFreq\LowPart 
  ! RDTSC 
  ! MOV [esp+4], eax ;MOV ulEAX_EDX\LowPart, eax 
  ! MOV [esp+8], edx ;MOV ulEAX_EDX\HighPart,edx 
  ! fild qword [esp+4]  ;ulEAX_EDX 
  ! fistp qword [esp+36];ulStartCounter 
  ;ulStartCounter\LowPart = ulEAX_EDX\LowPart 
  ! fild qword [esp+28] ;ulValue 
startloop: 
  ! fild qword [esp+20] ;ulTicks 
  ! FCOMP 
  ! FNSTSW ax 
  ! SAHF 
  ! JAE l_endloop 
  ;While (ulTicks\LowPart <= ulValue\LowPart) 
    QueryPerformanceCounter_(ulTicks) 
  ;Wend 
  Goto startloop 
endloop: 
  ! fstp st0    
  ! RDTSC 
  ! MOV [esp+4], eax ;MOV ulEAX_EDX\LowPart, eax 
  ! MOV [esp+8], edx ;MOV ulEAX_EDX\HighPart,edx 
  ! fild qword [esp+4]  ;ulEAX_EDX 
  ! fild qword [esp+36] ;ulStartCounter 
  ! fsubp st1,st0       ;ST0=ulEAX_EDX - ulStartCounter 
  ! fild dword [esp]    ;OneMillion 
  ! fdivp st1,st0       ;ST0=(ulEAX_EDX - ulStartCounter)/1000000 
  ! fistp qword [esp+44];ST0->ulResult 
  ;ulResult\LowPart = (ulEAX_EDX\LowPart - ulStartCounter\LowPart)/1000000 
  ProcedureReturn ulResult\LowPart-2; / 1000000 
EndProcedure; Takes 1 second to calculate... 
mhz = CPUSpeed() 
MessageRequester("CPU Speed", "CPU speed: " + Str (mhz) + " MHz", #MB_ICONINFORMATION) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
