; English forum: 
; Author: Manolo
; Date: 05. April 2003
; OS: Windows, Linux
; Demo: Yes

Procedure.s StrG(a.f)
  ; Convert float to string with n digits precision
  n=Len(Mid(StrF(a),1,FindString(StrF(a),".",1)+1))
  If Int(a)=0
    n-1
  EndIf
 
  If Int(a)-a=0
    n=Len(StrF(Int(a)))+2     
  EndIf

  a$=""
  If a<0:a$="-":a=-a:EndIf
  b.f=1000000000
  b=b*b*b*b*100
  If a>b:ProcedureReturn("O/F"):EndIf
  b=1/b
  If a<b:ProcedureReturn("0"):EndIf
  If n<1:n=1:EndIf
  If n>7:n=7:EndIf;max float accuracy
  b=1:For i.l=1 To n:b=b*10:Next i
  e.l=0
  While a>=b:a/10:e+1:Wend
  b=b/10
  While a<b:a*10:e-1:Wend
  i=Round(a+0.5,0)
  If e>=0 And e<(11-n)
    a$+LSet(Str(i),n+e,"0")
  ElseIf e>-n And e<0
    a$+Left(Str(i),n+e)+"."+Right(Str(i),-e)
  ElseIf e=-n
    a$+"0."+Str(i)
  Else
    a$+Left(Str(i),1)
    If n>1:a$=a$+".":EndIf
    a$+Right(Str(i),n-1)
    i=e+n-1
    If i<0
      a$+"E-"+RSet(Str(-i),2,"0")
    Else
      a$+"E+"+RSet(Str(i),2,"0")
    EndIf
  EndIf
ProcedureReturn a$
EndProcedure

;- Test
a.f = 45.64526
a$=StrG(a)
Debug a$
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -