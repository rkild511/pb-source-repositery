; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8073&start=15
; Author: Rings
; Date: 01. December 2003
; OS: Windows
; Demo: No


; Will change the 'Back' (german 'Rück') button of the Windows calculator to 'Pure'

; Preferences, added by Andre
#lang = 0      ; set to 0 if you are running ENGLISH Windows, set to 1 if running GERMAN Windows
#win  = 0      ; set to 0 if you are running WinXP (Win9x not tested), set to 1 if running WinNT

; 
; simple Trainer, ported from vb to Pure 
; search in a other process's memory for a keyword (here wideansi string) 
; and replace that with our own 
; 
; another hack brought to you by Codeguru 
; 2003 Siegfried Rings 
; 

#PROCESS_VM_READ = $10 
#PROCESS_VM_WRITE = $20 
#PROCESS_VM_OPERATION = $8 
#PROCESS_QUERY_INFORMATION = $400 
#PROCESS_READ_WRITE_QUERY = #PROCESS_VM_READ|#PROCESS_VM_WRITE|#PROCESS_VM_OPERATION|#PROCESS_QUERY_INFORMATION 
#PROCESS_ALL_ACCESS= $1F0FFF 

#MEM_PRIVATE = $20000 
#MEM_COMMIT = $1000 

Global ProcessID.l 

Procedure.l RunProgramEx(Filename.s,Parameter.s,Directory.s,ShowFlag.l) 
  Info.STARTUPINFO : Info\cb=SizeOf(STARTUPINFO) : Info\dwFlags=1 
  Info\wShowWindow=ShowFlag : ProcessInfo.PROCESS_INFORMATION 
  ProcessPriority=#NORMAL_PRIORITY_CLASS 
  If CreateProcess_(@Filename,@Parameter,0,0,0,ProcessPriority,0,@Directory,@Info,@ProcessInfo) 
    ProcessID.l=ProcessInfo\dwProcessId 
    Repeat 
      win=FindWindow_(0,0) 
      While win<>0 
        GetWindowThreadProcessId_(win,@pid.l) 
        If pid=ProcessID : WinHandle=win : Break : EndIf 
        win=GetWindow_(win,#GW_HWNDNEXT) 
      Wend 
    Until WinHandle 
  EndIf 
  ProcedureReturn WinHandle 
EndProcedure 

Procedure CompareMemorybuffers(Bufferadress1,Bufferadress2,Len1,len2) 
L=0 
L2=len1-Len2  -1 
Repeat 
  B2.b=PeekB(Bufferadress2) 
  B1.b=PeekB(Bufferadress1+L) 
  If B1=B2 
   t=0 
   For L3=1 To Len2-1 
    B2.b=PeekB(Bufferadress2+L3) 
    B1.b=PeekB(Bufferadress1+L+L3) 
     If B2=B1 
      If B2<>0 
       ;Debug "Should="+Chr(B2) +"  is= "+Chr(B1) 
      EndIf 
      t+1 
     Else 
      Break 
     EndIf 
   Next L3 
   If t=len2 -1 
    ProcedureReturn l 
   EndIf      
  EndIf 
  L+1 
Until L=L2 
EndProcedure 

CompilerIf #lang = 0
  sSearchString.s = "Back" 
CompilerElse
  sSearchString.s = "Rück"
CompilerEndIf

aSearchString.s =Space(2*Len(sSearchString.s)) 
MultiByteToWideChar_ ( #CP_ACP, 0,@sSearchString.s ,Len(sSearchString.s ),@aSearchString.s ,Len(aSearchString.s ) ) 

sReplaceString.s = "Pure" 
aReplaceString.s =Space(2*Len(sReplaceString.s)) 
MultiByteToWideChar_ ( #CP_ACP, 0,@sReplaceString.s ,Len(sReplaceString.s ),@aReplaceString.s ,Len(aReplaceString.s ) ) 


si.SYSTEM_INFO 
CompilerIf #win = 0
  hWin=RunProgramEx("c:\windows\system32\calc.exe","","c:\windows\system32\",#SW_SHOW) 
CompilerElse
  hWin=RunProgramEx("c:\winnt\system32\calc.exe","","c:\winnt\system32\",#SW_SHOW) 
CompilerEndIf

;ProcessID=Val(InputRequester("Info","input PID",Str(ProcessID))) 
;Debug "PID="+Str(ProcessID) ;that is the processhandle !!! 
; better open with full access to close it later 
hProcess = OpenProcess_(#PROCESS_ALL_ACCESS,0,ProcessID) 
;Debug hProcess 

lLenMBI = SizeOf(MEMORY_BASIC_INFORMATION ) 
;Debug "ilENMBI="+Str(lLenmbi) 
GetSystemInfo_(si) 
lpMem = si\lpMinimumApplicationAddress 
;Debug lpmem 
;Debug si\lpMaximumApplicationAddress 
*mbi.MEMORY_BASIC_INFORMATION 
adr=AllocateMemory(28) 
*mbi=adr 
While lpMem < si\lpMaximumApplicationAddress 
    ret = VirtualQueryEx_(hProcess, lpMem, adr,lLenMBI ) ; *** ALWAYS RETURNS 0 *** 
    ;ret = VirtualQueryEx_(hProcess, lpMem, mbi2,lLenMBI ) ; *** ALWAYS RETURNS 0 *** 
    ;Debug "Ret="+Str(ret) 
    If ret = lLenMBI 
        If ((*mbi\lType = #MEM_PRIVATE) And (*mbi\State = #MEM_COMMIT)) 
            If *mbi\RegionSize > 0 
               sBuffer = AllocateMemory(*mbi\RegionSize) 
               Res=ReadProcessMemory_(hProcess, *mbi\BaseAddress, sBuffer, *mbi\RegionSize, @lWritten) 
               ;Remember that most Programs use Ansi-Widestrings, 
               If lWritten>0 And res>0 
                l=CompareMemorybuffers(sBuffer,@aSearchString.s ,*mbi\RegionSize,Len(sSearchstring.s) ) 
                If L>0 
                 Debug "found at Pos. "+Str(l)+ "  : "+PeekS(sBuffer+L,1) +PeekS(sBuffer+L+2,1)+PeekS(sBuffer+L+4,1)+PeekS(sBuffer+L+6,1) 
                 CalcAddress = *mbi\BaseAddress + l 
                 result=WriteProcessMemory_(hProcess, CalcAddress , @aReplaceString.s, Len(sReplaceString.s)*2, @lWritten) 
                EndIf 
               EndIf 
               FreeMemory(sBuffer) 
            EndIf  
        EndIf 
        lpMem = *mbi\BaseAddress + *mbi\RegionSize 
    Else 
      Break 
    EndIf 
Wend 

If hProcess 
  ; TerminateProcess_(hprocess,0) 
  CloseHandle_(hProcess) 
EndIf 
FreeMemory(adr) 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -