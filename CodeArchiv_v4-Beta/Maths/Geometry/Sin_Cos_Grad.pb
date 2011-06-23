; German forum: 
; Author: Daniel
; Date: 04. September 2002
; OS: Windows, Linux
; Demo: Yes


;Winkel wird in Grad ausgegeben

Procedure.f GSin(winkel.f)
  preturn.f=Sin(winkel*(2*3.14159265/360))
  ProcedureReturn preturn
EndProcedure

Procedure.f GCos(winkel.f)
  preturn.f=Cos(winkel*(2*3.14159265/360))
  ProcedureReturn preturn
EndProcedure 

Procedure.l Fakultaet(fa.l)
  For fan=fa-1 To 1 Step -1
    fa=fa*fan
  Next
  ProcedureReturn fa
EndProcedure

Procedure.f Sinus(x.f)
  pom=1
  Repeat
    If x<0 : x=x+180*0.01745329 : pom=pom*-1
    ElseIf x>180*0.01745329 : x=x-180*0.01745329 : pom=pom*-1
    EndIf
  Until x>0 And x<180*0.01745329
  ProcedureReturn  (x - (Pow(x,3)/Fakultaet(3)) + (Pow(x,5)/Fakultaet(5)) - (Pow(x,7)/Fakultaet(7)) + (Pow(x,9)/Fakultaet(9)) - (Pow(x,11)/Fakultaet(11)) + (Pow(x,13)/Fakultaet(13)) - (Pow(x,15)/Fakultaet(15)))*pom
EndProcedure

Procedure.f Cosinus(x.f)
  ProcedureReturn  Sinus(x+(90*0.01745329))
EndProcedure

MessageRequester("Sinus","Sinus von 30°:"+Chr(10)+StrF(Sinus(30*0.01745329),6),0)
MessageRequester("Cosinus","Cosinus von 30°:"+Chr(10)+StrF(Cosinus(30*0.01745329),6),0) 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -