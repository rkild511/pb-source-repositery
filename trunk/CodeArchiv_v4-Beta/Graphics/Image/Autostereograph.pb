; German forum: http://www.purebasic.fr/german/viewtopic.php?t=219&highlight=
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 21. September 2004
; OS: Windows
; Demo: Yes


; Autostereogramm

; Muster.bmp     : Enthält ein (kachelbares,) farbiges Bild mit der gleichen Höhe 
;                  des Tiefenbildes und einer Breite < Augenabstand 
; Tiefenbild.bmp : 24-BitBitmap mit Graustufen. Irgendwelche Grösse. 
;                  Schwarz=Hinten Weiss=Vorne 
;                  Info: Bei dem Tiefenbild kann man in der Breite des Musters 
;                  die ersten Pixel nicht gebrauchen.
; Quelle: Spektrum der Wissenschaft: Digest 2/2002 

; Es wäre möglich, den Speed noch mit WinApi zu vervielfachen, ist so aber 
; leichter zu verstehen. 


Structure Bild 
  id.l 
  Breite.l 
  Hoehe.l 
  Wert.f 
EndStructure 


BMuster.Bild\id   = LoadImage(#PB_Any,"Muster.bmp") 
BMuster\Breite   = ImageWidth(BMuster.Bild\id) 
BMuster\Hoehe  = ImageHeight(BMuster.Bild\id) 

BTiefen.Bild\id   = LoadImage(#PB_Any,"Tiefenbild.bmp") 
BTiefen\Breite   = ImageWidth(BTiefen.Bild\id) 
BTiefen\Hoehe   = ImageHeight(BTiefen.Bild\id) 

B3D.Bild\id        = CreateImage(#PB_Any,BTiefen\Breite,BTiefen\Hoehe) 
B3D\Breite        = BTiefen\Breite 
B3D\Hoehe       = BTiefen\Hoehe 

If IsImage(BMuster\id) = 0 Or IsImage(BTiefen\id) = 0 Or IsImage(B3D\id) = 0 
  Debug "Fehler" 
  End 
EndIf 


StartDrawing(ImageOutput(B3D\id)) 
  DrawImage(ImageID(BMuster\id), 0, 0) 
StopDrawing() 

For x = BMuster\Breite To BTiefen\Breite 
  For y = 0 To BTiefen\Hoehe 
    StartDrawing(ImageOutput(BTiefen\id)) 
      BTiefen\Wert = Red(Point(x,y)) 
    StopDrawing() 
    BTiefen\Wert = 1 - (BTiefen\Wert * 0.25 / 255) 
    
    StartDrawing(ImageOutput(B3D\id)) 
      Plot(x,y,Point(x - (BMuster\Breite * BTiefen\Wert),y)) 
    StopDrawing() 
    
  Next 
Next 

SaveImage(B3D\id,"3D-Bild.bmp") 

MessageRequester("Fertig","Fertig") 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -