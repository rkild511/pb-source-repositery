; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2910&highlight=
; Author: [DS]DarkDragon
; Date: 23. November 2003
; OS: Windows
; Demo: Yes

; Autor/Author: [DS]DarkDragon/DarkDragon 
; --- 
; Beschr./Descr.: 
; Einfache EValfunktion 
; Simple evalfunction 
; --- 
; Sprache/Language: 
; Deutsch/German 
; --- 
; Ich weiß es gibt schon eine Funktion dafür, aber ich finde die für meinen Gebrauch zu groß 
; I know there is another eval-function but for my usings the other function is too big 

#NUM = "0123456789" 

Procedure ERRORMSG(Message.s) 
   MessageRequester("ERROR", Message, #MB_ICONERROR | #PB_MessageRequester_Ok) 
   End 
EndProcedure 

Procedure.s GetNum(Str.s, Index) ; Prozedur zum Finden einzelner Zahlen(Index = 1...) 
       If Str.s <> "" 
         k = 0 
         Str.s = ReplaceString(Str, " ", "") 
         While MyIndex < Index 
           MyIndex + 1 
           Char.s = "" 
           Comb.s = "" 
           While FindString(#NUM, Char.s, 0) <> 0 And k <= Len(Str) 
             k + 1  ; Nächster Buchstabe 
             Comb.s = Comb.s + Char.s 
             Char.s = Mid(Str, k, 1) 
           Wend 
         Wend 
        ProcedureReturn Comb.s 
       EndIf 
EndProcedure 

Procedure GetSym(Str.s, Sym.s) ; Prozedur zum Finden einzelner Zahlen(Index = 1...) 
       If Str.s <> "" And FindString(Str, Sym, 0) <> 0 
         k = 0 
         Str.s = ReplaceString(Str, " ", "") 
         While Char.s <> Sym And k <= Len(Str) 
           Char.s = "1" 
           While FindString("*/-+()", Char.s, 0) = 0 And k <= Len(Str) 
             k + 1 
             Char.s = Mid(Str, k, 1) 
           Wend 
           Ind + 1 
         Wend 
        ProcedureReturn Ind 
       ElseIf FindString(Str, Sym, 0) = 0 
         ProcedureReturn 0 
       EndIf 
EndProcedure 

Procedure.s Math(Str.s) 
    Str.s = ReplaceString(Str.s, " ", "") 
    Bracket: 
    If GetSym(Str.s, "(") <> 0 And GetSym(Str.s, ")") <> 0 ; Wenn eine Klammer vorhanden ist 
       BracketStart = FindString(Str, "(", 0)+1 
       BracketStop = FindString(Str, ")", BracketStart) 
       BrStr.s = Mid(Str, BracketStart, BracketStop-BracketStart) 
       Str.s = ReplaceString(Str.s, "("+BrStr.s+")", Math(BrStr.s)) ; Die Funktion Math wird aufgerufen um den Klammerinhalt auszurechnen. 
    ElseIf (GetSym(Str.s, "(") <> 0 And GetSym(Str.s, ")") = 0) Or (GetSym(Str.s, "(") = 0 And GetSym(Str.s, ")") <> 0) 
       ERRORMSG("Reading script: no bracket found "+Str.s) 
    EndIf 
    While GetSym(Str.s, "*") <> 0 ; Symbol * suchen 
      Result = ValF(GetNum(Str, GetSym(Str.s, "*")))*ValF(GetNum(Str, GetSym(Str.s, "*")+1)) 
      Replace.s = GetNum(Str, GetSym(Str.s, "*"))+"*"+GetNum(Str, GetSym(Str.s, "*")+1) 
      Str.s = ReplaceString(Str, Replace.s, Str(Result)) ; Das Ergebnis in den String einsetzen 
    Wend 
    While GetSym(Str.s, "/") <> 0 ; Symbol / suchen 
      V1 = ValF(GetNum(Str, GetSym(Str.s, "/"))) 
      V2 = ValF(GetNum(Str, GetSym(Str.s, "/")+1)) 
      Result = V1/V2 
      Replace.s = GetNum(Str, GetSym(Str.s, "/"))+"/"+GetNum(Str, GetSym(Str.s, "/")+1) 
      Str.s = ReplaceString(Str, Replace.s, Str(Result)) 
    Wend 
    While GetSym(Str.s, "+") <> 0 ; Symbol + suchen 
      V1 = ValF(GetNum(Str, GetSym(Str.s, "+"))) 
      V2 = ValF(GetNum(Str, GetSym(Str.s, "+")+1)) 
      Result = V1+V2 
      Replace.s = GetNum(Str, GetSym(Str.s, "+"))+"+"+GetNum(Str, GetSym(Str.s, "+")+1) 
      Str.s = ReplaceString(Str, Replace.s, Str(Result)) 
    Wend 
    While GetSym(Str.s, "-") <> 0 ; Symbol - suchen 
      V1 = ValF(GetNum(Str, GetSym(Str.s, "-"))) 
      V2 = ValF(GetNum(Str, GetSym(Str.s, "-")+1)) 
      Result = V1-V2 
      Replace.s = GetNum(Str, GetSym(Str.s, "-"))+"-"+GetNum(Str, GetSym(Str.s, "-")+1) 
      Str.s = ReplaceString(Str, Replace.s, Str(Result)) 
    Wend 
    ProcedureReturn Str.s 
EndProcedure 

; Leider Funktioniert das Klammernausrechnen nicht wie in wirklichkeit. 

Debug "1 + (5 - 1 * 3)" 
Debug "=" 
Debug Math("1 + (5 - 1 * 3)") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
