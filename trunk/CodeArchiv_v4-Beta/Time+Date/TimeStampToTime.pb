; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1710&highlight=
; Author: Pille
; Date: 15. July 2003
; OS: Windows
; Demo: Yes

; 
; by Pille, 15.07.2003 
; 

Procedure.s Timestamp2Time(stamp.l) 
  ;Time = Timestamp2Time(1234567890) 

    tStart.l = Date(1970,01,01,00,00,00) 
    ProcedureReturn FormatDate("%dd.%mm.%yyyy %hh:%ii:%ss", tStart+stamp) 
EndProcedure 

Procedure.l now2Timestamp() 
  ;Timestamp.l = now2Timestamp() 
    
    tStart.l = Date(1970,01,01,00,00,00) 
    ProcedureReturn tStart + Date() 
EndProcedure 


Debug Timestamp2Time(0) 
Debug Timestamp2Time(1234567890) 

Debug now2Timestamp() 
Debug Timestamp2Time(now2Timestamp())

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
