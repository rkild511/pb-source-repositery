; English forum: http://purebasic.myforums.net/viewtopic.php?t=8957&highlight=
; Author: Wayne Diamond
; Date: 01. January 2004


; ELF32 - Outputs a 32-bit unsigned hash that is the modulo generated
; by dividing the returned integer by the size of the table.
; Used in UNIX object files that use the ELF format.

Procedure.l ELF32(Buffer.l, BufLen.l)
  H.l = 0
  XOR ebx, ebx      ; ebx = result holder (H)
  MOV edx, BufLen   ; edx = Length
  MOV ecx, Buffer   ; ecx = Ptr to string
  XOR esi, esi      ; esi = temp holder
  Elf1:
  XOR eax, eax
  SHL ebx, 4
  MOV al, [ecx]
  ADD ebx, eax
  INC ecx
  MOV eax, ebx
  AND eax, 0xF0000000
  CMP eax, 0
  JE l_elf2
  MOV esi, eax
  SHR esi, 24
  XOR ebx, esi
  Elf2:
  NOT eax
  AND ebx,eax
  DEC edx
  CMP edx, 0
  JNE l_elf1
  MOV H, ebx
  ProcedureReturn H
EndProcedure

;// MAIN
Checksum.l = 0
Buffer.s = "Wayne Diamond"
Checksum = ELF32(@Buffer, Len(Buffer))
MessageRequester("ELF32", "Should be 07688354: " + Right("00000000" + Hex(Checksum),8), 0)
; ExecutableFormat=Windows
; FirstLine=1
; EnableAsm
; EOF