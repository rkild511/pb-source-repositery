; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=3480&highlight=
; Author: manne
; Date: 18. January 2004


; ROT13 - mono-alphabetical encryption

; ROT13 - Monoalphabetische Verschlüsselung
; -----------------------------------------
; Die wohl bekannteste Form einer symmetrischen Verschlüsselung ist die vom
; römischen Herrscher Julius Cäsar erfundene Monoalphabetische Verschlüsselung,
; bei der die Schlüssellänge 1 Bit beträgt. 
; Im vorliegenden Verfahren wird jeder Buchstabe des Alphabets mit 
; einem Buchstaben des um 13 Zeichen verschobenen Alphabets ersetzt. 

Procedure.s Encrypt(str.s) 
  DefType.l i, C 
  DefType.s tmp, erg 
  
  For i = 1 To Len(str) 
    tmp = Mid(str, i, 1) 
    C = Asc(tmp) + 13 
    If C > 255 
      C = C - 255 
    EndIf 
    erg = erg + Chr(C) 
  Next 
  
  ProcedureReturn erg 
EndProcedure 

Procedure.s Decrypt(str.s) 
  DefType.l i, C 
  DefType.s tmp, erg 
  
  For i = 1 To Len(str) 
    tmp = Mid(str, i, 1) 
    C = Asc(tmp) - 13 
    If C < 0 
      C = C + 255 
    EndIf 
    erg = erg + Chr(C) 
  Next 
  
  ProcedureReturn erg 
EndProcedure 

test.s = Encrypt("Der gute alte Julius war schon ein Schlawiner") 
Debug test 
Debug Decrypt(test) 

; ExecutableFormat=Windows
; FirstLine=1
; EOF