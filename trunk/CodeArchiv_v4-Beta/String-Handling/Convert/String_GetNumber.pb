; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2854&highlight=
; Author: [DS]DarkDragon (fixed + updated for PB4.00 by blbltheworm)
; Date: 16. November 2003
; OS: Windows
; Demo: Yes

; Find an value inside a string...
#NUM = "0123456789"

Procedure GetNum(Str.s, Index) ; Prozedur zum Finden von Zahlen
  If Str.s <> ""
    Str.s = ReplaceString(Str, " ", "") ; Trim geht nur am Anfang und Ende

    k=1
    While MyIndex < Index
      
      Char.s = Mid(Str,k,1)
      Comb.s = ""
      If FindString(#NUM, Char.s, 0)                          ;<-added by blbltheworm
        MyIndex + 1
        Repeat 
          k + 1  ; Nächster Buchstabe
          Comb.s = Comb.s + Char.s
          Char.s = Mid(Str, k, 1)
        Until FindString(#NUM, Char.s, 0) = 0 Or k > Len(Str)
      Else
        k+1  ; Nächster Buchstabe
      EndIf
    Wend
    ProcedureReturn Val(Comb)
  EndIf
EndProcedure

Debug  GetNum(" 123 + 4567 + 89 ", 2)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
