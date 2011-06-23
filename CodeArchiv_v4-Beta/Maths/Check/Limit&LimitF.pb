; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8135&highlight=
; Author: Psychophanta
; Date: 17. November 2003
; OS: Windows
; Demo: Yes

; These next 2 (Limit() and LimitF()) are wanted functions when working
; with plane or spaces, etc. 
; It is to avoid things like:
;    If j>800:j=800:EndIf 
;    If j<10:j=10:EndIf 

 
;Format: Limit(value,margin1,margin2) 
Procedure.l Limit(number.l,margin1.l,margin2.l) 
  !mov ecx,dword[esp]   ;number 
  !mov eax,dword[esp+4] ;margin1 
  !mov ebx,dword[esp+8] ;margin2 
  !cmp eax,ebx 
  !jl near @f    ;if margin1 lower than margin2 jump 
  !xchg eax,ebx ;swap them 
  !@@:    ;now lower margin is in eax, and higher in ebx 
  !cmp eax,ecx ;if eax (lower margin) > number, then: 
  !jnl near Limitgo     ;return eax (lower margin) 
  !mov eax,ebx  ;load higher margin to eax 
  !cmp eax,ecx  ;if eax (higher margin) < number, then: 
  !jl near Limitgo   ;return eax (higher margin) 
  !mov eax,ecx ;else return number 
  !Limitgo: 
  ProcedureReturn 
EndProcedure 

;Prove it: 
For limit=-20 To 20 
  Debug Str(limit)+"   "+Str(Limit(limit,4,-7)) 
Next



;Format: LimitF(value,margin1,margin2) 

Procedure.f LimitF(number.f,margin1.f,margin2.f) 
  !fld dword[esp+4] ;push right value to FPU stack 
  !fld dword[esp+8] ;push left value 
  !fcomi st1    ;compare st1 (margin2) with st0 (margin1) 
  !jc near @f   ;if st1 (margin2) < st0 (margin1), then: 
  !fxch    ;swap st0 and st1 
  !@@: ;now we have lower margin at st0, and higher margin at st1 
  !fld dword[esp] ;push number to FPU stack 
  !fcomi st1   ;compare number with st1 (the lower margin) for test C flag 
  !fcmovb st1  ;load st1 into st0 if st1 is greater st0 
  !jc near @f  ;if st0 (number) < st1 (the lower margin), then return the lower margin 
  !fcomi st2   ;compare number with st2 (the higher margin) for test C flag 
  !fcmovnb st2 ;load st2 into st0 if st2 is below st0 
  !@@: 
  !fstp st1 
  !fstp st1 
EndProcedure 

;Prove it: 
limitf.f=-5 
While limitf<5 
  Debug StrF(limitf)+"   "+StrF(LimitF(limitf,-3.67,-0.45)) 
  limitf+0.3984 
Wend

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
