; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10826
; Author: #NULL
; Date: 18. November 2006
; OS: Windows
; Demo: Yes


; Format a number with seperators for each 3 digits
; Formatiert eine Zahl mit Tausender-Trennzeichen

Procedure.s FormatByteSize(n.q)
  Protected s.s=StrQ(n)
  Protected len=Len(s)
  Protected ret.s
 
  For i=0 To len-1
    If i And Not i%3 :: ret="."+ret :: EndIf
    ret= Mid(s,len-i,1) +ret
  Next
 
  ProcedureReturn ret
EndProcedure

Debug FormatByteSize(1)
Debug FormatByteSize(12)
Debug FormatByteSize(123)
Debug FormatByteSize(1234)
Debug FormatByteSize(12345)
Debug FormatByteSize(123456)
Debug FormatByteSize(1234567)
Debug FormatByteSize(12345678)
Debug FormatByteSize(123456789)
Debug FormatByteSize(1234567890)
Debug FormatByteSize(4294967295)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP