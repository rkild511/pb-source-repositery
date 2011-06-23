; English forum: 
; Author: jack
; Date: 29. March 2005
; OS: Windows
; Demo: Yes


;some real10 routines by Jack 
;placed into the public domain, use any way you want 

Structure r10 
  StructureUnion 
    fw.w[5] 
    tb.b[10]      
  EndStructureUnion 
EndStructure 

Declare AtoF(float$, *x.r10)        ;string To r10 
Declare.s FtoA(*x.r10)              ;r10 to string 
Declare.s r10hex(*x.r10)            ;r10 to hex string 
Declare.s myHex(n.w)                ;integer word to hex string 
Declare copy(*x.r10,*y.r10)         ;y=x 
Declare r10log(*x.r10,*y.r10)       ;y=log10(x) 
Declare r10Fcom(*x.r10,*y.r10)      ;compare x with y: -1 if x<y, 0 if x=y, 1 if x>y 
Declare r10Add(*x.r10,*y.r10,*z.r10);z=x+y 
Declare r10Sub(*x.r10,*y.r10,*z.r10);z=x-y 
Declare r10Mul(*x.r10,*y.r10,*z.r10);z=x*y 
Declare r10Div(*x.r10,*y.r10,*z.r10);z=x/y 
Declare r10Dec(*x.r10)              ;x=x-1 
Declare r10Inc(*x.r10)              ;x=x+1 
Declare r10abs(*x.r10,*y.r10)       ;y=Abs(x) 
Declare r10iDiv(*x.r10,z.l,*y.r10)  ;y=x/z 
Declare r10iSub(*x.r10,z.l,*y.r10)  ;y=x-z  
Declare r10iMul(*x.r10,z.l,*y.r10)  ;y=x*z 
Declare r10Trunc(*x.r10,*y.r10)     ;y=trunc(x), (chop) 
Declare r10ToLong(*x.r10)           ;returns long integer by truncating x (chop) 
Declare NInt(*x.r10)                ;returns integer rounded to nearest 
Declare r10Floor(*x.r10)            ;returns integer rounded to minus infinity 
Declare r10Sqrt(*x.r10,*y.r10)      ;y=sqrt(x) 
Declare scale(*x.r10, j.l, *y.r10)  ;y=x*2^j 
Declare exponent(*x.r10)            ;returns base 2 exponent of x 
Declare xpower(*x.r10, e.l, *y.r10) ;y=x^e 
Declare real(i,*x.r10)              ;converts integer i into r10 in x 
Declare Sign(*x.r10)                ;returns integer: -1 if x<0, 0 if x=0, 1 if x>0 
Declare r10Sin(*x.r10, *y.r10)      ;y=Sin(x) 
Declare r10Cos(*x.r10, *y.r10)      ;y=Cos(x) 
Declare r10Tan(*x.r10, *y.r10)      ;y=Tan(x) 
Declare r10Asin(*x.r10,*y.r10)      ;y=asin(x) 
Declare r10Acos(*x.r10,*y.r10)      ;y=acos(x) 
Declare r10Atan(*x.r10,*y.r10)      ;y=atan(x) 

Procedure scale(*x.r10, j.l, *y.r10) 

! mov eax,[esp+8]   ;y 
! mov ebx,[esp]     ;x 
! finit 
! fild dword [esp+4];j 
! fld tword [ebx]   ;x 
! fscale 
! fstp tword [eax]  ;y 
! fstp st0 
ProcedureReturn 
EndProcedure 

Procedure exponent(*x.r10) 
e.l 
! mov ebx,[esp] 
! lea eax,[esp+4] 
! finit 
! fld tword [ebx] ;x 
! fxtract 
! fstp st0 
! fistp dword [eax] 
! mov eax,[eax] 

ProcedureReturn 
EndProcedure 

Procedure r10ToLong(*x.r10) 

