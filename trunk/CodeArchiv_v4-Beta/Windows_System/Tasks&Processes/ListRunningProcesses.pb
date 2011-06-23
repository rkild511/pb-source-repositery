; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8086&highlight=
; Author: Hi-Toro  (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 28. October 2003
; OS: Windows
; Demo: No


; Code example doesn't work on Win95,98,NT !!
; Use ListRunningProcesses_W9x.pb instead to get a "All" Windows version...

; This code shows how to iterate through the list of all running processes.
; Combine it with the code at the bottom for a crude Task Manager replacement... 

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

; ----------------------------------------------------------------------------- 
; GLOBAL PROCESS LIST! Used to retrieve information after getting process list... 
; ----------------------------------------------------------------------------- 

Global NewList Proc32.PROCESSENTRY32 () 

; ----------------------------------------------------------------------------- 
; kernel32.dll open/close... 
; ----------------------------------------------------------------------------- 

Procedure InitProcess32 () 
    ProcedureReturn OpenLibrary (#PROCESS32LIB, "kernel32.dll") 
EndProcedure 

Procedure CloseProcess32 () 
    ProcedureReturn CloseLibrary (#PROCESS32LIB) 
EndProcedure 

; ----------------------------------------------------------------------------- 
; Get/free snapshot of process list... 
; ----------------------------------------------------------------------------- 

Procedure CreateProcessList () 
    ClearList (Proc32 ()) 
    ProcedureReturn CallFunction (#PROCESS32LIB, "CreateToolhelp32Snapshot", #TH32CS_SNAPPROCESS, 0) 
EndProcedure 

Procedure FreeProcessList (snapshot) 
    ; Free process list (.PROCESSENTRY32 structures)... 
    ClearList (Proc32 ()) 
    ; Close snapshot handle... 
    ProcedureReturn CloseHandle_ (snapshot) 
EndProcedure 

; ----------------------------------------------------------------------------- 
; Iterate processes... 
; ----------------------------------------------------------------------------- 

Procedure GetFirstProcess (snapshot) 
    ; Allocate a new .PROCESSENTRY32 structure and fill in SizeOf (structure)... 
    AddElement (Proc32 ()) 
    Proc32 ()\dwSize = SizeOf (PROCESSENTRY32) 
    ; Call Process32First with snapshot handle and pointer to structure... 
    If CallFunction (#PROCESS32LIB, "Process32First", snapshot, @Proc32 ()) 
        ProcedureReturn #True 
    Else 
        ; Free the structure if function call failed... 
        DeleteElement (Proc32 ()) 
        ProcedureReturn #False 
    EndIf 
EndProcedure 

Procedure GetNextProcess (snapshot) 
    ; Allocate a new .PROCESSENTRY32 structure and fill in SizeOf (structure)... 
    AddElement (Proc32 ()) 
    Proc32 ()\dwSize = SizeOf (PROCESSENTRY32) 
    ; Call Process32Next with snapshot handle and pointer to structure... 
    If CallFunction (#PROCESS32LIB, "Process32Next", snapshot, @Proc32 ()) 
        ProcedureReturn #True 
    Else 
        ; Free the structure if function call failed... 
        DeleteElement (Proc32 ()) 
        ProcedureReturn #False 
    EndIf 
EndProcedure 

; ----------------------------------------------------------------------------- 
; D e m o . . . 
; ----------------------------------------------------------------------------- 

MessageRequester ("Process32", "Make sure debugger is on!", #MB_ICONINFORMATION) 

; ----------------------------------------------------------------------------- 
; Initialise (really just opening kernel32.dll!)... 
; ----------------------------------------------------------------------------- 

If InitProcess32 () 

    ; ------------------------------------------------------------------------- 
    ; Get a snapshot of all running processes... 
    ; ------------------------------------------------------------------------- 
    
    snapshot = CreateProcessList () 
    
    If snapshot 
    
        ; --------------------------------------------------------------------- 
        ; Get list of processes... 
        ; --------------------------------------------------------------------- 
        
        If GetFirstProcess (snapshot) 
            Repeat 
                result = GetNextProcess (snapshot) 
            Until result = #False 
        EndIf 

        ; --------------------------------------------------------------------- 
        ; Iterate through Proc32 () list, and act on process data here... 
        ; --------------------------------------------------------------------- 

        ResetList (Proc32 ()) 
        
        While NextElement (Proc32 ()) 
        
            ; Example of accessing PROCESSENTRY32 structure... 
            
            Debug "Process ID: " + Str (Proc32 ()\th32ProcessID) + " (" + PeekS (@Proc32 ()\szExeFile) + ")" 
            
        Wend 

        ; --------------------------------------------------------------------- 
        ; Free snapshot/list of processes... 
        ; --------------------------------------------------------------------- 

        FreeProcessList (snapshot) 
        
    EndIf 

    ; ------------------------------------------------------------------------- 
    ; Close kernel32.dll... 
    ; ------------------------------------------------------------------------- 
        
    CloseProcess32 () 
    
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
