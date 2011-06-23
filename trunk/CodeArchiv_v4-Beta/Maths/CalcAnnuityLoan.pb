; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2701&highlight=
; Author: dige
; Date: 30. October 2003
; OS: Windows
; Demo: Yes

; Wer mal ein paar 'was wäre wenn?' Finanzierungsbetrachtungen 
; machen möchte, nachfolgend die wichtigsten Formeln für oben 
; genannte Kreditform. (Annuitätkredit: gleichbleibende Tilgungsrate 
; über einen Zinsfestschreibungsraum. ) 


; R= Restschuld 
; K= Darlehen 
; A= jährliche Annuität 
; p= Zinssatz nominal 
; l= Laufzeit 

; notwenige Tilgungsrate für einen Kredit in Höhe R über l Jahre: 
; A = K * Pow((1 + p/100), l)/( (Pow( (1 + p/100), l ) - 1 ) / ( (1 + p/100) - 1)) 

; maximal mögliche Kredithöhe bei einer bestimmten Tilgungsrate: 
; K = A * ( (Pow( (1 + p/100), l ) - 1 ) / ( (1 + p/100) - 1)) / Pow((1 + p/100), l) 

; Bsp. für Restschuld nach l Jahren: 
;  Kredit = 150.000,- 
;  Zinssatz (z)= 5% 
;  Tilgung (t)= 2% 
;  ergibt eine Annuität von monatlich 875,- 
;  ergibt eine Annuität von jährlich (A) = 10500,- 
;  Restschuld nach l = 10 Jahren berechnen: 

K.f = 150000 
p.f = 5 
A.f = 10500 
l.l = 10 

R.f = K * Pow( (1 + p/100), l ) - A * ( Pow( ( 1 + p/100), l ) - 1) / ( p/100 ) 
Debug R 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
