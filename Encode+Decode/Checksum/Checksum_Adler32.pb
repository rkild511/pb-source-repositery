; English forum: http://purebasic.myforums.net/viewtopic.php?t=8957&highlight=
; Author: Wayne Diamond
; Date: 01. January 2004


; Adler32 - an algorithm used by ZIP files that creates a 32-bit checksum.
; The algorithm is approximately 33% faster than CRC32, And nearly as reliable.
; Adler32 is a 32-bit extension And improvement of the Fletcher algorithm,
; used in the ITU-T x.224 / ISO 8073 standard.

Procedure.l Adler32(Buffer.l, BufLen.l, Seed.l)
  Result.l = 0
  MOV edx, Seed
  MOVZX ecx, dx
  SHR edx, 16
  MOV esi, Buffer
  MOV eax, BufLen
  ADD eax, esi
  XOR ebx, ebx
  LP:
  MOV bl, [esi]
  ADD ecx, ebx
  CMP ecx, 65521
  JB l_m1
  SUB ecx, 65521
  M1:
  ADD edx, ecx
  CMP edx, 65521
  JB l_m2
  SUB edx, 65521
  M2:
  INC esi
  CMP esi, eax
  JNZ l_lp
  SHL edx, 16
  ADD ecx, edx
  MOV Result, ecx
  ProcedureReturn Result
EndProcedure

;// MAIN
Checksum.l = 0
Buffer.s = "Wayne Diamond"
Checksum = Adler32(@Buffer, Len(Buffer), 1)
MessageRequester("Adler32", "Should be 218804E1: " + Right("00000000" + Hex(Checksum),8), 0)
; ExecutableFormat=Windows
; FirstLine=1
; EnableAsm
; EOF