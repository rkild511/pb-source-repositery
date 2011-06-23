; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8135&highlight=
; Author: Psychophanta (updated for PB 4.00 by Deeem2031)
; Date: 17. November 2003
; OS: Windows
; Demo: No

;- Wrap() is to wrap a integer variable inside a fringe, delimited by 2 values: 

;Format: Wrap(value,margin1,margin2) 
;NOTE: the range is [lower margin, higher margin] "both inclusive" 

;Format: Wrap(value,margin1,margin2) 
;NOTE: the range is [lower margin, higher margin] "both inclusive" 

Procedure.l Wrap(number.l,margin1.l,margin2.l) 
  !PUSH Ebx
  !mov ecx,dword[p.v_number +4]   ;number 
  !mov eax,dword[p.v_margin1+4] ;margin1 
  !mov ebx,dword[p.v_margin2+4] ;margin2 
  !cmp eax,ebx  ;compare margin values 
  !jz near Wrapgo ;if margin1 = margin2 then return margin1 
  !jl near @f    ;if margin1 lower than margin2 jump. 
  !xchg eax,ebx ;swap them 
  !mov dword[p.v_margin1+4],eax ;low margin 
  !mov dword[p.v_margin2+4],ebx ;right margin 
  !@@:    ;now lower margin is in eax, and higher in ebx 
  !xor edx,edx  ;let edx=0 
  !sub ebx,eax  ;range [lowermargin,highermargin] decremented to floor. 
  !inc ebx ;to have [lowermargin,highermargin] inclusive 
  !sub ecx,eax  ;number substracted to floor 
  !mov eax,ecx  ;number 
  !jns near @f   ;if number is below lower margin then: 
  !not eax  ;change its sign and decrement it by 1 
  !div ebx    ;modulo is now in edx 
  !mov eax,dword[p.v_margin2+4];higher margin 
  !sub eax,edx  ;decrement higher margin by the obtained modulo and return the result 
  !POP Ebx
  ProcedureReturn 
  !@@: 
  !div ebx    ;modulo is now in edx 
  !mov eax,dword[p.v_margin1+4];lower margin 
  !add eax,edx  ;increment lower margin by the obtained modulo and return the result 
  !Wrapgo: 
  !POP Ebx
  ProcedureReturn 
EndProcedure 

;Prove it: 
For t=-40 To 40 
  Debug Str(t)+"   "+Str(Wrap(t,2,-13)) 
Next 



;- WrapF()) is to wrap a float variable inside a fringe, delimited by 2 values: 

;Format: WrapF(value.f,margin1.f,margin2.f) 
;NOTE: The range is [lowermargin,highermargin) for all values over and under the fringe. 

Procedure.f WrapF(number.f,margin1.f,margin2.f) 
  !fld dword[p.v_margin1] ;push left value to FPU stack (to st1) 
  !fld dword[p.v_margin2] ;push right value (to st0) 
  !fcomi st1   ;compares st1 (margin2) with st0 (margin1) 
  !jz near WrapFEqual   ;if margin1 = margin2 then return margin2 (to avoid fprem instruction to divide by 0) 
  !jnc near @f  ;if st0 (margin2) < st1 (margin1), then: 
  !fxch    ;swap st0 and st1, else: 
  !@@: ;now we have lower margin at st1, and higher margin at st0 
  !fsub st0,st1  ;range [lowermargin,highermargin] decremented to floor, now in st0 
  !fld dword[p.v_number] ;push "number" to FPU stack (to st0). 
  !fsub st0,st2  ;number (st0) substracted to floor. Number now in st0 
  !;Now "number" in st0. Range in st1. And lower margin in st2 
  !fprem  ;get remainder (modulo) in st0, from the division st0/st1 
  !ftst ;test to see if modulo <= 0 
  !fnstsw ax ;transfers FPU status word to ax 
  !fwait 
  !sahf   ;transfers ah to CPU flags. 
  !jnc near @f ;if number has a negative value (is less than lower margin), the modulo is negative too then: 
  !faddp st1,st0 ;add modulo and range (inverting modulo inside range) 
  !faddp st1,st0 ;add the result to lower margin 
  !jmp near WrapFgo 
  !WrapFEqual:fstp st1 
  !jmp near WrapFgo 
  !@@:  ;else 
  !fstp st1 ;don't need anymore the range, so now modulo is in st0 
  !faddp st1,st0 ;add the modulo to lower margin 
  !WrapFgo: ;finish returning st0 content 
  ProcedureReturn
EndProcedure 

;Prove it: 
s.f=-10 
While s<10 
  Debug StrF(s)+"   "+StrF(WrapF(s,5,-2)) 
  s+0.2764564 
Wend 

Debug "Testing speed... (#msecs. in 1E7 function call)" 
DisableDebugger 
;Test for speed: 
ff.l=GetTickCount_() 
For tt=1 To 10000000 
  WrapF(2.453,2.3452,-1.04595) 
Next 
EnableDebugger 

Debug GetTickCount_()-ff 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
