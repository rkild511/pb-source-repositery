; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2309&highlight=
; Author: Froggerprogger (updated for PB3.93 by ts-soft)
; Date: 16. September 2003
; OS: Windows
; Demo: No


; Zusammenfassung:
; Die folgenden Prozeduren tun das, was ihr Name sagt. 
; Dabei können die Bits bzw. Bitfelder (aus 1-32 Bits) direkt in einem Speicherbereich
; von 2GB Bytes angesprungen werden. Schön ist dabei die Möglichkeit, entweder die
; reine Bitposition (<2147483647) oder diese als Kombination von Byte- und Bitoffset
; anzugeben, wodurch sich auch die Bits >2147483647 erreichen lassen. 


;- Froggerprogger 16.09.03 
;- 
;- Dieses Programm stellt die Funktionen PokeBit(), PeekBit(), PokeBits() und PeekBits() 
;- zur Verfügung. 
;- Da PB nur vorzeichenbehaftete Variablen unterstützt, wird hier auch stets jedes 
;- Bitfeld als vorzeichenbehaftet behandelt. 
;- 
;- Anmerkungen: 
;- 1. Byteoffset + (Bitoffset/8) darf nicht größer als 2147483647 sein 
;-    (da die Summe vom Typ signed Long ist) 
;- 
;- 2. Die Bitposition setzt sich zusammen aus Byteoffset (0-2147483647) und Bitoffset (0-2147483647) 
;-    Wird der Byteoffset auf 0 gelassen, so ist die höchste direkt adressierbare 
;-    Bitposition 2147483647 (da Bitoffset vom Typ signed Long ist), 
;-    und bewegt sich somit im Bereich von 0 bis 2147483647 / 8 = 268435456 Bytes - 1 Bit 
;-    Es gilt (Byteoffset ; Bitoffset) = (Byteoffset + 1*n ; Bitoffset - 8*n) 
;-    Z.B. einige Umformungen: 
;-      (0 ; 32769) = (1 ; 32761) = (4096 ; 1) = (4097 ; -7) = ... 
;-      (0 ; 2147483640) = (268435455 ; 0) = ... 
;-      (0 ; 2147483647) = (268435455 ; 7) = ...  + 1 Bit => (268435456 ; 0) = (1 ; 2147483640) 
;- 


;- PokeBit-parameter: 
;   *memory - pointer to preallocated memory 
;   Byteoffset - Byteoffset (0 - 2147483647) 
;   Bitoffset - Bitoffset (0 - 2147483647) 
;   value - the value to set (0 or 1) 
Procedure PokeBit(*memory, Byteoffset.l, Bitoffset.l, value.l) 
  Protected PositionMod.l     : PositionMod = Bitoffset - Bitoffset / 8 * 8 ; Modulo - don't use 64 instead of 8*8 
  Protected ByteAlignedPosition.l : ByteAlignedPosition = (Bitoffset - PositionMod)>>3 + Byteoffset 

  If value = 0 
    PokeB(*memory + ByteAlignedPosition, PeekB(*memory + ByteAlignedPosition) & ~(1 << PositionMod)) 
  Else 
    PokeB(*memory + ByteAlignedPosition, PeekB(*memory + ByteAlignedPosition) | (1 << PositionMod)) 
  EndIf 

EndProcedure 

;- PeekBit-parameter: 
;   *memory - pointer to preallocated memory 
;   Byteoffset - Byteoffset (0 - 2147483647) 
;   Bitoffset - Bitoffset (0 - 2147483647) 
;   Procedurereturn - LONG-value of the specified Bit (0 or 1) 
Procedure.l PeekBit(*memory.l, Byteoffset.l, Bitoffset.l) 
  Protected result.l          : result = 0 
  Protected PositionMod.l     : PositionMod = Bitoffset - Bitoffset / 8 * 8 ; Modulo - don't use 64 instead of 8*8 
  Protected ByteAlignedPosition.l : ByteAlignedPosition = (Bitoffset - PositionMod)>>3 + Byteoffset 

  If PeekB(*memory + ByteAlignedPosition) >> PositionMod & 1 
    result = 1 
  EndIf 

  ProcedureReturn result 
EndProcedure 

;- PokeBits-parameter 
;   *memory - pointer to preallocated memory 
;   Byteoffset - Byteoffset (0 - 2147483647) 
;   Bitoffset - Bitoffset (0 - 2147483647) 
;   Length - number of Bits to write (1 to 32) 
;   value - value to write (-1*Pow(2,Length) < value < Pow(2, Length)-1) for correct results) 
Procedure PokeBits(*memory, Byteoffset.l, Bitoffset.l, Length.l, value.l) 
  Protected i.l 
  
  If Bitoffset > 2147483615 : Byteoffset + 4 : Bitoffset - 32 : EndIf ; avoid Bitoffset-Overrun 

  For i=0 To Length - 1 
    PokeBit(*memory, Byteoffset, Bitoffset + i, 1 & value >> (Length - 1 - i)) 
  Next 
  
EndProcedure 

;- PeekBits-parameter 
;   *memory - pointer to preallocated memory 
;   Byteoffset - Byteoffset (0 - 2147483647) 
;   Bitoffset - Bitoffset (0 - 2147483647) 
;   Length - number of Bits to write (1 to 32) 
;   Procedurereturn - LONG-value of the specified Bitfield 
  ;- annotation 
  ; PeekBits() for a one-bit-value returns 0 or 1, though 0 or -1 would be 
  ; mathematically correct for a signed one-bit-value - but not as practical. 
  ; [See the term If Length > 1 for this] 
Procedure.l PeekBits(*memory, Byteoffset.l, Bitoffset.l, Length.l) 
  Protected i.l 
  Protected result.l 
  
  If Bitoffset > 2147483615 : Byteoffset + 4 : Bitoffset - 32 : EndIf ; avoid Bitoffset-Overrun 
  
  For i=0 To Length - 1 
    result + PeekBit(*memory, Byteoffset, Bitoffset + (Length - 1 - i)) << i 
  Next 
  
  If Length > 1 And result>>(Length-1) ; "if Length > 1 and it is a negative result in a 'Length'Bit-Bitfield" 
    result | $FFFFFFFF<<(Length-1)  ; "fill all the Bits > Length with 1, so it is a negative result in the 32Bit-Bitfield, too." 
  EndIf 
  
  ProcedureReturn result 
EndProcedure 

;- 
;-                            Geschwindigkeits-Testprogramm 
;- 

#step = 16384 
#max = 2147483646 - #step 
#min = -2147483648 + #step 
Debug "Jede Aktion wird " + Str((#max/#step-#min/#step)) + " Mal ausgeführt..." 
Debug "_________________________________________________________________________" 

For bits = 7 To 31 Step 8 
    *mem = AllocateMemory(bits*16777217*2/8 + 1) 

    start = GetTickCount_() 
    p=0 
    For i=#min To #max Step #step 
      PokeBits(*mem, 0, p, bits, i) 
      p+bits 
    Next 
    Debug Str(GetTickCount_()-start) + " ms für PokeBits mit " + Str(bits+1) + " Bit." 
      
    start = GetTickCount_() 
    p=0 
    For i=#min To #max Step #step 
      PeekBits(*mem, 0, p, bits) 
      p+bits 
    Next 
    Debug Str(GetTickCount_()-start) + " ms für PeekBits mit " + Str(bits+1) + " Bit." 
    
    Debug "_________________________________________________________________________" 
Next 
  
Debug "program end"
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
