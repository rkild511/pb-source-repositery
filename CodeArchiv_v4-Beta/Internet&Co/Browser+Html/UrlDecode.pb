; http://www.purebasic-lounge.de
; Author: Hroudtwolf
; Date: 30. October 2006
; OS: Windows, Linux
; Demo: Yes

Structure tCHAR
  c.c
EndStructure

Procedure.s UrlDecode (*String.tCHAR)
  Protected tmp.s
  While *String\c<>0
    If *String\c='%'
      *String+1
      Value.l<<4
      If *String\c>60
        Value.l+*String\c-55
      Else
        Value.l+*String\c-48
      EndIf
      *String+1
      Value.l<<4
      If *String\c>60
        Value.l+*String\c-55
      Else
        Value.l+*String\c-48
      EndIf
      tmp.s+Chr(Value.l)
    ElseIf *String\c='+'
      tmp.s+Chr(32)
    Else
      tmp.s+Chr(*String\c)
    EndIf
    *String+1
  Wend
  ProcedureReturn tmp.s
EndProcedure


Debug UrlDecode (@"5%30%30%3E1%30%30+und+1%30%30%3C5%30%30.+Eins%2C+Zwei+%22Drei%22+Test")

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -