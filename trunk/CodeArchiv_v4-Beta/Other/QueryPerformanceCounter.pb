; German forum: http://www.purebasic.fr/german/viewtopic.php?t=904&highlight=
; Author: CSprengel
; Date: 16. November 2004
; OS: Windows
; Demo: No


; Messen genauer Zeitabstände

T1.Large_integer 
FREQ.Large_integer 
M1=AllocateMemory(8);speicher reservieren, sonst gehts nich 
Result=QueryPerformanceFrequency_(M1) ;bestimmen der frequenz 
If Result=0 
  Debug  GetErrorDLL()  ;Kein Hardwaretimer ? 
  End 
Else 
  CopyMemory(M1,@FREQ,8) ;Variable kopieren 
EndIf 
Debug FREQ\lowpart ;Counts pro Sekunde 
Debug FREQ\highpart 
Result=QueryPerformanceCounter_(M1) 
If Result 
  CopyMemory(M1,@T1,8) 
  Debug T1\lowpart 
  Debug T1\highpart 
  OldT1L=T1\lowpart ;Alten Low-wert sichern! 
EndIf 

Delay(200) ;Mal 200 ms warten 

Result=QueryPerformanceCounter_(M1) 
If Result 
  CopyMemory(M1,@T1,8) 
  Zeit.f=T1\lowpart-OldT1L 
  Debug Zeit 
  Zeit.f=Zeit.f /   (FREQ\lowpart) 
  Debug "200 Milliskeunden benötigen genau: "+ StrF(Zeit)+"Sekunden" 
EndIf 
If M1 
  FreeMemory(M1) 
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -