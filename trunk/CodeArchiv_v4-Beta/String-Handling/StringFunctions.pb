; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1363&highlight=
; Author: Rob (updated for PB4.00 by blbltheworm, examples added by Andre)
; Date: 15. June 2003
; OS: Windows
; Demo: Yes


; Ein paar nützliche String-Funktionen. 
; 
; AddSlashes(string.s) - Fügt zu ' " und \ ein Backslash hinzu. Nützlich für SQL-Datenbankabfragen. 
; 
; Levenshtein(string1.s, string2.s) - Errechnet die Levenshtein-Differenz der zwei Strings, also die Zahl an
;                                     Ersetzungen/Löschungen, die nötig ist um string1 in string2 zu wandeln 
; 
; Caesar(string.s,offset.w) - Caesar-Chiffre. Einfaches verschieben der Buchstaben im Alphabet.
;                             Mit offset=13 hat man eine ROT13-Verschlüsselung. 
; 
; ReplaceChars(string.s, search.s, replace.s) - Einzelne Buchstaben ersetzen. Wie strtr() in PHP. 
; 
; WordCount(string.s,trenn.s) - Zählt die durch trenn.s getrennten Wörter in string.s. trenn.s kann auch
;                               mehrfach hintereinander in string.s vorkommen. 
; 
; TurnString(string.s) - Dreht einen String um. moep -> peom 
; 
; StringCount(string.s, search.s, casesens.w) - Gibt an, wie oft search.s in string.s vorkommt. casesens=1
;                                               für Case-sensitive Suche. 


; Ermittelt die kleinste der 3 Zahlen. Wird von levenshtein() benötigt. 
Procedure Minimum(a,b,c) 
  mi = a 
  If b < mi : mi = b : EndIf 
  If c < mi : mi = c : EndIf 
  ProcedureReturn mi 
EndProcedure 


; Fügt zu ' " und \ ein Backslash hinzu. Nützlich für SQL-Datenbankabfragen. 
Procedure.s AddSlashes(string.s) 
  string = ReplaceString(string,"\","\\") 
  string = ReplaceString(string,"'","\'") 
  string = ReplaceString(string,Chr(34),"\"+Chr(34)) 
  ProcedureReturn string 
EndProcedure 


; Errechnet die Differenz der zwei Strings, also die Zahl der Ersetzungen/Löschungen, die 
; nötig sind um aus String1 String2 zu machen. Benötigt Minimum(). 
Procedure Levenshtein(s.s, t.s) 
  n = Len(s) 
  m = Len(t) 
  If m=0 Or n=0 : ProcedureReturn 0 : EndIf 
  Global Dim d(n,m) 
  For i = 0 To n : d(i, 0) = i : Next 
  For j = 0 To m : d(0, j) = j : Next 
  For i = 1 To n 
    si.s = Mid(s,i,1) 
    For j = 1 To m 
      tj.s = Mid(t,j,1) 
      If si = tj : lv = 0 : Else : lv = 1 : EndIf 
      d(i,j) = Minimum(d(i-1,j)+1, d(i,j-1)+1, d(i-1,j-1)+lv) 
    Next j 
  Next i 
  ProcedureReturn d(n,m) 
EndProcedure 


; Caesar-Chiffre. Einfaches verschieben der Buchstaben im Alphabet. 
; Mit offset=13 hat man eine ROT13-Verschlüsselung. 
Procedure.s Caesar(string.s,offset.w) 
  l = Len(string) 
  For i = 1 To l 
    char.l = Asc(Mid(string, i, l)) 
    char2 = char 
    If (char > 64 And char < 91) : char2 = (char-65+offset)%26+65 : EndIf 
    If (char > 96 And char < 123): char2 = (char-97+offset)%26+97 : EndIf 
    string2.s + Chr(char2) 
  Next 
  ProcedureReturn string2 
EndProcedure 

; Buchstaben ersetzen. 
; Wenn String="ReplaceChars", search="eca" und replace="izo", 
; dann ist das Ergebnis "RiploziChors". Zum Beispiel... 
Procedure.s ReplaceChars(string.s, search.s, replace.s) 
  ls = Len(search) 
  lr = Len(replace) 
  For i = 1 To ls 
    If i <= lr : string = ReplaceString(string,Mid(search,i,1), Mid(replace,i,1)) : EndIf 
  Next 
  ProcedureReturn string 
EndProcedure 


; Zählt die Wörter in einem String. trenn.s ist das Zeichen, mit dem sie getrennt sind. 
Procedure WordCount(string.s,trenn.s) 
  wort.l = 0 : count.l = 0 
  l = Len(string) : trenn = Mid(trenn,1,1) 
  For i = 1 To l 
    If wort = 1 And (Mid(string,i,1) = trenn Or i=l): count + 1 : EndIf 
    If Mid(string,i,1) <> trenn : wort = 1 : Else : wort = 0 : EndIf 
  Next 
  ProcedureReturn count 
EndProcedure 


; Dreht einen String um. moep -> peom 
Procedure.s TurnString(string.s) 
  l = Len(string) 
  For i = l To 1 Step -1 
    string2.s + Mid(string,i,1) 
  Next 
  ProcedureReturn string2 
EndProcedure 


; Gibt an, wie oft search.s in string.s vorkommt. 
; casesens=1 für Case-sensitive Suche 
Procedure StringCount(string.s, search.s, casesens.w) 
  If casesens : string=LCase(string) : search = LCase(search) : EndIf 
  l = Len(search) 
  pos - l 
  While pos <> 0 
    pos = FindString(string,search,pos+l) 
    If pos : count+1 : EndIf 
  Wend 
  ProcedureReturn count 
EndProcedure 


;- Examples
Debug Minimum(10,20,5)
Debug AddSlashes("test\")
Debug Levenshtein("Test", "TestTest")
Debug Caesar("Test",2)
Debug ReplaceChars("ReplaceChars", "ace", "oto")
Debug WordCount("test,test,test", ",")
Debug TurnString("test")
Debug StringCount("this is a test","is",0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
