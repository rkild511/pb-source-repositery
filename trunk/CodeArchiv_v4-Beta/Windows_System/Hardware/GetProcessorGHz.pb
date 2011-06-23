; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2419
; Author: Froggerprogger (updated for PB 4.00 by Andre + Progi1984 + Helle)
; Date: 12. March 2005
; OS: Windows
; Demo: Yes

; ghz.f = GetProcessorGHz(waitMs.l)
; returns to get the processors speed and uses waitMs Milliseconds
; for the calculation. (values >= 500 should give an accurate result)
; by Froggerprogger 12.03.05

; GetProcessorGHz(waitMs.l) liefert einen Float zurück, der die Geschwindigkeit
; der CPU in GHz wiedergibt. Dabei kann die Dauer des Tests eingestellt werden,
; "ein paar 100" ms sollten es aber schon sein, bei allem unter 100ms wird es
; bei mir zumindest sehr ungenau.

Procedure.f GetProcessorGHz(waitMs.l)
  Protected Hi.l, Lo.l

  SetPriorityClass_(GetCurrentProcess_(),#REALTIME_PRIORITY_CLASS)  ; switching to realtime priority
  Sleep_(0)                  ; wait for new time-slice

  !RDTSC                     ; load the proc's timestamp to eax & edx
  !MOV [p.v_Lo], eax         ; store eax to Lo
  !MOV [p.v_Hi], edx         ; store edx to Hi

  Sleep_(waitMs)             ; wait for waitMs ms

  !RDTSC                     ; load the proc's timestamp to eax & edx
  !SUB eax, [p.v_Lo]         ; subtract Lo from eax
  !SBB edx, [p.v_Hi]         ; subtract Hi from edx incl. carrybit

  !MOV ecx, dword 1000       ; store 1000 to ecx
  !DIV ecx                   ; divide edx & eax by ecx and store result in eax

  !MOV [p.v_Lo], eax         ; copy result to Lo

  SetPriorityClass_(GetCurrentProcess_(),#NORMAL_PRIORITY_CLASS)  ; switching back to normal priority
  Val.f=  Lo / (1000.0 * waitMs)
  ProcedureReturn Val
EndProcedure

MessageRequester("","Processorspeed is " + StrF(GetProcessorGHz(1000), 4) + " GHz") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -