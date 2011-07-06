Enumeration 
  #ButtonGetList
  #ButtonGetFiles
  #TreeGadget
EndEnumeration

Structure Path
  Item.i
  Path.s
  SubLevel.i
  FolderFlag.i
EndStructure

Global NewList Tree.Path()

Procedure MakeTreeGadget()
  ClearGadgetItems(#TreeGadget)
  ForEach Tree()
    AddGadgetItem(#TreeGadget, Tree()\Item, Tree()\Path, 0, Tree()\SubLevel)
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
  DisableGadget(#ButtonGetFiles, 1)
  ClearGadgetItems(#TreeGadget)
EndProcedure

Procedure Enabler()
  DisableGadget(#ButtonGetList, 0)
  DisableGadget(#ButtonGetFiles, 0)
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
    Debug "ITEM DOESN'T HAVE A PARENT"         
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


;Télécharge en local une version "lecture seule" sur le serveur
Procedure GetFiles(nil)
  Disabler()
  svn = RunProgram("svn\bin\svn.exe","checkout https://pb-source-repositery.googlecode.com/svn/trunk/ repositeries\pb-source-repositery-Read-only", "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error)
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
            
          Case #ButtonGetFiles
            
            SetGadgetText(#ButtonGetFiles, "Please Wait")
            CreateThread(@GetFiles(), nil)
            SetGadgetText(#ButtonGetFiles, "Récupérer les fichiers")

          Case #TreeGadget
            
            Select EventType()
              Case #PB_EventType_LeftDoubleClick
                Item = GetGadgetState(#TreeGadget)
                SubLevel = GetGadgetItemAttribute(#TreeGadget, Item, #PB_Tree_SubLevel)
                Debug "--------------------"
                Debug "Item : " + Str(item)
                Debug "SubLevel : " + Str(SubLevel)
                Debug "Full name : " + GetFullPathFromTree(Item, SubLevel)
                If IsFolder(GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel))
                  SetGadgetText(#ButtonGetList, "Please Wait")
                  GetFileList(Item + 1, SubLevel + 1, GetFullPathFromTree(Item, SubLevel))
                  MakeTreeGadget()                
                  SetGadgetText(#ButtonGetList, "Liste des fichiers sur le serveur")                
                EndIf
                
            EndSelect
            
        EndSelect
        
    EndSelect
    
  Until Event = #PB_Event_CloseWindow
  
EndIf

End

; IDE Options = PureBasic 4.60 Beta 2 (Windows - x86)
; CursorPosition = 208
; FirstLine = 203
; Folding = --
; EnableThread
; EnableXP