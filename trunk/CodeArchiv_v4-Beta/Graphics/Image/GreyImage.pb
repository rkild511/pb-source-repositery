; www.PureArea.net
; Author: DEU.exe (updated for PB4.00 by blbltheworm)
; Date: 13. December 2003
; OS: Windows
; Demo: Yes

;
; Konvertiert Bild in Graustufen 
; by DEU.exe, 13.12.03
;
; Einfachere (aber langsamere!) Alternative zu ChangeImageColorChannel.pb u.a.
; Dieser Code sollte einfach, für Anfänger durchschaubar und mit BASIC-Befehlen realisiert werden. 
;
;
; Hier kann man mit verschiedenen Werten experimentieren:
; z.B. rechnet das Zeichenprogramm Gimp mit: 
; 0,3/0,53/0,11 
; Eine etwas neutralere Angleichung ist:
; 0,4/0,3/0,3
; danach mit 100 multiplizieren: 
redlight=30 : greenlight=53 : bluelight=11

; total = RGB-lights, unterschiedliche Intensität der Farbanteile, zusammen 100:
total = redlight + greenlight + bluelight

; Testimage laden (muß vorhanden sein) & aktivieren:
LoadImage(1,"..\Gfx\PureBasic.bmp") 
StartDrawing(ImageOutput(1)) 

; Konvertieren Anfang: 
For y=0 To ImageHeight(1) 
  For x= 0 To ImageWidth(1)

   ;Farbwert eines Punktes ermitteln:
   p=Point(x,y)

   ;jeden Farbkanal extra auslesen, mit Lichtanteilen multiplizieren, 
   ;Rot+Grün+Blau addieren und durch 'total' dividieren:
   grau=(Red(p)*redlight+Green(p)*greenlight+Blue(p)*bluelight) / total
   ;Punkt neuschreiben und jeden Kanal extra angeben: 
   Plot(x,y,RGB(grau,grau,grau))

   Next x 
Next y 
; Konvertieren Ende.

; Testimage speichern: 
StopDrawing() 
SaveImage(1,"Test.bmp") 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger