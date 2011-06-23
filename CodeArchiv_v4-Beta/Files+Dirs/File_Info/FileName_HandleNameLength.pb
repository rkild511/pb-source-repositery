; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2582&highlight=
; Author: dige  (example added by Andre)
; Date: 17. October 2003
; OS: Windows
; Demo: No


; Umwandeln in DOS 8.3 Schreibweise: 
Procedure.s GetShortFileName ( Long.s ) 
  Short.s = Long 
  GetShortPathName_ ( @Long, @Short, Len(Short) ) 
  ProcedureReturn Short 
EndProcedure 
 
 ; Example
file$ = OpenFileRequester("Choose file","","",0)
Debug GetShortFileName(file$)



; Zu einen DOS Namen den Langnamen ermitteln: 
Procedure.s GetLongFileName ( Short.s ) 
  Res = FindFirstFile_ ( @Short, FD.WIN32_FIND_DATA ) 
  If Res 
    ProcedureReturn PeekS( @FD\cFileName[0], 255) 
  EndIf 
  ProcedureReturn "" 
EndProcedure 

; Example 
Debug GetLongFileName(file$)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
