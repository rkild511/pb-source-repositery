; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8121&highlight= 
; Author: Psychophanta (updated for PB 4.00 by Deeem2031)
; Date: 17. November 2003 
; OS: Windows
; Demo: Yes

Procedure.l Min(n1.l,n2.l) 
  !mov eax,dword[p.v_n1] 
  !cmp eax,dword[p.v_n2] 
  !cmovnl eax,dword[p.v_n2] ;for i686 and above only 
  ProcedureReturn 
EndProcedure 

;Try it: 
Debug Min(20,178) 
Debug Min(177,178) 
Debug Min(170,20) 



Procedure.l Max(n1.l,n2.l) 
  !mov eax,dword[p.v_n1] 
  !cmp eax,dword[p.v_n2] 
  !cmovl eax,dword[p.v_n2];<-- NOTE: for i686 and above only 
  ProcedureReturn 
EndProcedure 

;Try it: 
Debug Max(20,-178) 
Debug Max(-177,-178) 
Debug Max(170,20) 



Procedure.f MinF(n1.f,n2.f) 
  !fld dword[p.v_n1] 
  !fld dword[p.v_n2] 
  !fstp st2 
  !fcomi st1 
  !fcmovnb st1 
  ProcedureReturn 
EndProcedure 

;prove it: 
Debug MinF(20,178) 
Debug MinF(20.177,20.178) 
Debug MinF(170,20) 
For t=-20 To 20 
  Debug MinF(0,t) 
Next 



Procedure.f MaxF(n1.f,n2.f) 
  !fld dword[p.v_n1] 
  !fld dword[p.v_n2] 
  !fstp st2 
  !fcomi st1 
  !fcmovb st1 
  ProcedureReturn 
EndProcedure 

;prove it: 
Debug MaxF(20,178) 
Debug MaxF(20.177,20.178) 
Debug MaxF(170,20) 
s.f=-5 
While s.f<5 
  Debug MaxF(s,-1.00202) 
  s+0.269048 
Wend 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
