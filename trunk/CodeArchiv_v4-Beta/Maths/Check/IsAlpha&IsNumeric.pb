; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9261
; Author: Danilo
; Date: 22. January 2004
; OS: Windows, Linux
; Demo: Yes

; Note: these procedures are the platform-independent versions, there are also
;       Windows only versions in ASM - take a look at IsAlpha&IsNumeric_WinOnly.pb !


; And PB-Style (for platform-independent use):   (by Danilo)
Procedure.l IsAlpha(String$) 
  ; check if only a-z and A-Z is used in the string 
  ; returns 1 (true)  for alphastrings, 
  ; returns 0 (false) if other chars found 
  If String$ 
    *p.BYTE = @String$ 
    Repeat 
      char = *p\b & $FF 
      If (char >= 'a' And char <= 'z') Or (char >= 'A' And char <= 'Z') Or char=0 
        *p+1 
      Else 
        ProcedureReturn 0 
      EndIf 
    Until char = 0 
    ProcedureReturn 1 
  EndIf 
EndProcedure 

Procedure.l IsNumeric(String$) 
  ; check if only numbers 0-9 are used in the string 
  ; returns 1 (true)  for number-string, 
  ; returns 0 (false) if other chars are found 
  If String$ 
    *p.BYTE = @String$ 
    Repeat 
      char = *p\b & $FF 
      If (char >= '0' And char <= '9') Or char=0 
        *p+1 
      Else 
        ProcedureReturn 0 
      EndIf 
    Until char = 0 
    ProcedureReturn 1 
  EndIf 
EndProcedure 

Debug IsAlpha("")
Debug IsAlpha("aBcDeF")
Debug IsAlpha("abc1")
Debug "---"
Debug IsNumeric("")
Debug IsNumeric("0123456789")
Debug IsNumeric("1234a")
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -