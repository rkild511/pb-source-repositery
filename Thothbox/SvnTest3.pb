UsePNGImageDecoder()

;*****************************************************************************
;- CONSTANTS

Enumeration 
  #StringSearch
  #StringUsername
  #StringPassword
  #ButtonGetList
  #ButtonGetFilesReadOnly
  #ButtonGetFiles
  #ButtonSearch
  #ButtonStopSearch
  #ButtonCommit
  #ButtonUpdate
  #TreeGadget
EndEnumeration

Enumeration 
  #FolderImg
  #FileImg
EndEnumeration

Structure Path
  Item.i
  Path.s
  SubLevel.i
  FolderFlag.i
EndStructure

;*****************************************************************************
;- LISTS

Global NewList Tree.Path()
Global UserName.s, Password.s

;- START
InitNetwork()

;*****************************************************************************
;- PROCEDURES

Procedure MakeTreeGadget()
  ClearGadgetItems(#TreeGadget)
  ForEach Tree()
    If Tree()\FolderFlag
      AddGadgetItem(#TreeGadget, Tree()\Item, Tree()\Path, ImageID(#FolderImg), Tree()\SubLevel)
    Else
      AddGadgetItem(#TreeGadget, Tree()\Item, Tree()\Path, ImageID(#FileImg), Tree()\SubLevel)
    EndIf
  Next
  ;Open folders
  ForEach Tree()
    If Tree()\FolderFlag
      SetGadgetItemState(#TreeGadget, Tree()\Item, #PB_Tree_Expanded)
    EndIf
  Next
EndProcedure

Procedure.i IsFolder(Path.s)
  LastChar.s = Right(Path, 1)
  If LastChar = "\" Or LastChar = "/"
    ProcedureReturn #True
  EndIf
EndProcedure

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
  DisableGadget(#ButtonGetFilesReadOnly, 1)  
  DisableGadget(#ButtonGetFiles, 1)
  DisableGadget(#ButtonSearch, 1)
EndProcedure

Procedure Enabler()
  DisableGadget(#ButtonGetList, 0)
  DisableGadget(#ButtonGetFilesReadOnly, 0)
  DisableGadget(#ButtonGetFiles, 0)
  DisableGadget(#ButtonSearch, 0)
EndProcedure

Procedure Marquee(*Null)
  
  Repeat
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
    Counter + 1
    Delay(10)
  ForEver
  
EndProcedure

Procedure.s GetFullPathFromTree(Item, SubLevel)
  
  Path.s = GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel)
  
  If Item > 0            
    For i = Item - 1 To 0 Step -1
      If GetGadgetItemAttribute(#TreeGadget, i, #PB_Tree_SubLevel) < SubLevel
        Debug "Parent Item : " + RSet(Str(i),2,"0") + " Parent text : " + GetGadgetItemText(#TreeGadget, i, #PB_Tree_SubLevel)
        Path = GetGadgetItemText(#TreeGadget, i, #PB_Tree_SubLevel) + Path
        SubLevel = GetGadgetItemAttribute(#TreeGadget, i, #PB_Tree_SubLevel)     
      EndIf
    Next      
  Else
    Debug "Item doesn't have a parent"         
  EndIf
   
  ProcedureReturn Path
  
EndProcedure

;Get file list on google servers and construct tree list
Procedure GetFileList(Item, SubLevel, Path.s)
  ;Disabler()
  
  FoldersNb = 0
  NewItemsNb = 0
  If Item <> 0 
    SelectElement(Tree(), Item - 1)
  Else
    ResetList(tree())
  EndIf
  
  FirstItem = Item
    
  svn = RunProgram("svn\bin\svn.exe", "list " + Chr(34) + "http://pb-source-repositery.googlecode.com/svn/trunk/" + Path + Chr(34), "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error )
  If svn
    
    While ProgramRunning(svn)     
            
      If AvailableProgramOutput(svn)
        Error.s =  ReadProgramError(svn)
        If Error <> ""
          Debug Error
        EndIf
        NewPath.s = ReadProgramString(svn)
        If NewPath<> ""
          AddElement(Tree())
          Tree()\Item = Item
          Tree()\SubLevel = SubLevel
          Tree()\Path = NewPath
          Debug "----"
          Debug NewPath
          Debug Item          
          If IsFolder(NewPath.s)
            Tree()\FolderFlag = #True
            FoldersNb + 1
          EndIf
          ;AddGadgetItem(#TreeGadget, Item, NewPath, 0, SubLevel)
          NewItemsNb + 1
          Item + 1
        EndIf
        ;Item + 1       
      EndIf
      Delay(10)

    Wend
    
    Error.s =  ReadProgramError(svn)
    If Error <> ""
      Debug Error
    EndIf

    CloseProgram(svn) ; Close the connection to the program
    
    If Item <> FirstItem
      Debug "First Item : " + Str(FirstItem)
      Debug "Last Item : " + Str(Item)
      Debug "Folders Nb : " + Str(FoldersNb)
      Debug "NewItemsNb : " + Str(NewItemsNb)
      
      ;Renumber to the end of the list
      While NextElement(Tree())
        Tree()\Item = Item
        Item + 1
      Wend

      CompilerIf #PB_Compiler_Debugger
        Debug "*******"
        ForEach Tree()
          Debug "Item Nb " + Str(Tree()\Item) + " Sublevel " + Str(tree()\SubLevel) + " Value " + tree()\Path + " Folder " + Str(tree()\FolderFlag)
        Next
      CompilerEndIf
      
      ;Sort by files/folders the new entries
      If NewItemsNb > 0
        SortStructuredList(Tree(), #PB_Sort_Descending, OffsetOf(Path\FolderFlag), #PB_Sort_Integer, FirstItem, FirstItem + NewItemsNb - 1) ;First : sort all
        ;Sort by names
        If FoldersNb > 0
          SortStructuredList(Tree(), #PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(Path\Path), #PB_Sort_String, FirstItem, FirstItem + FoldersNb - 1) ; then folders
        EndIf
        SortStructuredList(Tree(), #PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(Path\Path), #PB_Sort_String, FirstItem + FoldersNb, FirstItem + NewItemsNb - 1) ;and files
      EndIf
      CompilerIf #PB_Compiler_Debugger
        Debug "*******"
        ForEach Tree()
          Debug "Item Nb " + Str(Tree()\Item) + " Sublevel " + Str(tree()\SubLevel) + " Value " + tree()\Path + " Folder " + Str(tree()\FolderFlag)
        Next
      CompilerEndIf
      Debug "*******"
      ;Renumber all the list
      Item = 0
      ForEach Tree()
        Tree()\Item = Item
        Item + 1
        Debug "Item Nb " + Str(Tree()\Item) + " Sublevel " + Str(tree()\SubLevel) + " Value " + tree()\Path + " Folder " + Str(tree()\FolderFlag)
      Next
  
    EndIf
      
  EndIf
  ;Enabler()  
EndProcedure

Procedure Search(*Pattern.s)
   
  ClearGadgetItems(#TreeGadget)
  ClearList(Tree())
  ;SetGadgetText(#ButtonSearch, "Please Wait")

  Item = 0
  
  CreateRegularExpression(0, *Pattern)
  svn = RunProgram("svn\bin\svn.exe", "list " + Chr(34) + "http://pb-source-repositery.googlecode.com/svn/trunk/" + Chr(34) + " -R", "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error )
  
  If svn
   
    While ProgramRunning(svn)     
      
      If AvailableProgramOutput(svn)
        Error.s =  ReadProgramError(svn)
        If Error <> ""
          Debug Error
        EndIf
        Path.s = ReadProgramString(svn)
        Debug Path
        If Path<> "" And MatchRegularExpression(0, Path)
          ;AddElement(Tree())
          ;Tree()\Item = Item
          ;Tree()\SubLevel = SubLevel
          ;Tree()\Path = Path
          ;Debug "----"
          Debug Path
          Debug Item          
          ;If IsFolder(Path.s)
          ;  Tree()\FolderFlag = #True
          ;  FoldersNb + 1
          ;EndIf
          ;Directly adding to the TreeGadget to not have to wait for result
          AddGadgetItem(#TreeGadget, Item, Path)
          ;NewItemsNb + 1
          Item + 1
        EndIf
        ;Item + 1       
      EndIf
      Delay(10)
      
    Wend
  EndIf
  
  ;MakeTreeGadget()
  FreeGadget(#ButtonStopSearch)
  ButtonGadget(#ButtonSearch, 310, 10, 130, 20, "Rechercher")  
  Enabler()

EndProcedure

;Télécharge en local une version "lecture seule" sur le serveur
Procedure GetFilesReadOnly(nil)
  
  svn = RunProgram("svn\bin\svn.exe","checkout http://pb-source-repositery.googlecode.com/svn/trunk/ repositeries\pb-source-repositery-Read-only", "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error)
  
  If svn
    While ProgramRunning(svn)     
      If AvailableProgramOutput(svn)
        Error.s =  ReadProgramError(svn)
        If Error <> ""
          Debug Error
        EndIf
        AddGadgetItem (#TreeGadget, -1, ReadProgramString(svn))
      EndIf
      Delay(10)
      Counter + 1
    Wend
    
    Error.s =  ReadProgramError(svn)
    If Error <> ""
      Debug Error
    EndIf
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  
  RunProgram("explorer.exe", "repositeries\pb-source-repositery-Read-only", "")
  
EndProcedure

Procedure GetFiles(nil)
  
  svn = RunProgram("svn\bin\svn.exe","checkout https://pb-source-repositery.googlecode.com/svn/trunk/ repositeries\pb-source-repositery --username " + UserName + " --password " + Password, "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error)
  
  If svn
    While ProgramRunning(svn)     
      If AvailableProgramOutput(svn)
        Error.s =  ReadProgramError(svn)
        If Error <> ""
          Debug Error
        EndIf
        AddGadgetItem (#TreeGadget, -1, ReadProgramString(svn))
      EndIf
      Delay(10)
      Counter + 1
    Wend
    
    Error.s =  ReadProgramError(svn)
    If Error <> ""
      Debug Error
    EndIf
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  
  RunProgram("explorer.exe", "repositeries\pb-source-repositery", "")
  
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

;*****************************************************************************
;- MAIN

If OpenWindow(0, 0, 0, 450, 350, "Google Code Subversion Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  StringGadget(#StringSearch, 10, 10, 300, 20, "")
  ButtonGadget(#ButtonSearch, 310, 10, 130, 20, "Rechercher")  
  ButtonGadget(#ButtonGetList, 10, 30, 430, 20, "Liste des fichiers sur le serveur")  
  TreeGadget(#TreeGadget, 10, 50, 430, 250)
  StringGadget(#StringUsername, 10, 300, 150, 20, "Nom d'utilisateur")
  StringGadget(#StringPassword, 10, 320, 150, 20, "Mot de passe")
  ButtonGadget(#ButtonUpdate, 170, 300, 100, 20, "Recevoir MàJ")
  ButtonGadget(#ButtonCommit, 170, 320, 100, 20, "Envoyer MàJ")
  ButtonGadget(#ButtonGetFilesReadOnly, 280, 300, 160, 20, "Recevoir dépôt en lecture")
  ButtonGadget(#ButtonGetFiles, 280, 320, 160, 20, "Recevoir dépôt acc. complet")
  StringGadget(#StringSearch, 10, 10, 300, 20, "")

  If LoadImage(#FolderImg, "gfx\FolderIcon16x16.png") = #False
    Debug "Folder img loading failed"  
  EndIf
  If LoadImage(#FileImg, "gfx\FileIcon16x16.png") = #False
    Debug "File img loading failed"  
  EndIf

  Repeat 
    Event = WaitWindowEvent()
    
    Select Event
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
            
          Case #ButtonGetList
            
            ClearList(Tree())
            SetGadgetText(#ButtonGetList, "Please Wait")
            GetFileList(0, 0, "")
            MakeTreeGadget()
            SetGadgetText(#ButtonGetList, "Liste des fichiers sur le serveur")            
            
          Case #ButtonSearch
            
            Disabler()
            FreeGadget(#ButtonSearch)
            ButtonGadget(#ButtonStopSearch, 310, 10, 130, 20, "Arrêter la recherche")
            Pattern.s = GetGadgetText(#StringSearch)
            SearchThread = CreateThread(@Search(), @Pattern)
            
          Case #ButtonStopSearch
            
            KillThread(SearchThread)
            FreeGadget(#ButtonStopSearch)
            ButtonGadget(#ButtonSearch, 310, 10, 130, 20, "Rechercher")  
            Enabler()
            
          Case #ButtonGetFilesReadOnly
            
            Disabler()
            SetGadgetText(#ButtonGetFilesReadOnly, "Please Wait")
            CreateThread(@GetFilesReadOnly(), nil)
            SetGadgetText(#ButtonGetFilesReadOnly, "Recevoir dépôt en lecture")
            Enabler()
            
          Case #ButtonGetFiles
            
            Disabler()
            UserName = GetGadgetText(#StringUserName)
            Password = GetGadgetText(#StringPassword)
            ReplaceString(Password, Chr(32), "_")
            ReplaceString(UserName, Chr(32), "_")
            SetGadgetText(#ButtonGetFiles, "Please Wait")
            CreateThread(@GetFiles(), nil)
            SetGadgetText(#ButtonGetFiles, "Recevoir dépôt acc. complet")
            Enabler()

          Case #TreeGadget
            
            Select EventType()
                
              Case #PB_EventType_LeftDoubleClick
               
                Item = GetGadgetState(#TreeGadget)
                SubLevel = GetGadgetItemAttribute(#TreeGadget, Item, #PB_Tree_SubLevel)
                Name.s = GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel)
                FullPath.s = GetFullPathFromTree(Item, SubLevel)
                Debug "--------------------"
                Debug "Item : " + Str(Item)
                Debug "SubLevel : " + Str(SubLevel)
                Debug "Full name : " + FullPath
                
                ;If folder, look into
                If IsFolder(Name)
                  SetGadgetText(#ButtonGetList, "Please Wait")
                  GetFileList(Item + 1, SubLevel + 1, FullPath)
                  MakeTreeGadget()                
                  SetGadgetText(#ButtonGetList, "Liste des fichiers sur le serveur")                
                Else
                  ;If file, download it
                  Name = GetFilePart(Name) ;In case where the Name is coming from a search with a full path
                  Filename$ = SaveFileRequester("Where to save " + Name + " ?", Name, "", 0)
                  If URLDownloadToFile_(0,"https://pb-source-repositery.googlecode.com/svn/trunk/" + FullPath, Filename$, 0, 0) = #S_OK
                    Debug "Success"  
                  Else
                    Debug "Failed"
                    MessageRequester("Alert", "Can't save the specified file", #PB_MessageRequester_Ok)
                  EndIf
                EndIf
                
            EndSelect
            
        EndSelect
        
    EndSelect
    
  Until Event = #PB_Event_CloseWindow
  
EndIf

End

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 303
; FirstLine = 279
; Folding = ---
; EnableThread
; EnableXP