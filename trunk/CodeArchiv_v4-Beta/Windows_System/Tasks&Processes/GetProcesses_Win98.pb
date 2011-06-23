; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6865&highlight=
; Author: Fred  (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 10. July 2003
; OS: Windows
; Demo: No

; 
; List processes on Win9x. (works also with Win 2k)
; 
; Structure PROCESSENTRY32
;   dwSize.l 
;   cntUsage.l 
;   th32ProcessID.l 
;   th32DefaultHeapID.l 
;   th32ModuleID.l 
;   cntThreads.l 
;   th32ParentProcessID.l 
;   pcPriClassBase.l 
;   dwFlags.l 
;   szExeFile.b[#MAX_PATH] 
; EndStructure 

#TH32CS_SNAPPROCESS = $2 

Procedure GetProcessList9x() 

  If OpenLibrary(0, "Kernel32.dll") 
  
    CreateToolhelpSnapshot = GetFunction(0, "CreateToolhelp32Snapshot") 
    ProcessFirst           = GetFunction(0, "Process32First") 
    ProcessNext            = GetFunction(0, "Process32Next") 
    
    If CreateToolhelpSnapshot And ProcessFirst And ProcessNext ; Ensure than all the functions are found 
    
      Process.PROCESSENTRY32\dwSize = SizeOf(PROCESSENTRY32) 
    
      Snapshot = CallFunctionFast(CreateToolhelpSnapshot, #TH32CS_SNAPPROCESS, 0) 
      If Snapshot 
        
        ProcessFound = CallFunctionFast(ProcessFirst, Snapshot, Process) 
        While ProcessFound 
          Debug PeekS(@Process\szexeFile) 
          ProcessFound = CallFunctionFast(ProcessNext, Snapshot, Process) 
        Wend 
      EndIf 
      
      CloseHandle_(Snapshot) 
    EndIf 
    
    CloseLibrary(0) 
  EndIf 
  
EndProcedure 

GetProcessList9x()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
