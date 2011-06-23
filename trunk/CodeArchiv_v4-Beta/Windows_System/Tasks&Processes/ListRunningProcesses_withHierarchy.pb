; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8086&highlight=
; Author: Hi-Toro (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 29. October 2003
; OS: Windows
; Demo: No


; Should run correctly on WinXP, Win2000/2003 - will not work correctly on Win98 and older...
; Look for ListRunningProcesses_withHierrachy_W9x.pb to get a version for Win95 and newer.

; ----------------------------------------------------------------------------- 
; Shows list of running processes and their hierarchy... 
; ----------------------------------------------------------------------------- 
; james @ hi - toro . com 
; ----------------------------------------------------------------------------- 

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
Global subLevel.l ;Cur Level of the Treegadget

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
; Another PROCESSENTRY32 list for destructive operations on process list... 
; ----------------------------------------------------------------------------- 

Global NewList Proc32Copy.PROCESSENTRY32 () 

; Copy Proc32 () into Proc32Copy ()... 

Procedure CopyProcessList () 
    ResetList (Proc32 ()) 
    While NextElement (Proc32 ()) 
        AddElement (Proc32Copy ()) 
        CopyMemory (@Proc32 (), @Proc32Copy (), SizeOf (PROCESSENTRY32)) 
    Wend 
EndProcedure 

; Free Proc32Copy () list when done with it... 

Procedure FreeProcessListCopy () 
    ClearList (Proc32Copy ()) 
EndProcedure 

; By the wonders of trial and error, we have this (this recursively adds 
; processes to supplied TreeGadget)... don't ask me to explain this (see 
; 'trial and error' comment... ;) 

Procedure AddTreeProcesses (gadget, currentid) ; currentid = Proc32Copy ()\th32ProcessID 

    ; Iterate through copy of Proc32 () -- call CopyProcessList () to get this... 
    
    ResetList (Proc32Copy ()) 
    
    While NextElement (Proc32Copy ()) 

        ; Skip if checking against 'currentid', ie. same process... 
                
        If Proc32Copy ()\th32ProcessID <> currentid 
            
            ; Check currentid against this one... 
            
            againstid = Proc32Copy ()\th32ProcessID 
            againstparent = Proc32Copy ()\th32ParentProcessID 
        
            ; If 'currentid' is parent of this process... 
            
            If currentid = againstparent 
            
                ; We have a child process. Open a new node in the TreeGadget... 
                
                subLevel+1

                    ; Note: next line uses GetFilePart () as the Win9x \szExeFile contains full path (WinNT has filename only)! 
                    
                    AddGadgetItem (gadget, -1, GetFilePart (PeekS (@Proc32Copy ()\szExeFile)),0,subLevel) 

                    ; Store current position in Proc32Copy () list... 
                    
                    current = ListIndex (Proc32Copy ()) 
                    
                    ; Recursive function call to iterate against all other processes (ow, head hurts)... 
                    
                    AddTreeProcesses (gadget, againstid) 
                    
                    ; Go back to stored position in list... 
                    
                    SelectElement (Proc32Copy (), current) 
                    
                    ; Delete element so we don't process it again... 
                    
                    DeleteElement (Proc32Copy ()) 

                ; OK, close the new TreeGadget node... 
                
                subLevel-1
                
            EndIf 
            
        EndIf 
        
    Wend 
    
EndProcedure 

; Window callback procedure (resizes TreeGadget on window resize)... 

Procedure WindowCallback (WindowID, Message, wParam, lParam) 
    Select Message 
        Case #WM_SIZE 
            ResizeGadget (0, #PB_Ignore, #PB_Ignore, WindowWidth (0), WindowHeight (0)) 
    EndSelect 
    ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

; Create basic window and gadget list... 

OpenWindow (0, 0, 0, 320, 300, "List of running processes...", #PB_Window_SystemMenu | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
CreateGadgetList (WindowID (0)) 

; Create TreeGadget... 

TreeGadget (0, 0, 0, WindowWidth (0), WindowHeight (0)) 

; Create root node in TreeGadget... 

subLevel+1

; Start window callback procedure... 

SetWindowCallback (@WindowCallback ()) 

; About to add list of processes to TreeGadget... 

; ----------------------------------------------------------------------------- 
; Initialise process list stuff (really just opening kernel32.dll!)... 
; ----------------------------------------------------------------------------- 

If InitProcess32 () 

    ; ------------------------------------------------------------------------- 
    ; Get a snapshot of all running processes... 
    ; ------------------------------------------------------------------------- 
    
    snapshot = CreateProcessList () 
    
    If snapshot 
    
        ; --------------------------------------------------------------------- 
        ; Get list of processes (generates the Proc32 () list)... 
        ; --------------------------------------------------------------------- 
        
        If GetFirstProcess (snapshot) 
            Repeat 
                result = GetNextProcess (snapshot) 
            Until result = #False 
        EndIf 

        ; --------------------------------------------------------------------- 
        ; Copy Proc32 () as Proc32Copy (), so we can do nasty things to data... 
        ; --------------------------------------------------------------------- 

        ; Note that in this particular example, we don't need to operate on Proc32 () 
        ; after creating the list, but I'm making a copy because you need to delete elements 
        ; when adding to the TreeGadget so that you don't repeatedly compare against 
        ; previously elements already added. If we needed to operate on the Proc32 () 
        ; list later, this way would mean it's still available... 
        
        CopyProcessList () 
        
        ; --------------------------------------------------------------------- 
        ; Iterate through Proc32Copy () list, and act on process data here... 
        ; --------------------------------------------------------------------- 

        ResetList (Proc32Copy ()) 
        
        While NextElement (Proc32Copy ()) 
            
            ; Add new item to root node... 
            
            AddGadgetItem (0, -1, GetFilePart (PeekS (@Proc32Copy ()\szExeFile)),0,subLevel) 
            
            ; Store current position in Proc32Copy () list... 
            
            current = ListIndex (Proc32Copy ()) 
            
            ; Iterate through the Proc32Copy () list (recursive function)... 
            
            AddTreeProcesses (0, Proc32Copy ()\th32ProcessID) 
            
            ; Go back to where we were in the list... 
            
            SelectElement (Proc32Copy (), current) 
            
        Wend 

        ; --------------------------------------------------------------------- 
        ; Free copy of process list... 
        ; --------------------------------------------------------------------- 

        FreeProcessListCopy () 

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

; ----------------------------------------------------------------------------- 
; Event loop... 
; ----------------------------------------------------------------------------- 

Repeat 
Until WaitWindowEvent () = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
