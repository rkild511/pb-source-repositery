; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3279&highlight=
; Author: Sylvia
; Date: 29. December 2003
; OS: Windows
; Demo: Yes


;**********************************
;* 2003 Dec.29 "Sylvia" GermanForum
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
  ;           andere Zeichen werden 1:1 ausgegeben
  ;
  ; Result$ = formatierter Zahlenstring

  Protected Result$,a,Wert$

  Result$=""

  If Len(Format$)=0: Goto StringUsingEnd: EndIf

  ; Wert in Hex/Binär/Dezimal-String umwandeln
  Select Left(Format$,2)
    Case ">$": Wert$=Hex(Wert): Format$=Right(Format$,Len(Format$)-2)
    Case ">%": Wert$=Bin(Wert): Format$=Right(Format$,Len(Format$)-2)

      Default:   Wert$=Str(Wert)
  EndSelect

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
        Result$=Mid(Format$,a,1)+Result$

    EndSelect

  Next a

  StringUsingEnd:
  ProcedureReturn Result$

EndProcedure


; Beispiele
a$=">% %########  ########": Zahl= 123456789:      Debug StringUsing(a$,Zahl)
a$=">%%0000 0000 0000 0000": Zahl= 123456789:      Debug StringUsing(a$,Zahl)
Debug ""
a$=">$ 00 00 00 00":         Zahl= 123456789:      Debug StringUsing(a$,Zahl)
a$=">$ 0000 0000":           Zahl= 123456789:      Debug StringUsing(a$,Zahl)
Debug ""
a$="###0.000 kByte":         Zahl= 123456789/1024: Debug StringUsing(a$,Zahl)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -