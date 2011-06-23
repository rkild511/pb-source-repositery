; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3433&highlight=
; Author: PBfetischist
; Date: 14. January 2004
; OS: Windows
; Demo: Yes


; Calculate the checksum of EAN

; Pruefziffer für 13 stellige EAN (Europäische Auszeichnungs Nummerierung) berechnen.
; Das sind die Nummern auf den Milchtüten, oder Konserven oder einfach überall.
; Einmal als Strichcode und darunter in Zahlenform.

Procedure Pruefziffer(EAN.s) 
  UNGERADE = 0 
  For X = 1 To 11 Step 2 
    UNGERADE+ Val(Mid(EAN.s,x,1)) * 1 
  Next 
  GERADE = 0 
  For X = 2 To 12 Step 2 
    GERADE+ Val(Mid(EAN.s,x,1)) * 3 
  Next 
  PRODUKTSUMME = GERADE + UNGERADE 
  ProcedureReturn (((PRODUKTSUMME / 10) + 1) * 10) - PRODUKTSUMME 
EndProcedure 

EAN.s = "400999314560" ; Ohne Pruefziffer 
Debug Pruefziffer(EAN.s) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
