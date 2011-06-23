; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8957&highlight=
; Author: Wayne Diamond
; Date: 01. January 2004
; OS: Windows
; Demo: Yes


; FNV32 - A very simple algorithm designed For high-speed hashing
; resulting in highly dispersed hashes with minimal collisions.
; Named after its creators Glenn Fowler, Phong Vo, And Landon Curt Noll.

Procedure.l FNV32(Buffer.l, BufLen.l, offset_basis.l)
  MOV esi, Buffer      ;esi = ptr to buffer
  MOV ecx, BufLen         ;ecx = length of buffer (counter)
  MOV eax, offset_basis  ;set to 0 for FNV-0, or 2166136261 for FNV-1
  MOV edi, 0x01000193    ;FNV_32_PRIME = 16777619
  XOR ebx, ebx           ;ebx = 0
  nextbyte:
  MUL edi                ;eax = eax * FNV_32_PRIME
  MOV bl, [esi]          ;bl = byte from esi
  XOR eax, ebx           ;al = al xor bl
  INC esi                ;esi = esi + 1 (buffer pos)
  DEC ecx                ;ecx = ecx - 1 (counter)
  JNZ l_nextbyte         ;if ecx is 0, jmp to NextByte
  ProcedureReturn
EndProcedure

;// MAIN
Checksum.l = 0
Buffer.s = "Wayne Diamond"
Checksum = FNV32(@Buffer, Len(Buffer), 0)
MessageRequester("FNV32", "Should be 8AFD6DE2: " + Right("00000000" + Hex(Checksum),8), 0)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
