; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13423&highlight=
; Author: Psychophanta
; Date: 18. December 2004
; OS: Windows
; Demo: No


; Hi-res timing delayer
; --------------------- 

;-determine timer max resolution: 
If QueryPerformanceFrequency_(Freq.LARGE_INTEGER) 
  periodns.f=1000000000/(Pow(2,32)*Freq\highpart+Freq\lowpart) 
  ;MessageRequester("","Resolution (used time per tick) in this machine is: "+Str(periodns)+" nanosecs") 
Else 
  MessageRequester("","No High-res timer allowed"):End 
EndIf 

;-determine API call and other stuff delay: 
!fldz 
!fldz 
QueryPerformanceCounter_(t1.LARGE_INTEGER) 
     ;Same stuff than below (needed to determine the time amount used by testing process): 
!fild qword[v_t1] 
!fsub st0,st1 
!fcomip st2 
!jc @f 
!@@: 
!fstp st0 
!fstp st0 
QueryPerformanceCounter_(t2.LARGE_INTEGER) 
calldelay.LARGE_INTEGER\lowpart = t2\lowpart - t1\lowpart 
;MessageRequester("","API call used time was ~ "+StrF(calldelay\lowpart*periodns)+" nanosecs") 


;-perform hires-timing delay: 
Standby.f=ValF(InputRequester("","Input wished delay time in milliseconds","0.655")) 
Standby.f*1000000;    <- pass nanosecs to millisecs 

!fld dword[v_Standby] 
!fdiv dword[v_periodns]; <-now in st0 is the #ticks to perform 
QueryPerformanceCounter_(t1.LARGE_INTEGER) 
!fild qword[v_t1]   ;<-now in st0 is checkpoint1,in st1 is #ticks 
!fsub qword[v_calldelay]  ;<-substract the time used by QueryPerformanceCounter_() function call 
!@@: 
QueryPerformanceCounter_(t2.LARGE_INTEGER) 
!fild qword[v_t2] ;<-now in st0 is checkpoint2, in st1 is checkpoint1 and in st2 is #ticks 
!fsub st0,st1   ;<- checkpoint2 - checkpoint1 - calldelay to st0 
!fcomip st2     ;<-compare #ticks 
!jc @r          ;<-continue polling until #ticks is reached 
!fstp st0 
!fstp st0 


MessageRequester("","That's it!") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -