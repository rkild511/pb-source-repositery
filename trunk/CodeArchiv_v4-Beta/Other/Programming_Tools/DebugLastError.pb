; www.PureArea.net
; Author: Unknown
; Date: 23. May 2005
; OS: Windows
; Demo: No

Procedure.s ShowError () 
  error = GetLastError_ () 
  If error 
    *MemoryID = AllocateMemory (255)
    length = FormatMessage_ (#FORMAT_MESSAGE_FROM_SYSTEM, #Null, error, 0, *MemoryID, 255, #Null) 
    If length > 1 ; Some error messages are "" + Chr (13) + Chr (10)... stoopid M$... :( 
        e$ = PeekS (*MemoryID, length - 2) 
    Else 
        e$ = "Unknown error!" 
    EndIf 
    FreeMemory (0) 
    ProcedureReturn e$ 
  Else 
    ProcedureReturn "No error has occurred!" 
  EndIf 
EndProcedure 

Debug ShowError()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -