; English forum: http://purebasic.myforums.net/viewtopic.php?t=7350
; Author: Fangbeast
; Date: 26. August 2003

;=========================================================================================================================================== 
; Original code and idea (Could not have done database without him) :                 Rings. 
; Reworked and made automatic and easy                              :                 Paul. 
; Bashed over the head and extensively redone to suit my needs      :                 Fangles/FangBeast/BeastFang etc 
; 
; Note: I prefer to use subroutines wherever possible now as I have learned from a great many people that it is slightly faster than a 
; Procedure but that is my choice and no-one has to be locked into that. Also, I don't have to explicitly declare my variables global this 
; was as they will remain so. 
; 
; The raw database header can be renamed to whatever you like that makes sense to you, as can any variable I/we have used as once again, 
; nothing is set in concrete. The raw file can be created by using Microsoft Access to create a blank database with no table in it. 
; Actually, you can probably use any database program. 
; 
; Also, I have headr that you can create this header on the fly by using the API. Unfortunately, I do not know how to do it or I would 
; tell you. 
; 
; Note1: Also remember that if you have a subroutine that calls a procedural function, either have the procedure 'on top' of the calling 
; routine or remember to put a procedural declaration for it at the top of your code as PureBasic doesn't maintain a searchable procedure 
; stack, it is a single pass compiler (as I understand it). 
; 
; Note2: The "MessageRequester" parts can be replaced with debug statements for yourself as you develop your program or as LarsG recently 
; Suggested to me, make all the relevant sections into procedures with their own error return codes to check each stage of the database and 
; table creation routines for total control over the process or custom error routines etc. 
;=========================================================================================================================================== 

#ODBCLibrary      = 1 
#StringMemory     = 1 

;============================================================================================================================ 
; This part originally reworked by paul to autocreate a database and autofill it with a table. I re-did the entire thing so 
; that you can create any new databases in your program whenever you wanted to. 
;============================================================================================================================ 

