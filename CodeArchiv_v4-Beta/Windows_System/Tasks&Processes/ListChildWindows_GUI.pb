; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8437&highlight=
; Author: Hi-Toro (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 02. December 2003
; OS: Windows
; Demo: No


; This code lists all open windows, including hidden ones and sub-windows.
; Turn Debug on!
; Note that ListChildWindows is called recursively on each child-window,
; using the 'parameter' variable to track 'depth'... 


; GUI code with tiny fix (a bit hard-coded to this tree gadget, I'm afraid)... 

#TREEGADGET = 0 

Procedure ListChildWindows (window, parameter) 

    *memory = ReAllocateMemory(*memory, 255)
    GetClassName_ (window, *memory, 255) 
    class$ = PeekS (*memory) 

    *memory = ReAllocateMemory(*memory, 255)
    GetWindowText_ (window, *memory, 255) 
    title$ = PeekS (*memory) 

    If title$ = "" 
        title$ = "[Unnamed]" 
    EndIf 

    FreeMemory (0) 

    AddGadgetItem (#TREEGADGET, -1, title$ + " [" + class$ + "]",0,3) 
    EnumChildWindows_ (window, @ListChildWindows (), 0) 
    
    ProcedureReturn #True 
    
EndProcedure 

Procedure ListWindows (window, parameter) 

    *memory = ReAllocateMemory(*memory, 255)
    GetClassName_ (window, *memory, 255) 
    class$ = PeekS (*memory) 
    *memory = ReAllocateMemory(*memory, 255)
    GetWindowText_ (window, *memory, 255) 
    title$ = PeekS (*memory) 

    If title$ = "" 
        title$ = "[Unnamed]" 
    EndIf 

    FreeMemory (0) 

    AddGadgetItem (#TREEGADGET, -1, title$ + " [" + class$ + "]",0,2) 
    EnumChildWindows_ (window, @ListChildWindows (), 1) 

    ProcedureReturn #True 

EndProcedure 

Procedure WinHook (WindowID, Message, wParam, lParam) 
    If Message = #WM_SIZE 
        ResizeGadget (#TREEGADGET, 0, 0, WindowWidth (0), WindowHeight (0) - 25) 
        RedrawWindow_ (GadgetID (#TREEGADGET), #Null, #Null, #RDW_INVALIDATE) 
        ResizeGadget (1, 0, WindowHeight (0) - 25, WindowWidth (0), 25) 
    EndIf 
    ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

Procedure GetWindowTree () 
  ClearGadgetItemList (#TREEGADGET) 
  
    AddGadgetItem (#TREEGADGET, -1, "All windows...",0,1) 
    EnumWindows_ (@ListWindows (), 0)  
EndProcedure 

OpenWindow (0, 0, 0, 400, 300, "All windows...", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget) 
CreateGadgetList (WindowID (0)) 

TreeGadget (#TREEGADGET, 0, 0, WindowWidth (0), WindowHeight (0) - 25) 
GetWindowTree () 
SetGadgetItemState (0, 0, #PB_Tree_Expanded) 

ButtonGadget (1, 0, WindowHeight (0) - 25, WindowWidth (0), 25, "Update list...") 

SetWindowCallback (@WinHook ()) 

Repeat 

    Select WaitWindowEvent () 
        Case #PB_Event_CloseWindow 
            End 
        Case #PB_Event_Gadget 
            If EventGadget () = 1 
                GetWindowTree () 
                SetGadgetItemState (0, 0, #PB_Tree_Expanded) 
            EndIf 
    EndSelect 
    
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
