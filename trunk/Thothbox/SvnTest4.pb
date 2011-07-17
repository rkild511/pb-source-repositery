UsePNGImageDecoder()

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  #PathSeparator = "\"
CompilerElse 
  #PathSeparator = "/"
CompilerEndIf
  
;*****************************************************************************
;- CONSTANTS

Enumeration 
  #TextRemoteRepositery
  #StringRemoteRepositery
  #StringSearch
  #ButtonSearch
  #ButtonExploreRemoteRepositery
  #TextLocalRepositery
  #StringLocalRepositery
  #ButtonChangeLocalRepositery
  #ButtonGetRepositeryReadOnly
  #ButtonExploreLocalRepositery
  #TextUsername
  #StringUsername
  #TextPassword
  #StringPassword
  #ButtonGetRepositery
  #StringUpdateComment
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

#SVNConfigProxyHost     = " --config-option servers:global:http-proxy-host="
#SVNConfigProxyPort     = " --config-option servers:global:http-proxy-port="
#SVNConfigProxyUserName = " --config-option servers:global:http-proxy-username="
#SVNConfigProxyPassword = " --config-option servers:global:http-proxy-password="

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
Global RemoteRepositery.s = "https://pb-source-repositery.googlecode.com/svn/trunk/"
Global LocalRepositery.s = GetCurrentDirectory() + "repositeries\pb-source-repositery\"
;Global LocalRepositeryReadOnly.s = GetCurrentDirectory() + "repositeries\pb-source-repositery-ReadOnly"
Global ProxyFlag.i = #False
Global SVNConfigProxyHost.s = "94.23.49.197"
Global SVNConfigProxyPort.s = "8080"
Global SVNConfigProxyUserName.s = "anonymous"
Global SVNConfigProxyPassword.s = "anonymous@anonymous.com"

InitNetwork()

;*****************************************************************************
;- PROCEDURES

Procedure SubversionCall(SvnArgs.s, Path.s = "")

  If ProxyFlag
    SvnArgs + #SVNConfigProxyHost + SVNConfigProxyHost + #SVNConfigProxyPort + SVNConfigProxyPort + #SVNConfigProxyUserName + SVNConfigProxyUserName + #SVNConfigProxyPassword + SVNConfigProxyPassword
  EndIf
  SvnArgs + " --non-interactive --no-auth-cache"
  Debug SvnArgs   
  
  ProcedureReturn RunProgram("svn\bin\svn.exe", SvnArgs, Path, #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error )

EndProcedure

Procedure MakeTreeGadget()
  ClearGadgetItems(#TreeGadget)
  ForEach Tree()
    If Tree()\FolderFlag
      AddGadgetItem(#TreeGadget, Tree()\Item, Tree()\Path, ImageID(#FolderImg), Tree()\SubLevel)
      SetGadgetItemData(#TreeGadget, Tree()\Item, #True)
    Else
      AddGadgetItem(#TreeGadget, Tree()\Item, Tree()\Path, ImageID(#FileImg), Tree()\SubLevel)
      SetGadgetItemData(#TreeGadget, Tree()\Item, #False)
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
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

;Ne sert pas ici, mais �a peut servir plus tard ;)
Procedure.s GetStdOut(Prog.s, Arg.s)
  svn = RunProgram(Prog, Arg, "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open )
  Output$ = ""
  If svn
    While ProgramRunning(svn)
      While AvailableProgramOutput(svn)
        Output$ + ReadProgramString(svn) + Chr(13)
      Wend
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
    SetGadgetText(#ButtonExploreRemoteRepositery, txt)
    Counter + 1
    Delay(10)
  ForEver
  
EndProcedure

; Take over a gadget tree to obtain a full path from a sub level item
Procedure.s GetFullPathFromTree(Item, SubLevel)
  
  Path.s = GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel)
  
  If Item > 0            
    For i = Item - 1 To 0 Step -1
      If GetGadgetItemAttribute(#TreeGadget, i, #PB_Tree_SubLevel) < SubLevel
        Debug "Parent Item : " + RSet(Str(i),2,"0") + " Parent text : " + GetGadgetItemText(#TreeGadget, i, #PB_Tree_SubLevel)
          If GetGadgetItemData(#TreeGadget, i) And IsFolder(GetGadgetItemText(#TreeGadget, i, #PB_Tree_SubLevel)) = #False
          ;If this is a folder and path separatator is not in the item text
          Path = GetGadgetItemText(#TreeGadget, i, #PB_Tree_SubLevel) + #PathSeparator + Path
        Else
          Path = GetGadgetItemText(#TreeGadget, i, #PB_Tree_SubLevel) + Path
        EndIf
        SubLevel = GetGadgetItemAttribute(#TreeGadget, i, #PB_Tree_SubLevel)     
      EndIf
    Next      
  Else
    Debug "Item doesn't have a parent"         
  EndIf
   
  ProcedureReturn Path
  
EndProcedure

;Get file list on google servers and construct tree list
Procedure GetRemoteFileList(Item, SubLevel, Path.s)
  ;Disabler()
  
  FoldersNb = 0
  NewItemsNb = 0
  
  If Item <> 0 
    ;If this is not the root
    
    SelectElement(Tree(), Item - 1 )
    While NextElement(tree()) And Tree()\SubLevel >= Sublevel  
      ;Delete all the elements in the current folder (when double click on already explored, to avoid doublons)
      DeleteElement(Tree())
    Wend
    
    SelectElement(Tree(), Item - 1)  
  Else
    ResetList(tree())
  EndIf
  
  FirstItem = Item
  
  svn = SubversionCall("list " + Chr(34) + RemoteRepositery + Path + Chr(34))
  
  If svn
    
    While ProgramRunning(svn)     
            
      While AvailableProgramOutput(svn)
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
      Wend
      Delay(10)

    Wend
    
    Repeat
      Error.s =  ReadProgramError(svn)
      Debug Error
    Until Error = ""

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

;Get file list on local repositery and construct tree list
Procedure GetLocalFileList(Item, SubLevel, Path.s)
  ;Disabler()
  
  FoldersNb = 0
  NewItemsNb = 0
  
  If Item <> 0 
    ;If this is not the root
    
    SelectElement(Tree(), Item - 1 )
    While NextElement(tree()) And Tree()\SubLevel >= Sublevel  
      ;Delete all the elements in the current folder (when double click on already explored, to avoid doublons)
      DeleteElement(Tree())
    Wend

    SelectElement(Tree(), Item - 1)
  Else
    ResetList(tree())
  EndIf
  
  FirstItem = Item
  
  ;Debug LocalRepositery + Path
  If ExamineDirectory(0, LocalRepositery + Path, "*.*")  
    While NextDirectoryEntry(0)
      NewPath.s = DirectoryEntryName(0)
      If NewPath <> "" And Left(NewPath, 1) <> "."
        AddElement(Tree())
        Tree()\Item = Item
        Tree()\SubLevel = SubLevel
        Tree()\Path = NewPath
        Debug "----"
        Debug NewPath
        Debug Item          
        If DirectoryEntryType(0) <> #PB_DirectoryEntry_File
          ;If it's a folder
          Tree()\FolderFlag = #True
          ;Tree()\Path
          FoldersNb + 1
        EndIf
        ;AddGadgetItem(#TreeGadget, Item, NewPath, 0, SubLevel)
        NewItemsNb + 1
        Item + 1
      EndIf
      ;Item + 1       
    Wend
    FinishDirectory(0)
   
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
  svn = SubversionCall("list " + RemoteRepositery + " -R")
    
  If svn
   
    While ProgramRunning(svn)     
      
      While AvailableProgramOutput(svn)
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
      Wend
      Delay(10)
      
    Wend
  EndIf
  
  Repeat
    Error.s =  ReadProgramError(svn)
    Debug Error
  Until Error = ""
  
  ;MakeTreeGadget()
  FreeGadget(#ButtonStopSearch)
  ButtonGadget(#ButtonSearch, 310, 30, 130, 20, "Rechercher")  
  Enabler()

EndProcedure

;T�l�charge en local une version "lecture seule" sur le serveur
Procedure GetRepositeryReadOnly(nil)
   
  svn = SubversionCall("checkout " + RemoteRepositery + " " + LocalRepositery)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ReadProgramError(svn)
        If Error <> ""
          Debug Error
        EndIf
        AddGadgetItem (#TreeGadget, -1, ReadProgramString(svn))
      Wend
      Delay(10)
      Counter + 1
    Wend
    
    Repeat
      Error.s =  ReadProgramError(svn)
      Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  
  RunProgram("explorer.exe", LocalRepositery, "")
  
  SetGadgetText(#ButtonGetRepositeryReadOnly, "Recevoir une copie du d�p�t en lecture seule")
  Enabler()
  
EndProcedure

Procedure Update(nil)
  ; repositeries\pb-source-repositery --username " + UserName + " --password " + Password
   
  svn = SubversionCall("update " + LocalRepositery + " --username " + UserName + " --password " + Password)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ReadProgramError(svn)
        If Error <> ""
          Debug Error
        EndIf
        AddGadgetItem (#TreeGadget, -1, ReadProgramString(svn))
      Wend
      Delay(10)
      Counter + 1
    Wend
    
    Repeat
      Error.s =  ReadProgramError(svn)
      Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
      
EndProcedure

Procedure Commit(nil)
  ; repositeries\pb-source-repositery --username " + UserName + " --password " + Password
   
  svn = SubversionCall("commit " + " --username " + UserName + " --password " + Password + " -m " + Chr(34) + GetGadgetText(#StringUpdateComment) + Chr(34), LocalRepositery )
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ReadProgramError(svn)
        If Error <> ""
          Debug Error
        EndIf
        AddGadgetItem (#TreeGadget, -1, ReadProgramString(svn))
      Wend
      Delay(10)
      Counter + 1
    Wend
    
    Repeat
      Error.s =  ReadProgramError(svn)
      Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  Else
    Debug "Erreur!"
  EndIf
      
EndProcedure

Procedure GetRepositery(nil)
   
  svn = SubversionCall("checkout " + RemoteRepositery + " " + LocalRepositery + " --username " + UserName + " --password " + Password)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ReadProgramError(svn)
        If Error <> ""
          Debug Error
        EndIf
        AddGadgetItem (#TreeGadget, -1, ReadProgramString(svn))
      Wend
      Delay(10)
      Counter + 1
    Wend
    
    Repeat
      Error.s =  ReadProgramError(svn)
      Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  
  RunProgram("explorer.exe", LocalRepositery, "")
  
  SetGadgetText(#ButtonGetRepositery, "Recevoir d�p�t acc�s complet")
  Enabler()  
  
EndProcedure

Procedure MakeDirOnRepositery(Url.s, UserName.s, Password.s, LocalFolder.s, PleaseWaitButton.i)
  
  Disabler()
  
  txt.s = "Veuillez patienter"
  Counter = 0
  
  svn = SubversionCall("mkdir " + Url + " --username " + UserName + " --password " + Password)
  
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

If OpenWindow(0, 0, 0, 450, 430, "ThotBox SubVersion Tiny FrontEnd", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  TextGadget(#TextRemoteRepositery, 10, 11, 80, 20, "URL du d�p�t")
  StringGadget(#StringRemoteRepositery, 80, 9, 360, 20, RemoteRepositery)
  StringGadget(#StringSearch, 10, 30, 300, 20, "")
  ButtonGadget(#ButtonSearch, 310, 30, 130, 20, "Rechercher")  
  ButtonGadget(#ButtonExploreRemoteRepositery, 10, 50, 430, 20, "Explorer le d�p�t sur le serveur")
  TreeGadget(#TreeGadget, 10, 70, 430, 250)
  TextGadget(#TextLocalRepositery, 10, 323, 120, 20, "D�p�t local")
  StringGadget(#StringLocalRepositery, 80, 321, 280, 20, LocalRepositery)
  GadgetToolTip(#StringLocalRepositery, "Dossier local du d�p�t. Il sera cr�� s'il n'existe pas.")
  ButtonGadget(#ButtonChangeLocalRepositery, 360, 321, 80, 20, "Parcourir")  
  ButtonGadget(#ButtonGetRepositeryReadOnly, 10, 341, 240, 20, "Recevoir une copie du d�p�t en lecture seule") 
  ButtonGadget(#ButtonExploreLocalRepositery, 250, 341, 190, 20, "Explorer le d�p�t local") 
  TextGadget(#TextUsername, 10, 372, 80, 20, "Nom d'utilisateur")
  StringGadget(#StringUsername, 91, 370, 120, 20, "")
  TextGadget(#TextPassword, 239, 372, 65, 20, "Mot de passe")
  StringGadget(#StringPassword, 307, 370, 132, 20, "")
  ButtonGadget(#ButtonGetRepositery, 10, 390, 331, 20, "Recevoir une copie de travail du d�p�t")
  ButtonGadget(#ButtonUpdate, 340, 390, 100, 20, "Recevoir M�J")
  StringGadget(#StringUpdateComment, 10, 410, 330, 20, "Mise � jour " + Str(Date()))
  GadgetToolTip(#StringUpdateComment, "Commentaire de mise � jour")
  ButtonGadget(#ButtonCommit, 340, 410, 100, 20, "Envoyer M�J")

  If LoadImage(#FolderImg, "gfx\FolderIcon16x16.png") = #False
    Debug "Folder img loading failed"  
  EndIf
  If LoadImage(#FileImg, "gfx\FileIcon16x16.png") = #False
    Debug "File img loading failed"  
  EndIf
  
  LocalExploration.i = #False
  
  Repeat
    
    Event = WaitWindowEvent()
    
    Select Event
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
            
          Case  #StringRemoteRepositery
            
            Select EventType()
                
              Case #PB_EventType_Change 
                
                RemoteRepositery = GetGadgetText(#StringRemoteRepositery)
                
            EndSelect
            
          Case  #StringLocalRepositery
            
            Select EventType()
                
              Case #PB_EventType_LostFocus
                
                LocalRepositery = GetGadgetText(#StringLocalRepositery)
                If IsFolder(LocalRepositery) = #False
                  LocalRepositery + #PathSeparator
                EndIf
                              
            EndSelect

          Case  #StringUpdateComment
            
            Select EventType()
                
              Case #PB_EventType_Change 

                If Trim(GetGadgetText(#StringUpdateComment)) = ""
                  ;Default comment
                  SetGadgetText(#StringUpdateComment, "Mise � jour " + Str(Date()))
                EndIf
                
            EndSelect
                  
          Case  #StringUsername
            
            Select EventType()
                
              Case #PB_EventType_LostFocus
                
                If FindString(GetGadgetText(#StringUsername), " ")
                  MessageRequester("Alerte", "Votre nom d'utilisateur ne peut contenir d'espace", #PB_MessageRequester_Ok)
                  SetGadgetText(#StringUsername, "")
                EndIf
                UserName = GetGadgetText(#StringUsername)
                                
            EndSelect
            
         Case  #StringPassword
            
            Select EventType()
                
              Case #PB_EventType_LostFocus 
                
                If FindString(GetGadgetText(#StringPassword), " ")
                  MessageRequester("Alerte", "Votre mot de passe ne peut contenir d'espace", #PB_MessageRequester_Ok)
                  SetGadgetText(#StringPassword, "")
                EndIf
                Password = GetGadgetText(#StringPassword)
                
            EndSelect
            
          Case #ButtonSearch
            
            Disabler()
            LocalExploration = #False
            FreeGadget(#ButtonSearch)
            ButtonGadget(#ButtonStopSearch, 310, 30, 130, 20, "Arr�ter la recherche")
            Pattern.s = GetGadgetText(#StringSearch)
            SearchThread = CreateThread(@Search(), @Pattern)
            
          Case #ButtonStopSearch
            
            KillThread(SearchThread)
            LocalExploration = #False
            FreeGadget(#ButtonStopSearch)
            ButtonGadget(#ButtonSearch, 310, 30, 130, 20, "Rechercher")  
            Enabler()
            
          Case #ButtonGetRepositeryReadOnly
            
            Disabler()
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonGetRepositeryReadOnly, "Veuillez patienter")
            CreateThread(@GetRepositeryReadOnly(), nil)
            
          Case #ButtonChangeLocalRepositery
            
            If FileSize(LocalRepositery) = - 2 
              ;If folder exists
              LocalRepositery = PathRequester("Dossier du d�p�t local", LocalRepositery)
            Else  
              ;Else local app folder
              LocalRepositery = PathRequester("Dossier du d�p�t local", GetCurrentDirectory())
            EndIf
            
            SetGadgetText(#StringLocalRepositery, LocalRepositery)
            
          Case #ButtonGetRepositery
            
            Disabler()
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            UserName = GetGadgetText(#StringUserName)
            Password = GetGadgetText(#StringPassword)
            SetGadgetText(#ButtonGetRepositery, "Veuillez patienter")
            CreateThread(@GetRepositery(), nil)
            
          Case #ButtonUpdate
            
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonUpdate, "Veuillez patienter")
            Update(nil)
            SetGadgetText(#ButtonUpdate, "Recevoir M�J")            
            
          Case #ButtonCommit
            
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonCommit, "Veuillez patienter")
            Commit(nil)
            SetGadgetText(#ButtonCommit, "Envoyer M�J")            
            
          Case #ButtonExploreRemoteRepositery
            
            ClearList(Tree())
            SetGadgetText(#ButtonExploreRemoteRepositery, "Veuillez patienter")
            GetRemoteFileList(0, 0, "")
            MakeTreeGadget()
            SetGadgetText(#ButtonExploreRemoteRepositery, "Explorer le d�p�t sur le serveur")
            LocalExploration = #False
            
          Case #ButtonExploreLocalRepositery
            
            If FileSize(LocalRepositery) = -2
              ClearList(Tree())
              SetGadgetText(#ButtonExploreLocalRepositery, "Veuillez patienter")
              GetLocalFileList(0, 0, "")
              MakeTreeGadget()
              SetGadgetText(#ButtonExploreLocalRepositery, "Explorer le d�p�t local")
              LocalExploration = #True
            Else
              MessageRequester("Alerte", "Le dossier n'existe pas encore." + Chr(13) + Chr(13) + "Peut-�tre devriez-vous d'abord " + Chr(34) + " Recevoir une copie du d�p�t ? " + Chr(34) , #PB_MessageRequester_Ok)
            EndIf
              
          Case #TreeGadget
            
            Select EventType()
                
              Case #PB_EventType_LeftDoubleClick
                
                Item = GetGadgetState(#TreeGadget)
                SubLevel = GetGadgetItemAttribute(#TreeGadget, Item, #PB_Tree_SubLevel)
                Name.s = GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel)
                IsFolder = GetGadgetItemData(#TreeGadget, Item)
                FullPath.s = GetFullPathFromTree(Item, SubLevel)
                Debug "--------------------"
                Debug "Item : " + Str(Item)
                Debug "SubLevel : " + Str(SubLevel)
                Debug "Full name : " + FullPath
                
                If LocalExploration
                  
                  ;-Local Exploration

                  If IsFolder
                    ;If folder, look into
                    SetGadgetText(#ButtonExploreRemoteRepositery, "Veuillez patienter")
                    GetLocalFileList(Item + 1, SubLevel + 1, FullPath)
                    MakeTreeGadget()
                    SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
                    SetGadgetState(#TreeGadget, Item)
                    SetGadgetText(#ButtonExploreRemoteRepositery, "Explorer le d�p�t sur le serveur")                
                  EndIf
                    
                Else
                  
                  ;-Remote exploration
                  
                  If IsFolder
                    ;If folder, look into
                    SetGadgetText(#ButtonExploreRemoteRepositery, "Veuillez patienter")
                    GetRemoteFileList(Item + 1, SubLevel + 1, FullPath)
                    MakeTreeGadget()
                    SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
                    SetGadgetState(#TreeGadget, Item)
                    SetGadgetText(#ButtonExploreRemoteRepositery, "Explorer le d�p�t sur le serveur")                
                  Else
                    ;If file, download it
                    Name = GetFilePart(Name) ;In case where the Name is coming from a search with a full path
                    Filename$ = SaveFileRequester("O� enregistrer le fichier " + Name + " ?", Name, "", 0)
                    If URLDownloadToFile_(0,"" + RemoteRepositery + "" + FullPath, Filename$, 0, 0) = #S_OK
                      Debug "Download succeded"  
                    Else
                      Debug "Download failed"
                      MessageRequester("Alerte", "Enregistrement impossible", #PB_MessageRequester_Ok)
                    EndIf
                  EndIf
                EndIf
                
            EndSelect
            
        EndSelect
        
    EndSelect
    
    ;Disable "full access" gadgets if username&password are not given
    If GetGadgetText(#StringUsername) = ""
      DisableGadget(#StringPassword, 1)     
    Else
      DisableGadget(#StringPassword, 0)
    EndIf
    If GetGadgetText(#StringUsername) = "" Or GetGadgetText(#StringPassword) = ""
      DisableGadget(#ButtonGetRepositery, 1)
      DisableGadget(#StringUpdateComment, 1)
      DisableGadget(#ButtonCommit, 1)
      DisableGadget(#ButtonUpdate, 1)
    Else
      DisableGadget(#ButtonGetRepositery, 0)
      DisableGadget(#StringUpdateComment, 0)
      DisableGadget(#ButtonCommit, 0)
      DisableGadget(#ButtonUpdate, 0)      
    EndIf
    
  Until Event = #PB_Event_CloseWindow
  
EndIf

End

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 248
; FirstLine = 99
; Folding = ---
; EnableThread
; EnableXP