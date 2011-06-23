; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2700&highlight=
; Author: Rings
; Date: 30. October 2003
; OS: Windows
; Demo: Yes

;Random-Muster und Linked List's

NewList Names.s() ;Original Liste
Structure MyS
  Inhalt.s
  Hauefigkeit.l
EndStructure

NewList Ergebnis.Mys() ;ergebnisliste

For i=1 To 1000
  AddElement(Names())
  Names()=Str(Random(10))
Next
ResetList(Names()) ;rücksetzen des LinkedlistZeigers

While NextElement(Names()) ;Alle durchgehen
  Such.s=Names()
  ResetList(Ergebnis()) ;rücksetzen des LinkedlistZeigers
  Flag=0
  While NextElement(Ergebnis()) ;Alle Durchgehen
    If Such.s=Ergebnis()\Inhalt
      Ergebnis()\Hauefigkeit +1
      Flag=1
    EndIf
  Wend
  If Flag=0
    AddElement(Ergebnis())
    Ergebnis()\Inhalt=Such.s
    Ergebnis()\Hauefigkeit =1
  EndIf
Wend

Ausgabe:
;Debug CountList(Ergebnis())
ResetList(Ergebnis())
While NextElement(Ergebnis())
  Debug Ergebnis()\Inhalt + " ist vorhanden  "+Str(Ergebnis()\Hauefigkeit) +" mal"
  Summe=summe+Ergebnis()\Hauefigkeit
Wend
Debug ("Summe="+Str(Summe))

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
