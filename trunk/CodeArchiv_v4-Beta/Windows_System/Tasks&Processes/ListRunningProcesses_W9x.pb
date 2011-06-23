; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8086&highlight=
; Author: Hi-Toro (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 30. November 2003
; OS: Windows
; Demo: No


; Should run on all Windows version from Win95 till WinXP !!
; For special WinXP/Win2000 only example look for ListRunningProcesses.pb

; MAKE SURE DEBUGGER IS ON!!! 

#TH32CS_SNAPHEAPLIST = $1 
#TH32CS_SNAPPROCESS = $2 
#TH32CS_SNAPTHREAD = $4 
#TH32CS_SNAPMODULE = $8 
#TH32CS_SNAPALL = #TH32CS_SNAPHEAPLIST | #TH32CS_SNAPPROCESS | #TH32CS_SNAPTHREAD | #TH32CS_SNAPMODULE 
#TH32CS_INHERIT = $80000000 
#INVALID_HANDLE_VALUE = -1 
#PROCESS32LIB = 9999 

; Structure PROCESSENTRY32 
;     dwSize.l 
;     cntUsage.l 
;     th32ProcessID.l 
;     th32DefaultHeapID.l 
;     th32ModuleID.l 
;     cntThreads.l 
;     th32ParentProcessID.l 
;     pcPriClassBase.l 
;     dwFlags.l 
;     szExeFile.b [#MAX_PATH] 
; EndStructure 

; NOTE: I've chosen to add processes to this list so that it can be played with as necessary... 

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

; List processes... 

ResetList (Process32 ()) 

While NextElement (Process32 ()) 
    Debug PeekS (@Process32 ()\szExeFile) 
Wend 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
