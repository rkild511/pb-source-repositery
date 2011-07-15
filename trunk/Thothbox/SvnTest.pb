Enumeration 
  #ButtonGetList
  #ButtonGetFiles
  #TreeGadget
EndEnumeration

Structure Branch
  Trunk.i
  Branch.i
  Path.s
  SubPath.s
EndStructure

Global BaseFolder.s = "http://pb-source-repositery.googlecode.com/svn/trunk/"

Global NewList Tree.Branch()

;Ne sert pas ici, mais ça peut servir plus tard ;)
Procedure.s GetStdOut(Prog.s, Arg.s)
  svn = RunProgram(Prog, Arg, "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open )
  Output$ = ""
  If svn
    While ProgramRunning(svn)
      If AvailableProgramOutput(svn)
        Output$ + ReadProgramString(svn) + Chr(13)
      EndIf
    Wend   
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  ProcedureReturn Output$
EndProcedure

Procedure Disabler()
  DisableGadget(#ButtonGetList, 1)
  DisableGadget(#ButtonGetFiles, 1)
  ClearGadgetItems(#TreeGadget)
EndProcedure

Procedure Enabler()
  DisableGadget(#ButtonGetList, 0)
  DisableGadget(#ButtonGetFiles, 0)
EndProcedure

;Récupère la liste des fichiers sur le serveur google
Procedure GetFileList(*Trunk.Branch)
  ;Disabler()
  txt.s = "Please Wait"
  Counter = 0
  Debug *CurrentFile\Path
  svn = RunProgram("svn\bin\svn.exe", "list " + *CurrentFile\Path, "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open )
  If svn
    While ProgramRunning(svn)     
      txt.s = "Please Wait"
      Select Counter%400
        Case 1 To 100
          txt + "."
        Case 100 To 200
          txt + ".."
        Case 200 To 300
          txt + "..."
      EndSelect
      SetGadgetText(#ButtonGetList, txt)
      If AvailableProgramOutput(svn)
        n.s = ReadProgramString(svn)
       
;        AddGadgetItem (#TreeGadget, *CurrentFile\Item, n, 0, *CurrentFile\SubLevel )
        Debug n
         AddElement(Tree())
         Tree()\Index = *CurrentFile\Item
;         FileList()\Name = *CurrentFile\Name + ReadProgramString(svn)        
      EndIf
      Delay(10)
      Counter + 1
    Wend  
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  SetGadgetText(#ButtonGetList, "Liste des fichiers sur le serveur")
  ;Enabler()  
EndProcedure

;Télécharge en local une version "lecture seule" sur le serveur
Procedure GetFiles(nil)
  Disabler()
  txt.s = "Please Wait"
  Counter = 0
  svn = RunProgram("svn\bin\svn.exe","checkout http://pb-source-repositery.googlecode.com/svn/trunk/ repositeries\pb-source-repositery-Read-only", "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open)
  If svn
    While ProgramRunning(svn)     
      txt.s = "Please Wait" 
      Select Counter%400
        Case 1 To 100
          txt + "."
        Case 100 To 200
          txt + ".."
        Case 200 To 300
          txt + "..."
      EndSelect
      SetGadgetText(#ButtonGetFiles, txt)
      If AvailableProgramOutput(svn)
        AddGadgetItem (#TreeGadget, -1, ReadProgramString(svn))
      EndIf
      Delay(10)
      Counter + 1
    Wend  
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  SetGadgetText(#ButtonGetFiles, "Récupérer les fichiers")
  Enabler()
  RunProgram("explorer.exe", "repositeries\pb-source-repositery-Read-only", "")
EndProcedure


Procedure MakeDirOnRepositery(Url.s, UserName.s, Password.s, LocalFolder.s, PleaseWaitButton.i)
  Disabler()
  txt.s = "Please Wait"
  Counter = 0
  svn = RunProgram("svn\bin\svn.exe","mkdir " + Url + " --username " + UserName + " --password " + Password, "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error)
  If svn
    While ProgramRunning(svn)     
      txt.s = "Please Wait" 
      Select Counter%400
        Case 1 To 100
          txt + "."
        Case 100 To 200
          txt + ".."
        Case 200 To 300
          txt + "..."
      EndSelect
      SetGadgetText(PleaseWaitButton, txt)
      Delay(10)
      Counter + 1
    Wend
    If ProgramExitCode(svn)
      Result$ = ""
      Repeat
        Error$ = ReadProgramError(svn)
        If Error$ <> ""
          Error$ + Chr(13)
        EndIf
        Result$ + Error$
      Until Error$ = ""
    EndIf
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  If Result$ <> ""
    MessageRequester("Error", Result$, #PB_MessageRequester_Ok )
  EndIf
  Enabler()
EndProcedure

;- Début du code

If OpenWindow(0, 0, 0, 450, 350, "Google Code Subversion Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ButtonGadget(#ButtonGetList, 10, 10, 430, 20, "Liste des fichiers sur le serveur")  
  TreeGadget(#TreeGadget, 10, 30, 430, 250)
  ButtonGadget(#ButtonGetFiles, 10, 280, 430, 20, "Récupérer les fichiers")  
  
  ;Download root files list
  Define.Tree CurrentFile
  CurrentFile\Item = 0
  CurrentFile\SubLevel = 0
  CurrentFile\Path = BaseFolder + ""
  CreateThread(@GetFileList(), @CurrentFile)
  
  Repeat 
    Event = WaitWindowEvent()
    
    Select Event
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
            
          Case #ButtonGetList
            CreateThread(@GetFileList(), @"")
            
          Case #ButtonGetFiles
            CreateThread(@GetFiles(), nil)
            
          Case #TreeGadget
            
            Select EventType()
                
              Case #PB_EventType_LeftDoubleClick
                
                 CurrentItem = GetGadgetState(#TreeGadget)
      
                 CurrentLevel = GetGadgetItemAttribute(#TreeGadget, CurrentItem, #PB_Tree_SubLevel)
                 Debug currentlevel

      If CurrentLevel > 0            
         For i = CurrentItem-1 To 0 Step -1         
            If GetGadgetItemAttribute(#TreeGadget, i, #PB_Tree_SubLevel) < CurrentLevel
              Debug "ITEM PARENT ID: #" + RSet(Str(i+1),2,"0")
              Debug GetGadgetItemText(#TreeGadget, i, #PB_Tree_SubLevel)
             CurrentFile\Path = BaseFolder + GetGadgetItemText(#TreeGadget, CurrentItem, #PB_Tree_SubLevel)
               Break
            EndIf            
         Next      
      Else
         Debug "ITEM DOESN'T HAVE A PARENT"         
         CurrentFile\Path = BaseFolder + GetGadgetItemText(#TreeGadget, CurrentItem, #PB_Tree_SubLevel)
       EndIf
                
;                 
;                 CurrentFile\Path = BaseFolder
;                 ;CurrentLevel = GetGadgetItemAttribute(#TreeGadget, CurrentItem, #PB_Tree_SubLevel)
; 
; For index = CurrentFile\Item - 1 To 0 Step -1
;   If GetGadgetItemAttribute(#TreeGadget, index, #PB_Tree_SubLevel) < CurrentLevel
;     ; index is the parent of CurrentItem
;     Debug GetGadgetItemText(#TreeGadget, index, #PB_Tree_SubLevel)
;     Path.s = GetGadgetItemText(#TreeGadget, index, #PB_Tree_SubLevel)
;     CurrentFile\Path + Path
;     Break 
;   EndIf
; Next index
;                GetGadgetItemAttribute(#TreeGadget, CurrentFile\Item, #PB_Tree_SubLevel)
;                  CurrentFile\Path + GetGadgetItemText(#TreeGadget, CurrentFile\Item, #PB_Tree_SubLevel)

                CurrentFile\Item = CurrentItem + 1
                CurrentFile\SubLevel = ParentSublevel + 1
                CreateThread(@GetFileList(), @CurrentFile)               
                
            EndSelect           
        EndSelect
        
    EndSelect
    
  Until Event = #PB_Event_CloseWindow
  
EndIf

End
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 188
; FirstLine = 171
; Folding = --
; EnableThread