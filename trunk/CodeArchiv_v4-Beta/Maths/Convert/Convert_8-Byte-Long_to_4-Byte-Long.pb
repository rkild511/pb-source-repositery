; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3739&highlight=
; Author: Sylvia
; Date: 18. February 2004
; OS: Windows
; Demo: Yes


; Convert 8-Byte Integer --> 4-Byte Integer (Long)

; ********************************* 
; 19.Feb.2004 "Sylvia" German-Forum 
; ********************************* 
Procedure.l LongLongDiv1024(*LL) 
     ; Weil PB (3.80) keine LongLong unterstützt... 
     ; Konvertiert 8-Byte Integer zu 4-Byte Integer (Long) 
     ; (Bytes/1024 -> KBytes) funktioniert korrekt bis ~4400 GB ohne Verlust 
     ; 
     ; *LL     = Zeiger auf den LowPart von LongLong 
     ; *LL+4   =               HighPart von LongLong 
     ; 
     ; Result  = 4-Byte Long 
      
     Protected Result 
     Result=0 
      
     MOV  EDX, [esp] 
     MOV  EAX, [EDX]        ; Value LowPart 
     MOV  EDX, [EDX+4]      ; Value HighPart 
    !SHRD EAX, EDX, 10      ; 64Bit/1024 
     MOV  Result, EAX 
      
     ProcedureReturn Result 
EndProcedure


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableAsm