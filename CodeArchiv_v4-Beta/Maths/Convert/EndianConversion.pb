; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14524&highlight=
; Author: Rescator (updated for PB 4.00 by Andre)
; Date: 24. March 2005
; OS: Windows
; Demo: Yes


; Simple Big Endian / Little Endian byte order swap function. 
; Einfache Funktionen zum Vertauschen der BigEndian/LittleEndian Byte-Reihenfolge .


; Ever needed to swap the byte order when working with LittleEndian 
; and BigEndian values? 
; Now you can just do things like color=Endian(color) 
; if you need to convert to/from RGB,BGR or RGBA and ABGR etc. 
; Or when dealing with network order/Motorola (big endian) values.


; Little/Big Endian byte swapping with 32bit values
Procedure.l Endian(dummy.l) 
  !BSWAP Eax 
  ProcedureReturn 
EndProcedure 

a = 15
Debug a

a = Endian(a)
Debug a


; Little/Big Endian byte swapping with 64bit values
Procedure.l Endian64(*dummy) 
  !MOV Ebx,[Eax] 
  !MOV Edx,[Eax+4] 
  !BSWAP Ebx 
  !BSWAP Edx 
  !MOV [Eax+4],Ebx 
  !MOV [Eax],Edx 
  ProcedureReturn 
EndProcedure


b.LARGE_INTEGER 
b\HighPart=$BB0220 
b\LowPart=$AA0110 

Debug Hex(b\HighPart) 
Debug Hex(b\LowPart) 

Endian64(b) 

Debug Hex(b\HighPart) 
Debug Hex(b\LowPart) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -