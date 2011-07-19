UsePNGImageDecoder()

XIncludeFile "translator.pbi"

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
  #FileImg
  #FolderImg
  #Added
  #Conflicted
  #Suppressed
  #Ignored
  #Modified
  #Remplaced
  #NonVersionnedFolder
  #NonVersionned
  #Missing
  #Dissimulated
  #Locked
  #AddedWithHistory
  #Switched
  #LockToken
  #LockOther
  #LockStolen
  #LockBroken
  #END_OF_IMAGES
EndEnumeration
Enumeration #PB_Compiler_EnumerationValue Step #END_OF_IMAGES
  #FileImgs
  #FolderImgs
  #Pad
EndEnumeration

#SVNConfigProxyHost     = " --config-option servers:global:http-proxy-host="
#SVNConfigProxyPort     = " --config-option servers:global:http-proxy-port="
#SVNConfigProxyUserName = " --config-option servers:global:http-proxy-username="
#SVNConfigProxyPassword = " --config-option servers:global:http-proxy-password="

;*****************************************************************************
;- STRUCTURES

Structure Path
  Item.i
  Path.s
  SubLevel.i
  FolderFlag.i
  Status.s
EndStructure

;*****************************************************************************
;- GLOBALS

Global NewList Tree.Path()
Global UserName.s, Password.s
Global RemoteRepositery.s = "https://pb-source-repositery.googlecode.com/svn/trunk/"
Global LocalRepositery.s = GetCurrentDirectory() + "repositeries\pb-source-repositery\"
;Global LocalRepositeryReadOnly.s = GetCurrentDirectory() + "repositeries\pb-source-repositery-ReadOnly"
Global ProxyFlag.i = #False
Global SVNConfigProxyHost.s = "proxy.cg59.fr"
Global SVNConfigProxyPort.s = "8080"
Global SVNConfigProxyUserName.s = ""
Global SVNConfigProxyPassword.s = ""
Global *MyReadProgramStringBuffer = AllocateMemory(1024)

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

;Coz bug of the MyReadProgramString() in unicode

Procedure.s MyReadProgramString(ProgramNr)
  Static MyReadProgramOffset.i = 0, Size, Char.b, Temp.s
  Size = AvailableProgramOutput(ProgramNr)
  If Size > 0
    Repeat
      ReadProgramData(ProgramNr, @Char, 1)
      PokeB(*MyReadProgramStringBuffer + MyReadProgramOffset, Char)
      MyReadProgramOffset + 1
    Until Char = $0A Or AvailableProgramOutput(ProgramNr) = 0 Or MyReadProgramOffset > 1024
    If Char <> $0A
      ProcedureReturn ""
    Else
      PokeB(*MyReadProgramStringBuffer + MyReadProgramOffset, 0)
      Temp = PeekS(*MyReadProgramStringBuffer, -1, #PB_Ascii)
      MyReadProgramOffset = 0
      ProcedureReturn ReplaceString(ReplaceString(Temp, Chr(13), ""), Chr(10), "")
    EndIf
  EndIf
EndProcedure

Procedure.i StatusImage(Status.s, Folder = #False)
  Static Base
  If Folder
    Base = #FolderImg 
  Else
    Base = #FileImg
  EndIf
  
  Select Status
    Case "A"
      ProcedureReturn ImageID(Base + #Added)
    Case "C"
      ProcedureReturn ImageID(Base + #Conflicted)
    Case "S"
      ProcedureReturn ImageID(Base + #Suppressed)
    Case "I"
      ProcedureReturn ImageID(Base + #Ignored)
    Case "M"
      ProcedureReturn ImageID(Base + #Modified)
    Case "R"
      ProcedureReturn ImageID(Base + #Remplaced)
    Case "X"
      ProcedureReturn ImageID(Base + #NonVersionnedFolder)
    Case "?"
      ProcedureReturn ImageID(Base + #NonVersionned)
    Case "!"
      ProcedureReturn ImageID(Base + #Missing)
    Case "~"
      ProcedureReturn ImageID(Base + #Dissimulated)
    Case "L"
      ProcedureReturn ImageID(Base + #Locked)
    Case "+"
      ProcedureReturn ImageID(Base + #AddedWithHistory)
    Case "S"
      ProcedureReturn ImageID(Base + #Switched)
    Case "K"
      ProcedureReturn ImageID(Base + #LockToken)
    Case "O"
      ProcedureReturn ImageID(Base + #LockOther)
    Case "T"
      ProcedureReturn ImageID(Base + #LockStolen)
    Case "B"
      ProcedureReturn ImageID(Base + #LockBroken)
    Default
      ProcedureReturn ImageID(Base)
  EndSelect       
  
EndProcedure

Procedure MyLoadImage(Nb.i, Filename.s)
  If LoadImage(Nb, Filename) = #False
    Debug "Can't load" + Filename
  EndIf
EndProcedure

Procedure PrepareImages()
  Static i
  
  MyLoadImage(#FolderImg, "gfx\FolderIcon16x16.png")
  MyLoadImage(#FileImg, "gfx\FileIcon16x16.png")
  
  MyLoadImage(#Added, "gfx\AIcon16x16.png")
  MyLoadImage(#Conflicted, "gfx\CIcon16x16.png")
  MyLoadImage(#Suppressed, "gfx\SIcon16x16.png")
  MyLoadImage(#Ignored, "gfx\IIcon16x16.png")
  MyLoadImage(#Modified, "gfx\MIcon16x16.png")
  MyLoadImage(#Remplaced, "gfx\RIcon16x16.png")
  MyLoadImage(#NonVersionnedFolder, "gfx\XIcon16x16.png")
  MyLoadImage(#NonVersionned, "gfx\NVIcon16x16.png")
  MyLoadImage(#Missing, "gfx\!Icon16x16.png")
  MyLoadImage(#Dissimulated, "gfx\~Icon16x16.png")
  MyLoadImage(#Locked, "gfx\LIcon16x16.png")
  MyLoadImage(#AddedWithHistory, "gfx\+Icon16x16.png")
  MyLoadImage(#Switched, "gfx\SIcon16x16.png")
  MyLoadImage(#LockToken, "gfx\KIcon16x16.png")
  MyLoadImage(#LockOther, "gfx\OIcon16x16.png")
  MyLoadImage(#LockStolen, "gfx\TIcon16x16.png")
  MyLoadImage(#LockBroken, "gfx\BIcon16x16.png")
  
  For i = #Added To #END_OF_IMAGES - 1
    CreateImage(#FolderImgs + i, 16, 16)
    StartDrawing(ImageOutput(#FolderImgs + i))
    DrawImage(ImageID(#FolderImg), 0, 0)
    DrawAlphaImage(i, 0, 0)
    StopDrawing()
    CreateImage(#FileImgs + i, 16, 16)
    StartDrawing(ImageOutput(#FileImgs + i))
    DrawImage(ImageID(#FileImg), 0, 0)
    DrawAlphaImage(i, 0, 0)
    StopDrawing()
  Next i
  
EndProcedure

Procedure MakeTreeGadget()
  ClearGadgetItems(#TreeGadget)
  ForEach Tree()
    If Tree()\FolderFlag
      AddGadgetItem(#TreeGadget, Tree()\Item, Tree()\Path, StatusImage(Tree()\Status, #True), Tree()\SubLevel)
      SetGadgetItemData(#TreeGadget, Tree()\Item, #True)
    Else
      AddGadgetItem(#TreeGadget, Tree()\Item, Tree()\Path, StatusImage(Tree()\Status), Tree()\SubLevel)
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
  Static LastChar.s
  LastChar = Right(Path, 1)
  If LastChar = "\" Or LastChar = "/"
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

;Ne sert pas ici, mais ça peut servir plus tard ;)
Procedure.s GetStdOut(Prog.s, Arg.s)
  Protected svn, Output$
  svn = RunProgram(Prog, Arg, "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open )
  Output$ = ""
  If svn
    While ProgramRunning(svn)
      While AvailableProgramOutput(svn)
        Output$ + MyReadProgramString(svn) + Chr(13)
      Wend
    Wend   
    CloseProgram(svn)
  EndIf
  ProcedureReturn Output$
EndProcedure

;To correct the infamous ReadProgramString() sending ascii instead of utf8 in an unicode compiled program
Procedure.s ASCII2UTF8(str.s)
  ProcedureReturn PeekS(@str, -1, #PB_Ascii)
EndProcedure  

Procedure Disabler()
  Protected i
  For i = 0 To #END_OF_THE_GADGETS_TO_DISABLE - 1
    If IsGadget(i)
      DisableGadget(i, 1)
    EndIf  
  Next i
EndProcedure

Procedure Enabler()
  Protected i
  For i = 0 To #END_OF_THE_GADGETS_TO_DISABLE - 1
    If IsGadget(i)
      DisableGadget(i, 0)
    EndIf
  Next i
EndProcedure

Procedure Marquee(*Null)
  Protected txt.s, counter
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
  Static Path.s, i
  
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

;Get file list on svn servers and construct tree list
Procedure GetRemoteFileList(Item, SubLevel, Path.s)
  Protected FoldersNb, NewItemsNb, FirstItem, svn, NewPath.s, Error.s
  
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
        NewPath.s = MyReadProgramString(svn)    
        If NewPath <> ""
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
      Error.s =  ASCII2UTF8(ReadProgramError(svn))
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

Procedure.s Status(FileName.s)
  Protected svn, Error.s, Output.s
   
  svn = SubversionCall("status " + Chr(34) + Filename + Chr(34) + " -v --depth empty")
  
  Output = ""
  
  If svn
    While ProgramRunning(svn)     
      If AvailableProgramOutput(svn)
        ;Read the first line
        Output = MyReadProgramString(svn)
      EndIf
      Delay(10)
    Wend
    
    Repeat
      Error.s =  ASCII2UTF8(ReadProgramError(svn))
      ;Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  
  Debug StringField(Output, 1, " ")
  
  ;Returns the fist field
  ProcedureReturn StringField(Output, 1, " ")
  
EndProcedure

;Get file list on local repositery and construct tree list
Procedure GetLocalFileList(Item, SubLevel, Path.s)
  Protected FoldersNb, NewItemsNb, FirstItem, svn, NewPath.s, Error.s

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
        ;Check if there's a path separator
        If (Path <> "" And Right(Path, 1) <> #PathSeparator) Or (Path = "" And Right(LocalRepositery, 1) <> #PathSeparator)
          Path + #PathSeparator
        EndIf
        Tree()\Status = Status(LocalRepositery + Path + DirectoryEntryName(0))
        ;Debug "----"
        ;Debug NewPath
        ;Debug Item          
        If DirectoryEntryType(0) <> #PB_DirectoryEntry_File
          ;If it's a folder
          Tree()\FolderFlag = #True
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
      ;Debug "First Item : " + Str(FirstItem)
      ;Debug "Last Item : " + Str(Item)
      ;Debug "Folders Nb : " + Str(FoldersNb)
      ;Debug "NewItemsNb : " + Str(NewItemsNb)
      
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
  Protected Item, svn, Path.s, Error.s
  
  ClearGadgetItems(#TreeGadget)
  ClearList(Tree())
  ;SetGadgetText(#ButtonSearch, "Veuillez patienter")
  Item = 0  
  
  svn = SubversionCall("list " + RemoteRepositery + " -R")
     
  If svn
    
    CreateRegularExpression(0, *Pattern)
    
    While ProgramRunning(svn)     
      
      While AvailableProgramOutput(svn)
        Path.s = MyReadProgramString(svn)
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
    Error.s =  ASCII2UTF8(ReadProgramError(svn))
    Debug Error
  Until Error = ""

  ;MakeTreeGadget()
  FreeGadget(#ButtonStopSearch)
  ButtonGadget(#ButtonSearch, 310, 30, 130, 20, t("Search"))
  Enabler()

EndProcedure

;Téléharge en local une version "lecture seule" sur le serveur (sans avoir besoin de mot de passe)
Procedure GetRepositeryReadOnly(nil)
  Protected Item.s, svn, Path.s, Error.s, Counter
   
  svn = SubversionCall("checkout " + RemoteRepositery + " " + LocalRepositery)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        If Error <> ""
          Debug Error
        EndIf
        Item = MyReadProgramString(svn)
        If Item <> ""
          AddGadgetItem (#TreeGadget, -1, Item)
        EndIf
      Wend
      Delay(10)
      Counter + 1
    Wend
    
    Repeat
      Error.s =  ASCII2UTF8(ReadProgramError(svn))
      Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  
  RunProgram("explorer.exe", LocalRepositery, "")
  
  SetGadgetText(#ButtonGetRepositeryReadOnly, t("Receive a read only repositery copy"))
  Enabler()
  
EndProcedure

Procedure Update(nil)
  Protected Item.s, svn, Path.s, Error.s, Counter
  ; repositeries\pb-source-repositery --username " + UserName + " --password " + Password
   
  svn = SubversionCall("update " + LocalRepositery + " --username " + UserName + " --password " + Password)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        If Error <> ""
          Debug Error
        EndIf
        Item = MyReadProgramString(svn)
        If Item <> ""
          AddGadgetItem (#TreeGadget, -1, Item)
        EndIf
      Wend
      Delay(10)
      Counter + 1
    Wend
    
    Repeat
      Error.s =  ASCII2UTF8(ReadProgramError(svn))
      Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
      
EndProcedure

Procedure Commit(nil)
  Protected Item.s, svn, Path.s, Error.s, Counter
  ; repositeries\pb-source-repositery --username " + UserName + " --password " + Password
   
  svn = SubversionCall("commit " + " --username " + UserName + " --password " + Password + " -m " + Chr(34) + GetGadgetText(#StringUpdateComment) + Chr(34), LocalRepositery )
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        If Error <> ""
          Debug Error
        EndIf
        Item = MyReadProgramString(svn)
        If Item <> ""
          AddGadgetItem (#TreeGadget, -1, Item)
        EndIf
      Wend
      Delay(10)
      Counter + 1
    Wend
    
    Repeat
      Error.s =  ASCII2UTF8(ReadProgramError(svn))
      Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  Else
    Debug "Erreur!"
  EndIf
      
EndProcedure

Procedure GetRepositery(nil)
  Protected Item.s, svn, Path.s, Error.s, Counter
   
  svn = SubversionCall("checkout " + RemoteRepositery + " " + LocalRepositery + " --username " + UserName + " --password " + Password)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        If Error <> ""
          Debug Error
        EndIf
        Item = MyReadProgramString(svn)
        If Item <> ""
          AddGadgetItem (#TreeGadget, -1, Item)
        EndIf
      Wend
      Delay(10)
      Counter + 1
    Wend
    
    Repeat
      Error.s =  ASCII2UTF8(ReadProgramError(svn))
      Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  
  RunProgram("explorer.exe", LocalRepositery, "")
  
  SetGadgetText(#ButtonGetRepositery, t("Receive a repositery work copy "))
  Enabler()  
  
EndProcedure

Procedure MakeDirOnRepositery(Url.s, UserName.s, Password.s, LocalFolder.s, PleaseWaitButton.i)
  Protected Item, svn, Path.s, Error.s, Counter, txt.s, Result.s
  
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
      Result = ""
      Repeat
        Error = ASCII2UTF8(ReadProgramError(svn))
        If Error <> ""
          Error + Chr(13)
        EndIf
        Result + Error
      Until Error = ""
    EndIf
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  If Result <> ""
    MessageRequester("Error", Result, #PB_MessageRequester_Ok )
  EndIf
  
  Enabler()
  
EndProcedure


;*****************************************************************************
;- MAIN

InitNetwork()

Define.i LocalExploration, Event, SearchThread, nil, Item, SubLevel, IsFolder
Define.s Pattern, Name, FullPath, Filename

; Initialize Translator and load default folder
; Here in example, we are forcing to load indonesian locale translation, blank means autodetect locale
Translator_init("locale\", "fr_FR")

If OpenWindow(0, 0, 0, 450, 430, t("ThotBox SubVersion Tiny FrontEnd"), #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  TextGadget(#TextRemoteRepositery, 10, 11, 80, 20, t("Repositery URL"))
  StringGadget(#StringRemoteRepositery, 80, 9, 360, 20, RemoteRepositery)
  StringGadget(#StringSearch, 10, 30, 300, 20, "")
  ButtonGadget(#ButtonSearch, 310, 30, 130, 20, t("Search"))  
  ButtonGadget(#ButtonExploreRemoteRepositery, 10, 50, 430, 20, t("Explore remote repositery"))
  TreeGadget(#TreeGadget, 10, 70, 430, 250)
  TextGadget(#TextLocalRepositery, 10, 323, 120, 20, t("Local repositery"))
  StringGadget(#StringLocalRepositery, 80, 321, 280, 20, LocalRepositery)
  GadgetToolTip(#StringLocalRepositery, t("Local repositery folder. It'll be created if necessary"))
  ButtonGadget(#ButtonChangeLocalRepositery, 360, 321, 80, 20, t("Choose"))  
  ButtonGadget(#ButtonGetRepositeryReadOnly, 10, 341, 240, 20, t("Receive a read only repositery copy")) 
  ButtonGadget(#ButtonExploreLocalRepositery, 250, 341, 190, 20, t("Explore local repositery")) 
  TextGadget(#TextUsername, 10, 372, 80, 20, t("User name"))
  StringGadget(#StringUsername, 91, 370, 120, 20, "")
  TextGadget(#TextPassword, 239, 372, 65, 20, t("Password"))
  StringGadget(#StringPassword, 307, 370, 132, 20, "")
  ButtonGadget(#ButtonGetRepositery, 10, 390, 331, 20, t("Receive a repositery work copy "))
  ButtonGadget(#ButtonUpdate, 340, 390, 100, 20, t("Receive update"))
  StringGadget(#StringUpdateComment, 10, 410, 330, 20, t("Update ") + Str(Date()))
  GadgetToolTip(#StringUpdateComment, t("Update comment"))
  ButtonGadget(#ButtonCommit, 340, 410, 100, 20, t("Send update"))
  
  PrepareImages()

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
                  SetGadgetText(#StringUpdateComment, t("Update ") + Str(Date()))
                EndIf
                
            EndSelect
                  
          Case  #StringUsername
            
            Select EventType()
                
              Case #PB_EventType_LostFocus
                
                If FindString(GetGadgetText(#StringUsername), " ")
                  MessageRequester(t("Alert"), t("Your username can't contain space"), #PB_MessageRequester_Ok)
                  SetGadgetText(#StringUsername, "")
                EndIf
                UserName = GetGadgetText(#StringUsername)
                                
            EndSelect
            
         Case  #StringPassword
            
            Select EventType()
                
              Case #PB_EventType_LostFocus 
                
                If FindString(GetGadgetText(#StringPassword), " ")
                  MessageRequester(t("Alert"), t("Your password can't contain space"), #PB_MessageRequester_Ok)
                  SetGadgetText(#StringPassword, "")
                EndIf
                Password = GetGadgetText(#StringPassword)
                
            EndSelect
            
          Case #ButtonSearch
            
            Disabler()
            LocalExploration = #False
            FreeGadget(#ButtonSearch)
            ButtonGadget(#ButtonStopSearch, 310, 30, 130, 20, t("Stop search"))
            Pattern.s = GetGadgetText(#StringSearch)
            SearchThread = CreateThread(@Search(), @Pattern)
            
          Case #ButtonStopSearch
            
            KillThread(SearchThread)
            LocalExploration = #False
            FreeGadget(#ButtonStopSearch)
            ButtonGadget(#ButtonSearch, 310, 30, 130, 20, t("Search"))  
            Enabler()
            
          Case #ButtonGetRepositeryReadOnly
            
            Disabler()
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonGetRepositeryReadOnly, t("Please wait"))
            CreateThread(@GetRepositeryReadOnly(), nil)
            
          Case #ButtonChangeLocalRepositery
            
            If FileSize(LocalRepositery) = - 2 
              ;If folder exists
              LocalRepositery = PathRequester(t("Local repositery folder"), LocalRepositery)
            Else  
              ;Else local app folder
              LocalRepositery = PathRequester(t("Local repositery folder"), GetCurrentDirectory())
            EndIf
            
            SetGadgetText(#StringLocalRepositery, LocalRepositery)
            
          Case #ButtonGetRepositery
            
            Disabler()
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            UserName = GetGadgetText(#StringUserName)
            Password = GetGadgetText(#StringPassword)
            SetGadgetText(#ButtonGetRepositery, t("Please wait"))
            CreateThread(@GetRepositery(), nil)
            
          Case #ButtonUpdate
            
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonUpdate, t("Please wait"))
            Update(nil)
            SetGadgetText(#ButtonUpdate, t("Receive update"))            
            
          Case #ButtonCommit
            
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonCommit, t("Please wait"))
            Commit(nil)
            SetGadgetText(#ButtonCommit, t("Send update"))            
            
          Case #ButtonExploreRemoteRepositery
            
            ClearList(Tree())
            SetGadgetText(#ButtonExploreRemoteRepositery, t("Please wait"))
            GetRemoteFileList(0, 0, "")
            MakeTreeGadget()
            SetGadgetText(#ButtonExploreRemoteRepositery, t("Explore remote repositery"))
            LocalExploration = #False
            
          Case #ButtonExploreLocalRepositery
            
            If FileSize(LocalRepositery) = -2
              ClearList(Tree())
              SetGadgetText(#ButtonExploreLocalRepositery, t("Please wait"))
              GetLocalFileList(0, 0, "")
              MakeTreeGadget()
              SetGadgetText(#ButtonExploreLocalRepositery, t("Explore local repositery"))
              LocalExploration = #True
            Else
              MessageRequester(t("Alert"), t("Folder doesn't exist.") + Chr(13) + Chr(13) + t("Maybe should you try first ") + Chr(34) + t(" to receive a repositery copy ? ") + Chr(34) , #PB_MessageRequester_Ok)
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
                    SetGadgetText(#ButtonExploreRemoteRepositery, t("Please wait"))
                    GetLocalFileList(Item + 1, SubLevel + 1, FullPath)
                    MakeTreeGadget()
                    SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
                    SetGadgetState(#TreeGadget, Item)
                    SetGadgetText(#ButtonExploreRemoteRepositery, t("Explore remote repositery"))                
                  EndIf
                    
                Else
                  
                  ;-Remote exploration
                  
                  If IsFolder
                    ;If folder, look into
                    SetGadgetText(#ButtonExploreRemoteRepositery, t("Please wait"))
                    GetRemoteFileList(Item + 1, SubLevel + 1, FullPath)
                    MakeTreeGadget()
                    SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
                    SetGadgetState(#TreeGadget, Item)
                    SetGadgetText(#ButtonExploreRemoteRepositery, t("Explore remote repositery"))                
                  Else
                    ;If file, download it
                    Name = GetFilePart(Name) ;In case where the Name is coming from a search with a full path
                    Filename = SaveFileRequester(t("Where should I save file ") + Name + " ?", Name, "", 0)
                    If URLDownloadToFile_(0,"" + RemoteRepositery + "" + FullPath, Filename, 0, 0) = #S_OK
                      Debug "Download succeded"  
                    Else
                      Debug "Download failed"
                      MessageRequester(t("Alert"), t("Saving failed"), #PB_MessageRequester_Ok)
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

Translator_destroy()

End

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 745
; FirstLine = 742
; Folding = ----
; EnableUnicode
; EnableThread
; EnableXP
; EnablePurifier