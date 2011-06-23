; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2701&highlight=
; Author: dige
; Date: 30. October 2003
; OS: Windows
; Demo: Yes

; Wer mal ein paar 'was w�re wenn?' Finanzierungsbetrachtungen 
; machen m�chte, nachfolgend die wichtigsten Formeln f�r oben 
; genannte Kreditform. (Annuit�tkredit: gleichbleibende Tilgungsrate 
; �ber einen Zinsfestschreibungsraum. ) 


; R= Restschuld 
; K= Darlehen 
; A= j�hrliche Annuit�t 
; p= Zinssatz nominal 
; l= Laufzeit 

; notwenige Tilgungsrate f�r einen Kredit in H�he R �ber l Jahre: 
; A = K * Pow((1 + p/100), l)/( (Pow( (1 + p/100), l ) - 1 ) / ( (1 + p/100) - 1)) 

; maximal m�gliche Kredith�he bei einer bestimmten Tilgungsrate: 
; K = A * ( (Pow( (1 + p/100), l ) - 1 ) / ( (1 + p/100) - 1)) / Pow((1 + p/100), l) 

; Bsp. f�r Restschuld nach l Jahren: 
;  Kredit = 150.000,- 
;  Zinssatz (z)= 5% 
;  Tilgung (t)= 2% 
;  ergibt eine Annuit�t von monatlich 875,- 
;  ergibt eine Annuit�t von j�hrlich (A) = 10500,- 
;  Restschuld nach l = 10 Jahren berechnen: 

K.f = 150000 
p.f = 5 
A.f = 10500 
l.l = 10 

R.f = K * Pow( (1 + p/100), l ) - A * ( Pow( ( 1 + p/100), l ) - 1) / ( p/100 ) 
Debug R 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
