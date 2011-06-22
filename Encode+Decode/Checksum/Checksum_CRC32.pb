; English forum: http://purebasic.myforums.net/viewtopic.php?t=8957&highlight=
; Author: Wayne Diamond
; Date: 01. January 2004


; CRC32 - A relatively fast algorithm that creates a 32-bit checksum.
; CRC32 is the most commonly-used 32-bit checksum algorithm.

Procedure.l CRC32(Buffer.l, BufLen.l)
  Result.l = 0
  MOV esi, Buffer    ;esi = ptr to buffer
  MOV edi, BufLen    ;edi = length of buffer
  MOV ecx, -1        ;ecx = -1
  MOV edx, ecx       ;edx = -1
  nextbyte:            ;next byte from buffer
  XOR eax, eax       ;eax = 0
  XOR ebx, ebx       ;ebx = 0
  DB 0xAC            ;"lodsb" instruction to get next byte
  XOR al, cl         ;xor al with cl
  MOV cl, ch         ;cl = ch
  MOV ch, dl         ;ch = dl
  MOV dl, dh         ;dl = dh
  MOV dh, 8          ;dh = 8
  nextbit:             ;next bit in the byte
  SHR bx, 1          ;shift bits in bx right by 1
  RCR ax, 1          ;(rotate through carry) bits in ax by 1
  JNC l_nocarry      ;jump to nocarry if carry flag not set
  XOR ax, 0x08320    ;xor ax with 33568
  XOR bx, 0x0EDB8    ;xor bx with 60856
  nocarry:             ;if carry flag wasn't set
  DEC dh             ;dh = dh - 1
  JNZ l_nextbit      ;if dh isnt zero, jump to nextbit
  XOR ecx, eax       ;xor ecx with eax
  XOR edx, ebx       ;xor edx with ebx
  DEC edi            ;finished with that byte, decrement counter
  JNZ l_nextbyte     ;if edi counter isnt at 0, jump to nextbyte
  NOT edx            ;invert edx bits - 1s complement
  NOT ecx            ;invert ecx bits - 1s complement
  MOV eax, edx       ;mov edx into eax
  ROL eax, 16        ;rotate bits in eax left by 16 places
  MOV ax, cx         ;mov cx into ax
  MOV Result, eax    ;crc32 result is in eax
  ProcedureReturn Result
EndProcedure

;// MAIN
Checksum.l = 0
Buffer.s = "Wayne Diamond"
Checksum = CRC32(@Buffer, Len(Buffer))
MessageRequester("CRC32", "Should be 6D32B86A: " + Right("00000000" + Hex(Checksum),8), 0)
; ExecutableFormat=Windows
; FirstLine=1
; EnableAsm
; EOF