; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8972&start=15
; Author: Wayne Diamond
; Date: 02. January 2004
; OS: Windows
; Demo: Yes

; Hex function with length parameter...
Procedure.s HexEx(inValue.l, inLength.l)
  outHex.s = Hex(inValue): minLen.l = Len(outHex): outHex = Space(inLength) + outHex
  outHex = ReplaceString(outHex, " ", "0", 1, 1): If minLen < inLength: minLen = inLength: EndIf
  outHex = Right(outHex, minLen): ProcedureReturn outHex
EndProcedure

MessageRequester("HexEx Test", HexEx(1212, 8), 0)  ;// returns 000004BC
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
