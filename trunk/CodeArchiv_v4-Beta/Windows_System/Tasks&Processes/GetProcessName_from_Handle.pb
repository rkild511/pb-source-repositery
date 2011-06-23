; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8555&highlight=
; Author: Hi-Toro (updated for PB4.00 by blbltheworm)
; Date: 30. November 2003
; OS: Windows
; Demo: No

; ----------------------------------------------------------------------------- 
; Public domain -- Hi-Toro 2003 
; ----------------------------------------------------------------------------- 
; Return a window's process name from its handle... 
; ----------------------------------------------------------------------------- 

; IMPORTANT! You must paste the following section of code (from here to the 
; demo section) at the top of your code, AND paste the part at the bottom 
; (the 'GetProcessList' sub-routine) at the bottom of your code. The reason the 
; sub-routine is required (rather than a procedure) is that the Win32 function 
; 'Process32Next' seems to fail on Windows 9x when called from inside a procedure... 

; Note that you should always call 'GetProcessList' before trying to retrieve a window's process name... 

; ----------------------------------------------------------------------------- 
; Paste at top of your code... 
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

; List used to store processes on 'Gosub GetProcessList'... 

Global NewList Process32.PROCESSENTRY32 () 

; Returns process name from window handle... 
; IMPORTANT! You should 'Gosub GetProcessList' before calling this! 

Procedure.s FindWindowProcessName (window) 
    ResetList (Process32 ()) 
    While NextElement (Process32 ()) 
        GetWindowThreadProcessId_ (window, @pid) 
        If pid = Process32 ()\th32ProcessID 
            exe$ = GetFilePart (PeekS (@Process32 ()\szExeFile)) 
            LastElement (Process32 ()) 
        EndIf 
    Wend 
    ProcedureReturn exe$ 
EndProcedure 

; Returns Process ID from window handle... 

Procedure.l FindWindowProcessID (window) 
    GetWindowThreadProcessId_ (window, @pid) 
    ProcedureReturn pid 
EndProcedure 

; ----------------------------------------------------------------------------- 
; D E M O... 
; ----------------------------------------------------------------------------- 

window = OpenWindow (0, 0, 0, 320, 200, "Test window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 

; Update every 100 ms... 

SetTimer_ (WindowID (0), 0, 100, 0) 

Repeat 
    Select WaitWindowEvent () 
        Case #PB_Event_CloseWindow 
            End 
        Case #WM_TIMER 
            ; Get process list... 
            Gosub GetProcessList 
            ; Get window under mouse position... 
            GetCursorPos_ (@p.POINT) 
            over = WindowFromPoint_ (p\x, p\y) 
            ; Find its name and set this window's title to it... 
            proc$ = FindWindowProcessName (over) 
            SetWindowText_ (window, proc$) 
    EndSelect 
ForEver 

; ----------------------------------------------------------------------------- 
; Paste at bottom of your code... 
; ----------------------------------------------------------------------------- 

End ; Leave this here! 

GetProcessList: 

    ClearList (Process32 ()) 

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

Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
