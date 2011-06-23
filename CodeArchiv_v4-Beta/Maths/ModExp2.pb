; German forum: http://www.purebasic.fr/german/viewtopic.php?t=554&highlight=
; Author: Froggerprogger
; Date: 22. October 2004
; OS: Windows, Linux
; Demo: Yes


; Eine Zahl a in die b-te Potenz erheben und den Modulo n zurückgeben

Procedure modexp_2(a.l, b.l, n.l) 
  If b=0 : ProcedureReturn 1 : EndIf 
  c = a 
  While b > 1 
    c * a 
    c % n 
    b - 1 
  Wend 
  ProcedureReturn c % n 
EndProcedure 

Debug modexp_2(3,4,2)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -