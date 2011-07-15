UsePNGImageDecoder()

;*****************************************************************************
;- CONSTANTS

Enumeration 
  #TextRepositery
  #StringRepositery
  #ButtonRepositery
  #StringSearch
  #TextUsername
  #TextPassword
  #StringUsername
  #StringPassword
  #StringUpdateComment
  #ButtonGetList
  #ButtonGetFilesReadOnly
  #ButtonGetFiles
  #ButtonSearch
  #ButtonCommit
  #ButtonUpdate
  #END_OF_THE_GADGETS_TO_DISABLE
  #ButtonStopSearch
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
Global RepositeryURL.s = "https://pb-source-repositery.googlecode.com/svn/trunk/"

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
  For i = 0 To #END_OF_THE_GADGETS_TO_DISABLE - 1
    If IsGadget(i)
      DisableGadget(i, 1)
    EndIf  
  Next i
EndProcedure

Procedure Enabler()
  For i = 0 To #END_OF_THE_GADGETS_TO_DISABLE - 1
    If IsGadget(i)
      DisableGadget(i, 0)
    EndIf
  Next i
EndProcedure

Procedure Marquee(*Null)
  
  Repeat
    txt.s = "Veuillez patienter" 
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
    
  svn = RunProgram("svn\bin\svn.exe", "list " + Chr(34) + RepositeryURL + Path + Chr(34), "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error )
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
  ;SetGadgetText(#ButtonSearch, "Veuillez patienter")

  Item = 0
  
  CreateRegularExpression(0, *Pattern)
  svn = RunProgram("svn\bin\svn.exe", "list " + RepositeryURL + " -R", "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error )
  
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
  ButtonGadget(#ButtonSearch, 310, 30, 130, 20, "Rechercher")  
  Enabler()

EndProcedure

;Télécharge en local une version "lecture seule" sur le serveur
Procedure GetFilesReadOnly(nil)
  
  svn = RunProgram("svn\bin\svn.exe","checkout " + RepositeryURL + " repositeries\pb-source-repositery-Read-only", "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error)
  
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
  
  SetGadgetText(#ButtonGetFilesReadOnly, "Recevoir une copie du dépôt en lecture seule")
  Enabler()
  
EndProcedure

Procedure Update(nil)
  ; repositeries\pb-source-repositery --username " + UserName + " --password " + Password
  svn = RunProgram("svn\bin\svn.exe","update repositeries\pb-source-repositery", "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error)
  
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
      
EndProcedure

Procedure Commit(nil)
  ; repositeries\pb-source-repositery --username " + UserName + " --password " + Password
  svn = RunProgram("svn\bin\svn.exe","commit repositeries\pb-source-repositery -m " + Chr(34) + GetGadgetText(#StringUpdateComment) + Chr(34), "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error)
  
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
      
EndProcedure

Procedure GetFiles(nil)
  
  svn = RunProgram("svn\bin\svn.exe","checkout " + RepositeryURL + " repositeries\pb-source-repositery --username " + UserName + " --password " + Password, "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error)
  
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
  
  SetGadgetText(#ButtonGetFiles, "Recevoir dépôt accès complet")
  Enabler()  
  
EndProcedure

Procedure MakeDirOnRepositery(Url.s, UserName.s, Password.s, LocalFolder.s, PleaseWaitButton.i)
  
  Disabler()
  
  txt.s = "Veuillez patienter"
  Counter = 0
  svn = RunProgram("svn\bin\svn.exe","mkdir " + Url + " --username " + UserName + " --password " + Password, "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error)
  If svn
    While ProgramRunning(svn)     
      txt.s = "Veuillez patienter" 
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

If OpenWindow(0, 0, 0, 450, 420, "Google Code Subversion Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  TextGadget(#TextRepositery, 10, 11, 80, 20, "URL du dépôt")
  StringGadget(#StringRepositery, 80, 9, 360, 20, RepositeryURL)
  StringGadget(#StringSearch, 10, 30, 300, 20, "")
  ButtonGadget(#ButtonSearch, 310, 30, 130, 20, "Rechercher")  
  ButtonGadget(#ButtonGetList, 10, 50, 430, 20, "Parcourir le dépôt sur le serveur")
  TreeGadget(#TreeGadget, 10, 70, 430, 250)
  ButtonGadget(#ButtonGetFilesReadOnly, 10, 320, 430, 20, "Recevoir une copie du dépôt en lecture seule")
  TextGadget(#TextUsername, 10, 350, 80, 20, "Nom d'utilisateur")
  StringGadget(#StringUsername, 91, 348, 120, 20, "")
  TextGadget(#TextPassword, 240, 350, 130, 20, "Mot de passe")
  StringGadget(#StringPassword, 307, 348, 132, 20, "")
  ButtonGadget(#ButtonGetFiles, 10, 370, 331, 20, "Recevoir une nouvelle copie de travail du dépôt")
  ButtonGadget(#ButtonUpdate, 340, 370, 100, 20, "Recevoir MàJ")
  StringGadget(#StringUpdateComment, 10, 390, 330, 20, "Mise à jour " + Str(Date()))
  GadgetToolTip(#StringUpdateComment, "Commentaire de mise à jour")
  ButtonGadget(#ButtonCommit, 340, 390, 100, 20, "Envoyer MàJ")

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
            
          Case  #StringRepositery
            
            Select EventType()
                
              Case #PB_EventType_Change 
                
                RepositeryURL = GetGadgetText(#StringRepositery)
                
            EndSelect
            
          Case  #StringUpdateComment
            
            Select EventType()
                
              Case #PB_EventType_Change 

                If Trim(GetGadgetText(#StringUpdateComment)) = ""
                  
                  SetGadgetText(#StringUpdateComment, "Mise à jour " + Str(Date()))
                  
                EndIf
                
            EndSelect
                  
          Case  #StringUsername
            
            Select EventType()
                
              Case #PB_EventType_Change
                
                If FindString(GetGadgetText(#StringUsername), " ")
                  MessageRequester("Alerte", "Votre nom d'utilisateur ne peut contenir d'espace", #PB_MessageRequester_Ok)
                  SetGadgetText(#StringUsername, "")
                EndIf
                                
            EndSelect
            
         Case  #StringPassword
            
            Select EventType()
                
              Case #PB_EventType_Change 
                
                If FindString(GetGadgetText(#StringPassword), " ")
                  MessageRequester("Alerte", "Votre mot de passe ne peut contenir d'espace", #PB_MessageRequester_Ok)
                  SetGadgetText(#StringPassword, "")
                EndIf
                
            EndSelect

          Case #ButtonSearch
            
            Disabler()
            FreeGadget(#ButtonSearch)
            ButtonGadget(#ButtonStopSearch, 310, 30, 130, 20, "Arrêter la recherche")
            Pattern.s = GetGadgetText(#StringSearch)
            SearchThread = CreateThread(@Search(), @Pattern)
            
          Case #ButtonStopSearch
            
            KillThread(SearchThread)
            FreeGadget(#ButtonStopSearch)
            ButtonGadget(#ButtonSearch, 310, 30, 130, 20, "Rechercher")  
            Enabler()
            
          Case #ButtonGetFilesReadOnly
            
            Disabler()
            ClearList(Tree())
            SetGadgetText(#ButtonGetFilesReadOnly, "Veuillez patienter")
            CreateThread(@GetFilesReadOnly(), nil)
            
          Case #ButtonGetFiles
            
            Disabler()
            ClearList(Tree())
            UserName = GetGadgetText(#StringUserName)
            Password = GetGadgetText(#StringPassword)
            SetGadgetText(#ButtonGetFiles, "Veuillez patienter")
            CreateThread(@GetFiles(), nil)
            
          Case #ButtonUpdate
            
            ClearList(Tree())
            SetGadgetText(#ButtonUpdate, "Veuillez patienter")
            Update(nil)
            SetGadgetText(#ButtonUpdate, "Recevoir MàJ")            
            
          Case #ButtonCommit
            
            ClearList(Tree())
            SetGadgetText(#ButtonCommit, "Veuillez patienter")
            Commit(nil)
            SetGadgetText(#ButtonCommit, "Envoyer MàJ")            
            
          Case #ButtonGetList
            
            ClearList(Tree())
            SetGadgetText(#ButtonGetList, "Veuillez patienter")
            GetFileList(0, 0, "")
            MakeTreeGadget()
            SetGadgetText(#ButtonGetList, "Parcourir le dépôt sur le serveur")            

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
                  SetGadgetText(#ButtonGetList, "Veuillez patienter")
                  GetFileList(Item + 1, SubLevel + 1, FullPath)
                  MakeTreeGadget()
                  SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
                  SetGadgetState(#TreeGadget, Item)
                  SetGadgetText(#ButtonGetList, "Parcourir le dépôt sur le serveur")                
                Else
                  ;If file, download it
                  Name = GetFilePart(Name) ;In case where the Name is coming from a search with a full path
                  Filename$ = SaveFileRequester("Où enregistrer le fichier " + Name + " ?", Name, "", 0)
                  If URLDownloadToFile_(0,"" + RepositeryURL + "" + FullPath, Filename$, 0, 0) = #S_OK
                    Debug "Download succeded"  
                  Else
                    Debug "Download failed"
                    MessageRequester("Alerte", "Enregistrement impossible", #PB_MessageRequester_Ok)
                  EndIf
                EndIf
                
            EndSelect
            
        EndSelect
        
    EndSelect
    
  Until Event = #PB_Event_CloseWindow
  
EndIf

End

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 129
; FirstLine = 125
; Folding = ---
; EnableThread
; EnableXP