oldcw.l  ;esp+4 
newcw.l  ;esp+8 
y.l 
! mov ecx,[esp]   ;x 
! lea edx,[esp+4] ;oldcw 
! lea edi,[esp+8] ;newcw 
! lea esi,[esp+12] ;y 
! fstcw word [edx] 
! mov ax,[edx] 
! Or ax,110000000000b 
! mov [edi],ax 
! fldcw word [edi] 
! fld tword [ecx] 
! frndint 
! fistp dword [esi] 
! mov eax,[esi] 
! fldcw word [edx] 

ProcedureReturn 
EndProcedure 

Procedure r10Floor(*x.r10) 

oldcw.l  ;esp+4 
newcw.l  ;esp+8 
y.l 
! mov ecx,[esp]   ;x 
! lea edx,[esp+4] ;oldcw 
! lea edi,[esp+8] ;newcw 
! lea esi,[esp+12] ;y 
! fstcw word [edx] 
! mov ax,[edx] 
! Or ax,010000000000b 
! mov [edi],ax 
! fldcw word [edi] 
! fld tword [ecx] 
! frndint 
! fistp dword [esi] 
! mov eax,[esi] 
! fldcw word [edx] 

ProcedureReturn 
EndProcedure 


Procedure NInt(*x.r10) 

oldcw.l  ;esp+4 
newcw.l  ;esp+8 
y.l 
! mov ecx,[esp]   ;x 
! lea edx,[esp+4] ;oldcw 
! lea edi,[esp+8] ;newcw 
! lea esi,[esp+12] ;y 
! fstcw word [edx] 
! mov ax,[edx] 
! Or ax,000000000000b 
! mov [edi],ax 
! fldcw word [edi] 
! fld tword [ecx] 
! frndint 
! fistp dword [esi] 
! mov eax,[esi] 
! fldcw word [edx] 
ProcedureReturn 
EndProcedure 

Procedure real(i.l,*x.r10) 
! finit 
! mov eax,[esp+4] ;x 
! fild dword [esp];i 
! fstp tword [eax];x 
ProcedureReturn 
EndProcedure 

Procedure copy(*x.r10,*y.r10);y=x 
! finit 
! mov ebx,[esp]   ;x 
! mov eax,[esp+4] ;y 
! fld tword [ebx] 
! fstp tword [eax] 
ProcedureReturn 
EndProcedure 

Procedure$ myHex(n.w) 
   c.w=PeekB(@n+1) & $ff 
   h.w=c/16 
   l.w=c-h*16 
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
   mhex$=hb$+lb$ 
   c.w=PeekB(@n) & $ff 
   h.w=c/16 
   l.w=c-h*16 
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
   mhex$=mhex$+hb$+lb$ 
  ProcedureReturn mhex$ 
EndProcedure 

Procedure xpower(*x.r10, e.l, *y.r10) 
! MOV eax,[esp+4];e 
! mov ebx,eax 
! rxpower_abseax: 
! neg eax 
! js  rxpower_abseax 
! fld1          ;  z:=1.0 
! fld1 
! mov edx,[esp];x 
! fld tword [edx] ;load st0 with x 
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
! mov eax,[esp+8] 
! fstp tword [eax] ;store z (st0) 

ProcedureReturn 
EndProcedure 

Procedure AtoF(value$,*x.r10) 

y.r10  ;esp+8 
pw.r10 ;esp+18 
t.l=10 ;esp+28 
j.l=1  ;esp+32 
s=1 
d=0 
e=0 
ep=0 
ex=0 
es=1 
i=0 
f=0 
fp=0 

value$=UCase(value$) 
fln=Len(value$) 
f=FindString(value$,"NAN",1) 
If f>0 
  *x\fw[4]=$FFFF 
  *x\fw[3]=$C000 
  *x\fw[2]=0 
  *x\fw[1]=0 
  *x\fw[0]=0 
  Goto atof_end 
EndIf 
f=FindString(value$,"INF",1) 
If f>0 
  *x\fw[4]=$7FFF 
  *x\fw[3]=$8000 
  *x\fw[2]=0 
  *x\fw[1]=0 
  *x\fw[0]=0 
  Goto atof_end 
EndIf 
f=FindString(value$,"-INF",1) 
If f>0 
  *x\fw[4]=$FFFF 
  *x\fw[3]=$8000 
  *x\fw[2]=0 
  *x\fw[1]=0 
  *x\fw[0]=0 
  Goto atof_end 
EndIf 
  
f1$="" 
f2$="" 
f3$="" 
! lea ebx,[esp+18] 
! lea edx,[esp+28] 
! finit 
! fild dword [edx] 
! fstp tword [ebx] 
While j<=fln 
  c$=Mid(value$,j,1) 
  If ep=1 
    If c$=" " 
      Goto atof1nxtch 
    EndIf 
    If c$="-" 
      es=-es 
      c$="" 
    EndIf 
    If c$="+" 
      Goto atof1nxtch 
    EndIf 
    If (c$="0") And (f3$="") 
      Goto atof1nxtch 
    EndIf 
    If (c$>"/") And (c$<":") ;c$ is digit between 0 and 9 
      f3$=f3$+c$ 
      ex=10*ex+(Asc(c$)-48) 
      Goto atof1nxtch 
    EndIf 
  EndIf 

  If c$=" " 
    Goto atof1nxtch 
  EndIf 
  If c$="-" 
    s=-s 
    Goto atof1nxtch 
  EndIf 
  If c$="+" 
    Goto atof1nxtch 
  EndIf 
  If c$="." 
    If d=1 
      Goto atof1nxtch 
    EndIf 
    d=1 
  EndIf 
  If (c$>"/") And (c$<":") ;c$ is digit between 0 and 9 
    If ((c$="0") And (i=0)) 
      If d=0 
        Goto atof1nxtch 
      EndIf 
      If (d=1) And (f=0) 
        e=e-1 
        Goto atof1nxtch 
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
atof1nxtch: 
  j=j+1 
Wend 
If fp=0 
  f=0 
  f2$="" 
EndIf 

ex=es*ex-18+i+e ;(es*ex)-(18-i)+e 
f1$=f1$+f2$ 
fln=Len(f1$) 
If Len(f1$)>20 
  f1$=Mid(f1$,1,20) 
EndIf 
While Len(f1$)<20 
  f1$=f1$+"0" 
Wend 
*x\tb[9]=0 ;alway zero for positive BCD number 
i=1 
j=8 
While i<18 
  c.w=16*(Asc(Mid(f1$,i,1))-48) 
  i=i+1 
  c.w=c+(Asc(Mid(f1$,i,1))-48) 
  i=i+1 
  *x\tb[j]=c 
  j=j-1 
Wend 
;put the last two digits into y 
For i=1 To 9 
  y\tb[i]=0 
Next 
c.w=16*(Asc(Mid(f1$,19,1))-48) 
c.w=c+(Asc(Mid(f1$,20,1))-48) 
y\tb[0]=c 
t=100 
! lea edx,[esp+28];t 
! lea ebx,[esp+8] ;y 
! fbld tword [ebx] 
! fild dword [edx] 
! fdivp st1,st0   ;y/100 
! mov eax,[esp+4] ;x 
! fbld tword [eax] 
! faddp st1,st0   ;x+y/100 
! fstp tword [eax] 
xpower(@pw,ex,@pw);10^(ex+2) 
! lea ebx,[esp+18];pw 
! mov eax,[esp+4] ;x 
! fld tword [ebx] 
! fld tword [eax] 
! fmulp st1,st0   ;x=x*pw 
If s<0 
  ! fchs 
EndIf 
! mov eax,[esp+4] 
! fstp tword [eax] 
atof_end: 
! mov eax,[esp+4] 
ProcedureReturn 
EndProcedure 

Procedure.s FtoA(*x.r10) 