makeanewdatabase: 

  databasename.s = SaveFileRequester("Create Database", "icat.mdb", "Database File | *.mdb" , 0) ; Get database name from the user 
  name.s = GetFilePart(databasename.s) : name.s = Left(name.s, Len(name.s) - 4)                  ; Strip the name from the path 
  user.s = ""                                                                                    ; Not using a user name 
  pass.s = ""                                                                                    ; not using a password 

  If OpenDatabase(0, name.s, user.s, pass.s) = 0        ; If database can't be opened, now we create it 

    If CreateFile(0, databasename.s)                    ; Database doesn't exist so we create a blank one with the 'databasename.s' variable 
      WriteData(?database, 40960)                       ; Write the raw database header to the newly created file 
      CloseFile(0)                                      ; Close the file now if we successfully created it 
      builddb = 1                                       ; Create a flag saying it was done okay 
      MessageRequester("Create Blank Database", "Blank Database " + databasename.s + " has been created And opened For use", #PB_MessageRequester_Ok) 
    Else                                                ; Otherwise, give an error message and exit the subroutine 
      MessageRequester("Make a New Database", "Could not create the blank database, raw header not found or damaged", #PB_MessageRequester_Ok) 
      fileopen = 0                                      ; Make sure other routines know a file was never opened to prevent errors 
      Return                                           ; get right out of this routine now 
    EndIf 
    
    DataSection                                        ; Raw database data 
      database: IncludeBinary "C:\Development\My Code\iCat\Resource\_db.raw"  ; My path to my raw header data (Can make with Access) 
    EndDataSection 
    
    result = Makeconnection("Microsoft Access Driver (*.mdb)", "Server=APServer;Description=" + name + ";DSN=" + name + ";DBQ=" + databasename + ";UID=" + "" + ";PWD=" + "" + ";")    

  EndIf                                                 ; End of the routine 

  ;------------------------------------------------------------------------------------------------ 

  If OpenDatabase(0, name.s, user.s, pass.s)            ; If we can now open the new database, do the following 
    rt = 1                                              ; Tell other routines we opened the database okay to now make a table 
    MessageRequester("Open New Database", "New Database " + databasename.s + " has been opened successfully", #PB_MessageRequester_Ok) 
    fileopen = 1                                        ; Tell other routines the file was opened okay 
  Else                                                  ; Otherwise do the below 
    MessageRequester("Open New Database", "Could not open the database that was just created", #PB_MessageRequester_Ok) 
    fileopen = 0                                         ; Tell other routines the database cannot be opened, so don't use it 
    Return                                              ; Now get the heck out of here 
  EndIf                                                 ; End of the routine 
    
  If builddb And rt                                     ; If database was both created and opened successfully, now make the table 
    query.s = "create table Style(id autoincrement, deleted long, marked long, dvol text(3), dlabel text(15), dfile text(254), " 
    query.s + "fver text(6), fcrc text(15) unique, fid0 text(20), fname text(50), ftype text(15), fsize text(15), fcat text(30), " 
    query.s + "fcoll text(30), fdisp text(30), tmark text(30), tlink text(50), fid1 text(20), fid2 text(20), fid3 text(20), " 
    query.s + "fid4 text(20), fid5 text(20), comment memo);" 
    If DatabaseQuery(query.s) <> 0                      ; Send the created sql query string to the SQL ODBC driver 
    Else                                                ; Otherwise do the below 
      MessageRequester("Create Table", "Failed To create the table in the open database", #PB_MessageRequester_Ok) 
      fileopen = 0                                      ; Can't create the table so tell other routines not to use it 
      Return                                           ; Get the heck out of here 
    EndIf                                              ; End of the routine 
  EndIf                                                ; End of the routine 

Return 

;============================================================================================================================ 
; Make an ODBC connection to a database on disk (This part created by Rings, not sure if Paul did anything to it) 
;============================================================================================================================ 

Procedure.l MakeConnection(Driver.s, strAttributes.s) 

  Result = OpenLibrary(#ODBCLibrary, "ODBCCP32.DLL")              ; Open the ODBC library as Library number 1 
  
  If Result                                                       ; If the library was able to be opened, do the following  
    MyMemory = AllocateMemory(#StringMemory, Len(strAttributes))  ; Allocate the memory you need here 
    CopyMemory(@strAttributes, MyMemory, Len(strAttributes))      ; Copy the database information string into the memory space 
  
    For L = 1 To Len(strAttributes)                               ; Check the string in the memory space now 
      If PeekB(MyMemory + L - 1) = Asc(";")                       ; If you find a semicolon anywhere in the string 
        PokeB(MyMemory + L - 1, 0)                                ; Replace it with an empty character as the driver doesn't use it 
      EndIf                                                       ; End the current check 
    Next L                                                        ; Check the next byte 
  
    Result = CallFunction(1, "SQLConfigDataSource", 0, 1, Driver, MyMemory)   ; Call the function you need from the ODBC library with the right details 
    
    FreeMemory(#StringMemory)                                     ; Free the memory now 
    
    CloseLibrary(#ODBCLibrary)                                    ; Close the library 
  
    If Result                                                     ; If the fucntion call worked, tell the rest of the code 
      ProcedureReturn 1                                         ; Return the result 
    EndIf                                                         ; End the check 
    
  EndIf                                                           ; End the routine 
  
EndProcedure 

;============================================================================================================================ 
; Notes 
;============================================================================================================================ 
; 
; "icat.mdb"                                        is my default database name 
; "C:\Development\My Code\iCat\Resource\_db.raw"    is the path to the raw database header that can be created by Access itself 
;                                                   It's only around 40k or so. 
; 
; create table Style                                SQL command to create a table called "Style" in the current opened database 
; id autoincrement                                  Automatically increment the record number as you add records 
; 
;============================================================================================================================ 
; Value types 
;============================================================================================================================ 

; deleted long                                      a field called "deleted" which is a purebasic long value 
; dvol text(3)                                      a field called "dvol" which is a text field of 3 characters long 
; comment memo                                      a field called "comment" which is a memo field in SQL. This length of a 
;                                                   string you can pass here is unfortunately subject to purebasic's string 
;                                                   length limitation which will be addressed in future releases 
;                                                  
;============================================================================================================================ 
; Simpler example for table creation 
;============================================================================================================================ 

; QueryString.s = "Create Table MyTable(ID AutoIncrement, DeadRecord Long, RecordName Text(128), Description memo);" 


; NOTE **  Don't forget the semicolon at the end of the SQL string or you will get an error 


; ExecutableFormat=
; FirstLine=1
; EnableXP
; EOF