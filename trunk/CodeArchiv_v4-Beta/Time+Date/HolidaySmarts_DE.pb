; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6806&highlight=
; Author: Andre Beer (based on an US example of Lance Jepsen)
; Date: 05. July 2003
; OS: Windows
; Demo: Yes

; Wie oft haben Sie ein Programm benutzt, dass zu Beginn einen schönen Gruß zum
; Feiertag ausgab?
; Sie können diese Funktionalität einfach zu Ihren Programmen hinzufügen.
; Denken Sie daran, dies funktioniert nur mit Feiertagen, die auf ein bestimmtes
; Datum fallen (also nicht mit Feiertagen, die flexibel sind wie z.B. "dritter
; Donnerstag im Monat").

date$ = FormatDate("%dd.%mm", Date())

Select date$
  Case "01.01"
    text$="Glückliches Neues Jahr!"
  Case "01.05"
    text$="Tag der Arbeit - heute schon was gemacht? ;)"
  Case "03.10"
    text$="Alles Gute zum Tag der Deutschen Einheit!"
  Case "24.12"
    text$="Fröhliche Weihnachten!"
  Case "25.12"
    text$="Erster Weihnachtsfeiertag - na, alle Geschenke schon ausgepackt? ;)"
  Case "26.12"
    text$="Zweiter Weihnachtsfeiertag - na, Gänsebraten schon verdaut? ;)"
  Case "31.12"
    text$="Guten Rutsch am heutigen Silvester!"
  Default
    text$="Alles Gute zu diesem Tag :)"
EndSelect

MessageRequester("Titel", text$, 0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