temp.r10 
y.r10 
ex.l=10 
t.l 
v.l 
s.l=Sign(*x) 
z.r10 
w.r10 
f.s 
vl$="" 
c.w 
hi.w 
lo.w 
v=*x\fw[4]&$ffff 
zz.l=*x\fw[3]&$ffff 
s=*x\fw[4]>>15 
If ((v=0) Or (v=32768)) And (zz=0) 
  vl$=" 0.000000000000000000e+0000" 
  If s=-1 
    vl$="-0.000000000000000000e+0000" 
  EndIf 
  Goto ftoa_end 
EndIf 
If (((v=65535) Or (v=32767)) And (zz=49152)) 
  vl$=" NaN" 
  Goto ftoa_end 
EndIf 
If ((v=32767) And (zz=32768)) 
  vl$=" Inf" 
  Goto ftoa_end 
EndIf 
If ((v=65535) And (zz=32768)) 
  vl$="-Inf" 
  Goto ftoa_end 
EndIf 

! mov ebx,[esp]    ;x 
! lea ecx,[esp+4]  ;temp 
! lea edi,[esp+14] ;y 
! lea edx,[esp+24] ;ex 
! finit 
! fld tword [ebx]  ;x 
! fabs             ;abs(x) 
! lea esi,[esp+40] ;z 
! fstp tword [esi] ;z=abs(x) 
! fild dword [edx] ;load value 10 from ex 
! fld st0          ;dup 
! lea edx,[esp+50] ;w 
! fstp tword [edx] ;w=10 
! fstp tword [ecx] ;temp=ex, = 10 
! fldlg2           ;load Log10(2) 
! fld tword [esi] 
! fyl2x            ; st1*log2(x) 
! fstp tword [edi] ;y=log10(x) 
ex=r10floor(@y) 
xpower(@temp,17-ex,@temp) 
! lea ebx,[esp+40] ;z 
! lea ecx,[esp+4]  ;temp 
! fld tword [ecx]  ;temp 
! fld tword [ebx]  ;z 
! fmulp st1,st0 
! fstp tword [ecx] ;temp 
r10Trunc(@temp,@w) 
! lea edi,[esp+14] ;y 
! lea edx,[esp+50] ;w 
! fld tword [edx]  ;w 
! fbstp tword [edi];y 
c=y\tb[8] & $ff 
hi=c>>4 
lo=c-hi<<4 
If hi=0 
  r10iMul(@temp,10,@temp) 
  ex=ex-1 
EndIf 
r10Trunc(@temp,@y) 
r10sub(@temp,@y,@temp) 
r10iMul(@temp,10,@temp) 
! lea ecx,[esp+4]  ;temp 
! lea edi,[esp+14] ;y 
! lea edx,[esp+50] ;w 
! fld tword [edi]  ;y 
! fbstp tword [edi];y 
! fld tword [ecx]  ;temp 
! fbstp tword [edx];w 
c=y\tb[8] & $ff 
hi=c>>4 
lo=c-hi<<4 
hb$=Chr(hi+48) 
lb$=Chr(lo+48) 
vl$=hb$+"."+lb$ 
i.l=7 
While i>=0 
   c=y\tb[i] & $ff 
   hi=c>>4 
   lo=c-hi<<4 
   hb$=Chr(hi+48) 
   lb$=Chr(lo+48) 
   vl$=vl$+hb$+lb$ 
   i=i-1 
Wend 
c=w\tb[0] & $ff 
hi=c>>4 
lo=c-hi<<4 
lb$=Chr(lo+48) 
vl$=vl$+lb$ 
If s=-1 
  vl$="-"+vl$ 
Else 
  vl$=" "+vl$ 
EndIf 
f=Str(Abs(ex)) 
f=RSet(f,4,"0") 
If ex<0 
  f="e-"+f 
Else 
  f="e+"+f 
EndIf 
vl$=vl$+f 

ftoa_end: 
ProcedureReturn vl$ 
EndProcedure 

Procedure Sign(*x.r10)   ;returns -1 if x<0,  0 if x=0,  1 if x>0 
;by Paul Dixon 
! mov edx,[esp] 
! fld tword [edx] 
! ftst 
! fstsw ax 
! mov al,ah 
! shr al,6      
! xor ah,1  
! xor ah,al 
! shl ah,1 
! Or al,ah 
! And eax,3 
! dec eax 
ProcedureReturn 
EndProcedure 

Procedure r10Fcom(*x.r10,*y.r10) 
! finit 
! mov eax,[esp]   ;*x 
! mov ebx,[esp+4] ;*y 
! fld tword [eax] 
! fld tword [ebx] 
! fsubp st1,st0 
! ftst 
! fstsw ax 
! mov al,ah 
! shr al,6      
! xor ah,1  
! xor ah,al 
! shl ah,1 
! Or al,ah 
! And eax,3 
! dec eax 
ProcedureReturn 
EndProcedure 

Procedure r10Add(*x.r10,*y.r10,*z.r10);z=x+y 
! finit 
! mov edx,[esp]  ;x 
! mov ebx,[esp+4];y 
! mov eax,[esp+8];z 
! fld tword [edx];x 
! fld tword [ebx];y 
! faddp st1,st0  ;x-y 
! fstp tword [eax];z 
ProcedureReturn 
EndProcedure 

Procedure r10Sub(*x.r10,*y.r10,*z.r10);z=x-y 
! finit 
! mov edx,[esp]  ;x 
! mov ebx,[esp+4];y 
! mov eax,[esp+8];z 
! fld tword [edx];x 
! fld tword [ebx];y 
! fsubp st1,st0  ;x-y 
! fstp tword [eax];z 
ProcedureReturn 
EndProcedure 

Procedure r10Dec(*x.r10) 
! finit 
! mov eax,[esp] ;x 
! fld tword [eax] 
! fld1 
! fsubp st1,st0 
! fstp tword [eax] 
ProcedureReturn 
EndProcedure 

Procedure r10Inc(*x.r10) 
! finit 
! mov eax,[esp] ;x 
! fld tword [eax] 
! fld1 
! faddp st1,st0 
! fstp tword [eax] 
ProcedureReturn 
EndProcedure 

Procedure r10log(*x.r10,*y.r10) 
! mov ebx,[esp] 
! mov eax,[esp+4] 
! fldlg2 ;load Log10(2) 
! fld tword [ebx];x 
! fyl2x ; st1*log2(x) 
! fstp tword [eax] ;y=log10(x) 
ProcedureReturn 
EndProcedure 

Procedure r10Sqrt(*x.r10,*y.r10);y=sqrt(x) 
! finit 
! mov eax,[esp+4] ;y 
! mov ebx,[esp]   ;x 
! fld tword [ebx] ;x 
! fsqrt 
! fstp tword [eax];y 
EndProcedure 

Procedure r10Mul(*x.r10,*y.r10,*z.r10);z=x*y 
! finit 
! mov eax,[esp+8] ;z 
! mov ebx,[esp+4] ;y 
! mov ecx,[esp]   ;x 
! fld tword [ecx] ;x 
! fld tword [ebx] ;y 
! fmulp st1,st0 
! fstp tword [eax];z 
EndProcedure 

Procedure r10Div(*x.r10,*y.r10,*z.r10);z=x/y 
! finit 
! mov eax,[esp+8] ;z 
! mov ebx,[esp+4] ;y 
! mov ecx,[esp]   ;x 
! fld tword [ecx] ;x 
! fld tword [ebx] ;y 
! fdivp st1,st0 
! fstp tword [eax];z 
EndProcedure 

Procedure r10abs(*x.r10,*y.r10);y=Abs(x) 
! mov ebx,[esp]   ;x 
! mov eax,[esp+4] ;y 
! fld tword [ebx] ;x 
! fabs            ;|x| 
! fstp tword [eax];y 
EndProcedure 

