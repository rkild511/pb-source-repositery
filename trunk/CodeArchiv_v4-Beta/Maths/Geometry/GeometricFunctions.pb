; German forum: http://www.purebasic.fr/german/viewtopic.php?t=252
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 25. September 2004
; OS: Windows, Linux
; Demo: yes


; Ermittelt die Entfernung zweier Punkte 
Procedure.f Point_Distance(X1.f, Y1.f, X2.f, Y2.f) 
  Protected a.f, b.f 
  a = X2 - X1 
  b = Y2 - Y1 
  
  ProcedureReturn Sqr(a * a + b * b) 
EndProcedure 

; Ermittelt den Winkel zwischen zwei Punkten und der X-Achse (im Koordinatensystem) 
Procedure.f Object_GetAngle_Points(X1.f, Y1.f, X2.f, Y2.f) 
  Protected w.f 
  w = ATan((Y2 - Y1) / (X2 - X1)) * 57.295776 
  If X2 < X1 
    w = 180 + w 
  EndIf 
  If w < 0 : w + 360 : EndIf 
  If w > 360 : w - 360 : EndIf 
  
  ProcedureReturn w 
EndProcedure 

; Ermittelt den Winkel zu einer Steigung 
Procedure.f Object_GetAngle_Gradiant(X.f, Y.f) 
  Protected w.f 
  w = ATan(Y / X) * 57.295776 
  If X < 0 
    w = 180 + w 
  EndIf 
  If w < 0 : w + 360 : EndIf 
  If w > 360 : w - 360 : EndIf 
  
  ProcedureReturn w 
EndProcedure 

; Modulo für Fließkommazahlen 
Procedure.f ModuloF(a.f, b.f) 
  If b < 0 : b = -b : EndIf 
  If a > 0 
    ProcedureReturn a - Int(a / b) * b 
  Else 
    ProcedureReturn b + a - Int(a / b) * b 
  EndIf 
EndProcedure 

; Gibt immer einen Winkel zwischen 0 und 360 zurück 
Procedure.f Mod_Angle(w.f) 
  If w >= 360 
    ProcedureReturn w - Int(w / 360) * 360 
  ElseIf w < 0 
    ProcedureReturn 360 + w - Int(w / 360) * b 
  Else 
    ProcedureReturn w 
  EndIf 
EndProcedure 


Debug Point_Distance(10,10,150,150)           ; get distance between point 10,10 and 150,150
Debug Object_GetAngle_Points(10,10,100,100)   ; get angle between point 10,10 and 100,100
Debug Object_GetAngle_Gradiant(90,45)         ; get angle to a gradient
Debug ModuloF(10.5,3.33)                      ; mod function for floats
Debug Mod_Angle(460.5)                        ; always returns an angle between 0 and 360

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -