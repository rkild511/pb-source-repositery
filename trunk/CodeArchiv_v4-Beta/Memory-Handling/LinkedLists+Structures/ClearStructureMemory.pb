; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1674&highlight=
; Author: Danilo
; Date: 11. July 2003
; OS: Windows
; Demo: No

; Anmerkung:
; Funktioniert natürlich nicht mit Strings, die in der zu löschenden Struktur
; enthalten sind. Dann wird nämlich der Pointer zum String auf Null gesetzt und: Fehler!

Procedure ClearMem(mem,length) 
  RtlZeroMemory_(mem,length) 
EndProcedure 

a.POINT 
a\x = 54321 
a\y = 12345 

Debug a\x 
Debug a\y 

ClearMem( a,SizeOf(POINT) ) 

Debug a\x 
Debug a\y 


Debug ";----------" 


Dim b.l(10) 

For i = 0 To 10 
  b(i) = Random($FFFFFF) 
  Debug b(i) 
Next i 

Debug "--" 

ClearMem( b(), 11*4 ) 

For i = 0 To 10 
  Debug b(i) 
Next i
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
