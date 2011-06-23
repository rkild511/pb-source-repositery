; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2951&highlight=
; Author: bobobo
; Date: 27. November 2003
; OS: Windows
; Demo: No

OpenConsole()
pippifax$="Erwin hat einen an der Schüssel äöüßÄÖÜ"
PrintN(pippifax$)
PrintN("So soll das nicht aussehen ..")
CharToOem_(pippifax$,pippifax$)
PrintN(pippifax$)
PrintN("Das passt schon eher")
OemToChar_(pippifax$,pippifax$)
PrintN(pippifax$)
PrintN("und nun sieht es wieder bloed aus")
PrintN("")
PrintN("diese OEMtoChar bzw. CharToOem Umwandlung sollte man immer bei Konsolenausgaben anwenden")
PrintN("alles weitere dazu siehe in der winhelp oder im PSDK")
Input()
CloseConsole()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
