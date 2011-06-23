; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8086&highlight=
; Author: Hi-Toro  (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 30. November 2003
; OS: Windows
; Demo: No


; Should work on all Windows version from Win95 till WinXP.
; For a Win2000/WinXP only version look for ListRunningProcesses_withHierrachy.pb

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

Global NewList Process32.PROCESSENTRY32 () 
Global subLevel


; This function sorts processes into TreeGadget list, so that child processes branch off from parents... 

Procedure CompareProcs (gadget, currentid, currentname$) 

    Debug "Comparing " + currentname$ + " [" + Str (currentid) + "]" 
    
    ResetList (Process32 ()) 
    
    While NextElement (Process32 ()) 

        ; Skip if checking against 'currentid', ie. same process... 
                
        If Process32 ()\th32ProcessID <> currentid 
            
            ; Check currentid against this one... 
            
            againstid = Process32 ()\th32ProcessID 
            againstparent = Process32 ()\th32ParentProcessID 
        
            ; If 'currentid' is parent of this process... 
            
            If currentid = againstparent 
                subLevel+1
                ;OpenTreeGadgetNode (gadget) 

                    proc$ = PeekS (@Process32 ()\szExeFile) 
                    Debug "--------> " + proc$ + " [" + Str (Process32 ()\th32ProcessID) + "]" + " / " + " [" + Str (Process32 ()\th32ParentProcessID) + "]" 
                    
                    AddGadgetItem (gadget, -1, PeekS (@Process32 ()\szExeFile),0,subLevel) 
                    
                    current = ListIndex (Process32 ()) 
                    CompareProcs (gadget, againstid, proc$) 
                    SelectElement (Process32 (), current) 
                    DeleteElement (Process32 ()) 

                ;CloseTreeGadgetNode (gadget) 
                subLevel-1
                
            EndIf 
            
        EndIf 
        
    Wend 
    
EndProcedure 

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

; Window hook, used to resize/redraw TreeGadget when window is resized... 

Procedure WinHook (WindowID, Message, wParam, lParam) 
    If Message = #WM_PAINT 
        ResizeGadget (0, #PB_Ignore, #PB_Ignore, WindowWidth (0), WindowHeight (0)) 
        RedrawWindow_ (GadgetID (0), #Null, #Null, #RDW_INVALIDATE) 
    EndIf 
    ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

; GUI... 

OpenWindow (0, 320, 200, 320, 400, "Process list...", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
CreateGadgetList (WindowID (0)) 
TreeGadget (0, 0, 0, WindowWidth (0), WindowHeight (0)) 

SetWindowCallback (@WinHook ()) 

;OpenTreeGadgetNode (0) 
subLevel+1

; Add processes to TreeGadget... 

ResetList (Process32 ()) 

While NextElement (Process32 ()) 
    AddGadgetItem (0, -1, PeekS (@Process32 ()\szExeFile),0,subLevel) 
    current = ListIndex (Process32 ()) 
    CompareProcs (0, Process32 ()\th32ProcessID, PeekS (@Process32 ()\szExeFile)) 
    SelectElement (Process32 (), current) 
Wend 

Repeat 

Until WaitWindowEvent () = #PB_Event_CloseWindow 
End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
