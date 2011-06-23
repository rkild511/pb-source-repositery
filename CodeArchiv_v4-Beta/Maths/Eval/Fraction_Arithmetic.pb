; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3411&highlight=
; Author: Froggerprogger 
; Date: 12. January 2004
; OS: Windows
; Demo: No


;- English:
;  some procedures to calculate with fractions 
;  12.01.04 by Froggerprogger 
; 
; keep in mind the denominator must never be zero - if it is, the Fraction_GetStr() returns 'Division by 0' 
; 
; GCD = Greatest Common Divisor 
; LCM = Lowest Common Multiple 


;- Deutsch:
;  Einige Prozeduren für die Bruchrechnung 
;   (Brüche, Bruch, Bruchrechnung, Kehrwert)
;  12.01.04 by Froggerprogger 
; 
; Beachte, dass der Nenner nie 0 sein darf. Fraction_GetStr() liefert dann "Division by 0" zurück 
; 
; Die Bezeichnungen der Prozeduren sind in englisch gehalten, so heißt u.a.: 
; nom = nominator := Zähler 
; denom = denominator := Nenner 
; GCD = Greatest Common Divisor := GGT = Größter gemeinsamer Teiler 
; LCM = Lowest Common Multiple := KGV = Kleinstes gemeinsames Vielfaches 
; Mixed Number := Gemischte Zahl 
; Reduce := Kürzen (hier: maximal kürzen) 
; Extend := Erweitern 
; Reciprocal := Kehrwert 
; Pow = Power := Potenz 

;- the main structure used by the procedures / die Hauptstruktur 
Structure Fraction 
  nom.l 
  denom.l 
EndStructure 

;- some help-procedures needed by the main-procedures / einige Hilfsprozeduren für die Hauptprozeduren 
Procedure.l AbsL(p_int.l) 
  If p_int > 0 
    ProcedureReturn p_int 
  Else 
    ProcedureReturn 0 - p_int 
  EndIf 
EndProcedure 

Procedure.l SgnL(p_int.l) 
  If p_int > 0 
    ProcedureReturn 1 
  ElseIf p_int < 0 
    ProcedureReturn -1 
  Else 
    ProcedureReturn 0 
  EndIf 
EndProcedure 

Procedure.l RoundReal(p_val.f) 
  If p_val = 0 
    ProcedureReturn 0 
  ElseIf p_val > 0 
    If p_val - Int(p_val) >= 0.5 
      ProcedureReturn Int(p_val) + 1 
    Else 
      ProcedureReturn Int(p_val) 
    EndIf 
  Else 
    If p_val - Int(p_val) <= -0.5 
      ProcedureReturn Int(p_val) - 1 
    Else 
      ProcedureReturn Int(p_val) 
    EndIf 
  EndIf 
EndProcedure 

Procedure.l GetGCD(p_int1.l, p_int2.l) 
  Protected i.l 
  
  If p_int1 = 0 Or p_int2 = 0 
    ProcedureReturn 0 
  EndIf 
  
  p_int1 = AbsL(p_int1) 
  p_int2 = AbsL(p_int2) 
  
  If p_int1 < p_int2  ; swap the values 
    i = p_int2 
    p_int2 = p_int1 
    p_int1 = i 
  EndIf 
  
  If p_int1 % p_int2 = 0 
    ProcedureReturn p_int2 
  EndIf 
  
  i = Int(p_int2)/2 
  While i > 1 And (p_int2 % i <> 0 Or p_int1 % i <> 0) 
    i - 1 
  Wend 
  ProcedureReturn i 
  
EndProcedure 

Procedure.l GetLCM(p_int1.l, p_int2.l) 
  Protected i.l 
  
  If p_int1 = 0 Or p_int2 = 0 
    ProcedureReturn 0 
  EndIf 
  
  p_int1 = AbsL(p_int1) 
  p_int2 = AbsL(p_int2) 
  
  If p_int1 < p_int2  ; swap the values 
    i = p_int2 
    p_int2 = p_int1 
    p_int1 = i 
  EndIf 
  
  i=1 
  While (i * p_int2) % p_int1 <> 0 
    i + 1 
  Wend 
  
  ProcedureReturn i * p_int2 
EndProcedure 


;- The main-procedures for the calculations, I think they're self-explaining 
; Nearly all return a pointer to the calculation's result, that is stored in 
; the first overgiven fraction-parameter, too. 
; you might keep the orignal value by using Fraction_GetCopy() inside the 
; procedure-call, see the examples. 

;- Die Hauptprozeduren für das Rechnen. Mit obigem Wörterbuch sind wohl alle 
; selbsterklärend. Fast alle geben einen Pointer auf das Rechenergebnis zurück, 
; welches in den ersten übergebenen Bruch geschrieben wird. 
; Dessen Originalwert kann man erhalten, wenn Fraction_GetCopy() im Prozeduraufruf 
; verwendet wird. 
Procedure.s Fraction_GetStr(*p_f.Fraction) 
  If *p_f\denom = 0 
    ProcedureReturn "Division by 0" 
  Else 
    ProcedureReturn Str(*p_f\nom)+" / "+Str(*p_f\denom) 
  EndIf 
EndProcedure 

Procedure.s Fraction_GetStrMixedNumber(*p_f.Fraction) 
  If *p_f\denom = 0 
    ProcedureReturn "Division by 0" 
  ElseIf *p_f\nom > *p_f\denom 
    ProcedureReturn Str(Int(*p_f\nom / *p_f\denom)) + " _ " + Str(*p_f\nom % *p_f\denom)+" / "+Str(*p_f\denom) 
  Else 
    ProcedureReturn Str(*p_f\nom % *p_f\denom)+" / "+Str(*p_f\denom) 
  EndIf 
EndProcedure 

Procedure.l Fraction_Create(p_nom.l, p_denom.l) 
  Protected *p_res.Fraction 
  *p_res = GlobalAlloc_(#GPTR, SizeOf(Fraction)) 
  *p_res\nom = p_nom 
  *p_res\denom = p_denom 
  ProcedureReturn *p_res 
EndProcedure 

Procedure.l Fraction_CreateMixedNumber(p_int.l, p_nom.l, p_denom.l) 
  Protected *p_res.Fraction 
  *p_res = GlobalAlloc_(#GPTR, SizeOf(Fraction)) 
  *p_res\nom = p_nom + p_int * p_denom 
  *p_res\denom = p_denom 
  ProcedureReturn *p_res 
EndProcedure 

Procedure.l Fraction_Free(*p_f.Fraction) 
  If GlobalFree_(*p_f) = 0 ; returning 0 means all is OK - Memory freed 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure.l Fraction_SetData(*p_f.Fraction, p_nom.l, p_denom.l) 
  *p_f\nom = p_nom 
  *p_f\denom = p_denom 
  ProcedureReturn *p_f 
EndProcedure 

Procedure.l Fraction_SetDataMixedNumber(*p_f.Fraction, p_int.l, p_nom.l, p_denom.l) 
  *p_f\nom = p_nom + p_int * p_denom 
  *p_f\denom = p_denom 
  ProcedureReturn *p_f 
EndProcedure 

Procedure.l Fraction_GetCopy(*p_f.Fraction) 
  Protected *p_res.l 
  *p_res = GlobalAlloc_(#GPTR, SizeOf(Fraction)) 
  CopyMemory(*p_f, *p_res, SizeOf(Fraction)) 
  ProcedureReturn *p_res 
EndProcedure 

Procedure.l Fraction_CopyTo(*p_f1.Fraction, *p_f2.Fraction) 
  *p_f1\nom = *p_f2\nom 
  *p_f1\denom = *p_f2\denom 
  ProcedureReturn *p_f1 
EndProcedure 

Procedure.l Fraction_Reduce(*p_f.Fraction) 
  Protected ggt.l 
  ggt = GetGCD(*p_f\nom, *p_f\denom) 
  If ggt > 1 
    *p_f\nom / ggt 
    *p_f\denom / ggt 
  EndIf 
  If *p_f\denom < 0 
    *p_f\nom * -1 
    *p_f\denom * -1 
  EndIf 
  ProcedureReturn *p_f 
EndProcedure  

Procedure.l Fraction_Extend(*p_f.Fraction, p_int.l) 
  *p_f\nom * p_int 
  *p_f\denom * p_int 
  ProcedureReturn *p_f 
EndProcedure  

Procedure.l Fraction_Reciprocal(*p_f1.Fraction) 
  Protected temp.l 
  temp = *p_f1\denom 
  *p_f1\denom = *p_f1\nom 
  *p_f1\nom = temp 
  ProcedureReturn *p_f1 
EndProcedure 

Procedure.l Fraction_Add(*p_f1.Fraction, *p_f2.Fraction) 
  If *p_f1\denom <> *p_f2\denom 
    Fraction_Reduce(*p_f1) 
    Fraction_Reduce(*p_f2) 
    Protected kgv.l 
    kgv = GetLCM(*p_f1\denom, *p_f2\denom) 
    If kgv > 1 
      Fraction_Extend(*p_f1, kgv/*p_f1\denom) 
      Fraction_Extend(*p_f2, kgv/*p_f2\denom) 
    EndIf 
  EndIf 
  
  *p_f1\nom + *p_f2\nom 
  ProcedureReturn Fraction_Reduce(*p_f1) 
EndProcedure 

Procedure.l Fraction_Add_L(*p_f1.Fraction, p_int.l) 
  *p_f1\nom + p_int * *p_f1\denom 
  ProcedureReturn Fraction_Reduce(*p_f1) 
EndProcedure 

Procedure.l Fraction_Sub(*p_f1.Fraction, *p_f2.Fraction) 
  If *p_f1\denom <> *p_f2\denom 
    Fraction_Reduce(*p_f1) 
    Fraction_Reduce(*p_f2) 
    Protected kgv.l 
    kgv = GetLCM(*p_f1\denom, *p_f2\denom) 
    If kgv > 1 
      Fraction_Extend(*p_f1, kgv/*p_f1\denom) 
      Fraction_Extend(*p_f2, kgv/*p_f2\denom) 
    EndIf 
  EndIf 
  
  *p_f1\nom - *p_f2\nom 
  ProcedureReturn Fraction_Reduce(*p_f1) 
EndProcedure 

Procedure.l Fraction_Sub_L(*p_f1.Fraction, p_int.l) 
  *p_f1\nom - p_int * *p_f1\denom 
  ProcedureReturn Fraction_Reduce(*p_f1) 
EndProcedure 

Procedure.l Fraction_Mul(*p_f1.Fraction, *p_f2.Fraction) 
  Fraction_Reduce(*p_f1) 
  Fraction_Reduce(*p_f2) 
  *p_f1\nom * *p_f2\nom 
  *p_f1\denom * *p_f2\denom 
  ProcedureReturn Fraction_Reduce(*p_f1) 
EndProcedure 

Procedure.l Fraction_Mul_L(*p_f1.Fraction, p_int.l) 
  Fraction_Reduce(*p_f1) 
  *p_f1\nom * p_int 
  ProcedureReturn Fraction_Reduce(*p_f1) 
EndProcedure 

Procedure.l Fraction_Div(*p_f1.Fraction, *p_f2.Fraction) 
  Fraction_Reduce(*p_f1) 
  Fraction_Reduce(*p_f2) 
  *p_f1\nom * *p_f2\denom 
  *p_f1\denom * *p_f2\nom 
  ProcedureReturn Fraction_Reduce(*p_f1) 
EndProcedure 

Procedure.l Fraction_Div_L(*p_f1.Fraction, p_int.l) 
  Fraction_Reduce(*p_f1) 
  *p_f1\denom * p_int 
  ProcedureReturn Fraction_Reduce(*p_f1) 
EndProcedure 

Procedure.l Fraction_Pow(*p_f1.Fraction, p_power.l) 
  Fraction_Reduce(*p_f1) 
  
  If p_power < 0 
    p_power * -1 
    Fraction_Reciprocal(*p_f1) 
  EndIf 
  
  If p_power = 0 
    *p_f1\nom = 1 
    *p_f1\denom = 1 
    ProcedureReturn *p_f1 
  ElseIf p_power = 1 
    ProcedureReturn *p_f1 
  Else 
    Protected *p_f2.Fraction 
    *p_f2 = Fraction_GetCopy(*p_f1) 
    For i=2 To p_power 
      Fraction_Mul(*p_f2, *p_f1) 
    Next  
    Fraction_CopyTo(*p_f1, *p_f2) 
    Fraction_Free(*p_f2) 
    ProcedureReturn Fraction_Reduce(*p_f1) 
  EndIf 
EndProcedure 

Procedure.f Fraction_GetVal_F(*p_f.Fraction) 
  If *p_f\denom = 0 
    ProcedureReturn $7FFFFFFF 
  Else 
    ProcedureReturn *p_f\nom / *p_f\denom 
  EndIf 
EndProcedure 

Procedure.l Fraction_GetVal_L(*p_f.Fraction) 
  If *p_f\denom = 0 
    ProcedureReturn $7FFFFFFF 
  Else 
    ProcedureReturn RoundReal(*p_f\nom / *p_f\denom) 
  EndIf 
EndProcedure  
  
  
  
;- 
;-  some examples / einige Beispiele 
;- 
Debug "Einige Beipsiele:" 
  
*a = Fraction_CreateMixedNumber(3, 5, 8) 
*b = Fraction_Create(12, 1) 

Debug "a = " + Fraction_GetStrMixedNumber(*a) + "  =  " + Fraction_GetStr(*a) 
Debug "b = " + Fraction_GetStrMixedNumber(*b) + "  =  " + Fraction_GetStr(*b) 

*c = Fraction_Sub(Fraction_GetCopy(*a), *b) ; *c is created by Fraction_GetCopy / *c wird von Fraction_GetCopy erstellt 
Debug "a - b = " + Fraction_GetStr(*c) 

Fraction_Free(*c) 
; all variables will be automatically freed after program end, too however, in some cases
; inside loops using Fraction_GetCopy() you should use it, if you don't need it anymore 
; Alle Variablen werden nach Programmende automatisch gelöscht. 
; Trotzdem sollte in manchen Fällen, wo in Loops Fraction_GetCopy() verwendet wird,
; der Variablenspeicherbereich stets wieder freigegeben werden, wenn er nicht benötigt wird. 

*d = Fraction_GetCopy(*a) 
Fraction_Mul(*d, *b) 
Debug "a * b = " + Fraction_GetStr(*d) 
Debug "(a * b) ^ 4 = " + Fraction_GetStrMixedNumber(Fraction_Pow(*c, 4)) 
Debug "" 

;to get direct access to the nominator / denominator create it with 'myName.Fraction' 
;um direkten Zugriff auf Zähler/Nenner zu haben, erstelle den Pointer als Fraction-Struktur 
*e.Fraction = Fraction_GetCopy(*a) 
Debug "a = " + Str(*e\nom) + " / " + Str(*e\denom) 

Fraction_Extend(*e, 3) 
Debug "a = " + Fraction_GetStr(*e) 
Debug "a = " + StrF(Fraction_GetVal_F(*e)) 

Fraction_SetData(*e, 3, 0) 
Debug "(a = 3/0) ->  a = " + Fraction_GetStr(*e)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -----
; EnableXP
