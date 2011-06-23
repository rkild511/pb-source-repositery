; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3127&start=10
; Author: Froggerprogger
; Date: 15. December 2003
; OS: Windows
; Demo: Yes

; Extremely fast possibility to test Bits, using a macro.
; The relating Long and the bit position of the new bit to test must be given...

; Hier mal eine extrem schnelle Möglichkeit, Bits zu testen. 
; Allerdings muss dazu der entsprechende Longwert und die Bitposition des zu
; testenden Bits übergeben werden. 
; Die Zeit für 50000000 Aufrufe von !getBit beträgt bei mir 261 ms, von
; !setBit 617 ms im Vergleich zu einer leeren (!) Prozedur 826 ms. 
; Prozeduren bremsen besonders zeitkritische, kurze Passagen. Makros werden
; stattdessen beim Kompilieren an Ort und Stelle durch ihren Code ersetzt,
; was sie so schnell macht, aber bei oft aufgerufenen umfangreichen Makros
; das Programm vergrößert. 


;- 14.12.2003 by Froggerprogger 
;- 
;- Hinweise im Umgang mit diesen Makros: 
;- 1. Programmvariablen, die an die Makros übergeben werden, müssen wie angegeben 
;-    mit [v_...] notiert werden, also: meineVariable -> [v_meineVariable] 
;- 2. Programmvariablen, die an die Makros übergeben werden, müssen zuvor 
;-    deklariert worden sein. 

;- !macro getBit value, pos, result 
;- 
;- Makro zum Auslesen eines Bits im 32-Bit-Wert 'value' an Stelle 'posID' (0-31) 
;- Aufruf im späteren Programm mit : 
;-    !getBit [v_myVariable], [v_myPositionID], [v_myResult] 
;- statt [v_...] können für 'value' und 'posID' auch Konstanten verwendet werden 
;- (wird ohne '[' oder ']' notiert) 
;- Der Wert der an 'value' übergebenen Variable wird nicht verändert. 
;- Das Ergebnis (0 oder 1) wird in der an 'result' übergebenen Variable gespeichert 

!macro getBit value, posID, result 
!{ 
!MOV eax, dword value 
!MOV edx, dword posID 
!BT eax, edx 
!SETC byte result 
!} 

;- !macro setBit value, pos, bitSwitch 
;- 
;- Makro zum Ändern eines Bits im 32-Bit-Wert 'value' an Stelle 'posID' (0-31) 
;- Aufruf im späteren Programm mit : 
;-    !getBit [v_myVariable], [v_myPositionID], [v_myBitSwitch] 
;- statt [v_...] können anstelle aller Variablen auch Konstanten verwendet werden 
;- (wird ohne '[' oder ']' notiert) 
;- Ist bitSwitch = 0 wird das Bit auf 0, sonst auf 1 gesetzt. 
;- Das Ergebnis wird in der an 'value' übergebenen Variable gespeichert 

!macro setBit value, posID, bitSwitch 
!{ 
!MOV eax, dword posID 
!MOV edx, dword bitSwitch 
!If edx eq 0 
!BTS value, eax 
!Else 
!BTR value, eax 
!End If 
!} 

;-Beispiele: 

Global dummy1.l, dummy2.l, result.l 
  
dummy1 = %1011010111 
!getBit [v_dummy1], 1, [v_result] 
Debug result 
  
dummy2 = 1 
!getBit 13467, [v_dummy2], [v_result] 
Debug result 
  
Dim arr(100) 
arr(22) = %101101011 
dummy1 = arr(22) 
dummy2 = 3 
!getBit [v_dummy1], [v_dummy2], [v_result] 
Debug result 

dummy1.l = %101010 
dummy2=3 
!setBit [v_dummy1], [v_dummy2], 0 
Debug Bin(dummy1) 

dummy1 = %11111111111 
dummy2 = 0 
!setBit [v_dummy1], 3, [v_dummy2] 
Debug Bin(dummy1) 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
