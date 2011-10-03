;*****************************************************************************
;
; ThotboxSVNFrontend
;
; For Thotbox project
; http://purebasic.fr/french/viewtopic.php?f=4&t=12008&start=135
;
; Lead coder djes@free.fr - 2011
;
; Comments :
;   in code : "Todo" -> need fix
;
;*****************************************************************************

UsePNGImageDecoder()

XIncludeFile "translator.pbi"

;To have the possibility to send a message to a gadget in the main loop

; Import "Gadget.lib"
;   PB_Gadget_SendGadgetCommand(hWnd, EventType)
; EndImport
; 
; Prototype.l PB_Gadget_SendGadgetCommand(hWnd.l,EventType.l)

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  #PathSeparator = "\"
CompilerElse 
  #PathSeparator = "/"
CompilerEndIf
  
;*****************************************************************************
;- CONSTANTS

;Gadgets
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
  #ButtonGetRepositery
  #ButtonCommit
  #ButtonUpdate
  #ButtonCleanup
  #TextSVNUserName
  #StringSVNUserName
  #TextSVNPassword
  #StringSVNPassword
  #CheckboxSVNAuthCache
  #END_OF_THE_GADGETS_TO_DISABLE
  #HyperlinkRepositery
  #ButtonStopSearch
  #TreeGadget
EndEnumeration

;Images
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
  #Updated
  #Merged
  #Existed
  #LockToken
  #LockOther
  #LockStolen
  #LockBroken
  #END_OF_IMAGES
EndEnumeration
;/!\ Do NOT separate these enumerations
Enumeration #PB_Compiler_EnumerationValue Step #END_OF_IMAGES
  #FileImgs
  #FolderImgs
  #Pad
EndEnumeration

;Menus
Enumeration 1
  #PopupMenuStatus
  #PopupMenuOpen
  #PopupMenuAdd
  #PopupMenuRevert
  #PopupMenuDelete
  #PopupMenuRemoteMkdir
  #PopupMenuRemoteDelete
  #PopupMenuRemoteDownload
  #PopupMenuRemoteOpen
EndEnumeration

#SVNConfigProxyHost     = " --config-option servers:global:http-proxy-host="
#SVNConfigProxyPort     = " --config-option servers:global:http-proxy-port="
#SVNConfigProxyUserName = " --config-option servers:global:http-proxy-username="
#SVNConfigProxyPassword = " --config-option servers:global:http-proxy-password="

#Local = 1
#Remote = 2
#Search = 3
#Get = 4

;*****************************************************************************
;- STRUCTURES

Structure Path
  Item.i
  Path.s
  SubLevel.i
  FolderFlag.i
  Status.s
  FullPath.s
EndStructure

;*****************************************************************************
;- GLOBALS

Global NewList Tree.Path()
Global Language.s
Global RemoteRepositery.s = "https://pb-source-repositery.googlecode.com/svn/trunk/"
Global LocalRepositery.s = GetCurrentDirectory() + "repositeries" + #PathSeparator + "pb-source-repositery" + #PathSeparator
;Global LocalRepositeryReadOnly.s = GetCurrentDirectory() + "repositeries\pb-source-repositery-ReadOnly"
Global ProxyFlag.i = #False
Global SVNConfigProxyHost.s = "proxy.cg59.fr"
Global SVNConfigProxyPort.s = "8080"
Global SVNConfigProxyUserName.s = ""
Global SVNConfigProxyPassword.s = ""
Global SVNAuthCacheFlag.i = #False
Global SVNUserName.s = ""
Global SVNPassword.s = ""
Global *MyReadProgramStringBuffer = AllocateMemory(1024)
Global StopSearchThread = #False, DisableGadgetsFlag = #False
Global ButtonStopSearchGadgetID

;*****************************************************************************
;- PROCEDURES

Procedure SubversionCall(SvnArgs.s, Path.s = "", Auth = #True)

  If ProxyFlag
    SvnArgs + #SVNConfigProxyHost + SVNConfigProxyHost + #SVNConfigProxyPort + SVNConfigProxyPort + #SVNConfigProxyUserName + SVNConfigProxyUserName + #SVNConfigProxyPassword + SVNConfigProxyPassword
  EndIf
  SvnArgs + " --non-interactive"
  If SVNAuthCacheFlag = #False 
    SvnArgs + " --no-auth-cache"
    SvnArgs + " --username " + SVNUserName + " --password " + SVNPassword  
  EndIf

  Debug SvnArgs   
  
  ProcedureReturn RunProgram("svn\bin\svn.exe", SvnArgs, Path, #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open|#PB_Program_Error )

EndProcedure

;*****************************************************************************
;Coz bug of the ReadProgramString() in unicode

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
      ProcedureReturn Trim(ReplaceString(ReplaceString(Temp, Chr(13), ""), Chr(10), ""))
    EndIf
  EndIf
EndProcedure

;*****************************************************************************
;---- Typhoon

#prg_name$="Thothbox"
#prg_version$="0.1"

Procedure LoadPreferences()
  ;First in the personal folder, then app directory
  If OpenPreferences(GetHomeDirectory() + #prg_name$+".prefs") = 0
    OpenPreferences(GetCurrentDirectory() + #prg_name$ + ".prefs")
  EndIf
  Language               = ReadPreferenceString( "language", "")
  
  RemoteRepositery       = ReadPreferenceString( "SVNRemoteRepositery", "https://pb-source-repositery.googlecode.com/svn/trunk/")
  LocalRepositery        = ReadPreferenceString( "SVNLocalRepositery",  GetCurrentDirectory() + "repositeries" + #PathSeparator + "pb-source-repositery"+ #PathSeparator)
  SVNUserName            = ReadPreferenceString( "SVNUsername", "")
  SVNPassword            = ReadPreferenceString( "SVNPassword", "")
  SVNAuthCacheFlag       = ReadPreferenceInteger("SVNAuthCache", #False) ;To use the installed svn auth mechanism

  ProxyFlag              = ReadPreferenceInteger("useProxy", #False)
  SVNConfigProxyHost     = ReadPreferenceString( "proxyHost", "")
  SVNConfigProxyPort     = Str(ReadPreferenceInteger("proxyPort", 80))
  SVNConfigProxyUserName = ReadPreferenceString( "proxyLogin", "")
  SVNConfigProxyPassword = ReadPreferenceString( "proxyPassword", "")
  ClosePreferences()
EndProcedure

;*****************************************************************************
Procedure SavePreferences() 
  If OpenPreferences(GetHomeDirectory() + #prg_name$ + ".prefs") = 0
    CreatePreferences(GetHomeDirectory() + #prg_name$ + ".prefs")
  EndIf
  
  WritePreferenceString("SVNRemoteRepositery", RemoteRepositery)
  WritePreferenceString("SVNLocalRepositery", LocalRepositery)
  
  WritePreferenceInteger("SVNAuthCache",  GetGadgetState(#CheckboxSVNAuthCache))
  WritePreferenceString( "SVNUsername",   SVNUserName)
  WritePreferenceString( "SVNPassword",   SVNPassword)
  ClosePreferences()
 EndProcedure
 
 ;*****************************************************************************
;----
;By Joakim Christiansen
Procedure.s InputRequesterOkCancel(Title$,Message$,DefaultString$="")
  Protected Result$, Window, String, OK, Cancel, Event
  Window = OpenWindow(#PB_Any,0,0,300,95,Title$,#PB_Window_ScreenCentered| #PB_Window_SystemMenu ) 
  If Window
    TextGadget(#PB_Any,10,10,280,20,Message$)
    String = StringGadget(#PB_Any,10,30,280,20,DefaultString$): SetActiveGadget(String)
    OK     = ButtonGadget(#PB_Any,60,60,80,25,"OK",#PB_Button_Default)
    Cancel = ButtonGadget(#PB_Any,150,60,80,25,"Cancel")
    AddKeyboardShortcut(Window, #PB_Shortcut_Return, 1000)
    Repeat
      Event = WaitWindowEvent() 
      If Event = #PB_Event_Gadget
        If EventGadget() = OK
          Result$ = GetGadgetText(String)
          Break
        ElseIf EventGadget() = Cancel
          Result$ = ""
          Break
        EndIf
      EndIf
      If Event = #PB_Event_CloseWindow
        Break
      EndIf
      If Event = #PB_Event_Menu
        If EventMenu() = 1000
          Result$ = GetGadgetText(String)
          Break
        EndIf  
      EndIf
    ForEver
  EndIf
  CloseWindow(Window)
  ProcedureReturn Result$
EndProcedure

;*****************************************************************************
Procedure.i StatusImage(Status.s, Folder = #False)
  Static Base
  If Folder
    Base = #FolderImgs ;the 's' is important ;)
  Else
    Base = #FileImgs
  EndIf
  
  Select Status
    Case "A"
      ProcedureReturn ImageID(Base + #Added)
    Case "B"
      ProcedureReturn ImageID(Base + #LockBroken)
    Case "C"
      ProcedureReturn ImageID(Base + #Conflicted)
    Case "D"
      ProcedureReturn ImageID(Base + #Suppressed)
    Case "E"
      ProcedureReturn ImageID(Base + #Existed)
    Case "G"
      ProcedureReturn ImageID(Base + #Merged)
    Case "I"
      ProcedureReturn ImageID(Base + #Ignored)
    Case "K"
      ProcedureReturn ImageID(Base + #LockToken)
    Case "L"
      ProcedureReturn ImageID(Base + #Locked)
    Case "M"
      ProcedureReturn ImageID(Base + #Modified)
    Case "O"
      ProcedureReturn ImageID(Base + #LockOther)
    Case "R"
      ProcedureReturn ImageID(Base + #Remplaced)
    Case "S"
      ProcedureReturn ImageID(Base + #Switched)
    Case "T"
      ProcedureReturn ImageID(Base + #LockStolen)
    Case "U"
      ProcedureReturn ImageID(Base + #Updated)
    Case "X"
      ProcedureReturn ImageID(Base + #NonVersionnedFolder)
    Case "?"
      ProcedureReturn ImageID(Base + #NonVersionned)
    Case "!"
      ProcedureReturn ImageID(Base + #Missing)
    Case "~"
      ProcedureReturn ImageID(Base + #Dissimulated)
    Case "+"
      ProcedureReturn ImageID(Base + #AddedWithHistory)
    Default
      If Folder
        ProcedureReturn ImageID(#FolderImg)
      Else
        ProcedureReturn ImageID(#FileImg)
      EndIf
  EndSelect       
  
EndProcedure

;*****************************************************************************
Procedure.s StatusName(Status.s)
 
  Select Status
    Case "A"
      ProcedureReturn t("Added")
    Case "C"
      ProcedureReturn t("Conflicted")
    Case "D"
      ProcedureReturn t("Suppressed")
    Case "I"
      ProcedureReturn t("Ignored")
    Case "M"
      ProcedureReturn t("Modified")
    Case "R"
      ProcedureReturn t("Remplaced")
    Case "X"
      ProcedureReturn t("Non Versionned Folder")
    Case "?"
      ProcedureReturn t("Non Versionned")
    Case "!"
      ProcedureReturn t("Missing")
    Case "~"
      ProcedureReturn t("Dissimulated")
    Case "L"
      ProcedureReturn t("Locked")
    Case "+"
      ProcedureReturn t("Added With History")
    Case "S"
      ProcedureReturn t("Switched")
    Case "K"
      ProcedureReturn t("Lock Token")
    Case "O"
      ProcedureReturn t("Lock Other")
    Case "T"
      ProcedureReturn t("Lock Stolen")
    Case "B"
      ProcedureReturn t("Lock Broken")
    Case "U"
      ProcedureReturn t("Updated")
    Case "G"
      ProcedureReturn t("Merged")
    Case "E"
      ProcedureReturn t("Existed")
    Default
      ProcedureReturn ""
  EndSelect       
  
EndProcedure

;*****************************************************************************
Procedure MyLoadImage(Nb.i, Filename.s)
  If LoadImage(Nb, Filename) = #False
    Debug "Can't load " + Filename
  EndIf
EndProcedure

;*****************************************************************************
Procedure PrepareImages()
  Static i
  
  MyLoadImage(#FolderImg, "gfx" + #PathSeparator + "FolderIcon16x16.png")
  MyLoadImage(#FileImg, "gfx" + #PathSeparator + "FileIcon16x16.png")
  
  MyLoadImage(#Added, "gfx" + #PathSeparator + "AIcon16x16.png")
  MyLoadImage(#Conflicted, "gfx" + #PathSeparator + "CIcon16x16.png")
  MyLoadImage(#Suppressed, "gfx" + #PathSeparator + "SIcon16x16.png")
  MyLoadImage(#Ignored, "gfx" + #PathSeparator + "IIcon16x16.png")
  MyLoadImage(#Modified, "gfx" + #PathSeparator + "MIcon16x16.png")
  MyLoadImage(#Remplaced, "gfx" + #PathSeparator + "RIcon16x16.png")
  MyLoadImage(#NonVersionnedFolder, "gfx" + #PathSeparator + "XIcon16x16.png")
  MyLoadImage(#NonVersionned, "gfx" + #PathSeparator + "NVIcon16x16.png")
  MyLoadImage(#Missing, "gfx" + #PathSeparator + "!Icon16x16.png")
  MyLoadImage(#Dissimulated, "gfx" + #PathSeparator + "~Icon16x16.png")
  MyLoadImage(#Locked, "gfx" + #PathSeparator + "LIcon16x16.png")
  MyLoadImage(#AddedWithHistory, "gfx" + #PathSeparator + "+Icon16x16.png")
  MyLoadImage(#Switched, "gfx" + #PathSeparator + "SIcon16x16.png")
  MyLoadImage(#LockToken, "gfx" + #PathSeparator + "KIcon16x16.png")
  MyLoadImage(#LockOther, "gfx" + #PathSeparator + "OIcon16x16.png")
  MyLoadImage(#LockStolen, "gfx" + #PathSeparator + "TIcon16x16.png")
  MyLoadImage(#LockBroken, "gfx" + #PathSeparator + "BIcon16x16.png")
  MyLoadImage(#Updated, "gfx" + #PathSeparator + "UIcon16x16.png")
  MyLoadImage(#Merged, "gfx" + #PathSeparator + "GIcon16x16.png")
  MyLoadImage(#Existed, "gfx" + #PathSeparator + "EIcon16x16.png")
  
  For i = #Added To #END_OF_IMAGES - 1
    CreateImage(#FolderImgs + i, 16, 16, 32)
    StartDrawing(ImageOutput(#FolderImgs + i))
    DrawImage(ImageID(#FolderImg), 0, 0)
    DrawAlphaImage(ImageID(i), 0, 0)
    StopDrawing()
    CreateImage(#FileImgs + i, 16, 16, 32)
    StartDrawing(ImageOutput(#FileImgs + i))
    DrawImage(ImageID(#FileImg), 0, 0)
    DrawAlphaImage(ImageID(i), 0, 0)
    StopDrawing()
  Next i
  
EndProcedure

;*****************************************************************************
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

;*****************************************************************************
Procedure.i IsFolder(Path.s)
  Static LastChar.s
  LastChar = RTrim(Right(Path, 1))
  If LastChar = "\" Or LastChar = "/" ;whatever is the remote os
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

;*****************************************************************************
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

;*****************************************************************************
;To correct the infamous ReadProgramString() sending ascii instead of utf8 in an unicode compiled program
Procedure.s ASCII2UTF8(str.s)
  ProcedureReturn PeekS(@str, -1, #PB_Ascii)
EndProcedure  

;*****************************************************************************
Procedure Disabler()
  Protected i
  For i = 0 To #END_OF_THE_GADGETS_TO_DISABLE - 1
    If IsGadget(i)
      DisableGadget(i, 1)
    EndIf  
  Next i
  DisableGadgetsFlag = #True
EndProcedure

;*****************************************************************************
Procedure Enabler()
  Protected i
  For i = 0 To #END_OF_THE_GADGETS_TO_DISABLE - 1
    If IsGadget(i)
      DisableGadget(i, 0)
    EndIf
  Next i
  DisableGadgetsFlag = #False
EndProcedure

;*****************************************************************************
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

;*****************************************************************************
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

;*****************************************************************************
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
    ClearList(tree())
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
          Tree()\FullPath = Path + NewPath 
          ;Debug "----"
          ;Debug NewPath
          ;Debug Item      
          ;Debug Tree()\FullPath
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
;       Debug "First Item : " + Str(FirstItem)
;       Debug "Last Item : " + Str(Item)
;       Debug "Folders Nb : " + Str(FoldersNb)
;       Debug "NewItemsNb : " + Str(NewItemsNb)
      
      ;Renumber to the end of the list
      While NextElement(Tree())
        Tree()\Item = Item
        Item + 1
      Wend
     
      ;Sort by files/folders the new entries
      If NewItemsNb > 0
        SortStructuredList(Tree(), #PB_Sort_Descending, OffsetOf(Path\FolderFlag), #PB_Sort_Integer, FirstItem, FirstItem + NewItemsNb - 1) ;First : sort all
        ;Sort by names
        If FoldersNb > 0
          SortStructuredList(Tree(), #PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(Path\Path), #PB_Sort_String, FirstItem, FirstItem + FoldersNb - 1) ; then folders
        EndIf
        SortStructuredList(Tree(), #PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(Path\Path), #PB_Sort_String, FirstItem + FoldersNb, FirstItem + NewItemsNb - 1) ;and files
      EndIf
      ;Renumber all the list
      Item = 0
      ForEach Tree()
        Tree()\Item = Item
        Item + 1
      Next
  
    EndIf
      
  EndIf
  ;Enabler()  
EndProcedure

;*****************************************************************************
Procedure.s Status(FileName.s)
  Protected svn, Error.s, Output.s
   
  ;I'm cheating a bit, as it gives on folder several files of the content, but it works!
  svn = SubversionCall("status " + Chr(34) + Filename + Chr(34));  + " -v --depth empty")
  
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
  
  ;Debug StringField(Output, 1, " ")
  
  ;Returns the fist field
  ProcedureReturn StringField(Output, 1, " ")
  
EndProcedure

;*****************************************************************************
Procedure.s Add(FileName.s)
  Protected svn, Error.s, Output.s
   
  svn = SubversionCall("add " + Chr(34) + Filename + Chr(34))
  
  Output = ""
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Output + MyReadProgramString(svn)
      Wend
      Delay(10)
    Wend
    
    ;Debug Output
    
    Repeat
      Error.s =  ASCII2UTF8(ReadProgramError(svn))
      ;Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
   
  ;Returns the fist field
  ProcedureReturn StringField(Output, 1, " ")
  
EndProcedure

;*****************************************************************************
Procedure.s Revert(FileName.s)
  Protected svn, Error.s, Output.s
   
  svn = SubversionCall("revert " + Chr(34) + Filename + Chr(34))
  
  Output = ""
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Output + MyReadProgramString(svn)
      Wend
      Delay(10)
    Wend
    
    ;Debug Output
    
    Repeat
      Error.s =  ASCII2UTF8(ReadProgramError(svn))
      ;Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
   
  ;Returns the fist field
  ProcedureReturn StringField(Output, 1, " ")
  
EndProcedure

;*****************************************************************************
Procedure.s Delete(FileName.s)
  Protected svn, Error.s, Output.s
   
  svn = SubversionCall("delete " + Chr(34) + Filename + Chr(34))
  
  Output = ""
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Output + MyReadProgramString(svn)
      Wend
      Delay(10)
    Wend
    
    ;Debug Output
    
    Repeat
      Error.s =  ASCII2UTF8(ReadProgramError(svn))
      ;Debug Error
    Until Error = ""
    
    CloseProgram(svn) ; Close the connection to the program
  EndIf
   
  ;Returns the fist field
  ProcedureReturn StringField(Output, 1, " ")
  
EndProcedure

;*****************************************************************************
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
        Tree()\FullPath = LocalRepositery + Path + DirectoryEntryName(0)
        Tree()\Status = Status(Tree()\FullPath)
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
      
      ;Renumber to the end of the list
      While NextElement(Tree())
        Tree()\Item = Item
        Item + 1
      Wend
;       
      ;Sort by files/folders the new entries
      If NewItemsNb > 0
        SortStructuredList(Tree(), #PB_Sort_Descending, OffsetOf(Path\FolderFlag), #PB_Sort_Integer, FirstItem, FirstItem + NewItemsNb - 1) ;First : sort all
        ;Sort by names
        If FoldersNb > 0
          SortStructuredList(Tree(), #PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(Path\Path), #PB_Sort_String, FirstItem, FirstItem + FoldersNb - 1) ; then folders
        EndIf
        SortStructuredList(Tree(), #PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(Path\Path), #PB_Sort_String, FirstItem + FoldersNb, FirstItem + NewItemsNb - 1) ;and files
      EndIf
      
      ;Renumber all the list
      Item = 0
      ForEach Tree()
        Tree()\Item = Item
        Item + 1
        ;Debug "Item Nb " + Str(Tree()\Item) + " Sublevel " + Str(tree()\SubLevel) + " Value " + tree()\Path + " Folder " + Str(tree()\FolderFlag)
      Next
  
    EndIf
      
  EndIf
  ;Enabler()  
EndProcedure

;*****************************************************************************
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
        ;Debug Path
        If Path<> "" And MatchRegularExpression(0, Path)
          ;AddElement(Tree())
          ;Tree()\Item = Item
          ;Tree()\SubLevel = SubLevel
          ;Tree()\Path = Path
          ;Debug "----"
          ;Debug Path
          ;Debug Item          
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
      
      If StopSearchThread
        Break
      EndIf
      
    Wend
  EndIf

  Repeat
    Error.s =  ASCII2UTF8(ReadProgramError(svn))
    Debug Error
  Until Error = ""
  
  ;Little hack to simulate a message on stop button to do the cleaning in the main loop (coz threads are not gadgets friendly)
  ; PB_Gadget_SendGadgetCommand(ButtonStopSearchGadgetID, #PB_EventType_LeftClick)

EndProcedure

;*****************************************************************************
;Locally download a Read-only version of the repositery (no Password needed)
Procedure GetRepositeryReadOnly(nil)
  Protected Item, svn, Path.s, Error.s, Counter, Output.s, Status.s, Newpath.s
  
  ClearList(tree())
  Item = 0
  
  svn = SubversionCall("checkout " + RemoteRepositery + " " + LocalRepositery, "", #False)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        If Error <> ""
          Debug Error
        EndIf
        Output.s = MyReadProgramString(svn)
        Status.s = Left(Output, 1)
        NewPath = Trim(Right(Output, Len(Output) - 1))
        If Status <> "A" And Status <> "D" And Status <> "U" And Status <> "C" And Status <> "G" And Status <> "E" And Status <> " "
          MessageRequester(t("Informations"), t("Update") + " : " + Output, #PB_MessageRequester_Ok)
        ElseIf NewPath <> "" 
          AddElement(Tree())
          Tree()\Item = Item
          Tree()\SubLevel = 0
          Tree()\Path = NewPath
          Tree()\FullPath = NewPath
          Tree()\Status = Status
          If IsFolder(NewPath.s)
            Tree()\FolderFlag = #True
          EndIf
          AddGadgetItem(#TreeGadget, -1, NewPath, StatusImage(Tree()\Status))
          Item + 1
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

;*****************************************************************************
Procedure Update(nil)
  Protected Item, svn, NewPath.s, Error.s, Counter, Output.s, Status.s
  ; repositeries\pb-source-repositery --username " + SVNUserName + " --Password " + SVNPassword
  
  ClearList(tree())
  Item = 0
  
  svn = SubversionCall("update " + LocalRepositery)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        If Error <> ""
          Debug Error
        EndIf
        Output.s = MyReadProgramString(svn) 
        Status.s = StringField(Output, 1, " ")
        NewPath = StringField(Output, 2, " ")
        If Status <> "A" And Status <> "D" And Status <> "U" And Status <> "C" And Status <> "G" And Status <> "E" And Status <> " "
          MessageRequester(t("Informations"), t("Update") + " : " + Output, #PB_MessageRequester_Ok)
        ElseIf NewPath <> "" 
          AddElement(Tree())
          Tree()\Item = Item
          Tree()\SubLevel = 0
          Tree()\Path = NewPath
          Tree()\FullPath = NewPath
          Tree()\Status = Status
          If IsFolder(NewPath.s)
            Tree()\FolderFlag = #True
          EndIf
          AddGadgetItem(#TreeGadget, -1, NewPath, StatusImage(Tree()\Status))
          Item + 1
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

;*****************************************************************************
Procedure Cleanup(nil)
  Protected Item, svn, NewPath.s, Error.s, Counter, Output.s, Status.s
  ; repositeries\pb-source-repositery --username " + SVNUserName + " --Password " + SVNPassword
  
  ClearList(tree())
  Item = 0
  
  svn = SubversionCall("cleanup " + LocalRepositery)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        If Error <> ""
          Debug Error
        EndIf
        Output.s = MyReadProgramString(svn)
        Debug output
        Status.s = StringField(Output, 1, " ")
        NewPath = StringField(Output, 2, " ")
        If Status <> "A" And Status <> "D" And Status <> "U" And Status <> "C" And Status <> "G" And Status <> "E" And Status <> " "
          MessageRequester(t("Informations"), t("Update") + " : " + Output, #PB_MessageRequester_Ok)
        ElseIf NewPath <> "" 
          AddElement(Tree())
          Tree()\Item = Item
          Tree()\SubLevel = 0
          Tree()\Path = NewPath
          Tree()\FullPath = NewPath
          Tree()\Status = Status
          If IsFolder(NewPath.s)
            Tree()\FolderFlag = #True
          EndIf
          AddGadgetItem(#TreeGadget, -1, NewPath, StatusImage(Tree()\Status))
          Item + 1
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

;*****************************************************************************
Procedure Commit(Comment.s)
  Protected Item.s, svn, Path.s, Error.s, Counter
  ; repositeries\pb-source-repositery --username " + SVNUserName + " --password " + SVNPassword
   
  svn = SubversionCall("commit -m " + Chr(34) + Comment + Chr(34) + " --force-log", LocalRepositery )
  
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

;*****************************************************************************
Procedure GetRepositery(nil)
  Protected Item, svn, Path.s, Error.s, Counter, Output.s, Status.s, Newpath.s
  
  ClearList(tree())
  Item = 0
  
  svn = SubversionCall("checkout " + RemoteRepositery + " " + LocalRepositery)
  
  If svn
    While ProgramRunning(svn)     
      While AvailableProgramOutput(svn)
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        If Error <> ""
          Debug Error
        EndIf
        Output.s = MyReadProgramString(svn)
        Status.s = Left(Output, 1)
        NewPath = Trim(Right(Output, Len(Output) - 1))
        If Status <> "A" And Status <> "D" And Status <> "U" And Status <> "C" And Status <> "G" And Status <> "E" And Status <> " "
          MessageRequester(t("Informations"), t("Update") + " : " + Output, #PB_MessageRequester_Ok)
        ElseIf NewPath <> "" 
          AddElement(Tree())
          Tree()\Item = Item
          Tree()\SubLevel = 0
          Tree()\Path = NewPath
          Tree()\FullPath = NewPath
          Tree()\Status = Status
          If IsFolder(NewPath.s)
            Tree()\FolderFlag = #True
          EndIf
          AddGadgetItem(#TreeGadget, -1, NewPath, StatusImage(Tree()\Status))
          Item + 1
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

;*****************************************************************************
; Procedure MakeDirOnRepositery(Url.s, SVNUserName.s, SVNPassword.s, LocalFolder.s, PleaseWaitButton.i)
;   Protected Item, svn, Path.s, Error.s, Counter, txt.s, Result.s
;   
;   Disabler()
;   
;   txt.s = "Veuillez patienter"
;   Counter = 0
;   
;   svn = SubversionCall("mkdir " + Url + " --username " + SVNUserName + " --password " + SVNPassword)
;   
;   If svn
;     While ProgramRunning(svn)     
;       txt.s = "Veuillez patienter" 
;       Select Counter%400
;         Case 1 To 100
;           txt + "."
;         Case 100 To 200
;           txt + ".."
;         Case 200 To 300
;           txt + "..."
;       EndSelect
;       SetGadgetText(PleaseWaitButton, txt)
;       Delay(10)
;       Counter + 1
;     Wend
;     If ProgramExitCode(svn)
;       Result = ""
;       Repeat
;         Error = ASCII2UTF8(ReadProgramError(svn))
;         If Error <> ""
;           Error + Chr(13)
;         EndIf
;         Result + Error
;       Until Error = ""
;     EndIf
;     CloseProgram(svn) ; Close the connection to the program
;   EndIf
;   If Result <> ""
;     MessageRequester("Error", Result, #PB_MessageRequester_Ok )
;   EndIf
;   
;   Enabler()
;   
; EndProcedure


;*****************************************************************************
Procedure.s RemoteMakeDir(Path.s, Filename.s)
  Protected svn, Error.s, Output.s
  
  If filename <> ""
    ;Debug "mkdir " + Chr(34) + RemoteRepositery + Path + FileName + Chr(34) + " -m " + Chr(34) + t("Directory") + " " + Filename + " " + t("created") + Chr(34) + " --username " + SVNUserName + " --password " + SVNPassword + " --force-log"
     
    svn = SubversionCall("mkdir " + Chr(34) + RemoteRepositery + Path + FileName + Chr(34) + " -m " + Chr(34) + t("Directory") + " " + Filename + " " + t("created") + Chr(34) + " --force-log")
    
    Output = ""
    
    If svn
      While ProgramRunning(svn)     
        While AvailableProgramOutput(svn)
          Output + MyReadProgramString(svn)
        Wend
        Delay(10)
      Wend
      
      Debug Output
      
      Repeat
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        Debug Error
      Until Error = ""
      
      CloseProgram(svn) ; Close the connection to the program
    EndIf
     
    ;Returns the fist field
    ProcedureReturn StringField(Output, 1, " ")
  
  EndIf

EndProcedure

;*****************************************************************************
Procedure.s RemoteDelete(FullPath.s)
  Protected svn, Error.s, Output.s
  
  If FullPath <> ""
    ;Debug "mkdir " + Chr(34) + RemoteRepositery + Path + FileName + Chr(34) + " -m " + Chr(34) + t("Directory") + " " + Filename + " " + t("created") + Chr(34) + " --username " + SVNUserName + " --password " + SVNPassword + " --force-log"
     
    svn = SubversionCall("delete " + Chr(34) + RemoteRepositery + FullPath + Chr(34) + " -m " + Chr(34) + FullPath + " " + t("deletion") + Chr(34) + " --force-log")
    
    Output = ""
    
    If svn
      While ProgramRunning(svn)     
        While AvailableProgramOutput(svn)
          Output + MyReadProgramString(svn)
        Wend
        Delay(10)
      Wend
      
      Debug Output
      
      Repeat
        Error.s =  ASCII2UTF8(ReadProgramError(svn))
        Debug Error
      Until Error = ""
      
      CloseProgram(svn) ; Close the connection to the program
    EndIf
     
    ;Returns the fist field
    ProcedureReturn StringField(Output, 1, " ")
  
  EndIf

EndProcedure

;*****************************************************************************
Procedure RemoteDownload(FullPath.s, Name.s, Filename.s)
  If Filename
    
    CompilerSelect #PB_Compiler_OS
        
      CompilerCase #PB_OS_Windows 
        ;Todo : This command is the only one working with proxy on Windows
        If URLDownloadToFile_(0,"" + RemoteRepositery + "" + FullPath, Filename, 0, 0) = #S_OK
        
      CompilerCase #PB_OS_Linux
        If ReceiveHTTPFile("" + RemoteRepositery + "" + FullPath, Filename)
        
      CompilerCase #PB_OS_MacOS
        If ReceiveHTTPFile("" + RemoteRepositery + "" + FullPath, Filename)
        
    CompilerEndSelect
    
      Debug "Download succeded"  
      ProcedureReturn #True
    Else
      Debug "Download failed"
      MessageRequester(t("Alert"), t("Saving failed"), #PB_MessageRequester_Ok)
      ProcedureReturn #False
    EndIf
  EndIf
EndProcedure  


;*****************************************************************************
;- MAIN

InitNetwork()

;- Define
Define.i Exploration, Event, SearchThread, nil, Item, SubLevel, IsFolder, MenuItemNb, u
Define.s Pattern, Name, FullPath, Filename, Comment

LoadPreferences()

; Initialize Translator
Translator_init("locale" + #PathSeparator, Language)

If OpenWindow(0, 0, 0, 450, 430, t("ThotBox SubVersion Tiny FrontEnd"), #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  TextGadget(#TextRemoteRepositery, 10, 11, 80, 20, t("Repositery URL"))
  StringGadget(#StringRemoteRepositery, 80, 9, 330, 20, RemoteRepositery)
  HyperLinkGadget(#HyperlinkRepositery, 420, 11, 20, 20, t("Go"), RGB(0,255,0), #PB_Font_Underline)
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
  CheckBoxGadget(#CheckboxSVNAuthCache, 10, 370, 250, 20, t("SVN authentification system"))
  TextGadget(#TextSVNUserName, 10, 392, 80, 20, t("User name"))
  StringGadget(#StringSVNUserName, 91, 390, 100, 20, SVNUserName)
  TextGadget(#TextSVNPassword, 192, 392, 65, 20, t("Password"))
  StringGadget(#StringSVNPassword, 260, 390, 90, 20, SVNPassword)
  ButtonGadget(#ButtonGetRepositery, 10, 410, 341, 20, t("Receive a repositery work copy "))
  ButtonGadget(#ButtonUpdate, 350, 390, 90, 20, t("Receive update"))
  ButtonGadget(#ButtonCommit, 350, 410, 90, 20, t("Send update"))
  ButtonGadget(#ButtonCleanup, 350, 370, 90, 20, t("Cleanup"))

  PrepareImages()
  
  Exploration = 0
  
  Repeat
    
    ;LockMutex(ThreadSync)
    
    Event = WaitWindowEvent()
    
    Select Event
        
      ;-- Gadgets events
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
            
          Case  #StringRemoteRepositery
            
            ;-#StringRemoteRepositery
            Select EventType()
                
              Case #PB_EventType_Change 
                
                RemoteRepositery = GetGadgetText(#StringRemoteRepositery)
                
            EndSelect
            
          Case #HyperlinkRepositery
            
            ;-#HyperlinkRepositery
            RunProgram(RemoteRepositery) ;launch URL
            
          Case  #StringLocalRepositery
            
            ;-#StringLocalRepositery
            Select EventType()
                
              Case #PB_EventType_LostFocus
                
                LocalRepositery = GetGadgetText(#StringLocalRepositery)
                If IsFolder(LocalRepositery) = #False
                  LocalRepositery + #PathSeparator
                EndIf
                              
            EndSelect
            
          Case #CheckboxSVNAuthCache
            
            ;-#CheckboxSVNAuthCache
            If GetGadgetState(#CheckboxSVNAuthCache)
              SVNAuthCacheFlag = #True
              DisableGadget(#StringSVNUserName, 1)     
              DisableGadget(#StringSVNPassword, 1)     
            Else
              SVNAuthCacheFlag = #false
              DisableGadget(#StringSVNUserName, 0)     
              DisableGadget(#StringSVNPassword, 0)  
            EndIf
            
          Case  #StringSVNUserName
            
            ;-#StringSVNUserName
            Select EventType()
                
              Case #PB_EventType_LostFocus
                
                If FindString(GetGadgetText(#StringSVNUserName), " ")
                  MessageRequester(t("Alert"), t("Your UserName can't contain space"), #PB_MessageRequester_Ok)
                  SetGadgetText(#StringSVNUserName, "")
                EndIf
                SVNUserName = GetGadgetText(#StringSVNUserName)
                
            EndSelect
            
         Case  #StringSVNPassword
            
           ;-#StringSVNPassword
           Select EventType()
               
             Case #PB_EventType_LostFocus 
               
               If FindString(GetGadgetText(#StringSVNPassword), " ")
                 MessageRequester(t("Alert"), t("Your Password can't contain space"), #PB_MessageRequester_Ok)
                 SetGadgetText(#StringSVNPassword, "")
               EndIf
               SVNPassword = GetGadgetText(#StringSVNPassword)
               
           EndSelect
           
          Case #ButtonSearch
            
            ;-#ButtonSearch
            Disabler()
            Exploration = #Search
            FreeGadget(#ButtonSearch)
            ButtonGadget(#ButtonStopSearch, 310, 30, 130, 20, t("Stop search"))
            ButtonStopSearchGadgetID = GadgetID(#ButtonStopSearch) ;for the search thread
            Debug ButtonStopSearchGadgetID
            Pattern.s = GetGadgetText(#StringSearch)
            SearchThread = CreateThread(@Search(), @Pattern)
            StopSearchThread = #False
            
          Case #ButtonStopSearch
            
            ;-#ButtonStopSearch
            StopSearchThread = #True
            WaitThread(SearchThread)
            FreeGadget(#ButtonStopSearch)
            ButtonGadget(#ButtonSearch, 310, 30, 130, 20, t("Search"))
            StopSearchThread = #False
            Exploration = #Search
            Enabler()
            
          Case #ButtonGetRepositeryReadOnly
            
            ;-#ButtonGetRepositeryReadOnly
            Disabler()
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonGetRepositeryReadOnly, t("Please wait"))
            CreateThread(@GetRepositeryReadOnly(), nil)
            Exploration = #Get            
            
          Case #ButtonChangeLocalRepositery
            
            ;-#ButtonChangeLocalRepositery
            If FileSize(LocalRepositery) = - 2 
              ;If folder exists
              LocalRepositery = PathRequester(t("Local repositery folder"), LocalRepositery)
            Else  
              ;Else local app folder
              LocalRepositery = PathRequester(t("Local repositery folder"), GetCurrentDirectory())
            EndIf
            SetGadgetText(#StringLocalRepositery, LocalRepositery)
            Exploration = 0            
            
          Case #ButtonGetRepositery
            
            ;-#ButtonGetRepositery
            Disabler()
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SVNUserName = GetGadgetText(#StringSVNUserName)
            SVNPassword = GetGadgetText(#StringSVNPassword)
            SetGadgetText(#ButtonGetRepositery, t("Please wait"))
            CreateThread(@GetRepositery(), nil)
            Exploration = #Get            
            
          Case #ButtonUpdate
            
            ;-#ButtonUpdate
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonUpdate, t("Please wait"))
            Update(nil)
            SetGadgetText(#ButtonUpdate, t("Receive update"))
            Exploration = #Local            
            
          Case #ButtonCleanup
            
            ;-#ButtonCleanup
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonCleanup, t("Please wait"))
            Cleanup(nil)
            SetGadgetText(#ButtonCleanup, t("Cleanup"))
            Exploration = 0            

          Case #ButtonCommit
            
            ;-#ButtonCommit
            Comment = InputRequesterOkCancel(t("Comment"), t("Give a comment for your commit"), t("Update ") + Str(Date()))
            If Comment = ""
              MessageRequester(t("Alert"), t("Canceled"), #PB_MessageRequester_Ok)
            Else
              ClearList(Tree())
              ClearGadgetItems(#TreeGadget)
              SetGadgetText(#ButtonCommit, t("Please wait"))
              Commit(Comment)
              SetGadgetText(#ButtonCommit, t("Send update"))            
              Exploration = 0
            EndIf
              
          Case #ButtonExploreRemoteRepositery
            
            ;-#ButtonExploreRemoteRepositery
            ClearList(Tree())
            ClearGadgetItems(#TreeGadget)
            SetGadgetText(#ButtonExploreRemoteRepositery, t("Please wait"))
            GetRemoteFileList(0, 0, "")
            MakeTreeGadget()
            SetGadgetText(#ButtonExploreRemoteRepositery, t("Explore remote repositery"))
            Exploration = #Remote
            
          Case #ButtonExploreLocalRepositery
            
            ;- #ButtonExploreLocalRepositery
            If FileSize(LocalRepositery) = -2
              ClearList(Tree())
              SetGadgetText(#ButtonExploreLocalRepositery, t("Please wait"))
              GetLocalFileList(0, 0, "")
              MakeTreeGadget()
              SetGadgetText(#ButtonExploreLocalRepositery, t("Explore local repositery"))
              Exploration = #Local
            Else
              MessageRequester(t("Alert"), t("Folder doesn't exist.") + Chr(13) + Chr(13) + t("Maybe should you try first ") + Chr(34) + t(" to receive a repositery copy ? ") + Chr(34) , #PB_MessageRequester_Ok)
            EndIf
            
          ;-Tree
          Case #TreeGadget
            
            Select EventType()
                
              ;-- Double click
              Case #PB_EventType_LeftDoubleClick
                
                Item = GetGadgetState(#TreeGadget)
                SubLevel = GetGadgetItemAttribute(#TreeGadget, Item, #PB_Tree_SubLevel)
                Name.s = GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel)
                IsFolder = GetGadgetItemData(#TreeGadget, Item)
                FullPath.s = GetFullPathFromTree(Item, SubLevel)
                
                If Exploration = #Local
                  
                  ;-Local Exploration
                  If IsFolder And (GetGadgetItemState(#TreeGadget, Item) & #PB_Tree_Expanded) = #False
                    ;If folder & not opened, look into
                    SetGadgetText(#ButtonExploreLocalRepositery, t("Please wait"))
                    GetLocalFileList(Item + 1, SubLevel + 1, FullPath)
                    MakeTreeGadget()
                    SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
                    SetGadgetState(#TreeGadget, Item)
                    SetGadgetText(#ButtonExploreLocalRepositery, t("Explore local repositery"))                
                  EndIf
                    
                ElseIf Exploration = #Remote
                  
                  ;-Remote exploration
                  If IsFolder
                    ;If folder, look into
                    If (GetGadgetItemState(#TreeGadget, Item) & #PB_Tree_Expanded) = #False
                      SetGadgetText(#ButtonExploreRemoteRepositery, t("Please wait"))
                      GetRemoteFileList(Item + 1, SubLevel + 1, FullPath)
                      MakeTreeGadget()
                      SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
                      SetGadgetState(#TreeGadget, Item)
                      SetGadgetText(#ButtonExploreRemoteRepositery, t("Explore remote repositery"))
                    EndIf
                  Else
                    Name = GetFilePart(Name) ;In case where the Name is coming from a search with a full path
                    ;If file, download it
                    Filename = SaveFileRequester(t("Where should I save file ") + Name + " ?", Name, "", 0)
                    RemoteDownload(FullPath, Name, Filename)
                  EndIf
                  
                ElseIf Exploration = #Search
                  
                  ;-Search results exploration
                  If IsFolder = #False
                    Name = GetFilePart(Name) ;In case where the Name is coming from a search with a full path
                    ;If file, download it
                    Filename = SaveFileRequester(t("Where should I save file ") + Name + " ?", Name, "", 0)
                    RemoteDownload(FullPath, Name, Filename)
                  EndIf                 
                EndIf
                
              ;-- Right click
              Case #PB_EventType_RightClick
                
                Item = GetGadgetState(#TreeGadget)
                SubLevel = GetGadgetItemAttribute(#TreeGadget, Item, #PB_Tree_SubLevel)
                Name.s = GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel)
                IsFolder = GetGadgetItemData(#TreeGadget, Item)
                FullPath.s = GetFullPathFromTree(Item, SubLevel)
                
                Select Exploration
                    
                  Case #Local
                    ;-Local Popup Menu
                    If CreatePopupMenu(0)
                      SelectElement(Tree(), Item)
                      If IsFolder = #False
                        MenuItem(#PopupMenuOpen, t("Open"))
                      EndIf
                      If StatusName(tree()\Status) <> ""
                        MenuItem(#PopupMenuStatus, StatusName(tree()\Status))
                        DisableMenuItem(0, #PopupMenuStatus, 1)
                        MenuItem(#PopupMenuAdd, t("Add"))
                        MenuItem(#PopupMenuRevert, t("Undo"))
                      EndIf
                      MenuItem(#PopupMenuDelete, t("Delete"))
                    EndIf
                    DisplayPopupMenu(0, WindowID(0))
                    
                  Case #Get
                    ;-Local Popup Menu
                    If CreatePopupMenu(0)
                      SelectElement(Tree(), Item)
                      If IsFolder = #False
                        MenuItem(#PopupMenuOpen, t("Open"))
                      EndIf                      
                      If StatusName(tree()\Status) <> ""
                        MenuItem(#PopupMenuStatus, StatusName(tree()\Status))
                        DisableMenuItem(0, #PopupMenuStatus, 1)
                      EndIf
                      MenuItem(#PopupMenuDelete, t("Delete"))
                    EndIf
                    DisplayPopupMenu(0, WindowID(0))
                    
                  Case #Remote
                    ;-Remote Popup Menu
                    If CreatePopupMenu(0)
                      SelectElement(Tree(), Item)
                      If IsFolder = #False
                        MenuItem(#PopupMenuRemoteDownload, t("Download"))
                        MenuItem(#PopupMenuRemoteOpen, t("Open"))
                      EndIf
                      If GetGadgetText(#StringSVNUserName) <> "" And GetGadgetText(#StringSVNPassword) <> "" 
                        MenuItem(#PopupMenuRemoteMkdir, t("Create directory"))
                        MenuItem(#PopupMenuRemoteDelete, t("Delete"))
                      EndIf
                    EndIf
                    DisplayPopupMenu(0, WindowID(0))
                    
                  Case #Search
                    ;-Search Popup Menu
                    If CreatePopupMenu(0)
                      SelectElement(Tree(), Item)
                      If IsFolder = #False
                        MenuItem(#PopupMenuRemoteDownload, t("Download"))
                        MenuItem(#PopupMenuRemoteOpen, t("Open"))
                      EndIf             
                    EndIf
                    DisplayPopupMenu(0, WindowID(0))
                    
                EndSelect
            EndSelect
            
        EndSelect
        
      ;-- Menus events
        
      Case #PB_Event_Menu
        
        Select EventMenu()  ; To see which menu has been selected
            
          Case #PopupMenuOpen
            
            Item = GetGadgetState(#TreeGadget)
            
            FullPath.s = GetFullPathFromTree(Item, SubLevel)
            RunProgram(FullPath, "", GetPathPart(FullPath))
            
          Case #PopupMenuAdd
            
            Item = GetGadgetState(#TreeGadget)

            SelectElement(Tree(), Item)
            Add(Tree()\FullPath)
            Tree()\Status = Status(Tree()\FullPath)
            MakeTreeGadget()
            SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
            SetGadgetState(#TreeGadget, Item)
            
          Case #PopupMenuRevert
            
            Item = GetGadgetState(#TreeGadget)
            
            SelectElement(Tree(), Item)
            Revert(Tree()\FullPath)
            Tree()\Status = Status(Tree()\FullPath)
            MakeTreeGadget()
            SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
            SetGadgetState(#TreeGadget, Item)
            
          Case #PopupMenuDelete
            
            Item = GetGadgetState(#TreeGadget)

            SelectElement(Tree(), Item)
            If MessageRequester(t("Deletion"), t("Are you sure to want to delete this item ?"), #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
              Delete(Tree()\FullPath)
              Tree()\Status = Status(Tree()\FullPath)
              MakeTreeGadget()
              SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
              SetGadgetState(#TreeGadget, Item)
            EndIf
            
          Case #PopupMenuRemoteDownload
            
            Item = GetGadgetState(#TreeGadget)
            Name.s = GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel)
            FullPath.s = GetFullPathFromTree(Item, SubLevel)
            Name = GetFilePart(Name) ;In case where the Name is coming from a search with a full path
            Filename = SaveFileRequester(t("Where should I save file ") + Name + " ?", Name, "", 0)
            RemoteDownload(FullPath, Name, Filename)
            
          Case #PopupMenuRemoteOpen
            
            Item = GetGadgetState(#TreeGadget)
            Name.s = GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel)
            FullPath.s = GetFullPathFromTree(Item, SubLevel)
            Name = GetFilePart(Name) ;In case where the Name is coming from a search with a full path
            If RemoteDownload(FullPath, Name, GetTemporaryDirectory() + Name)
              RunProgram(GetTemporaryDirectory() + Name, "", GetTemporaryDirectory())
            EndIf
            
          Case #PopupMenuRemoteDelete
            
            Item = GetGadgetState(#TreeGadget)
            SubLevel = GetGadgetItemAttribute(#TreeGadget, Item, #PB_Tree_SubLevel)
            Name.s = GetGadgetItemText(#TreeGadget, Item, #PB_Tree_SubLevel)
            IsFolder = GetGadgetItemData(#TreeGadget, Item)
            FullPath.s = GetFullPathFromTree(Item, SubLevel)

            SelectElement(Tree(), Item)
            If MessageRequester(t("Deletion"), t("Are you sure to want to delete this item ?"), #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
              RemoteDelete(Tree()\FullPath)
              SetGadgetText(#ButtonExploreRemoteRepositery, t("Please wait"))
              SelectElement(Tree(), Item)
              SubLevel = Tree()\SubLevel
              If SubLevel = 0
                ;Full tree
                GetRemoteFileList(0, 0, "")          
              Else
                For u = Item To 0 Step -1
                  PreviousElement(Tree())
                  If Tree()\Sublevel < SubLevel
                    Break
                  EndIf
                Next
                Item = Tree()\Item
                GetRemoteFileList(Item + 1, Tree()\Sublevel + 1, Tree()\FullPath)          
              EndIf
              MakeTreeGadget()
              SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
              SetGadgetState(#TreeGadget, Item)
              SetGadgetText(#ButtonExploreRemoteRepositery, t("Explore remote repositery"))
              Exploration = #Remote
            EndIf
            
          Case #PopupMenuRemoteMkdir
            
            Item = GetGadgetState(#TreeGadget)
            SubLevel = GetGadgetItemAttribute(#TreeGadget, Item, #PB_Tree_SubLevel)
            
            Name = InputRequesterOkCancel(t("Create directory"), t("Give the future directory a name"), "")
            Name = ReplaceString(ReplaceString(ReplaceString(ReplaceString(Name, "?", ""), ":", ""), "/", ""), "\", "")
            If Name <> ""
              RemoteMakedir(GetPathPart(Tree()\FullPath), Name)  
              SetGadgetText(#ButtonExploreRemoteRepositery, t("Please wait"))
              SelectElement(Tree(), Item)
              SubLevel = Tree()\SubLevel
              If Sublevel = 0
                ;Full tree
                GetRemoteFileList(0, 0, "")
              Else
              ;If user have clicked on a file, retrieve in what folder we are to recreate the tree
              If tree()\FolderFlag = #False
                For u = Item To 0 Step -1
                  PreviousElement(Tree())
                  If Tree()\Sublevel < SubLevel
                    Break
                  EndIf
                Next
                Item = Tree()\Item
              EndIf
              GetRemoteFileList(Item + 1, Tree()\Sublevel + 1, Tree()\FullPath)
              EndIf
              MakeTreeGadget()
              SetGadgetItemState(#TreeGadget, Item, #PB_Tree_Selected)
              SetGadgetState(#TreeGadget, Item)
              SetGadgetText(#ButtonExploreRemoteRepositery, t("Explore remote repositery"))
              Exploration = #Remote
              SetGadgetText(#ButtonExploreRemoteRepositery, t("Explore remote repositery"))
              Exploration = #Remote
            EndIf
            
        EndSelect
            
    EndSelect
    
    If DisableGadgetsFlag = #False
      ;Disable "full access" gadgets if SVNUserName&SVNPassword are not given
      If GetGadgetText(#StringSVNUserName) = "" Or GetGadgetState(#CheckboxSVNAuthCache)
        DisableGadget(#StringSVNPassword, 1)     
      Else
        DisableGadget(#StringSVNPassword, 0)
      EndIf
      If (GetGadgetText(#StringSVNUserName) = "" Or GetGadgetText(#StringSVNPassword) = "") And GetGadgetState(#CheckboxSVNAuthCache) = #PB_Checkbox_Unchecked
        DisableGadget(#ButtonGetRepositery, 1)
        DisableGadget(#ButtonCommit, 1)
        DisableGadget(#ButtonUpdate, 1)
      ElseIf (GetGadgetText(#StringSVNUserName) <> "" And GetGadgetText(#StringSVNPassword) <> "") Or GetGadgetState(#CheckboxSVNAuthCache) = #PB_Checkbox_Checked
        DisableGadget(#ButtonGetRepositery, 0)
        DisableGadget(#ButtonCommit, 0)
        DisableGadget(#ButtonUpdate, 0)      
      EndIf
    EndIf    
    
    ;Hate to have to do that but I don't have postmessage_()
;     If CleanupSearch
;       FreeGadget(#ButtonStopSearch)
;       ButtonGadget(#ButtonSearch, 310, 30, 130, 20, t("Search"))
;       StopSearchThread = #False
;       Enabler()
;       CleanupSearch = #False
;     EndIf   
    
  Until Event = #PB_Event_CloseWindow
  
EndIf

;-End
SavePreferences()
Translator_destroy()

End
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x86)
; CursorPosition = 1412
; FirstLine = 1394
; Folding = ------
; Markers = 933
; EnableUnicode
; EnableXP
; UseIcon = gfx\ibisv2.ico
; Executable = ThotboxSVNFrontend.exe
; EnablePurifier