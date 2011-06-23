; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3480&highlight=
; Author: manne (updated for PB 4.00 by Andre)
; Date: 18. January 2004
; OS: Windows
; Demo: Yes



; ROT13 - mono-alphabetical encryption

; ROT13 - Monoalphabetische Verschlüsselung
; -----------------------------------------
; Die wohl bekannteste Form einer symmetrischen Verschlüsselung ist die vom
; römischen Herrscher Julius Cäsar erfundene Monoalphabetische Verschlüsselung,
; bei der die Schlüssellänge 1 Bit beträgt. 
; Im vorliegenden Verfahren wird jeder Buchstabe des Alphabets mit 
; einem Buchstaben des um 13 Zeichen verschobenen Alphabets ersetzt. 

Procedure.s Encrypt(STR.s) 
  Define.l i, C 
  Define.s tmp, erg 
  
  For i = 1 To Len(STR) 
    tmp = Mid(STR, i, 1) 
    C = Asc(tmp) + 13 
    If C > 255 
      C = C - 255 
    EndIf 
    erg = erg + Chr(C) 
  Next 
  
  ProcedureReturn erg 
EndProcedure 

Procedure.s Decrypt(STR.s) 
  Define.l i, C 
  Define.s tmp, erg 
  
  For i = 1 To Len(STR) 
    tmp = Mid(STR, i, 1) 
    C = Asc(tmp) - 13 
    If C < 0 
      C = C + 255 
    EndIf 
    erg = erg + Chr(C) 
  Next 
  
  ProcedureReturn erg 
EndProcedure 

teste$ = Encrypt("Der gute alte Julius war schon ein Schlawiner") 
Debug teste$
Debug Decrypt(teste$) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
