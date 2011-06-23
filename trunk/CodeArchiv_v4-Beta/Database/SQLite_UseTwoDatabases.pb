; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8172&highlight=
; Author: El_Choni
; Date: 03. November 2003
; OS: Windows
; Demo: 

; Test for SQLite library v 1.33 
; Open more than one database 
; (a little example of opening and using two databases at the same time)

; make sure SQLite library is present 
If InitSQLite() 
  ; first database 
  DBName$ = "myrecipes.db" 
  ; Open database or create it if it doesn't exist 
  ; If you don't put an index, 0 will be used by default 
  DBHandle = SQLiteOpen(DBName$) 
  If DBHandle 
    ; Create test table if it doesn't exist 
    Result = SQLiteExec("CREATE TABLE recipes (id, name, ingredients, howto)") 
    ; Insert rows in table 
    Debug "CREATE result = "+Str(Result)+" - "+SQLiteError(Result) 
    Result = SQLiteExec("INSERT INTO recipes VALUES(1, 'Boiled egg', 'egg, water', 'Boil and eat')") 
    Debug "INSERT result = "+Str(Result)+" - "+SQLiteError(Result) 
    Result = SQLiteExec("INSERT INTO recipes VALUES(2, 'Fried egg', 'egg, oil, salt', 'Fry, salt and eat')") 
    Debug "INSERT result = "+Str(Result)+" - "+SQLiteError(Result) 
    Result = SQLiteExec("INSERT INTO recipes VALUES(3, 'Scrambled egg', 'egg, water, salt', 'Drop in boiling salted water, eat')") 
    Debug "INSERT result = "+Str(Result)+" - "+SQLiteError(Result) 
    Debug "" 
    Debug "Rows changed = " + Str(SQLiteRowsChanged()) 
    Debug "Last row inserted = " + Str(SQLiteLastInsertedRow()) 
    Debug "" 
    ; Get table (execute SQL query) 
    Result = SQLiteGetTable("SELECT id, name, ingredients, howto FROM recipes") 
    If Result=#SQLITE_OK 
      Rows = SQLiteRows() ; doesn't include headers row 
      Cols = SQLiteCols() 
      ; get the results 
      ; display number of rows/columns 
      Debug "Rows = " + Str(Rows) 
      Debug "Columns = " + Str(Cols) 
      ; Display column headers 
      For Col=0 To Cols-1 
        Debug SQLiteData(0, Col) 
      Next 
      ; Display returned rows 
      For Row=1 To Rows 
        Debug "" 
        Debug "Data row " + Str(Row) + " :" 
        For Col=0 To Cols-1 
          Debug SQLiteData(Row, Col) 
        Next 
      Next 
      Debug "" 
      ; 
      ; second database (the first is still open) 
      DBName2$ = "availablefood.db" 
      ; Open database or create it if it doesn't exist 
      ; Since we're using more than one database, we must use an index number. 
      ; We use 1 so it doesn't conflict with the first database (index 0). 
      DBHandle2 = SQLiteOpen(1, DBName2$) 
      If DBHandle2 
        ; Create table if it doesn't exist 
        Result = SQLiteExec(1, "CREATE TABLE food (id, eatablethings)") 
        ; Insert rows in table 
        Debug "CREATE result = "+Str(Result)+" - "+SQLiteError(Result) 
        Result = SQLiteExec(1, "INSERT INTO food VALUES(1, 'egg')") 
        Debug "INSERT result = "+Str(Result)+" - "+SQLiteError(Result) 
        Result = SQLiteExec(1, "INSERT INTO food VALUES(2, 'water')") 
        Debug "INSERT result = "+Str(Result)+" - "+SQLiteError(Result) 
        Debug "" 
        Debug "Rows changed = " + Str(SQLiteRowsChanged(1)) 
        Debug "Last row inserted = " + Str(SQLiteLastInsertedRow(1)) 
        Debug "" 
        ; Get table (execute SQL query) 
        Result = SQLiteGetTable(1, 1, "SELECT id, eatablethings FROM food") 
        If Result=#SQLITE_OK 
          Rows = SQLiteRows(1) ; doesn't include headers row 
          Cols = SQLiteCols(1) 
          ; get the results 
          ; display number of rows/columns 
          Debug "Rows = " + Str(Rows) 
          Debug "Columns = " + Str(Cols) 
          ; Display column headers 
          For Col=0 To Cols-1 
            Debug SQLiteData(1, 0, Col) 
          Next 
          ; Display returned rows 
          For Row=1 To Rows 
            Debug "" 
            Debug "Data row " + Str(Row) + " :" 
            For Col=0 To Cols-1 
              Debug SQLiteData(1, Row, Col) 
            Next 
          Next 
          For i=1 To SQLiteRows(0) 
            Debug "" 
            Debug "Recipe: "+SQLiteData(0, i, 1) 
            ingredients$ = RemoveString(SQLiteData(0, i, 2), " ") 
            position = 1 
            notavailable = 0 
            missing$ = "" 
            While StringField(ingredients$, position, ",") 
              Row = 0 
              While StringField(ingredients$, position, ",")<>SQLiteData(1, Row, 1) And Row<=Rows 
                Row+1 
              Wend 
              If Row>Rows 
                notavailable = 1 
                If missing$:missing$+", ":EndIf 
                missing$+StringField(ingredients$, position, ",") 
              EndIf 
              position+1 
            Wend 
            If notavailable 
              Debug "- Missing ingredients: "+missing$ 
            Else 
              Debug "- We have all we need." 
            EndIf 
          Next i 
        Else 
          MessageRequester("SQLite Error", "SQLiteGetTable error: "+SQLiteError(Result), #MB_IconError|#MB_OK) 
        EndIf 
      Else 
        MessageRequester("SQLite Error", "Can't open database "+DBName2$+Chr(10)+SQLiteError(), #MB_IconError|#MB_OK) 
      EndIf 
      ; 
    Else 
      MessageRequester("SQLite Error", "SQLiteGetTable error: "+SQLiteError(Result), #MB_IconError|#MB_OK) 
    EndIf 
    SQLiteClose(0) ; If more than one DB are open, we must close all DBs with its index number 
    SQLiteClose(1) 
    DeleteFile(DBName$) 
    DeleteFile(DBName2$) 
  Else 
    MessageRequester("SQLite Error", "Can't open database "+DBName$+Chr(10)+SQLiteError(), #MB_IconError|#MB_OK) 
  EndIf 
Else 
  MessageRequester("SQLite Error", "Can't open sqlite.dll", #MB_IconError|#MB_OK) 
EndIf 
End 

; ExecutableFormat=Windows
; EOF
