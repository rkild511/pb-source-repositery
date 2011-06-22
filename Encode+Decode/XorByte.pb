; English forum: http://purebasic.myforums.net/viewtopic.php?p=43409#43409
; Author: Wayne Diamond
; Date: 01. January 2004


; Here is the more-traditional version of 'XorWithKey' where each byte is XOR'd with the same value.

; EnableAsm
Procedure XOrByte(sText.l, TextLen.l, Key.b)
  MOV ecx, TextLen
  MOV esi, sText
  MOV edi, sText
  CLD
  Cipher:
  !lodsb
  XOR al, Key
  !stosb
  LOOP l_cipher
  ;MOV straddr, edx
EndProcedure

sText.s = "Text to encrypt"
bKey.b = 04
;// Encrypt
XorByte(@sText, Len(sText), bKey)
Debug sText
;// And again, which decrypts it
XorByte(@sText, Len(sText), bKey)
Debug sText
; ExecutableFormat=Windows
; FirstLine=1
; EnableAsm
; EOF