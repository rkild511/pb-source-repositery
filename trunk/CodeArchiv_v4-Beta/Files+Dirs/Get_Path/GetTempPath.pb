; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2022&highlight=
; Author: Danilo
; Date: 18. August 2003
; OS: Windows
; Demo: No

Procedure.s GetTempPath() 
  A$ = Space(1024) 
  GetTempPath_(1024,A$) 
  ProcedureReturn A$ 
EndProcedure 

MessageRequester("INFO","Temp: "+GetTempPath(),0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
