; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8437&highlight=
; Author: Hi-Toro
; Date: 02. December 2003
; OS: Windows
; Demo: No

; This code lists all open windows, including hidden ones and sub-windows.
; Turn Debug on!
; Note that ListChildWindows is called recursively on each child-window,
; using the 'parameter' variable to track 'depth'... 

; General non-GUI code here... 


; List top-level windows' children (called by ListWindows)... 

Global *Memory

Procedure ListChildWindows (window, parameter) 
    
    *Memory = ReAllocateMemory (0, 255)
    GetClassName_ (window, *Memory, 255) 
    class$ = PeekS (*Memory) 
    
    *Memory = ReAllocateMemory (0, 255)
    GetWindowText_ (window, *Memory, 255) 
    title$ = PeekS (*Memory) 

    FreeMemory (*Memory) 
    
    For a = 1 To parameter 
        sub$ = sub$ + "--------" 
    Next 
    
    Debug sub$ + ">" + Chr (34) + title$ + Chr (34) + " / Class: " + class$ 

    EnumChildWindows_ (window, @ListChildWindows (), parameter + 1) 

    ProcedureReturn #True 
    
EndProcedure 

; List top-level windows... 

Procedure ListWindows (window, parameter) 
    
    *Memory = ReAllocateMemory (0, 255)
    GetClassName_ (window, *Memory, 255) 
    class$ = PeekS (*Memory) 

    *Memory = ReAllocateMemory (0, 255)
    GetWindowText_ (window, *Memory, 255) 
    title$ = PeekS (*Memory) 

    FreeMemory (*Memory) 
    
    Debug "" 
    Debug "------------------------------------------------------------------------" 
    Debug Chr (34) + title$ + Chr (34) + " / Class: " + class$ 
    Debug "------------------------------------------------------------------------" 
    
    EnumChildWindows_ (window, @ListChildWindows (), 1) 
    
    ProcedureReturn #True 
    
EndProcedure 

EnumWindows_ (@ListWindows (), 0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
