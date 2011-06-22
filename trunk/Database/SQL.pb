; English forum:
; Author: Fangbeast
; Date: 17. June 2003


;Just in case anyone is interested... Table name is 'Stuff'
;               0   1        2         3         4         5           6        7          8              9
; table = Stuff(id, dosname, filename, filetype, category, collection, display, trademark, trademarklink, size)
#WinWidth = 956
#WinHeight = 508
#WorkPanel = 1
#ListBox = 2
#RunStandardQuery = 3
#RunSqlQuery = 4
#StandardSearchBox = 5
#SqlQueryBox = 6
#SearchType = 7
#Collumn = 8
#KeyWord = 9
#ExitProgram = 10
;--------------------------------------------------------------------------------------------------------------
; Setup global strings so we don't have to constantly pass long winded parameters
;--------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------
; Declare any needed routines
;--------------------------------------------------------------------------------------------------------------
Declare RunQuery(FindString$, SearchType$, Collumn$, KeyWord$)
Declare RunQueryThread(Parameter)
Declare BuildParametersBox()
;- Build the parameters box whenever I need it ----------------------------------------------------------------
Procedure BuildParametersBox()
  ComboBoxGadget(#SearchType, 120, 10, 120, 160)
    AddGadgetItem(#SearchType, -1, "Equal To") 
    AddGadgetItem(#SearchType, -1, "Greater Than")
    AddGadgetItem(#SearchType, -1, "Less Than")
    AddGadgetItem(#SearchType, -1, "Greater Than/Equal To")
    AddGadgetItem(#SearchType, -1, "Less Than/Equal To")
    AddGadgetItem(#SearchType, -1, "Not Equal")
    AddGadgetItem(#SearchType, -1, "LIKE")
  ComboBoxGadget(#Collumn, 250, 10, 80, 220)
    AddGadgetItem(#Collumn, -1, "id")
    AddGadgetItem(#Collumn, -1, "dosname")
    AddGadgetItem(#Collumn, -1, "filename")
    AddGadgetItem(#Collumn, -1, "filetype")
    AddGadgetItem(#Collumn, -1, "category")
    AddGadgetItem(#Collumn, -1, "collection")
    AddGadgetItem(#Collumn, -1, "display")
    AddGadgetItem(#Collumn, -1, "trademark")
    AddGadgetItem(#Collumn, -1, "trademarklink")
    AddGadgetItem(#Collumn, -1, "size")
  ComboBoxGadget(#KeyWord, 330, 10, 80, 220)
    AddGadgetItem(#KeyWord, -1, "Select")
    AddGadgetItem(#KeyWord, -1, "Delete")
    AddGadgetItem(#KeyWord, -1, "Insert")
    AddGadgetItem(#KeyWord, -1, "Update")
                
EndProcedure
;--------------------------------------------------------------------------------------------------------------
; This is where we shall find the item we are searching for
;--------------------------------------------------------------------------------------------------------------
Procedure RunQuery(FindString$, SearchType$, Collumn$, KeyWord$)     ; Find matching data and present it
If CountGadgetItems(#ListBox) <> 0                                    ; Clear all items out of the list for new query
  ClearGadgetItemList(#ListBox)
EndIf
Counter = 1
  Select SearchType$
    Case ""
    Query$ = KeyWord$ + " * from Stuff"
    Case "Equal To"
      Query$ = KeyWord$ + " * from Stuff where " + Collumn$ + " = " + "'" + FindString$ + "';"
    Case "Greater Than"
      Query$ = KeyWord$ + " * from Stuff where " + Collumn$ + " > " + "'" + FindString$ + "';"
    Case "Less Than"
      Query$ = KeyWord$ + " * from Stuff where " + Collumn$ + " < " + "'" + FindString$ + "';"
    Case "Greater Than/Equal To"
      Query$ = KeyWord$ + " * from Stuff where " + Collumn$ + " >= " + "'" + FindString$ + "';"
    Case "Less Than/Equal To"
      Query$ = KeyWord$ + " * from Stuff where " + Collumn$ + " <= " + "'" + FindString$ + "';"
    Case "Not Equal"
      Query$ = KeyWord$ + " * from Stuff where " + Collumn$ + " <> " + "'" + FindString$ + "';"
    Case "LIKE"
      Query$ = KeyWord$ + " * from Stuff where " + Collumn$ + " LIKE " + "'%" + FindString$ + "%';"
    Case "All"
  EndSelect
    
If DatabaseQuery(Query$)                                              ; Build the table if you can
  While NextDatabaseRow()
  
    record$ = GetDatabaseString(0)
    dosname$ = GetDatabaseString(1)
    filename$ = GetDatabaseString(2)
    filetype$ = GetDatabaseString(3)
    category$ = GetDatabaseString(4)
    collection$ = GetDatabaseString(5)
    display$ = GetDatabaseString(6)
    trademark$ = GetDatabaseString(7)
    trademarklink$ = GetDatabaseString(8)
    filesize$ = GetDatabaseString(9)
    
    AddGadgetItem(#ListBox, Counter - 1, record$ + Chr(10) + dosname$ + Chr(10) + filename$ + Chr(10) + filetype$ + Chr(10) + category$ + Chr(10) + collection$ + Chr(10) + display$ + Chr(10) + trademark$  + Chr(10) + trademarklink$ + Chr(10) + filesize$, 0)
    Counter + 1
  Wend
  Else                                                                ; Otherwise do the following
  MessageRequester("Error", Query$, 0)                                ; Give an error message about what failed
EndIf
EndProcedure
;- This thread runs the query box with the right parameters ---------------------------------------------------
Procedure RunQueryThread(Parameter)
  Shared FindString$, SearchType$, Collumn$, KeyWord$
  RunQuery(FindString$, SearchType$, Collumn$, KeyWord$)
EndProcedure
;- Initialise the database driver environment -----------------------------------------------------------------
If InitDatabase() = 0
  MessageRequester("Error","Could not Initialize ODBC Database Objects", 0)
  End
EndIf
;- Initialise the database ------------------------------------------------------------------------------------
If OpenDatabase(0, "IncrediMail", "", "") ; I've alreadyd efined, filled and connected my database :)
;  If OpenDatabaseRequester(0) = 0 
;    MessageRequester("Error","Could not open the specified Database", 0)
;    End 
;  EndIf
Else
   MessageRequester("Error","Could not open the specified Database", 0)
   End
EndIf
;- Open a window for our results to be shown, more civilised than console -------------------------------------
hWnd = OpenWindow(0, Random(GetSystemMetrics_(#SM_CXSCREEN) - #WinWidth), Random(GetSystemMetrics_(#SM_CYSCREEN) - #WinHeight), #WinWidth, #WinHeight, #PB_Window_SystemMenu , "SQL FindIt Box")
If hWnd = 0 Or CreateGadgetList(WindowID()) = 0
  Notest = MessageRequester("Can't Open", "Can't open a window, draw gadgets or attach a menu!!!", #PB_MessageRequester_Ok )
  End
EndIf
ListIconGadget(#ListBox, 10, 10, 937, 418, "Record", 50, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect | #PB_ListIcon_MultiSelect)   ; Listview box with first item title
  AddGadgetColumn(#ListBox, 1, "DiskFile", 100)
  AddGadgetColumn(#ListBox, 2, "FileName", 100)
  AddGadgetColumn(#ListBox, 3, "FileType", 80)
  AddGadgetColumn(#ListBox, 4, "Category", 80)
  AddGadgetColumn(#ListBox, 5, "Collection", 100)
  AddGadgetColumn(#ListBox, 6, "Display", 100)
  AddGadgetColumn(#ListBox, 7, "TradeMark", 150)
  AddGadgetColumn(#ListBox, 8, "TradeMarkLink", 150)
  AddGadgetColumn(#ListBox, 9, "FileSize", 50)
  
  PanelGadget(#WorkPanel, 10, 430, 937, 66)
  
  AddGadgetItem(#WorkPanel, 0, "Standard")
    ButtonGadget(#RunStandardQuery, 8, 10, 100, 20, "Do It")
    BuildParametersBox()
    StringGadget(#StandardSearchBox, 420, 10, 504, 20, "")
      
  CloseGadgetList()
  
;- All finished so close the database and end -----------------------------------------------------------------
Repeat
  EventID = WaitWindowEvent()                                                         ; Check for any window events
  
  If EventID = #PB_EventGadget                                                        ; Check for gadget events in a window
    Select EventGadgetID()                                                            ; Load the current ID into memory
    
      Case #RunStandardQuery
        FindString$ = GetGadgetText(#StandardSearchBox)
        SearchType$ = GetGadgetText(#SearchType)
        Collumn$ = GetGadgetText(#Collumn)
        KeyWord$ = GetGadgetText(#KeyWord)
        If KeyWord$ <> ""
          CreateThread(@RunQueryThread(), Parameter)
        EndIf
      Case #ExitProgram
        End
    EndSelect
  EndIf
Until EventID = #PB_Event_CloseWindow
CloseDatabase(0)
End
;- We is finished folks!! -------------------------------------------------------------------------------------
; ExecutableFormat=Windows
; FirstLine=1
; EnableAsm
; EnableXP
; Executable=M:\Documents and Settings\fred\Bureau\Gadget.exe
; EOF