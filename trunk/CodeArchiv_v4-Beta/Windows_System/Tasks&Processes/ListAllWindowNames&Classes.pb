; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8437&highlight=
; Author: Hi-Toro
; Date: 30. November 2003
; OS: Windows
; Demo: No

Procedure ListWindows (window, parameter) 
    
    *Memory = ReAllocateMemory (0, 255)
    GetClassName_ (window, *Memory, 255) 
    class$ = PeekS (*Memory) 

    *Memory = ReAllocateMemory (0, 255)
    GetWindowText_ (window, *Memory, 255) 
    title$ = PeekS (*Memory) 

    FreeMemory (*Memory) 
    
    Debug Chr (34) + title$ + Chr (34) + " / Class: " + class$ 
    
    ProcedureReturn #True 
    
EndProcedure 

EnumWindows_ (@ListWindows (), 0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
