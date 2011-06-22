; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=1513&highlight=
; Author: bobobo
; Date: 26. June 2003


; MS-SQL ODBC-DSN on the fly with TCP/IP-connection
; tested with MS-SQL-SERVER on W2K-Server and W2K-WS as Client

;Folgender Code geht für MS-SQL DB's 
;Erzeugen einer temporären DSN für vorhandene MS-SQL-Datenbanken. 
;Das folgende im Code beachten und anpassen.. 
;;-FOLGENDE ZEILE ANPASSEN 


;Create DSN on the fly  for ODBC 
; 
; An example by Siegfried Rings (CodeGuru) 
; extended by bobobo 

#ODBC_ADD_DSN = 1         ; Add Data source 
#ODBC_ADD_SYS_DSN = 4  ; Add SYSTEM Data source 
#ODBC_CONFIG_DSN = 2     ; Configure (edit) Data source 
#ODBC_REMOVE_DSN = 3     ; Remove Data source 
#ODBC_REMOVE_SYS_DSN = 6     ; Remove SYSTEM Data source 

#WINDOW=0 
#SHOWINFO=101 

crlf.s=Chr(13)+Chr(10) 

Procedure.s Showinfo(info.s) 
  crlf.s=Chr(13)+Chr(10) 
  SetGadgetText( #SHOWINFO,GetGadgetText(#SHOWINFO)+info+crlf) 
  While WindowEvent():Wend 
EndProcedure 

Procedure MakeConnection(Driver.s,strAttributes.s) 
  Result=OpenLibrary(1,"ODBCCP32.DLL") 
  If Result 
    lpszDriver.s=Driver 
    showinfo(strAttributes) 
    MyMemory=AllocateMemory(1,Len(strAttributes)) 
    CopyMemory(@strAttributes,MyMemory,Len(strAttributes)) 
    For L=1 To Len(strAttributes ) 
      If PeekB(MyMemory +l-1)=Asc(";") 
        PokeB(MyMemory +l-1,0) 
      EndIf 
    Next L 
    Result = CallFunction(1, "SQLConfigDataSource",  0,#ODBC_ADD_SYS_DSN,lpszDriver.s,MyMemory ) 
    FreeMemory(1) 
    CloseLibrary(1) 
    If Result 
      ProcedureReturn 1;MessageRequester("Info","DSN Created",0) 
    EndIf 
  EndIf 
EndProcedure 

Procedure DeleteConnection(Driver.s,DSN.s) 
  Result=OpenLibrary(1,"ODBCCP32.DLL") 
  If Result 
    lpszDriver.s=Driver 
    strAttributes.s = "DSN="+DSN 
    Result = CallFunction(1, "SQLConfigDataSource",  0,#ODBC_REMOVE_SYS_DSN,lpszDriver.s,strAttributes ) 
    CloseLibrary(1) 
    If Result 
      ProcedureReturn 1;MessageRequester("Info","DSN Delete",0) 
    EndIf 
  EndIf 
EndProcedure 


;-FOLGENDE ZEILE ANPASSEN Addresse 
ADDRESS$="127.0.0.1,1433"   ;   Network address,Port of the SQL Server. 
Network$="DBMSSOCN"         ; VerbindungsArt 
;-FOLGENDE ZEILE ANPASSEN StandardDatenbank 
DATABASE$="STANDARDDATENBANK"  ;Name of the Default database for the  connection 
;If Database is not specified, the Default database 
;defined For the login is used 


DESCRIPTION$="MEINE_DATENBANK_BESCHREIBUNG"            ;Description 

DRIVER$="SQL Server" 

QUERYLOG_ON$="no"                   ;default no : enables long query-runs 


QUERYLOGFILE$="c:\ODBCquery.log"                    ;Full path and name of the file used to log long-running queries. 

QUERYLOGTIME$="1"                   ;Digit character string specifying the threshold (in milliseconds) 
;for logging long-running queries. Any query that does not get a 
;response in the time specified is written To the long-running 
;query log file. 

;-FOLGENDE ZEILE ANPASSEN Name oder ip-Nummer des MS-SQL-SERVERS 
SERVER$="MEIN-MS-SQL-SERVER"           ;Name of a server running SQL Server on the network 
STATSLOG_ON$="no"                      ;Enables driver performance logging 
STATSLOGFILE$="c:\ODBCPerformance.log" ;Full pth of Log Driver Performance 

;FOR DB-LogOn 

;-FOLGENDE ZEILE ANPASSEN (funktional nicht wichtig) 
DSN$="MEINE_DB_VERBINDUNG"            ; dieser Name taucht im ODBC auf 
;-FOLGENDE ZEILE ANPASSEN 
UID$="USER_ID"                        ; UserId 
;-FOLGENDE ZEILE ANPASSEN 
PWD$="PASSWORT"                       ;Passwort 


ATTRIB$="DSN="+DSN$+";"+crlf 
ATTRIB$=ATTRIB$+"DESCRIPTION="+DESCRIPTION$+";"+crlf 
ATTRIB$=ATTRIB$+"SERVER="+SERVER$+";"+crlf 
ATTRIB$=ATTRIB$+"ADDRESS="+ADDRESS$+";"+crlf 
ATTRIB$=ATTRIB$+"NETWORK="+NETWORK$+";"+crlf 
ATTRIB$=ATTRIB$+"DATABASE="+DATABASE$+";"+crlf 
ATTRIB$=ATTRIB$+"StatsLog_On="+STATSLOG_ON$+";"+crlf 
ATTRIB$=ATTRIB$+"StatsLogFile="+STATSLOGFILE$+";"+crlf 
ATTRIB$=ATTRIB$+"QueryLog_on="+QUERYLOG_ON$+";"+crlf 
ATTRIB$=ATTRIB$+"QueryLogFile="+QUERYLOGFILE$+";"+crlf 
ATTRIB$=ATTRIB$+"QueryLogTime="+QUERYLOGTIME$+";" 

maxx  = GetSystemMetrics_(#SM_CXSCREEN) 
maxy  = GetSystemMetrics_(#SM_CYSCREEN) 
bor   = GetSystemMetrics_(#SM_CXSIZEFRAME) 


winwidth = 300 
If winwidth>maxx 
  winwidth=maxx 
EndIf 
winwidth=winwidth-bor*2 
winheight = 200 
winleft=maxx-winwidth-bor*2 ;ganz rechts 
wintop=0 
dropped=#FALSE 
#WINDOW=0 
#SHOWINFO=101 
#OKBUT=200 
OpenWindow(0, winleft, wintop, winwidth, winheight, #PB_Window_SystemMenu , Driver$) 
CreateGadgetList(WindowID()) 
StringGadget(#SHOWINFO,0,0,winwidth,winheight,"",#PB_STRING_MULTILINE) 

showinfo("Anmelden mit folgenden Parametern an "+Driver$) 
If MakeConnection(DRIVER$,ATTRIB$) 
  
  If InitDatabase() 
    If  OpenDatabase(0, DSN$,UID$, PWD$) 
      showinfo("ODBC:ok - DB:angemeldet: User:angemeldet - Status:OK") 
      While WindowEvent():Wend 
        MessageRequester(DRIVER$,"ODBC:ok - DB:angemeldet: User:angemeldet - Status:OK",0) 
        If DeleteConnection(DRIVER$,DSN$) 
          showinfo("DB ist wieder abgemeldet") 
          showinfo("Beenden") 
          
          MessageRequester(DRIVER$,"Beenden",0) 
          End 
          
        Else 
          showinfo("DB konnte nicht abgemeldet werden") 
        EndIf 
      Else 
        showinfo("ODBC EINTRAG VORHANDEN?") 
        showinfo("MS-SQL-SERVER VORHANDEN?") 
        showinfo("USER GÜLTIG?") 
        showinfo("PASSWORT GÜLTIG?") 
        MessageRequester(DRIVER$,"Beenden",0) 
        End 
      EndIf 
      
    Else 
      showinfo("DB kann nicht geöffnet werden") 
      
    EndIf 
  Else 
    showinfo("DB ist nicht angemeldet") 
    MessageRequester(DRIVER$,"DB ist nicht angemeldet",0) 
  EndIf 
  
Repeat 
  Event=WaitWindowEvent() 
  Select Event 
    Case #PB_Event_CloseWindow ; If the user has pressed on the close button 
      End 
  EndSelect 
ForEver 


; ExecutableFormat=Windows
; FirstLine=1
; EOF