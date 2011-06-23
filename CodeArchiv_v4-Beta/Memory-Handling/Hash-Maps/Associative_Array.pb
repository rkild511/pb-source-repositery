; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1778&highlight=
; Author: Hannes (updated for PB 4.00 by Andre)
; Date: 20. August 2003 (updated on 24. August 2003)
; OS: Windows
; Demo: Yes


; Example for an associative array / hash-map
; Beispiel f�r ein "Assoziatives Array" / Hash-Map

; Ein Assoziatives Array ist eine Datenstruktur, bei dem die Datenwerte, anders als beim normalen
; Array, nicht �ber einen Index, sondern �ber einen Schl�ssel angesprochen werden.

; Idealerweise wird der Schl�ssel vom Programmierer so gew�hlt, dass eine assoziative Verbindung
; zwischen Schl�ssel und Datenwert besteht.

; Hinweis: Ein Anwendungsbeispiel findet sich ganz am Ende.


#test = 1    ; Debug-Code aktiviert; Deaktivieren mit #test = 0


Declare.l mod(eineNum.l, eineNum2.l)


; ---------------------------------------------------
; Zeichenketten-Arrays deklarieren
; ---------------------------------------------------

; Die folgende Konstante legt die Gr�sse der Hashtabelle fest: 

#hashTabellenGroesse = 4001  ; Primzahl

; Die Hashtabellengr�sse muss eine Primzahl sein, sonst funktionert
; die Hashwertberechnung nicht zufriedenstellend.


; Die Tabellengr�sse muss eine Primzahl sein, z.B. 10007. Deshalb habe ich einen
; kleinen Primzahlentest beigegeben. 
; Jede Implementation einer Hashtabelle muss von einer maximalen Gr�sse ausgehen.
; Man w�hlt sie �blicherweise so, dass sie maximal zu etwas 50% gef�llt wird.
; Gewisse Implementationen �berwachen auch den F�llstand der Tabelle und kopieren
; die Daten in eine gr�ssere Tabelle um, wenn ein bestimmter F�llungsgrad �berschritten
; wird. Das m�chte ich bei meiner einfachen Implementation vermeiden. Ich w�hle einfach
; die Tabellengr�sse so, dass es f�r meine Anwendung reicht. 


Global Dim mapSchluessel.s(#hashTabellenGroesse)  ; enth�lt die originalen Schl�ssel
Global Dim mapWerte.s(#hashTabellenGroesse)       ; enth�lt die dazu passenden Werte





; -----------------------------------------------------------------------
; Hilfsfunktion zur Berechnung des ersten Zugriffsindex in die
; Streuspeicher-Arrays (Hashtabellen)
; -----------------------------------------------------------------------


Procedure.l stringHash(zeichenkette.s)
  ; Resultat: IntegerZahl berechnet aus der Zeichenkette.
  ; Die Resultatwerte sollten m�glichst gut
  ; zwischen 0 und #hashTabellenGroesse verteilt sein.
  ; Hinweis 211 ist eine Primzahl.
  ; Sie liegt in der Groessenordnung des Codebereichs
  ; von zeichen.s
  
  ; Hinweis: Viele weitere Hashfunktionen sind denkbar.
  ; Die vorliegende ist ordentlich aber wohl nicht
  ; optimal.
  
  wert.l = 0
  laenge.l = Len(zeichenkette.s)
  
  For i.l = 1 To laenge.l
    zeichen.s = Mid(zeichenkette.s,i.l,1)
    wert.l = wert.l + (Asc(zeichen.s) -32) * 211
    wert.l = mod(wert.l, 1009)
  Next
  ProcedureReturn wert.l
  
EndProcedure







; ---------------------------------------------------
; Prozedur zum Zugreifen (Auslesen)
; ---------------------------------------------------

Procedure.s  MapWertLesen(schluessel$)
  
  zugriffsversuche.l = 0
  ; Index f�r Zugriff berechnen: hash.w
  
  hash.w = stringHash(schluessel$)
  
  ; Lineares Sondieren
  While (schluessel$ <> mapSchluessel(hash.w)) And (zugriffsversuche.l < #hashTabellenGroesse)
    hash.w = hash.w + 10
    hash.w = mod(hash.w, #hashTabellenGroesse)
    zugriffsversuche.l =   zugriffsversuche.l + 1
  Wend
  
  
  If mapSchluessel(hash.w) = schluessel$
    ProcedureReturn mapWerte(hash.w)
  Else
    ProcedureReturn "<kein Eintrag>"
  EndIf
  
EndProcedure




; ---------------------------------------------------
; Prozedur um einen Wert zu setzen
; ---------------------------------------------------

Procedure  MapWertSchreiben(schluessel$, wert$)
  
  ; Hinweis: Es fehlt eine Pr�fung ob die Hashtabelle voll
  ; ist. Wenn sie voll ist, dann kommt das Programm in eine
  ; nicht abbrechende Schleife.
  
  
  ; Index f�r Ablage berechnen: hash.w
  ; freier Platz oder bereits bestehender gleicher Eintrag.
  
  hash.w = stringHash(schluessel$)
  
  
  ; Lineares Sondieren
  While (schluessel$ <> mapSchluessel(hash.w)) And (mapSchluessel(hash.w) <> "")
    hash.w = hash.w + 10
    hash.w = mod(hash.w, #hashTabellenGroesse)
  Wend
  
  
  
  ; Eintrag vornehmen
  mapSchluessel(hash.w) = schluessel$
  mapWerte(hash.w) = wert$
  
EndProcedure







; ---------------------------------------------------
; Hilfs- und Testcode
; ---------------------------------------------------


Procedure.l mod(eineNum.l, eineNum2.l)
  ; Modulo-Operation
  z.l = eineNum.l / eineNum2.l
  mod.l = eineNum.l - z.l * eineNum2.l
  
  ProcedureReturn mod.l
EndProcedure




Procedure primZahlenTest(kandidat.l)
  
  g = Round(Sqr(kandidat.l),1)
  
  primzahl.b = 1
  
  For i = 2 To g
    If mod(kandidat.l,i) = 0
      Debug Str(kandidat.l) + " ist keine Primzahl, da es einen Teiler " + Str(i) + " gibt."
      primzahl.b = 0
    EndIf
  Next
  
  If primzahl.b
    Debug Str(kandidat.l) + " ist eine Primzahl!"
  EndIf
EndProcedure








CompilerIf #test
  
  primZahlenTest(29)
  primZahlenTest(211)
  primZahlenTest(311)
  ; primZahlenTest(1001)
  ; primZahlenTest(1003)
  ; primZahlenTest(1007)
  primZahlenTest(1009)
  
  primZahlenTest(4001)
  
  primZahlenTest(10007)
  
  
  Debug ">>>Test der Hash-Funktion<<<"
  Debug stringHash("Aachen")
  Debug stringHash("Berlin")
  Debug stringHash("Bonn")
  Debug stringHash("K�ln")
  Debug stringHash("Leipzig")
  Debug stringHash("Oberfranken")
  Debug stringHash("Wetterau")
  Debug stringHash("Z�rich")
  
  
  Debug ">>>HashMap verwenden<<<"
  
  MapWertSchreiben("Aachen", "1000")
  MapWertSchreiben("Berlin", "5000")
  MapWertSchreiben("Bonn", "2000")
  MapWertSchreiben("K�ln", "2400")
  MapWertSchreiben("Leipzig", "2800")
  MapWertSchreiben("Oberfranken", "0400")
  MapWertSchreiben("Salzburg", "6000")
  MapWertSchreiben("Wetterau", "9800")
  
  MapWertSchreiben("Z�rich", "7999")
  MapWertSchreiben("Z�rich", "8000")
  
  
  Debug "Zugriff auf Eintrag 'Z�rich'  : " + MapWertLesen("Z�rich")
  Debug "Zugriff auf Eintrag 'Salzburg': " + MapWertLesen("Salzburg")
  Debug "Zugriff auf Eintrag 'Berlin'  : " + MapWertLesen("Berlin")
  Debug "Zugriff auf Eintrag 'Wien'    : " + MapWertLesen("Wien")
  
CompilerEndIf


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
