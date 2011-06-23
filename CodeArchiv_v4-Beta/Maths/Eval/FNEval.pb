; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8059&highlight= 
; Author: tejon (updated for PB 4.00 by Rings)
; Date: 01. November 2003 
; OS: Windows
; Demo: Yes

; Include file for FNEval_Test.pb file !!! 

; added logical operators <, <=, ==, <>, >=, > 
; operator returns 0 for false and 1 fFor true. 

Procedure.s eval(exprn$) 
  ; placed in the public domain by tejon 
  ; 
  ;since you can't have procedures or subroutines inside a procedure 
  ;(even tried CallFunctionFast(?GosubLabel) without success) 
  ;we simulate Gosub and Return 
  ;____________________________________________________________ 
  ;the following code simulates a Gosub 
  ;1: it loads the effective address of the label right after the Gosub, 
  ;   the address is put into the gosub stack 
  ;2: the stack pointer (eval_stk_index) is incremented 
  ;3: jmp to sub-routine (you could use Goto here) 
  
  ;Example: 
  ;Gosub tokenize 
  ;! MOV ebx,[eval_stk_index] 
  ;! SAL ebx,2 ;multiply index by 4 
  ;! MOV [ebx+gsubeval_stk],dword l_subeval2 
  ;! inc dword [eval_stk_index] 
  ;! JMP l_tokenize 
  ;subeval2: 
  ;____________________________________________________________ 
  
  ;this code simulates a return from gosub 
  ;1: stack pointer (eval_stk_index) is decremented 
  ;2: return address is put into ebx 
  ;3: jmp to return address 
  
  ;Example: 
  ;! dec dword [eval_stk_index] 
  ;! MOV eax,[eval_stk_index] 
  ;! SAL eax,2 
  ;! mov ebx,dword [eax+gsubeval_stk] 
  ;! JMP ebx 
  ;____________________________________________________________ 
  ;operators and functions supported: 
  ;unary +,- 
  ;+,-,*,/,^,!          (! :factorial) 
  ;____________________________________________________________ 
  ;operator precedence highest to lowest 
  ;! (gamma(1+x) if fractional) 
  ;^ 
  ;*,/ 
  ;unary +,- 
  ;+,- 
  ;logical: <, <=, ==, <>, >, >=      returns 1 if comparison is true, 0 if false 
  ; 
  ;assignment: =     ( as in a=2) 
  ;and of course, parenthesis (). 
  ;____________________________________________________________ 
  ;functions: 
  ;sin,cos,tan,asin,acos,atan,sqrt,sqr,ln,exp,log,alog,sinh,cosh,tanh,asinh,acosh,atanh 
  ;____________________________________________________________ 
  ;variables: 
  ;A thru Z, (case insensitive) 
  ;____________________________________________________________ 
  ;constants: 
  ;#pi,#e 
  ;____________________________________________________________ 
  ;@  holds the previous evaluation. 
  
  ;for example: x$=eval("sin(1/2)"), x$="4.79425538604203000e-1" 
  ;             y$=eval("asin(@)"),  y$="5.00000000000000000e-1" 
  
  
  Structure rx 
    StructureUnion 
    fword.w[5] 
    tbyte.b[10] 
    EndStructureUnion 
  EndStructure 
  
  
  x.rx:y.rx:g.rx:gt.rx:g0.rx:g2.rx 
  xtemp.rx:xtemp0.rx:xtemp1.rx:xtemp2.rx 
  tmp.rx 
  tenx.rx 
  p.l:ln.l:nm.l:id.l:i1.l 
  token.l 
  tokn.l 
  tok.l 
  token_Index.l = 1:CmpFlag.l 
  
  bc.w 
  ex.w 
  ex1.w 
  s.w 
  z.w 
  zz.w 
  bex.w 
  c.w 
  h.w 
  l.w 
  ch$="" 
  ch1$="" 
  ch2$="" 
  VarName.l=0 
  Result$="" 
  expr$=exprn$ 
  #NF=19 
  #T_ADD=43 ;+ 
  #T_SUB=45 ;- 
  #T_MUL=42 ;* 
  #T_DIV=47 ;/ 
  #T_EXP=94 ;^ 
  #T_SPC=32 ;space 
  #T_ERR=36 ;$ 
  #T_CON=35 ;# 
  #T_LPR=40 ;( 
  #T_RPR=41 ;) 
  #T_FAC=33 ;! 
  #T_LST=64 ;@ 
  #T_COM=44 ;, 
  #T_LT=60  ;less than 
  #T_EQ=61  ;equal 
  #T_GT=62  ;greater than 
  #T_LTE=188 ;less than or equal 
  #T_NEQ=189 ;not equal 
  #T_GTE=190 ;greater than or equal 
  ! finit 
  ! mov dword [OS_Index],0 
  ! mov dword [VS_Index],0 
  ! mov dword [eval_stk_index],0 
  ;Gosub tokenize 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 ;multiply index by 4 
  ! MOV [ebx+gsubeval_stk],dword l_subeval2 
  ! inc dword [eval_stk_index] 
  ! JMP l_tokenize 
  subeval2: 
  lenExpr.l = Len(expr$) 
  
  If lenExpr = 0 
    Goto EvalFNend 
  EndIf 
  
  ch1$=Mid(expr$,1,1) 
  i1=Asc(ch1$) 
  If (i1>64) And (i1<91) 
    If lenExpr>1 
      If (Mid(expr$,2,1)="=") And (Mid(expr$,3,1)<>"=") 
        expr$=Right(expr$,lenExpr-2) 
        lenExpr.l = Len(expr$) 
        VarName=i1 
      EndIf 
    EndIf 
  EndIf 
  
  ;Gosub compare 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval4 
  ! inc dword [eval_stk_index] 
  ! JMP l_compare 
  subeval4: 
  
  If token <> #T_SPC 
    PrintN("") 
    PrintN("Syntax Error") 
    PrintN("") 
    ;MessageRequester("","Syntax Error",0) 
  EndIf 
  
  If VarName>0 
    ! fld tword [ValStack] 
    i1=(VarName-65)*10 
    MOV eax,i1 
    ! fstp tword [FnEvalVars+eax] 
  EndIf 
  
  
  ! fld tword [ValStack] 
  ! fld st0 
  ! fstp tword [prev_eval] 
  LEA ebx,x 
  ! fstp tword [ebx] 
  ;***************************************************** 
  ;FtoA 
  
  z=x\fword[4]&$ffff 
  zz=x\fword[3]&$ffff 
  s=z>>15 
  If ((z=0) Or (z=-32768)) And (zz=0) 
    Result$=" 0.00000000000000000e+0000" 
    If s=-1 
      Result$="-0.00000000000000000e+0000" ;believe it or not, the FPU distinguishes between +0 and -0 
    EndIf 
    Goto FtoAend 
  EndIf 
  bex.w=(x\fword[4]&%111111111111111)-$3ffe 
  ;ex.w=bex*146/485   ;ex.w=Int(0.30103*bex)>===== 
  MOVSX eax,bex       ;                          | 
  ! imul eax,eax,146  ;146/485 = 0.3010309       | 
  ! mov ebx,485       ;                          | 
  ! cdq               ;                          | 
  ! idiv ebx          ;                          | 
  MOV ex,ax           ;.................... <===== 
  ex1.w=17-ex 
  ;FINIT 
  ;rxPower(@tenx,@rx_ten,ex1) ;raise tenx to ex power 
  MOV ax,ex1 
  ! cwde; eax 
  ;*************************************** 
  ! mov [y_rxpower],eax 
  ! fld tword [rx_ten] 
  ! fstp tword [x_rxpower] 
  ;Gosub rxpower 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword FnEval12 
  
  ! inc dword [eval_stk_index] 
  ! JMP rxpower 
  
  !FnEval12: 
  
  ! fld tword [z_rxpower] 
  LEA ebx,tenx 
  ! fstp tword [ebx] ;store z (st0) 
  
  ;LEA ebx,tenx { already in ebx } 
  ! fld tword [ebx] ;load tenx^ex into st0 
  FST st1 ;store into st1 
  LEA ebx,x 
  ! fld tword [ebx]; 
  FMUL st0,st1 ;the number is multiplied by tenx^ex 
  FST st1 
  LEA ebx,tmp 
  ! fbstp [ebx] ;BCD pack float into tmp 
  eight.w=8 
  If (tmp\tbyte[eight]&$ff)<10 
    FST st1 
    ! fld tword [rx_ten] ;load 10 into st0 
    FMUL st0,st1 
    ex=ex-1 
  EndIf 
  If s=-1 ;if our number sign was '-' then change the sign in float 
    FCHS 
  EndIf 
  LEA ebx,tmp 
  ! fbstp tword [ebx] ;BCD pack float into tmp 
  i=7 
  eight.w=8 
  c.w=tmp\tbyte[eight] & $ff 
  h.w=c>>4 
  l.w=c-h<<4 
  If h<10 
    hb$=Chr(h+48) 
  Else 
    hb$=Chr(h+55) 
  EndIf 
  If l<10 
    lb$=Chr(l+48) 
  Else 
    lb$=Chr(l+55) 
  EndIf 
  Result$=hb$+"."+lb$ 
  While i>=0 
    c.w=tmp\tbyte[i] & $ff 
    h.w=c>>4 
    l.w=c-h<<4 
    If h<10 
      hb$=Chr(h+48) 
    Else 
      hb$=Chr(h+55) 
    EndIf 
    If l<10 
      lb$=Chr(l+48) 
    Else 
      lb$=Chr(l+55) 
    EndIf 
    Result$=Result$+hb$+lb$ 
    i=i-1 
  Wend 
  If s=-1 
    Result$="-"+Result$ 
  Else 
    Result$=" "+Result$ 
  EndIf 
  ch$=Str(Abs(ex)) 
  ch$=RSet(ch$, 4, "0") 
  If ex<0 
    ch$="-"+ch$ 
  Else 
    ch$="+"+ch$ 
  EndIf 
  Result$=Result$+"e"+ch$ 
  ! fstp st0 
  FtoAend: 
  
  ;FtoA end 
  ;***************************************************** 
  Goto EvalFNend 
  
  scan: 
  
  If token_Index > lenExpr 
    token = #T_SPC 
  Else 
    token = Asc(Mid(expr$, token_Index, 1)) 
    token_Index = token_Index + 1 
  EndIf 
  ;CompilerIf 0 
  If token_Index > lenExpr 
    ch$ = " " 
  Else 
    ch$ = Mid(expr$, token_Index, 1) 
  EndIf 
  
  If (token=#T_LT)     ;if token="<" 
    If ch$="=" 
      token=#T_LTE 
      token_Index = token_Index + 1 
    ElseIf ch$=">" 
      token=#T_NEQ 
      token_Index = token_Index + 1 
    ElseIf ch$=" " 
      token=#T_ERR 
    EndIf 
  ElseIf (token=#T_GT)     ;if token=">" 
    If ch$="=" 
      token=#T_GTE 
      token_Index = token_Index + 1 
    ElseIf ch$="<" 
      token=#T_NEQ 
      token_Index = token_Index + 1 
    ElseIf ch$=" " 
      token=#T_ERR 
    EndIf 
  ElseIf (token=#T_EQ)     ;if token="=" 
    If ch$="=" 
      token_Index = token_Index + 1 
    ElseIf ch$="<" 
      token=#T_LTE 
      token_Index = token_Index + 1 
    ElseIf ch$=">" 
      token=#T_GTE 
      token_Index = token_Index + 1 
    ElseIf ch$=" " 
      token=#T_ERR 
    EndIf 
  EndIf 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  
  gamma: 
  ;Gosub factor 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_gamma1 
  ! inc dword [eval_stk_index] 
  ! JMP l_factor 
  gamma1: 
  If token <> #T_FAC 
    Goto gamma2 
  EndIf 
  ;Gosub scan 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval5 
  ! inc dword [eval_stk_index] 
  ! JMP l_scan 
  subeval5: 
  If token = #T_ERR 
    Goto gamma2 
  EndIf 
  ;rxCopy(@x,@ValStack([VS_Index] - 1)) 
  ! MOV ebx,[VS_Index] 
  ! DEC ebx 
  ! SAL ebx,1 
  ! MOV eax,ebx 
  ! SAL ebx,2 
  ! ADD ebx,eax 
  ! fld tword [ebx+ValStack] 
  LEA eax,x 
  ! fstp tword [eax] 
  If token <> #T_FAC 
    ;Gosub factorial 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval6 
    ! inc dword [eval_stk_index] 
    ! JMP l_factorial 
    subeval6: 
  Else 
    ;Gosub factorial2 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval7 
    ! inc dword [eval_stk_index] 
    ! JMP l_factorial2 
    subeval7: 
  EndIf 
  ;rxCopy(@ValStack([VS_Index] - 1),@g) 
  ! MOV ebx,[VS_Index] 
  ! DEC ebx 
  ! SAL ebx,1 
  ! MOV eax,ebx 
  ! SAL ebx,2 
  ! ADD ebx,eax 
  LEA eax,g 
  ! fld tword [eax] 
  ! fstp tword [ebx+ValStack] 
  
  If token = #T_FAC 
    ;Gosub scan 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval8 
    ! inc dword [eval_stk_index] 
    ! JMP l_scan 
    subeval8: 
  EndIf 
  Goto gamma1 
  gamma2: 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  
  expon: 
  ;gosub gamma 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_expon1 
  ! inc dword [eval_stk_index] 
  ! JMP l_gamma 
  expon1: 
  If token <> #T_EXP 
    Goto expon2 
  EndIf 
  ;gosub scan 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval9 
  ! inc dword [eval_stk_index] 
  ! JMP l_scan 
  subeval9: 
  ;Gosub gamma 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval10 
  ! inc dword [eval_stk_index] 
  ! JMP l_gamma 
  subeval10: 
  If token = #T_ERR 
    Goto expon2 
  EndIf 
  If token = #T_EXP 
    ;Gosub expon1 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval11 
    ! inc dword [eval_stk_index] 
    ! JMP l_expon1 
    subeval11: 
  EndIf 
  ! DEC dword [VS_Index] 
  ;rxFpow(@ValStack([VS_Index] - 1),@ValStack([VS_Index] - 1),@ValStack([VS_Index])) 
  ! MOV ebx,[VS_Index] 
  ! SAL ebx,1 
  ! MOV eax,ebx 
  ! SAL ebx,2 
  ! ADD ebx,eax 
  ! fld tword [ebx+ValStack] 
  ! fld tword [ebx+ValStack-10] 
  ! FYL2X 
  ! FLD st0 
  ! FRNDINT 
  ! FSUB st1, st0 
  ! FLD1 
  ! FSCALE 
  ! FXCH 
  ! FXCH st2 
  ! F2XM1 
  ! FLD1 
  ! FADDP st1, st0 
  ! FMULP st1, st0 
  ! fstp st1 
  ! fstp tword [ebx+ValStack-10] 
  Goto expon1 
  expon2: 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  
  term: 
  ;Gosub expon 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_term1 
  ! inc dword [eval_stk_index] 
  ! JMP l_expon 
  term1: 
  If (token <> #T_MUL) And (token <> #T_DIV) 
    Goto term2 
  EndIf 
  ;OpStack(OS_Index) = token: 
  ! MOV ebx,[OS_Index] 
  ! SAL ebx,2 
  MOV eax,token 
  ! MOV [ebx+OpStack],eax 
  ! inc dword [OS_Index] 
  ;Gosub scan 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval12 
  ! inc dword [eval_stk_index] 
  ! JMP l_scan 
  subeval12: 
  ;Gosub expon 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval13 
  ! inc dword [eval_stk_index] 
  ! JMP l_expon 
  subeval13: 
  ! dec dword [OS_Index] 
  ! MOV ebx,[OS_Index] 
  ! SAL ebx,2 
  ! MOV eax,[ebx+OpStack] 
  MOV tokn,eax 
  ;tokn = OpStack(OS_Index) 
  If tokn = #T_MUL 
    If token = #T_ERR 
      Goto term2 
    EndIf 
    ! DEC dword [VS_Index] 
    ;  rxMul(@ValStack([VS_Index] - 1),@ValStack([VS_Index] - 1),@ValStack([VS_Index])) 
    ! MOV ebx,[VS_Index] 
    ! SAL ebx,1 
    ! MOV eax,ebx 
    ! SAL ebx,2 
    ! ADD ebx,eax 
    ! fld tword [ebx+ValStack-10] 
    ! fld tword [ebx+ValStack] 
    ! fmulp st1,st0 
    ! fstp tword [ebx+ValStack-10] 
    Goto term1 
  EndIf 
  If tokn = #T_DIV 
    If token = #T_ERR 
      Goto term2 
    EndIf 
    ! DEC dword [VS_Index] 
    ;  rxDiv(@ValStack([VS_Index] - 1),@ValStack([VS_Index] - 1),@ValStack([VS_Index])) 
    ! MOV ebx,[VS_Index] 
    ! SAL ebx,1 
    ! MOV eax,ebx 
    ! SAL ebx,2 
    ! ADD ebx,eax 
    ! fld tword [ebx+ValStack-10] 
    ! fld tword [ebx+ValStack] 
    ! fdivp st1,st0 
    ! fstp tword [ebx+ValStack-10] 
    Goto term1 
  EndIf 
  term2: 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  
  unary: 
  If (token = #T_SUB) Or (token = #T_ADD) 
    ;  OpStack(OS_Index) = token 
    ! MOV ebx,[OS_Index] 
    ! SAL ebx,2 
    MOV eax,token 
    ! MOV [ebx+OpStack],eax 
    ! inc dword [OS_Index] 
    ;Gosub scan 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval14 
    ! inc dword [eval_stk_index] 
    ! JMP l_scan 
    subeval14: 
    ;Gosub term 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval15 
    ! inc dword [eval_stk_index] 
    ! JMP l_term 
    subeval15: 
    ! dec dword [OS_Index] 
    ! mov ebx,[OS_Index] 
    ! SAL ebx,2 
    ! MOV eax,[ebx+OpStack] 
    MOV tokn,eax 
    ;tokn = OpStack(OS_Index) 
    If tokn <> #T_SUB 
      Goto unary1 
    EndIf 
    If token = #T_ERR 
      Goto unary1 
    EndIf 
    ;  rxChs(@ValStack([VS_Index] - 1),@ValStack([VS_Index] - 1)) 
    ! MOV ebx,[VS_Index] 
    ! DEC ebx 
    ! SAL ebx,1 
    ! MOV eax,ebx 
    ! SAL ebx,2 
    ! ADD ebx,eax 
    ! fld tword [ebx+ValStack] 
    FCHS 
    ! fstp tword [ebx+ValStack] 
    Goto unary1 
  EndIf 
  ;Gosub term 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_unary1 
  ! inc dword [eval_stk_index] 
  ! JMP l_term 
  unary1: 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  
  evaluate_expr: 
  ;Gosub unary 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_expr1 
  ! inc dword [eval_stk_index] 
  ! JMP l_unary 
  expr1: 
  If (token <> #T_ADD) And (token <> #T_SUB) 
    Goto expr2 
  EndIf 
  ;OpStack(OS_Index) = token: 
  ! mov ebx,[OS_Index] 
  ! SAL ebx,2 
  MOV eax,token 
  ! MOV [ebx+OpStack],eax 
  ! inc dword [OS_Index] 
  ;Gosub scan 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval16 
  ! inc dword [eval_stk_index] 
  ! JMP l_scan 
  subeval16: 
  ;Gosub unary 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval17 
  ! inc dword [eval_stk_index] 
  ! JMP l_unary 
  subeval17: 
  ! dec dword [OS_Index] 
  ! mov ebx,[OS_Index] 
  ! SAL ebx,2 
  ! MOV eax,[ebx+OpStack] 
  MOV tokn,eax 
  ;tokn = OpStack(OS_Index) 
  If tokn = #T_ADD 
    If token = #T_ERR 
      Goto expr2 
    EndIf 
    ! DEC dword [VS_Index] 
    ;  rxAdd(@ValStack([VS_Index] - 1),@ValStack([VS_Index] - 1),@ValStack([VS_Index])) 
    ! MOV ebx,[VS_Index] 
    ! SAL ebx,1 
    ! MOV eax,ebx 
    ! SAL ebx,2 
    ! ADD ebx,eax 
    ! fld tword [ebx+ValStack-10] 
    ! fld tword [ebx+ValStack] 
    ! faddp st1,st0 
    ! fstp tword [ebx+ValStack-10] 
    Goto expr1 
  EndIf 
  If tokn = #T_SUB 
    If token = #T_ERR 
      Goto expr2 
    EndIf 
    ! DEC dword [VS_Index] 
    ;  rxSub(@ValStack([VS_Index] - 1),@ValStack([VS_Index] - 1),@ValStack([VS_Index])) 
    ! MOV ebx,[VS_Index] 
    ! SAL ebx,1 
    ! MOV eax,ebx 
    ! SAL ebx,2 
    ! ADD ebx,eax 
    ! fld tword [ebx+ValStack-10] 
    ! fld tword [ebx+ValStack] 
    ! fsubp st1,st0 
    ! fstp tword [ebx+ValStack-10] 
    Goto expr1 
  EndIf 
  expr2: 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  compare: 
  ;Gosub scan 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval3 
  ! inc dword [eval_stk_index] 
  ! JMP l_scan 
  subeval3: 
  
  ;Gosub evaluate_expr 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_compare1 
  ! inc dword [eval_stk_index] 
  ! JMP l_evaluate_expr 
  compare1: 
  If ((token<>#T_LT) And (token<>#T_EQ) And (token<>#T_GT) And (token<>#T_LTE) And (token<>#T_GTE) And (token<>#T_NEQ)) 
    Goto compare4 
  EndIf 
  ;OpStack(OS_Index) = token: 
  ! MOV ebx,[OS_Index] 
  ! SAL ebx,2 
  MOV eax,token 
  ! MOV [ebx+OpStack],eax 
  ! inc dword [OS_Index] 
  ;Gosub scan 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_compare2 
  ! inc dword [eval_stk_index] 
  ! JMP l_scan 
  compare2: 
  ;Gosub evaluate_expr 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_compare3 
  ! inc dword [eval_stk_index] 
  ! JMP l_evaluate_expr 
  compare3: 
  ! dec dword [OS_Index] 
  ! MOV ebx,[OS_Index] 
  ! SAL ebx,2 
  ! MOV eax,[ebx+OpStack] 
  MOV tokn,eax 
  If ((tokn=#T_LT) Or (tokn=#T_EQ) Or (tokn=#T_GT) Or (tokn=#T_LTE) Or (tokn=#T_GTE) Or (tokn=#T_NEQ)) 
    If token=#T_ERR 
      Goto compare4 
    EndIf 
    ! DEC dword [VS_Index] 
    ! MOV edx,[VS_Index] 
    ! SAL edx,1 
    ! MOV eax,edx 
    ! SAL edx,2 
    ! ADD edx,eax 
    ! fld tword [edx+ValStack] 
    ! fld tword [edx+ValStack-10] 
    ! fcompp 
    ! fnstsw ax 
    ! sahf 
    JE l_cmp_equals 
    JB l_cmp_x_less_y 
    JA l_cmp_x_greater_y 
    cmp_equals: 
    MOV CmpFlag,0 
    JMP l_compare_end 
    cmp_x_less_y: 
    MOV CmpFlag,1 
    JMP l_compare_end 
    cmp_x_greater_y: 
    MOV CmpFlag,2 
    compare_end: 
    If tokn=#T_LT 
      If (CmpFlag=1) 
        ! fld1 
      Else 
        ! fldz 
      EndIf 
      ! fstp tword [edx+ValStack-10] 
    ElseIf tokn=#T_EQ 
      If (CmpFlag=0) 
        ! fld1 
      Else 
        ! fldz 
      EndIf 
      ! fstp tword [edx+ValStack-10] 
    ElseIf tokn=#T_GT 
      If (CmpFlag=2) 
        ! fld1 
      Else 
        ! fldz 
      EndIf 
      ! fstp tword [edx+ValStack-10] 
    ElseIf tokn=#T_LTE 
      If (CmpFlag=0) Or (CmpFlag=1) 
        ! fld1 
      Else 
        ! fldz 
      EndIf 
      ! fstp tword [edx+ValStack-10] 
    ElseIf tokn=#T_GTE 
      If (CmpFlag=0) Or (CmpFlag=2) 
        ! fld1 
      Else 
        ! fldz 
      EndIf 
      ! fstp tword [edx+ValStack-10] 
    ElseIf  tokn=#T_NEQ 
      If (CmpFlag<>0) 
        ! fld1 
      Else 
        ! fldz 
      EndIf 
      ! fstp tword [edx+ValStack-10] 
    EndIf 
  EndIf 
  compare4: 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  factor: 
  tok=tokn 
  tokn = token 
  If (token>64) And (token<91) ;A..Z 
    ! MOV ebx,[VS_Index] 
    ! SAL ebx,1 
    ! MOV eax,ebx 
    ! SAL ebx,2 
    ! ADD ebx,eax 
    MOV eax,token 
    ! sub eax,65 
    ! sal eax,1 
    ! mov edx,eax 
    ! sal eax,2 
    ! add eax,edx 
    ! fld tword [eax+FnEvalVars] 
    ! fstp tword [ebx+ValStack] 
    ! INC dword [VS_Index] 
    ;Gosub scan 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval18 
    ! inc dword [eval_stk_index] 
    ! JMP l_scan 
    subeval18: 
  ElseIf token = #T_LST 
    ;  rxCopy(@ValStack([VS_Index]),@prev_eval): [VS_Index] = [VS_Index] + 1 
    ! MOV ebx,[VS_Index] 
    ! SAL ebx,1 
    ! MOV eax,ebx 
    ! SAL ebx,2 
    ! ADD ebx,eax 
    ! fld tword [prev_eval] 
    ! fstp tword [ebx+ValStack] 
    ! INC dword [VS_Index] 
    ;Gosub scan 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval20 
    ! inc dword [eval_stk_index] 
    ! JMP l_scan 
    subeval20: 
  ElseIf token = #T_CON 
    ;  rxCopy(@ValStack([VS_Index]),@constant(Val(Mid(expr$, token_Index, 2)))): [VS_Index] = [VS_Index] + 1 
    i1=Val(Mid(expr$, token_Index, 2)) 
    token_Index = token_Index + 2 
    MOV ebx,i1 
    ! SAL ebx,1 
    ! MOV eax,ebx 
    ! SAL ebx,2 
    ! ADD ebx,eax 
    ! fld tword [ebx+constant] 
    ! MOV ebx,[VS_Index] 
    ! SAL ebx,1 
    ! MOV eax,ebx 
    ! SAL ebx,2 
    ! ADD ebx,eax 
    ! fstp tword [ebx+ValStack] 
    ! INC dword [VS_Index] 
    ;Gosub scan 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval21 
    ! inc dword [eval_stk_index] 
    ! JMP l_scan 
    subeval21: 
  ElseIf (token = #T_SUB) Or (token = #T_ADD) 
    ;Gosub unary 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval22 
    ! inc dword [eval_stk_index] 
    ! JMP l_unary 
    subeval22: 
  ElseIf token = #T_LPR 
    ;Gosub compare 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval24 
    ! inc dword [eval_stk_index] 
    ! JMP l_compare 
    subeval24: 
    If token <> #T_RPR 
      PrintN("") : PrintN( "Missing ')'") 
    EndIf 
    ;Gosub scan 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval25 
    ! inc dword [eval_stk_index] 
    ! JMP l_scan 
    subeval25: 
  Else 
    tokn = token 
    If (tokn = 0) Or (tokn > #NF) 
      token = #T_ERR 
    Else 
      ;Gosub scan 
      ! MOV ebx,[eval_stk_index] 
      ! SAL ebx,2 
      ! MOV [ebx+gsubeval_stk],dword l_subeval26 
      ! inc dword [eval_stk_index] 
      ! JMP l_scan 
      subeval26: 
      ;    OpStack(OS_Index) = tokn: 
      ! MOV ebx,[OS_Index] 
      ! SAL ebx,2 
      MOV eax,tokn 
      ! MOV [ebx+OpStack],eax 
      ! inc dword [OS_Index] 
      If token <> #T_LPR 
        PrintN( "'(' expected") 
      Else 
        ;Gosub compare 
        ! MOV ebx,[eval_stk_index] 
        ! SAL ebx,2 
        ! MOV [ebx+gsubeval_stk],dword l_subeval28 
        ! inc dword [eval_stk_index] 
        ! JMP l_compare 
        subeval28: 
        If token <> #T_RPR 
          PrintN( "')' expected") 
        Else 
          ! nop 
          ! nop 
          ! nop 
          ! nop 
          ;Gosub scan 
          ! MOV ebx,[eval_stk_index] 
          ! SAL ebx,2 
          ! MOV [ebx+gsubeval_stk],dword l_subeval29 
          ! inc dword [eval_stk_index] 
          ! JMP l_scan 
          subeval29: 
          ! dec dword [OS_Index] 
          ! mov ebx,[OS_Index] 
          ! SAL ebx,2 
          ! MOV eax,[ebx+OpStack] 
          MOV tokn,eax 
          ! MOV ebx,[VS_Index] 
          ! DEC ebx 
          ! SAL ebx,1 
          ! MOV eax,ebx 
          ! SAL ebx,2 
          ! ADD ebx,eax 
          ! fld tword [ebx+ValStack] 
          MOV eax,tokn 
          ! SAL eax,2 ;multiply by 4 
          ! MOV eax,[eax+l_jmptable] 
          ! JMP eax 
          asinh:! fldln2 ;load loge(2) 
          ! FXCH 
          ! FLD st0 
          ! FMUL st0,st0 
          ! FLD1 
          ! faddp st1,st0 
          ! FSQRT 
          ! faddp st1,st0 
          ! FYL2X ;st1*log2(x) 
          ! JMP l_endfns 
          acosh:! fldln2 ;load loge(2) 
          ! FXCH 
          ! FLD st0 
          ! FMUL st0,st0 
          ! FLD1 
          ! fsubp st1,st0 
          ! FSQRT 
          ! faddp st1,st0 
          ! FYL2X ;st1*log2(x) 
          ! JMP l_endfns 
          atanh:! fldln2 ;load loge(2) 
          ! FXCH 
          ! FLD1 
          ! faddp st1,st0 
          ! FLD st0 
          ! fld tword [rx_two] 
          ! fsubrp st1,st0 
          ! fdivp st1,st0 
          ! FYL2X ;st1*log2(x) 
          ! fld tword [rx_half] 
          ! fmulp st1,st0 
          ! JMP l_endfns 
          sinh: ! FLD tword [rx_e] 
          ! FYL2X 
          ! FLD st0 
          ! FRNDINT 
          ! FSUB st1, st0 
          ! FLD1 
          ! FSCALE 
          ! FXCH 
          ! FXCH st2 
          ! F2XM1 
          ! FLD1 
          ! FADDP st1, st0 
          ! FMULP st1, st0 
          ! fstp st1 
          ! FLD st0 
          ! FLD1 
          ! fdivrp st1,st0 
          ! fsubp st1,st0 
          ! fld tword [rx_half] 
          ! fmulp st1,st0 
          ! JMP l_endfns 
          cosh: ! FLD tword [rx_e] 
          ! FYL2X 
          ! FLD st0 
          ! FRNDINT 
          ! FSUB st1, st0 
          ! FLD1 
          ! FSCALE 
          ! FXCH 
          ! FXCH st2 
          ! F2XM1 
          ! FLD1 
          ! FADDP st1, st0 
          ! FMULP st1, st0 
          ! fstp st1 
          ! FLD st0 
          ! FLD1 
          ! fdivrp st1,st0 
          ! faddp st1,st0 
          ! fld tword [rx_half] 
          ! fmulp st1,st0 
          ! JMP l_endfns 
          tanh: ! FLD tword [rx_e] 
          ! FYL2X 
          ! FLD st0 
          ! FRNDINT 
          ! FSUB st1, st0 
          ! FLD1 
          ! FSCALE 
          ! FXCH 
          ! FXCH st2 
          ! F2XM1 
          ! FLD1 
          ! FADDP st1, st0 
          ! FMULP st1, st0 
          ! fstp st1 
          ! FMUL  st0,st0 
          ! FLD   st0 
          ! FLD1 
          ! faddp st1,st0 
          ! FXCH 
          ! FLD1 
          ! fsubp st1,st0 
          ! fdivrp st1,st0 
          ! JMP l_endfns 
          asin: ! FLD1 
          ! FLD    st1 
          ! FMUL   st0,st0 
          ! FSUBP  st1,st0 
          ! FSQRT 
          ! FPATAN 
          ! fstp st1 
          ! JMP l_endfns 
          acos: ! FLD1 
          ! FLD    st1 
          ! FMUL   st0,st0 
          ! FSUBP  st1,st0 
          ! FSQRT 
          ! FXCH 
          ! FPATAN 
          ! fstp st1 
          ! JMP l_endfns 
          atan: ! FLD1 
          ! FPATAN 
          ! fstp st1 
          ! JMP l_endfns 
          alog: ! FLD tword [rx_ten] 
          ! FYL2X 
          ! FLD st0 
          ! FRNDINT 
          ! FSUB st1, st0 
          ! FLD1 
          ! FSCALE 
          ! FXCH 
          ! FXCH st2 
          ! F2XM1 
          ! FLD1 
          ! FADDP st1, st0 
          ! FMULP st1, st0 
          ! fstp st1 
          ! JMP l_endfns 
          sqrt: ! FSQRT 
          ! JMP l_endfns 
          sin:  ! FSIN 
          ! JMP l_endfns 
          cos:  ! fcos 
          ! JMP l_endfns 
          tan:  ! fptan 
          ! fstp st0 
          ! JMP l_endfns 
          log:  ! fldlg2 ;load Log10(2) 
          ! FXCH 
          ! fyl2x ; st1*log2(x) 
          ! JMP l_endfns 
          exp:  ! FLD tword [rx_e] 
          ! FYL2X 
          ! FLD st0 
          ! FRNDINT 
          ! FSUB st1, st0 
          ! FLD1 
          ! FSCALE 
          ! FXCH 
          ! FXCH st2 
          ! F2XM1 
          ! FLD1 
          ! FADDP st1, st0 
          ! FMULP st1, st0 
          ! fstp st1 
          ! JMP l_endfns 
          sqr:  ! FMUL st0,st0 
          ! JMP l_endfns 
          ln:   ! fldln2 ;load loge(2) 
          ! FXCH 
          ! FYL2X ;st1*log2(x) 
          endfns: 
          ! fstp tword [ebx+ValStack] 
        EndIf 
        endfactor: 
      EndIf 
    EndIf 
  EndIf 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  numstrip: 
  a$ = expr$ + " " 
  expr$ = "" 
  ln = Len(a$) 
  id = 1 
  value$ = "" 
  vi = 0 
  numstrip1: 
  ch1$="" 
  ch2$="" 
  If (id > ln) And (value$ = "") 
    Goto numstrip3 
  EndIf 
  If id > ln 
    ;Gosub vl 
    ! MOV ebx,[eval_stk_index] 
    ! SAL ebx,2 
    ! MOV [ebx+gsubeval_stk],dword l_subeval30 
    ! inc dword [eval_stk_index] 
    ! JMP l_vl 
    subeval30: 
    Goto numstrip1 
  EndIf 
  ch$ = Mid(a$, id, 1) 
  id = id + 1 
  If id<ln 
    ch1$=Mid(a$, id, 1) 
  EndIf 
  If ch$="#" 
    If (id+1)<ln 
      ch2$=Mid(a$,id+1,1) 
    EndIf 
    If ch1$="E" 
      MOV ebx,vi 
      ! SAL ebx,1 
      ! MOV eax,ebx 
      ! SAL ebx,2 
      ! ADD ebx,eax 
      ! fld tword [rx_e] 
      ! fstp tword [ebx+constant] 
      s$ = Str(vi) 
      vi = vi + 1 
      If (Len(s$) < 2) 
        s$ = "0" + s$ 
      EndIf 
      expr$ = expr$ + "#" + s$ 
      value$ = "" 
      id=id+1 
      Goto numstrip1 
    ElseIf (ch1$="P") And (ch2$="I") 
      MOV ebx,vi 
      ! SAL ebx,1 
      ! MOV eax,ebx 
      ! SAL ebx,2 
      ! ADD ebx,eax 
      ! fldpi 
      ! fstp tword [ebx+constant] 
      s$ = Str(vi) 
      vi = vi + 1 
      If (Len(s$) < 2) 
        s$ = "0" + s$ 
      EndIf 
      expr$ = expr$ + "#" + s$ 
      value$ = "" 
      id=id+2 
      Goto numstrip1 
    EndIf 
  EndIf 
  nm = FindString(" .0123456789", ch$,1) 
  If nm = 1 
    Goto numstrip1 
  EndIf 
  If (nm = 0) And (value$ = "") 
    expr$ = expr$ + ch$ 
    Goto numstrip1 
  EndIf 
  If nm = 0 
    If (value$ <> "") And (FindString("E", ch$,1) > 0) 
      ;Gosub vl1 
      ! MOV ebx,[eval_stk_index] 
      ! SAL ebx,2 
      ! MOV [ebx+gsubeval_stk],dword l_subeval31 
      ! inc dword [eval_stk_index] 
      ! JMP l_vl1 
      subeval31: 
      Goto numstrip1 
    EndIf 
    If nm = 0 
      ;Gosub vl 
      ! MOV ebx,[eval_stk_index] 
      ! SAL ebx,2 
      ! MOV [ebx+gsubeval_stk],dword l_subeval32 
      ! inc dword [eval_stk_index] 
      ! JMP l_vl 
      subeval32: 
      Goto numstrip1 
    EndIf 
  EndIf 
  value$ = value$ + ch$ 
  If nm <> 2 
    Goto numstrip1 
  EndIf 
  numstrip2: 
  If id > ln 
    Goto numstrip1 
  EndIf 
  ch$ = Mid(a$, id, 1) 
  id = id + 1 
  nm = FindString(" .0123456789", ch$,1) 
  If (nm = 1) Or (nm = 2) 
    Goto numstrip2 
  EndIf 
  If nm = 0 
    If FindString("E", ch$,1) > 0 
      ;Gosub vl1 
      ! MOV ebx,[eval_stk_index] 
      ! SAL ebx,2 
      ! MOV [ebx+gsubeval_stk],dword l_subeval33 
      ! inc dword [eval_stk_index] 
      ! JMP l_vl1 
      subeval33: 
      Goto numstrip1 
    EndIf 
    If nm = 0 
      ;Gosub vl 
      ! MOV ebx,[eval_stk_index] 
      ! SAL ebx,2 
      ! MOV [ebx+gsubeval_stk],dword l_subeval34 
      ! inc dword [eval_stk_index] 
      ! JMP l_vl 
      subeval34: 
      Goto numstrip1 
    EndIf 
  EndIf 
  value$ = value$ + ch$ 
  Goto numstrip2 
  Goto numstrip1 
  vl1: 
  value$ = value$ + "E" 
  vl0: 
  If id > ln 
    value$ = value$ + "0" 
    ch$ = "" 
    Goto vl 
  EndIf 
  ch$ = Mid(a$, id, 1) 
  id = id + 1 
  nm = FindString(" +-", ch$,1) 
  If nm = 1 
    Goto vl0 
  EndIf 
  If nm > 1 
    value$ = value$ + ch$ 
    ch$ = Mid(a$, id, 1) 
    id = id + 1 
    nm = 0 
  EndIf 
  If nm = 0 
    nm = FindString("0123456789", ch$,1) 
    If nm = 0 
      value$ = value$ + "0" 
      Goto vl2 
    EndIf 
    value$ = value$ + ch$ 
    Goto vl2 
    value$ = value$ + ch$ + "0" 
  EndIf 
  vl2: 
  If id > ln 
    ch$ = "" 
    Goto vl 
  EndIf 
  ch$ = Mid(a$, id, 1) 
  id = id + 1 
  nm = FindString(" 0123456789", ch$,1) 
  If nm = 1 
    Goto vl2 
  EndIf 
  If nm = 0 
    Goto vl 
  EndIf 
  value$ = value$ + ch$ 
  Goto vl2 
  vl: 
  ;rxAtoF(@constant(vi),value$ + "") 
  ;rxAtoF(@x,value$) 
  ;******************************************************* 
  ;Procedure rxAtoF(*x.rx,float$) 
  
  s=1 
  d=0 
  e=0 
  ep=0 
  ex=0 
  es=1 
  i=0 
  f=0 
  fp=0 
  j=1 
  fln=Len(value$) 
  ;f$=UCase(float$) 
  f1$="" 
  f2$="" 
  f3$="" 
  While j<=fln 
    c$=Mid(value$,j,1) 
    If ep=1 
      If c$=" " 
        Goto nxtch 
      EndIf 
      If c$="-" 
        es=-es 
        c$="" 
      EndIf 
      If c$="+" 
        Goto nxtch 
      EndIf 
      If (c$="0") And (f3$="") 
        Goto nxtch 
      EndIf 
      If (c$>"/") And (c$<":") ;c$ is digit between 0 and 9 
        f3$=f3$+c$ 
        ex=10*ex+(Asc(c$)-48) 
        Goto nxtch 
      EndIf 
    EndIf 
    
    If c$=" " 
      Goto nxtch 
    EndIf 
    If c$="-" 
      s=-s 
      Goto nxtch 
    EndIf 
    If c$="+" 
      Goto nxtch 
    EndIf 
    If c$="." 
      If d=1 
        Goto nxtch 
      EndIf 
      d=1 
    EndIf 
    If (c$>"/") And (c$<":") ;c$ is digit between 0 and 9 
      If ((c$="0") And (i=0)) 
        If d=0 
          Goto nxtch 
        EndIf 
        If (d=1) And (f=0) 
          e=e-1 
          Goto nxtch 
        EndIf 
      EndIf 
      If d=0 
        f1$=f1$+c$ 
        i=i+1 
      Else 
        If (c$>"0") 
          fp=1 
        EndIf 
        f2$=f2$+c$ 
        f=f+1 
      EndIf 
    EndIf 
    If c$="E" 
      ep=1 
    EndIf 
    nxtch: 
    j=j+1 
  Wend 
  If fp=0 
    f=0 
    f2$="" 
  EndIf 
  If i>18 
    f1$=Mid(f1$,1,18) 
    f2$="" 
  EndIf 
  ex=(es*ex)-(18-i)+e 
  f1$=f1$+f2$ 
  fln=Len(f1$) 
  While Len(f1$)<18 
    f1$=f1$+"0" 
  Wend 
  x\tbyte[9]=0 ;alway zero for positive BCD number 
  i=1 
  j=8 
  c.w 
  While i<18 
    c=16*(Asc(Mid(f1$,i,1))-48) 
    i=i+1 
    c=c+(Asc(Mid(f1$,i,1))-48) 
    i=i+1 
    x\tbyte[j]=c 
    j=j-1 
  Wend 
  ;rxPower(@tmp,@rx_ten,ex) 
  
  ;now we raise 10 to power ex and multiply our number by it to get proper float 
  ;******************************************************* 
  ;! rxpower: 
  MOV ax,ex 
  ! cwde; eax 
  ! mov [y_rxpower],eax 
  ! fld tword [rx_ten] 
  ! fstp tword [x_rxpower] 
  ;Gosub rxpower 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_numstrip12 
  ! inc dword [eval_stk_index] 
  ! JMP rxpower 
  numstrip12: 
  ! fld tword [z_rxpower] 
  ;******************************************************* 
  LEA eax,x 
  ! fbld tword [eax] 
  ! fmulp st1,st0 
  If s=-1 ;if our number sign was '-' then change the sign in float 
    FCHS 
  EndIf 
  ;end AtoF 
  ;******************************************************* 
  MOV ebx,vi 
  ! SAL ebx,1 
  ! MOV eax,ebx 
  ! SAL ebx,2 
  ! ADD ebx,eax 
  ! fstp tword [ebx+constant] 
  s$ = Str(vi) 
  vi = vi + 1 
  If (Len(s$) < 2) 
    s$ = "0" + s$ 
  EndIf 
  expr$ = expr$ + "#" + s$ + ch$ 
  value$ = "" 
  numstrip3: 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  
  tokenize: 
  expr$ = UCase(RemoveString(expr$," ")) 
  bc=1 
  p = FindString(expr$,"ASINH" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 5)+1) 
    p = FindString(expr$, "ASINH",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"ACOSH" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 5)+1) 
    p = FindString(expr$, "ACOSH",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"ATANH" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 5)+1) 
    p = FindString(expr$, "ATANH",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"SINH" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 4)+1) 
    p = FindString(expr$, "SINH",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"COSH" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 4)+1) 
    p = FindString(expr$, "COSH",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"TANH" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 4)+1) 
    p = FindString(expr$, "TANH",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"ASIN" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 4)+1) 
    p = FindString(expr$, "ASIN",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"ACOS" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 4)+1) 
    p = FindString(expr$, "ACOS",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"ATAN" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 4)+1) 
    p = FindString(expr$, "ATAN",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"ALOG" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 4)+1) 
    p = FindString(expr$, "ALOG",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"SQRT" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 4)+1) 
    p = FindString(expr$, "SQRT",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"SIN" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 3)+1) 
    p = FindString(expr$, "SIN",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"COS" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 3)+1) 
    p = FindString(expr$, "COS",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"TAN" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 3)+1) 
    p = FindString(expr$, "TAN",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"LOG" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 3)+1) 
    p = FindString(expr$, "LOG",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"EXP" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 3)+1) 
    p = FindString(expr$, "EXP",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"SQR" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 3)+1) 
    p = FindString(expr$, "SQR",1) 
  Wend 
  bc=bc+1 
  p = FindString(expr$,"LN" ,1) 
  While p <> 0 
    expr$ = Left(expr$, p - 1) + Chr(bc) + Right(expr$, Len(expr$)-(p + 2)+1) 
    p = FindString(expr$, "LN",1) 
  Wend 
  ;Gosub numstrip 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_subeval35 
  ! inc dword [eval_stk_index] 
  ! JMP l_numstrip 
  subeval35: 
  
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  ;*************************************** 
  
  factorial: 
  LEA ebx,x 
  ! fld tword [ebx] 
  ! fld st0 
  ! fld st0 
  ! FRNDINT 
  ! FCOMPP 
  ! FNSTSW ax 
  ! SAHF 
  ! JE l_fac1 
  ! jmp l_fac5 
  fac1: 
  ! fldz 
  ! FCOMPP 
  ! FNSTSW ax 
  ! SAHF 
  ! JBE l_fac2 
  ! fld tword [mbig] 
  ! jmp l_fac 
  fac2: 
  ! fld tword [ebx] 
  ! fild dword [OneHundred] 
  ! FCOMPP 
  ! FNSTSW ax 
  ! SAHF 
  ! JB l_fac5 
  ! fld tword [ebx] 
  ! fist dword [IntX] 
  ! mov ecx,[IntX] 
  ! fld1 
  ! fld1 
  ! fld st2 
  fac3: 
  ! fmul st2,st0 
  ! fsub st0,st1 
  ! sub ecx,1 
  ! jnle l_fac3 
  fac4: 
  ! fcompp 
  ! fstp st1 
  ! jmp l_fac 
  
  ;*************************************** 
  
  ; gamma(x + 1) = (x + Y + 1/2)^(x + 1/2)*exp(-(x + Y + 1/2)) 
  ; *sqrt(2*Pi)*(C0 + C1/(x + 1) + C2/(x + 2) +...+ CN/(x + N)) 
  ; 
  ; for more information visit http://home.att.net/~numericana/answer/info/godfrey.htm 
  fac5: 
  ! fld tword [ebx]         ;load x 
  ! fld tword [120+gamma]   ; 9.5 
  ! faddp st1,st0           ;x + 9.5 
  ! fld st0                 ;make copy 
  ! fld tword [ebx]         ;load x again 
  ! fld tword [rx_half]     ;load .5 
  ! faddp st1,st0           ;x + .5 
  ! fxch                    ;exchange st0 and st1: st0 = x + 9.5, st1 = x + .5 
  ! FYL2X                   ;st0 = st0 ^ st1 
  ! FLD st0                 ; " 
  ! FRNDINT                 ; " 
  ! FSUB st1, st0           ; " 
  ! FLD1                    ; " 
  ! FSCALE                  ; " 
  ! FXCH                    ; " 
  ! FXCH st2                ; " 
  ! F2XM1                   ; " 
  ! FLD1                    ; " 
  ! FADDP st1, st0          ; " 
  ! FMULP st1, st0          ; " 
  ! fstp st1                ; clean up fpu stack, result in st0 
  ! fxch                    ;exchange st0 and st1: st0 = x + 9.5, st1 = (x + 9.5) ^ (x + .5) 
  ! fchs                    ;st0 = - st0 = -(x + 9.5) 
  ! fld tword [rx_e]        ;st0 = exp(st0) 
  ! FYL2X                   ; " 
  ! FLD st0                 ; " 
  ! FRNDINT                 ; " 
  ! FSUB st1, st0           ; " 
  ! FLD1                    ; " 
  ! FSCALE                  ; " 
  ! FXCH                    ; " 
  ! FXCH st2                ; " 
  ! F2XM1                   ; " 
  ! FLD1                    ; " 
  ! FADDP st1, st0          ; " 
  ! FMULP st1, st0          ; " 
  ! fstp st1                ; clean up fpu stack, result in st0 
  ! fmulp st1,st0           ;st0 = (x + 9.5) ^ (x + .5) * exp(-(x + 9.5)) 
  ! fld tword [gamma]       ; 2.50662827463100050  ; Sqrt(2*Pi) 
  ! fmulp st1,st0           ;st0 = (x + 9.5) ^ (x + .5) * exp(-(x + 9.5)) * Sqrt(2*Pi) 
  ! fld tword [gamma+10]    ;1.00000000000000017 
  ! fld tword [ebx]         ;load x again 
  ! fiadd dword [ten]       ;st0 = x + 10 
  ! fld tword [110+gamma]   ;-4.02353314126823637e-9 
  ! fdiv st0,st1            ;st0 = -4.02353314126823637e-9 / (x + 10) 
  ! faddp st2,st0 
  ! fld1 
  ! fsubp st1,st0           ;st0 = x + 9 
  ! fld tword [100+gamma]   ; 5.38413643250956406e-8 
  ! fdiv st0,st1 
  ! faddp st2,st0 
  ! fld1 
  ! fsubp st1,st0           ;st0 = x + 8 
  ! fld tword [90+gamma]    ;-7.42345251020141615e-3 
  ! fdiv st0,st1 
  ! faddp st2,st0 
  ! fld1 
  ! fsubp st1,st0           ;st0 = x + 7 
  ! fld tword [80+gamma]    ; 2.60569650561175583 
  ! fdiv st0,st1 
  ! faddp st2,st0 
  ! fld1 
  ! fsubp st1,st0           ;st0 = x + 6 
  ! fld tword [70+gamma]    ;-108.176705351436963 
  ! fdiv st0,st1 
  ! faddp st2,st0 
  ! fld1 
  ! fsubp st1,st0           ;st0 = x + 5 
  ! fld tword [60+gamma]    ; 1301.60828605832187 
  ! fdiv st0,st1 
  ! faddp st2,st0 
  ! fld1 
  ! fsubp st1,st0           ;st0 = x + 4 
  ! fld tword [50+gamma]    ;-6348.16021764145881 
  ! fdiv st0,st1 
  ! faddp st2,st0 
  ! fld1 
  ! fsubp st1,st0           ;st0 = x + 3 
  ! fld tword [40+gamma]    ; 14291.4927765747855 
  ! fdiv st0,st1 
  ! faddp st2,st0 
  ! fld1 
  ! fsubp st1,st0           ;st0 = x + 2 
  ! fld tword [30+gamma]    ;-14815.3042676841391 
  ! fdiv st0,st1 
  ! faddp st2,st0 
  ! fld1 
  ! fsubp st1,st0           ;st0 = x + 1 
  ! fld tword [20+gamma]    ; 5716.40018827434138 
  ! fdivrp st1,st0 
  ! faddp  st1,st0 
  ! fmulp st1,st0 
  ! fstp st1 
  fac: 
  LEA ebx,g 
  ! fstp tword [ebx] 
  factorial1: 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  ;*************************************** 
  factorial2:;double factorial not implemented, goto factorial instead. 
  ;Gosub factorial 
  ! MOV ebx,[eval_stk_index] 
  ! SAL ebx,2 
  ! MOV [ebx+gsubeval_stk],dword l_factorial2a 
  ! inc dword [eval_stk_index] 
  ! JMP l_factorial 
  factorial2a: 
  LEA ebx,g 
  ! fld tword [ebx] 
  LEA ebx,x 
  ! fstp tword [ebx] 
  
  Goto factorial 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  ;*************************************** 
  ! rxInt: 
  ! fstcw word [oldCW] 
  ! mov ax,[oldCW] 
  ! Or ax,110000000000b 
  ! mov [newCW],ax 
  ! fldcw word [newCW] 
  ! fld tword [rx_X] 
  ! frndint 
  ! fstp tword [rx_Y] 
  ! fldcw word [oldCW] 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  ;*************************************** 
  ! rxpower: 
  ! MOV eax,[y_rxpower] 
  ! mov ebx,eax 
  ! rxpower_abseax: 
  ! neg eax 
  ! js  rxpower_abseax 
  ! fld1          ;  z:=1.0 
  ! fld1 
  ! fld tword [x_rxpower] ;load st0 with x 
  ! cmp eax,0     ;while y>0 
  ! rxpower_while1: 
  ! jle rxpower_wend1 
  ! rxpower_while2: 
  ! bt eax,0      ;test for odd/even 
  ! jc rxpower_wend2      ;jump if odd 
  ;                while y is even 
  ! sar eax,1     ;eax=eax/2 
  ! fmul st0,st0  ;x=x*x 
  ! jmp rxpower_while2 
  ! rxpower_wend2: 
  ! sub eax,1 
  ! fmul st1,st0  ;z=z*x ;st1=st1*st0 
  ! jmp rxpower_while1 
  ! rxpower_wend1: 
  ! fstp st0      ;cleanup fpu stack 
  ! fstp st1      ;"       "   " 
  ! cmp ebx,0     ;test to see if y<0 
  ! jge rxpower_noinv     ;skip reciprocal if not less than 0 
  ;                If y<0 take reciprocal 
  ! fld1 
  ! fdivrp st1,st0 
  ! rxpower_noinv: 
  ! fstp tword [z_rxpower] ;store z (st0) 
  ! dec dword [eval_stk_index] 
  ! MOV eax,[eval_stk_index] 
  ! SAL eax,2 
  ! mov ebx,dword [eax+gsubeval_stk] 
  ! JMP ebx 
  
  ;*************************************** 
  
  EvalFNend: 
  ProcedureReturn Result$ 
  
  ! section '.data' Data readable writeable 
  ! gamma: 
  ;N=10,Y=9 
  ! dw $2CB2,$B138,$98FF,$A06C,$4000    ;         2.50662827463100050  ; Sqrt(2*Pi)  ;    gamma 
  ! dw $064A,$0000,$0000,$8000,$3FFF    ;(FC0F)   1.00000000000000017 ______________ ; 10+gamma 
  ! dw $4FAA,$E8F4,$3395,$B2A3,$400B    ;(735D)   5716.40018827434138 ______________ ; 20+gamma 
  ! dw $6D9E,$F2A2,$3791,$E77D,$C00C    ;(DF08)  -14815.3042676841391 ______________ ; 30+gamma 
  ! dw $C153,$6C23,$F89A,$DF4D,$400C    ;(1B7F)   14291.4927765747855 ______________ ; 40+gamma 
  ! dw $767D,$2FD2,$4820,$C661,$C00B    ;(A17A)  -6348.16021764145881 ______________ ; 50+gamma 
  ! dw $5DC8,$52E3,$7714,$A2B3,$4009    ;(07DC)   1301.60828605832187 ______________ ; 60+gamma 
  ! dw $5F26,$B2E6,$791F,$D85A,$C005    ;(D958)  -108.176705351436963 ______________ ; 70+gamma 
  ! dw $AC57,$B9DA,$BB46,$A6C3,$4000    ;(290D)   2.60569650561175583 ______________ ; 80+gamma 
  ! dw $5E13,$9ACD,$6EE0,$F340,$BFF7    ;(C05D)  -7.42345251020141615e-3 ___________ ; 90+gamma 
  ! dw $16EB,$FC65,$34C4,$E73F,$3FE6    ;(F280)   5.38413643250956406e-8 ___________ ;100+gamma 
  ! dw $B1AB,$8882,$5F2D,$8A3F,$BFE3    ;(A364)  -4.02353314126823637e-9 ___________ ;110+gamma 
  ! dw $0000,$0000,$0000,$9800,$4002    ;         9.5 ______________________________ ;120+gamma 
  
  ! mbig: DW $7F1F,$D8A2,$8387,$9462,$FF95 ;-1.7e4900 
  ! pbig: DW $7F1F,$D8A2,$8387,$9462,$7F95 ; 1.7e4900 
  
  ! rx_two:     DW $0000,$0000,$0000,$8000,$4000 
  ! rx_four:    DW $0000,$0000,$0000,$8000,$4001 
  ! rx_ten:     DW $0000,$0000,$0000,$A000,$4002 
  ! rx_half:    DW $0000,$0000,$0000,$8000,$3FFE 
  ! rx_quarter: DW $0000,$0000,$0000,$8000,$3FFD 
  ! rx_e:       DW $4A9B,$A2BB,$5458,$ADF8,$4000 
  
  ! OpStack: 
  ! Repeat 100 
  !   dd      ? 
  ! End Repeat 
  
  ! gsubeval_stk: 
  ! Repeat 512 
  !   dd      ? 
  ! End Repeat 
  
  ! ValStack: 
  ! Repeat 100 
  !   dt      ? 
  ! End Repeat 
  
  ! constant: 
  ! Repeat 100 
  !   dt      ? 
  ! End Repeat 
  
  ! prev_eval:  dt      ? 
  
  ! FnEvalVars: 
  ! Repeat 26 
  !   dt      ? 
  ! End Repeat 
  
  ! rx_X: dt ? 
  ! rx_Y: dt ? 
  ! x_rxpower: dt ? 
  ! z_rxpower: dt ? 
  ! x_factorial2: dt ? 
  ! f1_factorial2: dt ? 
  ! f2_factorial2: dt ? 
  ! y_rxpower: DD ? 
  ! OneHundred: DD 100 
  ! IntX: DD ? 
  ! oldCW: DD ? 
  ! newCW: DD ? 
  ! eval_stk_index: DD 0 
  ! OS_Index: DD 0 
  ! VS_Index: DD 0 
  ! LST_Index: DD 0 
  
  jmptable: 
  ! ten:       ;not part of jumptable, but since table index starts at 1, 
  ! dd      10 ;use location at index 0 for something else. 
  ! dd      l_asinh;ASINH 
  ! dd      l_acosh;ACOSH 
  ! dd      l_atanh;ATANH 
  ! dd      l_sinh ;SINH 
  ! dd      l_cosh ;COSH 
  ! dd      l_tanh ;TANH 
  ! dd      l_asin ;ASIN 
  ! dd      l_acos ;ACOS 
  ! dd      l_atan ;ATAN 
  ! dd      l_alog ;ALOG 
  ! dd      l_sqrt ;SQRT 
  ! dd      l_sin  ;SIN 
  ! dd      l_cos  ;COS 
  ! dd      l_tan  ;TAN 
  ! dd      l_log  ;LOG 
  ! dd      l_exp  ;EXP 
  ! dd      l_sqr  ;SQR 
  ! dd      l_ln   ;LN 
  
EndProcedure 


; Some examples of valid expression... 
; x$=eval("#pi/4") ;x$ now holds "7.85398163397448309e-1" 
; x$=eval("#e") ;x$ = "2.718281828459045" 
; x$=eval("a=(1/2)!") ; x$ = "8.86226925452758013e-1" also "a" holds "8.86226925452758013e-1" 
; x$=eval("a^2*4") ; = "3.14159265358979324" 

; OpenConsole() 
; 
; ConsoleTitle ("FnEval test") 
; a$=" " 
; PrintN("enter an expression") 
; While Len(a$)>0 
;   Print("> ") 
;   a$=Input() 
;   PrintN("") 
;   PrintN(eval(a$)) 
; Wend 
; a$=Input() 
; CloseConsole() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
