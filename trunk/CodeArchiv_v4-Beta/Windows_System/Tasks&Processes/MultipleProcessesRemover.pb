; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8734&highlight=
; Author: scurrier (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 15. December 2003
; OS: Windows
; Demo: No


; Remove multiple processes with GUI...

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
#PROCESS32LIB = 9999
#TH32CS_SNAPHEAPLIST = $1
#TH32CS_SNAPPROCESS = $2
#TH32CS_SNAPTHREAD = $4
#TH32CS_SNAPMODULE = $8
#TH32CS_SNAPALL = #TH32CS_SNAPHEAPLIST | #TH32CS_SNAPPROCESS | #TH32CS_SNAPTHREAD | #TH32CS_SNAPMODULE
#TH32CS_INHERIT = $80000000


Enumeration
  #Window_0
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Listview_0
  #Listview_1
  #Text_0
  #Text_1
  #Button_0
  #Button_1
  #Button_2
  #Button_3
EndEnumeration

;- Fonts
;
Global FontID1
FontID1 = LoadFont(1, "Arial", 10, #PB_Font_Bold)
Global FontID2
FontID2 = LoadFont(2, "Arial", 20, #PB_Font_Bold)


Global Dim list1$(999)
Global Dim list2$(999)


;--- Structures ---


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
;   szExeFile.b [#MAX_PATH]
; EndStructure

;--- Procedures ---


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


If OpenWindow(#Window_0, 220, 53, 468, 300, "Remove Multiple Processes", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
  If CreateGadgetList(WindowID(#Window_0))
    ListViewGadget(#Listview_0, 20, 50, 160, 190) ; Current Processes
    ListViewGadget(#Listview_1, 280, 50, 150, 190) ; Processes to Delete
    TextGadget(#Text_0, 20, 30, 160, 20, "Running Processes", #PB_Text_Center) ; Text label
    SetGadgetFont(#Text_0, FontID1)
    TextGadget(#Text_1, 280, 30, 150, 20, "Processes to delete", #PB_Text_Center) ; Text label
    SetGadgetFont(#Text_1, FontID1)
    ButtonGadget(#Button_0, 200, 90, 60, 30, ">>") ; Add to Delete List
    SetGadgetFont(#Button_0, FontID2)
    ButtonGadget(#Button_1, 200, 150, 60, 30, "<<") ; Remove From Delete List
    SetGadgetFont(#Button_1, FontID2)
    ButtonGadget(#Button_2, 300, 250, 120, 30, "Delete Processes") ; Delete Button
    SetGadgetFont(#Button_2, FontID1)
    ButtonGadget(#Button_3, 40, 250, 120, 30, "Quit") ; quit button
    SetGadgetFont(#Button_3, FontID1)
  EndIf
EndIf


Global NewList Process32.PROCESSENTRY32 ()

; Add processes to Process32 () list...
restart:
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


; PureBasic Visual Designer v3.81 build 1321

;IncludeFile "Common.pb"

ResetList (Process32 ())
While NextElement (Process32 ())
  ; addtem( PeekS (@Process32 ()\szExeFile)
  proc$=(PeekS (@Process32 ()\szExeFile))
  AddGadgetItem(#Listview_0, -1,proc$)
Wend
terminate=0
Repeat
  Delay(1)
  
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_Gadget
    GadgetID = EventGadget()
    If GadgetID = #Button_0
      procnum = GetGadgetState(#Listview_0)
      checkproc$= GetGadgetItemText(#Listview_0,procnum,0)
      Debug checkproc$
      quit=0
      ResetList (Process32 ())
      While NextElement (Process32 ()) Or quit <> 1
        proc1$=(PeekS (@Process32 ()\szExeFile))
        Debug proc1$+" "+checkproc$
        If proc1$=checkproc$
          quit=1
          AddGadgetItem(#Listview_1, -1,proc1$)
          ;RemoveGadgetItem(#Listview_1, procnum)
        EndIf
      Wend
    EndIf
    
    If GadgetID = #Button_1
      Debug "GadgetID: #Button_1"
      procnum = GetGadgetState(#Listview_1)
      checkproc$= GetGadgetItemText(#Listview_1,procnum,0)
      RemoveGadgetItem(#Listview_1, procnum)
      AddGadgetItem(#Listview_0,-1, checkproc$)
    EndIf
    
    If GadgetID = #Button_2
      ;Debug "GadgetID: #Button_2"
      
      TotalToDelete = CountGadgetItems(#Listview_1)
      Debug TotalToDelete
      For x=0 To (TotalToDelete-1)
        quit=0
        ResetList (Process32 ())
        checkproc$= GetGadgetItemText(#Listview_1,x,0)
        Debug Str(x)+" "+checkproc$
        
        While NextElement (Process32 ()) Or quit <> 1
          proc1$=(PeekS (@Process32 ()\szExeFile))
          If proc1$=checkproc$
            quit=1
            ;Debug checkproc$
            Threadid = Process32 ()\th32ProcessID
            Debug "Killing Thread "+proc1$+" it's ID is "+Str(Threadid)
            KillProcess (Threadid)
            ;RemoveGadgetItem(#Listview_1, x)
          EndIf
        Wend
      Next x
      ClearGadgetItemList(#Listview_1)
      LLTotal = CountList(Process32 ())
      ResetList (Process32 ())
      For q=0 To LLTotal
        DeleteElement(Process32 ())
        Result = NextElement(Process32 ())
      Next q
      ResetList (Process32 ())
      ;Delay(20)
      ClearGadgetItemList(#Listview_0)
      Goto restart
    EndIf
    
    If GadgetID = #Button_3
      Debug "GadgetID: #Button_3"
      Terminate=1
      
    EndIf
    
  EndIf
  
Until Event = #PB_Event_CloseWindow Or Terminate=1

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
