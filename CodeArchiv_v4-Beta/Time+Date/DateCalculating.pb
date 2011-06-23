; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1169&highlight=
; Author: Falko (1st procedure by Maurizio555)
; Date: 09. December 2004
; OS: Windows
; Demo: Yes


;Formel entnommen von
; http://www.ortelius.de/kalender/calc_de.php
;Angepasst von Falko


; Diese Procedur erwartet d (Tag), m (Monat), y (Jahr) und gibt eine Long Zahl
; zurück. Diese stellt eine Fortlaufende Nummer dar, die sich Tag für Tag um 1
; erhöht. Damit kann ich Zeitrechnungen anstellen, ohne die Einschränkungen
; des Unixsystems (also auch 785 v.C. und 5304 n.C.).
Procedure.l FortlaufKal(d.b, m.w, y.w)
  If m.w <3
    y.w=y-1
    m.w=m+12
  EndIf
  a.w=Int(y/100)
  b=2-a+Int(a/4)
  zahl.l=Int(365.25*(y+4716))+Int(30.6001*(m+1))+d+b-1524
  ProcedureReturn zahl
EndProcedure

LANG.l=FortlaufKal(9,12,2004)
Debug LANG
;


; Umkehrung der obigen Prozedur. Nach Übergabe einer fortlaufenden Zahl
; wird in (T)ag, (M)onat und (J)ahr zurückgegeben
Procedure DMY(JD.l)
  Global T.b,M.w,J.w
  N1 = JD + 32044
  N2 = N1 / 146097
  N3 = N1 % 146097
  N4 = N3 / 36524 - N3 / 146096
  N5 = N3 - 36524*N4
  N6 = N5 / 1461
  N7 = N5 % 1461
  N8 = N7 / 365 - N7 / 1460
  N9 = N7 - 365*N8
  N10 = (111*N9 + 41) / 3395
  T = N9-30*N10-(7*(N10 + 1)) / 12 + 1
  M1 = N10 + 3
  J1 = 400*N2+100*N4+4*N6+N8-4800
  M = ((M1 + 11) % 12)+1
  J = J1+(M1 / 13)
EndProcedure

DMY(LANG)
Debug T
Debug M
Debug J

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -