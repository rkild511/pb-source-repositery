; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=867&highlight=
; Author: Feri (updated by Andre)
; Date: 04. May 2003
; OS: Windows
; Demo: Yes

CatchImage(0,?Beispielbild)                    ;  l�dt dein eingef�gtes Bild als Bild 0 von 
                                               ;  der Adresse des Labels, funktioniert wie 
                                               ;  LoadImage, nur bei Loadimage l�dst du das 
                                               ;  Bild von einem Laufwerk , z.B. 
                                               ;  (LoadImage(0,"C:\Bild.bmp") und mit 
                                               ;  CatchImage eben aus dem Speicher 
; 
; dein Programm ... 
; .....
End


; am Schlu�: 
Beispielbild: IncludeBinary "..\Gfx\PureBasic.bmp"    ; hier wird dein Bild in die Exe eingef�gt 
                                                      ;  und �ber das Label (hier: Beispielbild) 
                                                      ;  bekommst du die Adresse des Bildes 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
