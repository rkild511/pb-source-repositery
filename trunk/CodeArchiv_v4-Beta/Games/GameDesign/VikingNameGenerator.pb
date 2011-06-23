; German forum: http://www.purebasic.fr/german/viewtopic.php?t=868&highlight=
; Author: Hroudtwolf
; Date: 14. November 2004
; OS: Windows, Linux
; Demo: Yes

; Erstellt Wikinger-Namen
; Create Viking names

;_________________________________________________
;_                                                                                   _
;_ Programm  : Namenmacher                                          _
;_ Autor     : Thor Hroudtwolf                                             _
;_ Fertigung : 14.11.2004                                                  _
;_________________________________________________
;_                                               _
;_ Macht Namen die Wikingerisch klingen.(Siedler)_
;_ (Ich bin ein Wikingerfanatiker)               _
;_ Wotans_Macht@Web.de                           _
;_________________________________________________


#Namen_Masculin=1
#Namen_Feminin=2


Procedure.s GibNamen(silben.l,geschlecht)
  Dim ensilb$(17);Dimensioniere Silben-Liste
  Dim AnSilb$(21)
  If silben=0:silben=1:EndIf ; Null-Parameter-Korrektur
  If geschlecht=0:geschlecht=1:EndIf ; Null-Parameter-Korrektur
  
  
  If geschlecht=1
    EnSilb$(1)="ker";Endsilben des Weiblichen Geschlechts
    EnSilb$(2)="ling"
    EnSilb$(3)="tes"
    EnSilb$(4)="tur"
    EnSilb$(5)="len"
    EnSilb$(6)="ten"
    EnSilb$(7)="san"
    EnSilb$(8)="son"
    EnSilb$(9)="rin"
    EnSilb$(10)="klen"
    EnSilb$(11)="kont"
    EnSilb$(12)="tam"
    EnSilb$(13)="kim"
    EnSilb$(14)="ter"
    EnSilb$(15)="erl"
    EnSilb$(16)="arl"
    EnSilb$(17)="nur"
    EnSiAnz=17; Anzahl der Endsilben
  EndIf
  If geschlecht=2
    EnSilb$(1)="lina";Endsilben des männlichen Geschlechts
    EnSilb$(2)="kana"
    EnSilb$(3)="na"
    EnSilb$(4)="na"
    EnSilb$(5)="ri"
    EnSilb$(6)="tra"
    EnSilb$(7)="si"
    EnSilb$(8)="trun"
    EnSilb$(9)="hilde"
    EnSilb$(10)="te"
    EnSilb$(11)="re"
    EnSilb$(12)="riede"
    EnSilb$(13)="tine"
    EnSilb$(14)="line"
    EnSilb$(15)="rana"
    EnSiAnz=15; Anzahl der Endsilben
  EndIf
  
  AnSilb$(1)="Ha";Anfangssilben
  AnSilb$(2)="Ba"
  AnSilb$(3)="Be"
  AnSilb$(4)="Ki"
  AnSilb$(5)="Ka"
  AnSilb$(6)="La"
  AnSilb$(7)="Wal"
  AnSilb$(8)="Wil"
  AnSilb$(9)="Kun"
  AnSilb$(10)="San"
  AnSilb$(11)="Tro"
  AnSilb$(12)="Hum"
  AnSilb$(13)="Fla"
  AnSilb$(14)="Dan"
  AnSilb$(15)="Ger"
  AnSilb$(16)="Vor"
  AnSilb$(17)="Jan"
  AnSilb$(18)="Thor"
  AnSilb$(19)="Fried"
  AnSilb$(20)="Gen"
  AnSilb$(21)="War"
  AnSiAnz=21;Anzahl der Anfangssilben
  
  selbstl$="aeiou";Selbstlaute
  mittl$="dfghklnmprstw";Mittlaute
  
  ;Setzen der Zufallswerte zur Silbenbestimmung
  For x =1 To silben
    ml.l=Int(Random(Len(mittl$)))
    If ml=0:ml=1:EndIf
    sl.l=Int(Random(Len(selbstl$)))
    If sl=0:sl=1:EndIf
    silbe$=Mid(mittl$,ml,1)+Mid(selbstl$,sl,1)
    wort$=wort$+silbe$
  Next x
  es.l=Int(Random(EnSiAnz))
  If es=0:es=1:EndIf
  as.l=Int(Random(AnSiAnz))
  If as=0:as=1:EndIf
  
  ;Zusammenbau des Namens aus Anfangssilbe, Mittensilben,Endsilbe
  nn$=AnSilb$(as)+wort$+EnSilb$(es)
  
  ProcedureReturn nn$;übergibt Namen an Hauptprogramm
EndProcedure


;Testausgabe

Debug gibnamen(1,#Namen_Feminin)

Debug gibnamen(1,#Namen_Masculin)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -