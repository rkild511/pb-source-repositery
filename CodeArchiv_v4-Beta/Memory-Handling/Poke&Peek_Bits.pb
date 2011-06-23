; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7750
; Author: Froggerprogger
; Date: 03. October 2003
; OS: Windows
; Demo: Yes


; Here are 2 procedures to Peek/Poke single bits inside large memoryblocks. 
; Further there are 2 procedures to Peek/Poke the value of 1-31 Bits inside large memoryblocks. 
; This is useful for example to store a lot of LONG-values which do not exactly use all 32 Bits
; with only the needed bits per value. 


;-Code: 
;- Froggerprogger 16.09.03 
;- 
;- This program gives you the Procedures PokeBit(), PeekBit(), PokeBits() and PeekBits() 
;- Because of PB using signed variables, all bitfields are interpretated as signed values, too 
;- 
;- Announcements: 
;- 1. Byteoffset + (Bitoffset/8) < 2147483647 
;-    (because sum is of type signed Long) 
;- 
;- 2. The resulting Bitposition is the sum of the Byteoffset (0-2147483647) and Bitoffset (0-2147483647) 
;-    Is the Byteoffset 0, the maximum direct adressable Bitposition is 2147483647 (Bitoffset of type signed Long), 
;-    and so these Bits lay in range of 0 to 2147483647 / 8 = 268435456 Bytes - 1 Bit 
;- 
;-    Examples: 
;-    (Byteoffset ; Bitoffset) = (Byteoffset + 1*n ; Bitoffset - 8*n) 
;- 
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



;- an example 
*mem = AllocateMemory(4096) 
bits = 7 
p=0 
For i=2 To 62 Step 2 
  PokeBits(*mem, 3, p, bits, i) 
  p+bits 
Next 

p=0 
For i=2 To 62 Step 2 
  Debug PeekBits(*mem, 3, p, bits) 
  p+bits 
Next  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
