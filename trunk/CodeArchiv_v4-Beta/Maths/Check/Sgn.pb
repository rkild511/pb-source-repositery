; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8121&highlight=
; Author: Psychophanta (updated for PB 4.00 by Deeem2031)
; Date: 17. November 2003
; OS: Windows
; Demo: Yes

Procedure.b Sgn(n.f) 
  !fld dword[p.v_n] ;push FPU stack, and load value to st0 
  !fstp st1 ;left popped FPU stack while maintaining value in st0 
  !ftst   ;test value for update FPU flags. 
  !fnstsw ax  ;transfers FPU status word to ax 
  !fwait 
  !xor al,al;let al=0 
  !sahf    ;transfers ah to CPU flags. 
  !jz near @f;if 0, that's all. 
  !inc al;else al=1 
  !;inc instruction doesn't modify CPU C flag ;) 
  !jnc near @f;if positive, that's all 
  !neg al;else al=-1 
  !@@:movsx eax,al ;return and finish 
  ProcedureReturn 
EndProcedure 

;Prove it: 
r.f=7 
Debug Sgn(4.786594) 
Debug Sgn(-v.b) 
Debug Sgn(-r.f) 
Debug "" 
For t.w=-20 To 20 
  Debug Sgn(t.w) 
Next 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
