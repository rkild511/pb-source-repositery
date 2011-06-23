; English forum: http://www.purebasic.fr/english/viewtopic.php?t=3809&highlight=
; Author: Hi-Toro
; Date: 22. November 2003
; OS: Windows
; Demo: No

; ShowError () returns a system error message as a string... call any time a function fails! 

; If BlahBlah () 
;   EverythingNormal () 
; Else 
;   Debug ShowError () 
; EndIf 

Procedure.s ShowError () 
  error = GetLastError_ () 
  If error 
    *Memory = AllocateMemory (255)
    length = FormatMessage_ (#FORMAT_MESSAGE_FROM_SYSTEM, #Null, error, 0, *Memory, 255, #Null) 
    If length > 1 ; Some error messages are "" + Chr (13) + Chr (10)... stoopid M$... :( 
        e$ = PeekS (*Memory, length - 2) 
    Else 
        e$ = "Unknown error!" 
    EndIf 
    FreeMemory (*Memory) 
    ProcedureReturn e$ 
  Else 
    ProcedureReturn "No error has occurred!" 
  EndIf 
EndProcedure 

; D E M O . . . 

; Attempting to read an invalid filename... 

If ReadFile (0, "ZZZ :\ Stupid f@#&ing filename!") 
    MessageRequester ("Yay!", "Opened file!", 0) 
    CloseFile (0) 
Else 
    MessageRequester ("Doh!", ShowError (), 0) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
