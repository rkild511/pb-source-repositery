; English forum: 
; Author: Rings (updated for PB3.92+ by Lars, updated for PB 4.00 by Andre)
; Date: 05. May 2003
; OS: Windows
; Demo: No


; Notes: This example works fine for Access, if you want to make a DSN connection to a MsSQL 2000 Server
; then create your dsn by hand or read the docu about M$-sql-server carefully. 

; Enhanced Database example 
;by Siegfried Rings (CodeGuru) 
;File$ = OpenFileRequester("PureBasic - Open", "C:\*.mdb", "Microsoft Access (*.mdb)|*.mdb;*.bat|Microsoft Excel (*.xls)|*.xls", 1) 
File$ = "C:\TestDB.mdb" 
#ODBC_ADD_DSN = 1 ; Add Data source 
#ODBC_CONFIG_DSN = 2 ; Configure (edit) Data source 
#ODBC_REMOVE_DSN = 3 ; Remove Data source 
Procedure Makeconnection(Driver.s,strAttributes.s) 
  Result=OpenLibrary(1,"ODBCCP32.DLL") 
  If Result 
    lpszDriver.s=Driver 
    MyMemory=AllocateMemory(Len(strAttributes)) 
    CopyMemory(@strAttributes,MyMemory,Len(strAttributes)) 
    For l=1 To Len(strAttributes ) 
      If PeekB(MyMemory +l-1)=Asc(";"):PokeB(MyMemory +l-1,0):  EndIf 
    Next l 
    Result = CallFunction(1, "SQLConfigDataSource", 0,#ODBC_ADD_DSN,lpszDriver.s,MyMemory ) 
    NewResult=SQLConfigDataSource_(0,#ODBC_ADD_DSN,lpszDriver.s,MyMemory ) 
    
    FreeMemory(MyMemory) 
    CloseLibrary(1) 
    If Result 
      ProcedureReturn 1 
    EndIf 
  EndIf 
EndProcedure 

Procedure DeleteConnection(Driver.s,DSN.s) 
  Result=OpenLibrary(1,"ODBCCP32.DLL") 
  If Result 
    lpszDriver.s=Driver 
    strAttributes.s = "DSN="+DSN 
    Result = CallFunction(1, "SQLConfigDataSource", 0,#ODBC_REMOVE_DSN,lpszDriver.s,strAttributes ) 
    CloseLibrary(1) 
    If Result 
      ProcedureReturn 1;MessageRequester("Info","DSN Delete",0) 
    EndIf 
  EndIf 
EndProcedure 


MeinPointer.l 
Procedure GetDBHandle() 
  Shared MeinPointer.l 
  !EXTRN _PB_DataBase_CurrentObject;_PB_DataBase_CurrentObject 
  !MOV dword Eax,[_PB_DataBase_CurrentObject] 
  !MOV dword [v_MeinPointer], Eax 
  ProcedureReturn MeinPointer 
EndProcedure 


;File$ = OpenFileRequester("PureBasic - Open", "C:\*.mdb", "Microsoft Access (*.mdb)|*.mdb;*.bat|Microsoft Excel (*.xls)|*.xls", 1) 
File$ = "C:\TestDB.mdb" 
If File$<>"" 
  ;  MessageRequester("Information", "Selected File: "+File$, 0); 
Else 
  End 
EndIf 

EXT.s=UCase(GetExtensionPart(File$)) 
Select EXT 
  Case "MDB" 
    Result=Makeconnection("Microsoft Access Driver (*.mdb)","Server=SomeServer; Description=Description For Purebasic MDB-ODBC;DSN=PureBasic_DSN;DBQ="+File$+";UID=Rings;PWD=Siggi;") 
    ;Case "XLS" 
    ; Result=Makeconnection("Microsoft Excel Driver (*.xls)","DSN=PureBasic_DSN;Description=Description For Purebasic Excel;FileType=Excel97;DBQ="+File$+";") 
EndSelect 

If InitDatabase() = 0 
  MessageRequester("Error", "Can't initialize Database (ODBC v3 or better) environment", 0) 
  End 
EndIf 

OpenConsole() 

Dim DatabaseType.s(4) 
DatabaseType(0) = "Unknown" 
DatabaseType(1) = "Numeric" 
DatabaseType(2) = "String" 
DatabaseType(3) = "Float" 

; First, let's see which drivers are attached to the system.. 
; 
PrintN("Available drivers:") 
PrintN("") 

If ExamineDatabaseDrivers() 
  While NextDatabaseDriver() 
    PrintN(DatabaseDriverName()+" - "+DatabaseDriverDescription()) 
  Wend 
EndIf 

; Open an ODBC database 
; 
;'If OpenDatabaseRequester(0) 
User$="" 
Password$="" 
#Database=1 
Result = OpenDatabase(#Database, "PureBasic_DSN", User$, Password$) 
If Result 
  Browse$="Select * from Authors" 
  PrintN("") 
  PrintN("Database successfully opened !") 
  
  
  PrintN("Type EXIT to quit.") 
  PrintN("or anything else to browse database") 
  
  Repeat 
    Command$ = Input() 
    Select UCase(Command$) 
      Case "EXIT" 
        Quit = 1 
        
      Default 
        
        If DatabaseQuery(#Database, Browse$) 
          
          NbColumns = DatabaseColumns(#Database) 
          PrintN("NbColums: " + Str(NbColumns)) 
          
          For k=0 To NbColumns-1 
            PrintN(DatabaseColumnName(#Database, k) + " - " + DatabaseType(DatabaseColumnType(#Database, k))) 
          Next 
          
          PrintN("") 
          Print ("Press return to continue") : Input() 
          PrintN("") 
          PrintN("Query Result -------------------------------------") 
          
          While NextDatabaseRow(#Database) 
            PrintN(GetDatabaseString(#Database, 0)+Chr(9) +GetDatabaseString(#Database, 1)) 
          Wend 
          
          PrintN("--------------------------------------------------") 
        Else 
          PrintN("Bad Query !") 
        EndIf 
    EndSelect 
  Until Quit = 1 
Else 
  MessageRequester("Info", "Operation canceled", 0) 
EndIf 

;and delete: 
DeleteConnection("Microsoft Access Driver (*.mdb)","PureBasic_DSN") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -