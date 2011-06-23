; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8639&highlight=
; Author: Psychophanta
; Date: 06. December 2003
; OS: Windows
; Demo: Yes


; MIDI DeltaTimes Variables Lenghts Conversions 
; MIDI DeltaTimes - Konvertieren von Varaiblenlängen

; Esta es la explicación: 
; 
;Los Delta Times son omnipresentes en los MIDI files. Indican el tiempo entre notas y la longitud de los strings. 
;Es un truquito muy interesante. 

; A delta-time is stored as a series of bytes which is called a variable length quantity. 
; Only the first 7 bits of each byte is significant (right-justified; sort of like an ASCII byte). 
; So, If you have a 32-bit delta-time, you have To unpack it into a series of 7-bit bytes 
; (ie, as If you were going To transmit it over midi in a SYSEX message). 
; Of course, you will have a variable number of bytes depending upon your delta-time. 
; To indicate which is the last byte of the series, you leave bit #7 clear. 
; In all of the preceding bytes, you set bit #7. 
; So, If a delta-time is between 0-127, it can be represented as one byte. 
; The largest delta-time allowed is 0FFFFFFF, which translates To 4 bytes variable length. 
; Here are examples of delta-times as 32-bit values, And the variable length quantities that they translate To: 
; 
; 
;  NUMBER        VARIABLE QUANTITY 
; 00000000              00 
; 00000040              40 
; 0000007F              7F 
; 00000080             81 00 
; 00002000             C0 00 
; 00003FFF             FF 7F 
; 00004000           81 80 00 
; 00100000           C0 80 00 
; 001FFFFF           FF FF 7F 
; 00200000          81 80 80 00 
; 08000000          C0 80 80 00 
; 0FFFFFFF          FF FF FF 7F 
Procedure.L ReadVarLen(PO.l) 
  !mov ebx,dword[esp];<-cargo en ebx el valor en cuestión 
  !mov cl,24 
  !shrd eax,ebx,7;desplazo el valor en 7 bit a la derecha, entrándole por la izquierda a eax desde ebx 
  !shr eax,1;<-desplazo 1 bit a la derecha metiéndo un 0 por su izquierda 
  !shr ebx,7; 
  !jz @f 
  !sub cl,8 
  !shrd eax,ebx,7;desplazo a la derecha otros 7 bit, los cuales entran por la izquierda desde ebx 
  !shr eax,1;<-desplazo 1 bit a la derecha 
  !bts eax,31;<-dejando un 1 en su izquierda 
  !shr ebx,7 
  !jz @f 
  !sub cl,8 
  !shrd eax,ebx,7;desplazo a la derecha otros 7 bit, los cuales entran por la izquierda desde ebx 
  !shr eax,1;<-desplazo 1 bit a la derecha 
  !bts eax,31;<-dejando un 1 en su izquierda 
  !shr ebx,7 
  !jz @f 
  !shrd eax,ebx,7;desplazo a la derecha últimos 7 bit. 
  !shr eax,1;<-desplazo 1 bit a la derecha 
  !bts eax,31;<-dejando un 1 en su izquierda 
  ProcedureReturn 
  !@@:shr eax,cl 
  ProcedureReturn 
EndProcedure 

Procedure WriteVarLen(x) 
  !mov ebx,dword[esp];<-cargo en ebx el valor en cuestión 
  !mov cl,25 
  !shrd eax,ebx,7;desplazo el valor en 7 bit a la derecha, entrándole por la izquierda a eax desde ebx 
  !shr ebx,8 
  !;jc error  ;<-for error detection 
  !jz @f 
  !sub cl,7 
  !shrd eax,ebx,7;desplazo a la derecha otros 7 bit, los cuales entran por la izquierda desde ebx 
  !shr ebx,8 
  !;jnc error  ;<-for error detection 
  !jz @f 
  !sub cl,7 
  !shrd eax,ebx,7;desplazo a la derecha otros 7 bit, los cuales entran por la izquierda desde ebx 
  !shr ebx,8 
  !;jnc error  ;<-for error detection 
  !jz @f 
  !sub cl,7 
  !shrd eax,ebx,7;desplazo a la derecha otros 7 bit, los cuales entran por la izquierda desde ebx 
  !;shr ebx,8   ;<-needed for error detection 
  !;jnc error  ;<-for error detection 
  !@@:shr eax,cl 
  ProcedureReturn 
EndProcedure 

;TEST 
A.L=$FABADA 
B.L = ReadVarLen(A) 
Debug "Original Hex="+Hex(A) 
Debug "Transformado en Variable Length= "+Hex(B) 
Debug " Y reconvertido a Hex :" +Hex(WriteVarLen(B))

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
