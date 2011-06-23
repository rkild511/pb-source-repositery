; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8989&highlight=
; Author: Wayne Diamond
; Date: 03. January 2004
; OS: Windows
; Demo: Yes

Procedure.s UUDecode(sInBuf.s)
  sOutBuf.s = ""
  For lLoop.l = 1 To Len(sInBuf) Step 4
    sOutBuf = sOutBuf + Chr((Asc(Mid(sInBuf, lLoop, 1)) - 32) * 4 + (Asc(Mid(sInBuf, lLoop + 1, 1)) - 32) / 16)
    sOutBuf = sOutBuf + Chr((Asc(Mid(sInBuf, lLoop + 1, 1)) % 16) * 16 + (Asc(Mid(sInBuf, lLoop + 2, 1)) - 32) / 4)
    sOutBuf = sOutBuf + Chr((Asc(Mid(sInBuf, lLoop + 2, 1)) % 4) * 64 + Asc(Mid(sInBuf, lLoop + 3, 1)) - 32)
  Next lLoop
  ProcedureReturn sOutBuf
EndProcedure

Procedure.s UUEncode(sInBuf.s)
  sOutBuf.s = ""
  For lLoop.l = 1 To Len(sInBuf) Step 3
    sOutBuf = sOutBuf + Chr(Asc(Mid(sInBuf, lLoop, 1)) / 4 + 32)
    sOutBuf = sOutBuf + Chr((Asc(Mid(sInBuf, lLoop, 1)) % 4) * 16 + Asc(Mid(sInBuf, lLoop + 1, 1)) / 16 + 32)
    sOutBuf = sOutBuf + Chr((Asc(Mid(sInBuf, lLoop + 1, 1)) % 16) * 4 + Asc(Mid(sInBuf, lLoop + 2, 1)) / 64 + 32)
    sOutBuf = sOutBuf + Chr(Asc(Mid(sInBuf, lLoop + 2, 1)) % 64 + 32)
  Next lLoop
  ProcedureReturn sOutBuf
EndProcedure

sText.s = uuEncode("1234567890abcdefghijklmnopqrstuvwxyz")
Debug "Encoded=" + sText
sText = uuDecode(sText)
Debug "Decoded=" + sText
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