Procedure r10iDiv(*x.r10,z.l,*y.r10);y=x/z 
! finit 
! mov ebx,[esp]   ;x 
! lea ecx,[esp+4] ;z 
! mov eax,[esp+8] ;y 
! fld tword [ebx] ;x 
! fild dword [ecx];z 
! fdivp st1,st0 
! fstp tword [eax] 
EndProcedure 

Procedure r10iSub(*x.r10,z.l,*y.r10);y=x-z 
! finit 
! mov ebx,[esp]   ;x 
! lea ecx,[esp+4] ;z 
! mov eax,[esp+8] ;y 
! fld tword [ebx] ;x 
! fild dword [ecx];z 
! fsubp st1,st0 
! fstp tword [eax] 
EndProcedure 

Procedure r10iMul(*x.r10,z.l,*y.r10);y=x*z 
! finit 
! mov ebx,[esp]   ;x 
! lea ecx,[esp+4] ;z 
! mov eax,[esp+8] ;y 
! fld tword [ebx] ;x 
! fild dword [ecx];z 
! fmulp st1,st0 
! fstp tword [eax] 
EndProcedure 

Procedure r10Trunc(*x.r10,*y.r10) ;y=trunc(x) 

oldcw.l  ;esp+8 
newcw.l  ;esp+12 
y.l      ;esp+16 
! mov ecx,[esp]   ;x 
! lea edx,[esp+8] ;oldcw 
! lea edi,[esp+12] ;newcw 
! lea esi,[esp+16] ;y 
! fstcw word [edx] 
! mov ax,[edx] 
! Or ax,110000000000b 
! mov [edi],ax 
! fldcw word [edi] 
! fld tword [ecx] 
! frndint 
! mov eax,[esp+4] 
! fstp tword [eax] 
! fldcw word [edx] 

ProcedureReturn 
EndProcedure 

Procedure.s r10hex(*x.r10) 
i.l 
a.r10 
h.s 
For i=4 To 0 Step -1 
   h=h+myHex(*x\fw[i]) 
   h=h+" " 
Next i 
ProcedureReturn h 
EndProcedure 

Procedure r10Sin(*x.r10, *y.r10) ;y=Sin(x) 
! mov ebx,[esp]  ;x 
! mov eax,[esp+4];y 
! finit 
! fld tword [ebx];x 
! fsin 
! fstp tword [eax];y=sin(x) 
EndProcedure 

Procedure r10Cos(*x.r10, *y.r10) ;y=Cos(x) 
! mov ebx,[esp]  ;x 
! mov eax,[esp+4];y 
! finit 
! fld tword [ebx];x 
! fcos 
! fstp tword [eax];y=sin(x) 
EndProcedure 

Procedure r10Tan(*x.r10, *y.r10) ;y=Tan(x) 
! mov ebx,[esp]  ;x 
! mov eax,[esp+4];y 
! finit 
! fld tword [ebx];x 
! fptan 
! fstp st0 
! fstp tword [eax];y=sin(x) 
EndProcedure 

Procedure r10Asin(*x.r10,*y.r10);y=asin(x) 
! finit 
! mov ebx,[esp]   ;x 
! mov eax,[esp+4] ;y 
! fld tword [ebx] ;x 
! fld1 
! fld st1                
! fmul st0,st0          
! fsubp st1,st0        
! fsqrt                  
! fpatan  
! fstp tword [eax] 
EndProcedure 

Procedure r10Acos(*x.r10,*y.r10);y=acos(x) 
! finit 
! mov ebx,[esp]   ;x 
! mov eax,[esp+4] ;y 
! fld tword [ebx] ;x 
! fld1 
! fld st1                
! fmul st0,st0          
! fsubp st1,st0        
! fsqrt 
! fxch                  
! fpatan  
! fstp tword [eax] 
EndProcedure 

Procedure r10Atan(*x.r10,*y.r10);y=atan(x) 
! finit 
! mov ebx,[esp]   ;x 
! mov eax,[esp+4] ;y 
! fld tword [ebx] ;x 
! fld1 
! fpatan  
! fstp tword [eax] 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ------