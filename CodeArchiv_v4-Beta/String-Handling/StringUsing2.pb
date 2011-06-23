; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3279&highlight=
; Author: Sylvia
; Date: 05. March 2004
; OS: Windows
; Demo: Yes

Procedure.s StringReverse(was$)
  ; Gibt einen String umgekehrt zurück

  Protected Result$,a

  Result$=""
  For a=Len(was$) To 1 Step -1
    Result$+Mid(was$,a,1)
  Next a

  ProcedureReturn Result$
EndProcedure

Procedure.l Min(a,b)
  ; Liefert das Minimum zurück

  If a<b: ProcedureReturn a: EndIf
  ProcedureReturn b
EndProcedure

Procedure.l Max(a,b)
  ; Liefert das Maximum zurück

  If a>b: ProcedureReturn a: EndIf
  ProcedureReturn b
EndProcedure

;**********************************
;* 2004 Mar.05 "Sylvia" GermanForum
;**********************************

Procedure.s StringUsing(Format$,Wert)
  ; Liefert einen formatierten Zahlenstring zurück
  ;
  ; Format$ = Erste 2 Zeichen= ">$" = Wert wird Hexadezimal konvertiert
  ;           Erste 2 Zeichen= ">%" = Wert wird Binär       konvertiert
  ;
  ;           0  Ziffer/Vorzeichen oder zwingend 0
  ;           #  Ziffer/Vorzeichen oder Blank
  ;
  ;           Andere Zeichen werden 1:1 ausgegeben; ausgenommen die Zeichen,
  ;           die sich ZWISCHEN den Platzhaltern 0 oder # befinden. Diese
  ;           werden nur dann ausgegeben, wenn die zu formatierende Zahl die
  ;           entsprechende Grösse hat
  ;
  ; Result$ = formatierter Zahlenstring

  Protected Result$, a, b, Wert$, LeftBound, LeftNull, RightBound

  Result$=""

  ; Wert in Hex/Binär/Dezimal-String umwandeln
  Select Left(Format$,2)
    Case ">$": Wert$=Hex(Wert): Format$=Right(Format$,Len(Format$)-2)
    Case ">%": Wert$=Bin(Wert): Format$=Right(Format$,Len(Format$)-2)

      Default:   Wert$=Str(Wert)
  EndSelect

  ; Grenzen der Platzhalter ermitteln
  LeftBound=FindString(Format$,"#",1): If LeftBound=0: LeftBound=Len(Format$)+1: EndIf
  LeftNull= FindString(Format$,"0",1): If LeftNull=0:  LeftNull= Len(Format$)+1: EndIf
  If LeftBound=LeftNull: ProcedureReturn Format$+Wert$: EndIf

  a=FindString(StringReverse(Format$),"#",1)
  b=FindString(StringReverse(Format$),"0",1)
  If a=0: a=b: EndIf
  If b=0: b=a: EndIf
  RightBound=Len(Format$)+1-min(a,b)


  ; Result$ von hinten auffüllen
  For a=Len(Format$) To 1 Step -1
    Select Mid(Format$,a,1)
      Case "0"
        If Len(Wert$)
          Result$=Right(Wert$,1)+Result$
          Wert$=Left(Wert$,Len(Wert$)-1)
        Else
          Result$="0"+Result$
        EndIf

      Case "#"
        If Len(Wert$)
          Result$=Right(Wert$,1)+Result$
          Wert$=Left(Wert$,Len(Wert$)-1)
        Else
          Result$=" "+Result$
        EndIf

      Default
        If Len(Wert$) Or a>LeftNull Or a<LeftBound Or a>RightBound
          Result$=Mid(Format$,a,1)+Result$
        EndIf

    EndSelect
  Next a

  StringUsingEnd:
  ProcedureReturn Result$
EndProcedure

Debug StringUsing("EURO ###.##0",10745)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -