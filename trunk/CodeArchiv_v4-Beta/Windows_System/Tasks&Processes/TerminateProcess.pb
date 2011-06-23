; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8079&highlight=
; Author: Hi-Toro
; Date: 27. October 2003
; OS: Windows
; Demo: No

; This terminates a process, but you need its 'pid' (process ID).
; This can usually be retrieved from the Task Manager, or you can
; iterate through the process list using Process32First/Next, etc.

#PROCESS_TERMINATE = $1 
#PROCESS_CREATE_THREAD = $2 
#PROCESS_VM_OPERATION = $8 
#PROCESS_VM_READ = $10 
#PROCESS_VM_WRITE = $20 
#PROCESS_DUP_HANDLE = $40 
#PROCESS_CREATE_PROCESS = $80 
#PROCESS_SET_QUOTA = $100 
#PROCESS_SET_INFORMATION = $200 
#PROCESS_QUERY_INFORMATION = $400 
#PROCESS_ALL_ACCESS = #STANDARD_RIGHTS_REQUIRED | #SYNCHRONIZE | $FFF 

; This appears to be pretty much how Windows kills a program if you 'End Process' 
; from the Task Manager. Note that this is 'unfriendly'! 

Procedure KillProcess (pid) 
    phandle = OpenProcess_ (#PROCESS_TERMINATE, #False, pid) 
    If phandle <> #Null 
        If TerminateProcess_ (phandle, 1) 
            result = #True 
        EndIf 
        CloseHandle_ (phandle) 
    EndIf 
    ProcedureReturn result 
EndProcedure 

; Enter process ID here! I suggest going to Task Manager, 
; making sure PIDs are shown (try View menu -> Select columns if 
; they are not listed), then run a program and enter its number here... 

Debug KillProcess ( x ) 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
