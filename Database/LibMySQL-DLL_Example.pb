; English forum: http://purebasic.myforums.net/viewtopic.php?t=2734
; Author: Max
; Date: 22. April 2003


; Example for using MySQL with the libmysql.dll (download from
; http://www.mysqltools.com/download.htm)

; SQLite ist eine eigenständige Datenbankengine, die zwar die SQL92
; Syntax unterstützt, sonst aber mit MySQL nichts zu tun hat.
;
; Wenn Du übers Internet auf eine MySQL Datenbank zugreifen
; möchtest kannst Du das entweder über ODBC oder direkt mit der
; libmysql.dll -> http://www.mysqltools.com/download.htm realisieren.

; PS: Nachfolgend von Max aus dem Englischen Forum ein Beispiel für
; die Nutzung der libmysql.dll:


#libmysql = 1

host.s    = "62.75.148.207"
user.s    = "purebasic"
passwd.s  = "test"
db.s      = "purebasic"
port.l    = 3306

dbHnd.l
SQL.s
row.s
i.l
j.l
affRows.l
fieldNum.l
rowsNum.l

Procedure.s GetError(db_ID,requester)
  
  Protected Errormsg.s, i.l, Error.l
  
  If CallFunction(#libmysql,"mysql_errno",db_ID) > 0
    *Error =CallFunction(#libmysql,"mysql_error",db_ID)
    i=-1
    Repeat
      i=i+1
      Errormsg=Errormsg+PeekS(*Error+i,1)
    Until PeekB(*Error+i)=0
    If requester
      Result= MessageRequester("MySQL error",Errormsg,#PB_MessageRequester_Ok)
    EndIf
  EndIf
  
  ProcedureReturn Errormsg
  
EndProcedure



If OpenLibrary(#libmysql,"libmysql.dll")
  Result=CallFunction(#libmysql,"mysql_init",dbHnd)
  If Result
    dbHnd = Result
    If CallFunction(#libmysql,"mysql_real_connect",dbHnd, host, user, passwd, db, port, "", 0) = 0
      GetError(dbHnd,1)
    Else
      CallDebugger
      SQL = "SELECT * FROM test"
      If CallFunction(#libmysql,"mysql_real_query", dbHnd, SQL, Len(SQL))
        GetError(dbHnd,1)
      Else
        *mysqlResult=CallFunction(#libmysql,"mysql_store_result",dbHnd)
        
        ;no result returned
        If *mysqlResult=0
          ;no fields returned means error
          If CallFunction(#libmysql,"mysql_field_count",dbHnd)
            GetError(dbHnd,1)
            ;fields are returned, so no error but query didn't return data
          Else
            
          EndIf
          ;results are returned
        Else
          
          
          affRows   = CallFunction(#libmysql,"mysql_affected_rows",dbHnd)
          fieldNum  = CallFunction(#libmysql,"mysql_num_fields",*mysqlResult)
          rowsNum   = CallFunction(#libmysql,"mysql_num_rows",*mysqlResult)
          
          Debug affRows
          Debug fieldNum
          Debug rowsNum
          
          
          For i=1 To rowsNum
            *mysqlRow=CallFunction(#libmysql,"mysql_fetch_row",*mysqlResult)
            *mysqlLen=CallFunction(#libmysql,"mysql_fetch_lengths",*mysqlResult)
            
            row = ""
            
            ;length of given field
            For j=1 To fieldNum
              length=PeekL(*mysqlLen+4*(j-1))
              fieldptr=PeekL(*mysqlRow+4*(j-1))
              If fieldptr>0
                content.s=PeekS(fieldptr,length)
              Else
                ;zero pointer returend means empty field
                content="NULL"
              EndIf
              row = row + content + ";"
            Next j
            
            Debug row
            
          Next i
          Result.l=CallFunction(#libmysql,"mysql_free_result",*mysqlResult)
        EndIf
      EndIf
    EndIf
  EndIf
EndIf


; ExecutableFormat=Windows
; FirstLine=1
; EOF