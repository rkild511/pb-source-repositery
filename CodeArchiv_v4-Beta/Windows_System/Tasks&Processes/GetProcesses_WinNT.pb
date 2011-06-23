; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6865&highlight=
; Author: Fred (updated for PB4.00 by blbltheworm)
; Date: 10. July 2003
; OS: Windows
; Demo: No

; 
; List processes on WinNT. 
; 

Structure PROCESS_MEMORY_COUNTERS 
   cb.l 
   PageFaultCount.l 
   PeakWorkingSetSize.l 
   WorkingSetSize.l 
   QuotaPeakPagedPoolUsage.l 
   QuotaPagedPoolUsage.l 
   QuotaPeakNonPagedPoolUsage.l 
   QuotaNonPagedPoolUsage.l 
   PageFileUsage.l 
   PeakPagefileUsage.l 
EndStructure 

#OWNER_SECURITY_INFORMATION = $00000001 
#GROUP_SECURITY_INFORMATION = $00000002 
#DACL_SECURITY_INFORMATION  = $00000004 
#SACL_SECURITY_INFORMATION  = $00000008 
#PROCESS_TERMINATE          = $0001 
#PROCESS_CREATE_THREAD      = $0002  
#PROCESS_SET_SESSIONID      = $0004  
#PROCESS_VM_OPERATION       = $0008  
#PROCESS_VM_READ            = $0010  
#PROCESS_VM_WRITE           = $0020  
#PROCESS_DUP_HANDLE         = $0040  
#PROCESS_CREATE_PROCESS     = $0080  
#PROCESS_SET_QUOTA          = $0100  
#PROCESS_SET_INFORMATION    = $0200  
#PROCESS_QUERY_INFORMATION  = $0400  
#PROCESS_ALL_ACCESS         = #STANDARD_RIGHTS_REQUIRED | #SYNCHRONIZE | $FFF 


#NbProcessesMax = 10000 
Global Dim ProcessesArray(#NbProcessesMax) 


Procedure GetProcessListNt() 
  
  If OpenLibrary(0, "psapi.dll") 
  
    EnumProcesses      = GetFunction(0, "EnumProcesses") 
    EnumProcessModules = GetFunction(0, "EnumProcessModules") 
    GetModuleBaseName  = GetFunction(0, "GetModuleBaseNameA") 

    If EnumProcesses And EnumProcessModules And GetModuleBaseName  ; Be sure we have detected all the functions 
      
      CallFunctionFast(EnumProcesses, ProcessesArray(), #NbProcessesMax, @nProcesses) 
      
      For k=1 To nProcesses/4 
        hProcess = OpenProcess_(#PROCESS_QUERY_INFORMATION | #PROCESS_VM_READ, 0, ProcessesArray(k-1)) 
        
        If hProcess 
          CallFunctionFast(EnumProcessModules, hProcess, @BaseModule, 4, @cbNeeded) 
          
          Name$ = Space(255) 
          CallFunctionFast(GetModuleBaseName, hProcess, BaseModule, @Name$, Len(Name$)) 
          Debug Name$ 
          CloseHandle_(hProcess) 
        EndIf 
      Next 
      
    EndIf 
    CloseLibrary(0) 
  EndIf 
      
EndProcedure 

GetProcessListNt()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
