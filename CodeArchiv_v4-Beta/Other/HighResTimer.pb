; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13410&highlight=
; Author: Sparkie
; Date: 18. December 2004
; OS: Windows
; Demo: No

Procedure.s HiResTimer(xNum) 
  Ctr1.LARGE_INTEGER 
  Ctr2.LARGE_INTEGER 
  Freq.LARGE_INTEGER 
  Overhead.LARGE_INTEGER 
  A.l 
  i.l 
  If QueryPerformanceFrequency_(Freq) 
    QueryPerformanceCounter_(Ctr1) 
    QueryPerformanceCounter_(Ctr2) 
    Overhead\lowpart = Ctr2\lowpart - Ctr1\lowpart  ; determine API overhead 
    QueryPerformanceCounter_(Ctr1)                  ; start time loop 
    Delay(xNum) 
    QueryPerformanceCounter_(Ctr2)                  ; end time loop 
    TimerInfo$ = "Delay(" + Str(xNum) + ") took " + StrF((Ctr2\lowpart - Ctr1\lowpart - Overhead\lowpart) / Freq\lowpart) + " seconds" 
    result$ = TimerInfo$ 
  Else 
    result$ = "Error occured" 
  EndIf 
  ProcedureReturn result$ 
EndProcedure 

MessageRequester("Hi_Res Timer", HiResTimer(1000))
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -