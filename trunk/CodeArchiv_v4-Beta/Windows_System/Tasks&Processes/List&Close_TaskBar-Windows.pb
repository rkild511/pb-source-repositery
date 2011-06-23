; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8086&start=15
; Author: Hi-Toro (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 30. November 2003
; OS: Windows
; Demo: No


; Here's a (fairly useless) little program that tries to list only open, visible windows,
; listed on the taskbar (it's not quite perfect as you sometimes get a window that's not
; on the taskbar), and lets you send a request to close that window. Might be handy for
; 'safe' closing of other programs from within your own. 

; It also shows how to retrieve a window's process name, which you can't get any other
; way, AFAIK. 


; ----------------------------------------------------------------------------- 
; Constants required by process functions, etc... 
; ----------------------------------------------------------------------------- 

#TH32CS_SNAPHEAPLIST = $1 
#TH32CS_SNAPPROCESS = $2 
#TH32CS_SNAPTHREAD = $4 
#TH32CS_SNAPMODULE = $8 
#TH32CS_SNAPALL = #TH32CS_SNAPHEAPLIST | #TH32CS_SNAPPROCESS | #TH32CS_SNAPTHREAD | #TH32CS_SNAPMODULE 
#TH32CS_INHERIT = $80000000 
#INVALID_HANDLE_VALUE = -1 
#MAX_PATH = 260 
#PROCESS32LIB = 9999 

; Structure PROCESSENTRY32 
;     dwSize.l 
;     cntUsage.l 
;     th32ProcessID.l 
;     *th32DefaultHeapID.l 
;     th32ModuleID.l 
;     cntThreads.l 
;     th32ParentProcessID.l 
;     pcPriClassBase.l 
;     dwFlags.l 
;     szExeFile.b [#MAX_PATH] 
; EndStructure 

Structure TaskbarWindow 
    handle.l 
EndStructure 

Global NewList TaskbarList.TaskbarWindow () 

Procedure ListTaskbarWindows (window, parameter) 

    If GetParent_ (window) = #Null 
    
        If GetWindowLong_ (window, #GWL_STYLE) & #WS_VISIBLE 
            *memory = ReAllocateMemory(*memory, 255)
            GetClassName_ (window, *memory, 255) 
            class$ = PeekS (*memory) 

            ; Ignore Explorer classes... 
                        
            Select LCase (class$) 
                Case "explorewclass" 
                    ignore = #True 
                Case "workerw" 
                    ignore = #True 
                Case "progman" 
                    ignore = #True 
                Case "shell_traywnd" 
                    ignore = #True 
            EndSelect 

            If ignore = #False 
                AddElement (TaskbarList ()) 
                TaskbarList ()\handle = window 
            EndIf 

            FreeMemory (0) 
                        
        EndIf 
        
    EndIf 

    ProcedureReturn #True 
    
EndProcedure 

Procedure WinHook (WindowID, Message, wParam, lParam) 
    If Message = #WM_SIZE 
        ResizeGadget (0, 0, 0, WindowWidth (0), WindowHeight (0) - 25) 
        ResizeGadget (1, 0, WindowHeight (0) - 24, WindowWidth (0), 25) 
        RedrawWindow_ (GadgetID (0), #Null, #Null, #RDW_INVALIDATE) 
    EndIf 
    ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

Global NewList Process32.PROCESSENTRY32 () 

; Add processes to Process32 () list... 

If OpenLibrary (#PROCESS32LIB, "kernel32.dll") 

    snap = CallFunction (#PROCESS32LIB, "CreateToolhelp32Snapshot", #TH32CS_SNAPPROCESS, 0) 

    If snap 

        Define.PROCESSENTRY32 Proc32 
        Proc32\dwSize = SizeOf (PROCESSENTRY32) 
        
        If CallFunction (#PROCESS32LIB, "Process32First", snap, @Proc32) 

            AddElement (Process32 ()) 
            CopyMemory (@Proc32, @Process32 (), SizeOf (PROCESSENTRY32)) 
            
            While CallFunction (#PROCESS32LIB, "Process32Next", snap, @Proc32) 
                AddElement (Process32 ()) 
                CopyMemory (@Proc32, @Process32 (), SizeOf (PROCESSENTRY32)) 
            Wend 
            
        EndIf    
        CloseHandle_ (snap) 
    
    EndIf 

    CloseLibrary (#PROCESS32LIB) 
    
EndIf 

OpenWindow (0, 0, 0, 400, 300, "Processes", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
CreateGadgetList (WindowID (0)) 

lv = ListViewGadget (0, 0, 0, WindowWidth (0), WindowHeight (0) - 25) 
ButtonGadget (1, 0, WindowHeight (0) - 24, WindowWidth (0), 25, "Close program...") 
ClearList (TaskbarList ()) 
EnumWindows_ (@ListTaskbarWindows (), 0) 

SetWindowCallback (@WinHook ()) 

ResetList (TaskbarList ()) 
While NextElement (TaskbarList ()) 
    *memory = AllocateMemory(255)
    GetWindowText_ (TaskbarList ()\handle, *memory, 255) 
    title$ = PeekS (*memory) 
    ResetList (Process32 ()) 
    While NextElement (Process32 ()) 
        GetWindowThreadProcessId_ (TaskbarList ()\handle, @pid) 
        If pid = Process32 ()\th32ProcessID 
            exe$ = GetFilePart (PeekS (@Process32 ()\szExeFile)) 
            LastElement (Process32 ()) 
        EndIf 
    Wend 
    AddGadgetItem (0, -1, title$ + " [Process " + Str (pid) + ": " + exe$ + "]") 
Wend 

SetGadgetState (0, 0) 

SetTimer_ (WindowID (0), 0, 1000, 0) 

Repeat 

    Select WaitWindowEvent () 
    
        Case #WM_TIMER 
            selected = GetGadgetState (0) 
            ClearGadgetItemList (0) 
            ClearList (TaskbarList ()) 
            EnumWindows_ (@ListTaskbarWindows (), 0) 
            ResetList (TaskbarList ()) 
            While NextElement (TaskbarList ()) 
                *memory = AllocateMemory(255)
                GetWindowText_ (TaskbarList ()\handle, *memory, 255) 
                title$ = PeekS (*memory) 
                ResetList (Process32 ()) 
                While NextElement (Process32 ()) 
                    GetWindowThreadProcessId_ (TaskbarList ()\handle, @pid) 
                    If pid = Process32 ()\th32ProcessID 
                        exe$ = GetFilePart (PeekS (@Process32 ()\szExeFile)) 
                    EndIf 
                Wend 
                AddGadgetItem (0, -1, title$ + " [Process " + Str (pid) + ": " + exe$ + "]") 
            Wend 
            If SetGadgetState (0, selected) = -1 
                SetGadgetState (0, 0) 
            EndIf 

        Case #PB_Event_CloseWindow 
            End 
            
        Case #PB_Event_Gadget 
            Select EventGadget () 
                Case 1 
                    ClearList (TaskbarList ()) 
                    EnumWindows_ (@ListTaskbarWindows (), 0) 
                    ResetList (TaskbarList ()) 
                    While NextElement (TaskbarList ()) 
                        *memory = AllocateMemory(255)
                        GetWindowText_ (TaskbarList ()\handle, *memory, 255) 
                        title$ = PeekS (*memory) 
                        ; SORT THIS! 
                        item$ = GetGadgetItemText (0, GetGadgetState (0), 0) 
                        found = FindString (item$, " [Process ", 1) 
                        If found > 1 
                            found = found - 1 
                            If title$ = Left (item$, found) 
                                If MessageRequester ("Processes...", "Close window: " + title$ +" ?", #PB_MessageRequester_YesNo) = #IDYES 
                                    PostMessage_ (TaskbarList ()\handle, #WM_CLOSE, 0, 0) 
                                    LastElement (TaskbarList ()) 
                                EndIf 
                            EndIf 
                        EndIf 
                    Wend 
            EndSelect 
            
    EndSelect 
    
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
