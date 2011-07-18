;*********************************************
;***** Envoi de fichier par requete HTTP *****
;******** Par lepiaf31 le 28/06/2011 *********
;****** et quelques modif part thyphoon ******
;*********************************************


EnableExplicit

Structure HTTP_file
  name.s
  path.s
EndStructure

Structure HTTP_Proxy
  host.s
  port.i
  login.s
  password.s
EndStructure

Structure HTTP_Query
  method.b
  host.s
  port.i
  path.s
  boundary.s
  proxy.HTTP_Proxy
  List headers.s()
  List postData.s()
  List files.HTTP_file()
  conn.i          
  *buffer         ; buffer received data
  *data           ; complete received data
  *header         ; received header data
EndStructure


Enumeration
  #HTTP_METHOD_GET
  #HTTP_METHOD_POST
  #HTTP_METHOD_FILE
EndEnumeration


Procedure HTTP_addQueryHeader(*query.HTTP_Query, name.s, value.s)
  Protected string.s
  
  string = name+": "+value
  AddElement(*query\headers())
  *query\headers() = string
EndProcedure

Procedure HTTP_createQuery(*query.HTTP_Query, method.b, path.s, host.s, port.i=80, proxyHost.s="", login.s="", password.s="")
  Protected query.HTTP_Query, result.i, string.s, res.s
  
  *query\method = method
  *query\host = host
  *query\port = port
  *query\path = path
  
  If proxyHost <> ""
    *query\host = proxyHost
    If login <> ""
      string = login+":"+password
      res = Space(Len(string)*4)
      Base64Encoder(@string, Len(string), @res, Len(string)*4)
      HTTP_addQueryHeader(*query, "Proxy-Authorization", "Basic "+res)
    EndIf
  EndIf
  
  HTTP_addQueryHeader(*query, "Host", host)
  If method = #HTTP_METHOD_POST
    HTTP_addQueryHeader(*query, "Content-type", "application/x-www-form-urlencoded")
  ElseIf method = #HTTP_METHOD_FILE
    *query\boundary = "----------"+Str(ElapsedMilliseconds())
    HTTP_addQueryHeader(*query, "Content-type", "multipart/form-data; boundary="+*query\boundary)
  EndIf
EndProcedure

Procedure HTTP_addPostData(*query.HTTP_Query, name.s, value.s)
  Protected string.s
  
  If *query\method =#HTTP_METHOD_POST Or *query\method = #HTTP_METHOD_FILE
    string = ReplaceString(URLEncoder(name), "=", "%3D")+"="+ReplaceString(URLEncoder(value), "=", "%3D")
    AddElement(*query\postData())
    *query\postData() = string
    ProcedureReturn 1
  EndIf
  
  ProcedureReturn 0
EndProcedure

Procedure HTTP_addFile(*query.HTTP_Query, name.s, fileName.s)
  If *query\method = #HTTP_METHOD_FILE And FileSize(fileName) > -1
    AddElement(*query\files())
    *query\files()\name = name
    *query\files()\path = fileName
    ProcedureReturn 1
  EndIf
  
  ProcedureReturn 0
EndProcedure
Macro SendNetworkAscii(__cnx,__txt)
  *tmpbuffer=AllocateMemory(StringByteLength(__txt, #PB_Ascii)+1)
  PokeS(*tmpbuffer,__txt,Len(__txt),#PB_Ascii)
  SendNetworkData(__cnx, *tmpbuffer, StringByteLength(__txt, #PB_Ascii))
  FreeMemory(*tmpbuffer)
EndMacro

Procedure HTTP_sendQuery(*query.HTTP_Query)
  Protected head.s, postData.s, connection.i, size.i, fileHeaderSize.i, file.i, readed.i, *buffer,*tmpbuffer
  
  ;Methode
  Select *query\method
    Case #HTTP_METHOD_GET
      head = "GET "
    Case #HTTP_METHOD_POST
      head = "POST "
    Case #HTTP_METHOD_FILE
      head = "POST "
  EndSelect
  
  ;En-tetes
  head + *query\path + " HTTP/1.0" + #CRLF$
  ForEach *query\headers()
    head + *query\headers() + #CRLF$
  Next
  
  connection = OpenNetworkConnection(*query\host, *query\port)
  If connection
    Select *query\method
      Case #HTTP_METHOD_GET
        head + #CRLF$
        
        SendNetworkAscii(connection,head)
        
      Case #HTTP_METHOD_POST
        ForEach *query\postData()
          postData + *query\postData() + "&"
        Next
        postData = Left(postData, Len(postData)-1)
        
        head + "Content-Length: "+Str(Len(postData)) + #CRLF$
        head + #CRLF$
        head + postData
        SendNetworkAscii(connection, head)
      Case #HTTP_METHOD_FILE
        ForEach *query\postData()
          postData + "--"+*query\boundary+#CRLF$
          postData +"Content-Disposition: form-data; name="+Chr(34)+StringField(*query\postData(), 1, "=")+Chr(34)+#CRLF$
          postData + #CRLF$
          postData + StringField(*query\postData(), 2, "=")+#CRLF$
        Next
        
        fileHeaderSize = Len("Content-Disposition: form-data; name="+Chr(34)+Chr(34) +"; filename="+Chr(34)+Chr(34)+#CRLF$+"Content-Type: application/octet-stream" + #CRLF$ + #CRLF$)
        size = fileHeaderSize * ListSize(*query\files())
        ForEach *query\files()
          size + Len(GetFilePart(*query\files()\path))
          size + Len(*query\files()\name)
          size + 4
          size + FileSize(*query\files()\path)
          size + Len("--"+*query\boundary)
        Next
        size + Len(postData)
        size + (2+Len(*query\boundary)+2)
        
        head + "Content-Length: "+Str(size)+#CRLF$
        head + #CRLF$
        head + postData
        SendNetworkAscii(connection,head)
        *buffer = AllocateMemory(2048)
        ForEach *query\files()
          postData = "--"+*query\boundary+#CRLF$
          postData + "Content-Disposition: form-data; name="+Chr(34)+*query\files()\name+Chr(34) +"; filename="+Chr(34)+GetFilePart(*query\files()\path)+Chr(34)+#CRLF$
          postData + "Content-Type: application/octet-stream" + #CRLF$ + #CRLF$
          SendNetworkAscii(connection,postData)
          file = OpenFile(#PB_Any, *query\files()\path)
          
          If file
            While Eof(file) = 0
              readed = ReadData(file, *buffer, 2048)
              SendNetworkData(connection, *buffer, readed)
            Wend
            SendNetworkAscii(connection,#CRLF$)
            CloseFile(file)
          EndIf
        Next
        FreeMemory(*buffer)
        
        postData = "--"+*query\boundary+"--"
        SendNetworkData(connection, @postData, Len(postData))
    EndSelect
    
    ProcedureReturn connection
  EndIf
  Debug "error to connect:"+*query\host+" port:"+Str(*query\port)
  ProcedureReturn 0
EndProcedure
;- Nouvelles fonctions
;###############################################################################################################
Procedure HTTP_proxy(*test.HTTP_Query,host.s="",port.i=80,login.s="",password.s="")
  *test\proxy\host=host
  *test\proxy\port=port
  *test\proxy\login=login
  *test\proxy\password=password
EndProcedure



Procedure HTTP_receiveRawData(*test.HTTP_Query)
  Protected *rawdata,time.i,readed.i,size.i,NEvent.i
  If *test\conn
    *test\buffer = AllocateMemory(2048)
    *rawdata=AllocateMemory(1)
    time = ElapsedMilliseconds()
    Debug "start"
    Repeat
      NEvent=NetworkClientEvent(*test\conn);NetworkClientEvent(*test\conn) 
      If NEvent=#PB_NetworkEvent_Data
        readed = ReceiveNetworkData(*test\conn, *test\buffer, 2048)
        If readed>0
          Debug readed
          
          size=MemorySize(*rawdata)
          If size=1:size=0:EndIf
          *rawdata=ReAllocateMemory(*rawdata,size+readed)
          CopyMemory(*test\buffer,*rawdata+size,readed)
          Debug "size:"+Str(readed)
        Else 
          Debug "rien"
        EndIf
        time = ElapsedMilliseconds()
      EndIf
      Delay(10)
      
    Until NEvent=#PB_NetworkEvent_Disconnect ;ElapsedMilliseconds() - time >= 3000
    Debug"end"
    FreeMemory(*test\buffer):*test\buffer=0;
    ProcedureReturn *rawdata
  Else
    Debug "no Networkconnection"
  EndIf
EndProcedure

; find the end of the header
Procedure HTTP_FindHeader(*mem)
  Protected z.l
  If *mem>0
    For z=0 To MemorySize(*mem)-4
      If PeekB(*mem+z)=13 And PeekB(*mem+z+1)=10 And PeekB(*mem+z+2)=13 And PeekB(*mem+z+3)=10
        ProcedureReturn z+4
      EndIf
    Next
  Else 
    Debug "HTTP_FindHeader : No data to analyse";
    ProcedureReturn 0
  EndIf
  
EndProcedure

Procedure HTTP_query(*test.HTTP_Query,method.b,url.s)
  Protected host.s,port.l,path.s,login.s,pass.s,res.s,string.s
  ; si on a un proxy
  If *test\proxy\host<>""
    Debug "Use Proxy:"+*test\proxy\host+" port:"+Str(*test\proxy\port)
    HTTP_createQuery(*test, method, url, *test\proxy\host,*test\proxy\port,*test\proxy\login,*test\proxy\password)
    ;si on a pas de proxy 
  Else
    host = GetURLPart(url, #PB_URL_Site); the main domain
    path =GetURLPart(url,#PB_URL_Path); the path
    port= Val(GetURLPart(url, #PB_URL_Port))
    If port=0:port=80:EndIf
    HTTP_createQuery(*test, method, "/"+path, host,port)
  EndIf
  ;si on a une protection part login/password via un htacess
  login=GetURLPart(url, #PB_URL_User)
  pass=GetURLPart(url, #PB_URL_Password)
  If login <> ""
    string = login+":"+pass
    res = Space(Len(string)*4)
    Base64Encoder(@string, Len(string), @res, Len(string)*4)
    HTTP_addQueryHeader(*test, "Authorization", "Basic "+res)
  EndIf
  
  
  
EndProcedure

Procedure HTTP_DataProcessing(*test.HTTP_Query,*rawdata)
  Protected lenght.i
  If *rawdata>0
  lenght=HTTP_FindHeader(*rawdata) ;found the lenght of the header
  If lenght>0
    ;copy header
    *test\header=AllocateMemory(lenght)
    CopyMemory(*rawdata,*test\header,lenght);
    ;copy file Data
    If MemorySize(*rawdata)-lenght>0
      *test\data=AllocateMemory(MemorySize(*rawdata)-lenght)
      CopyMemory(*rawdata+lenght,*test\data,MemorySize(*rawdata)-lenght);
    Else
      Debug "DataProcessing:No Data juste Header"
    EndIf
  EndIf
  FreeMemory(*rawdata):*rawdata=0
Else
    Debug "DataProcessing:No answer"
  EndIf
EndProcedure

Procedure HTTP_DownloadToMem(*test.HTTP_Query,url.s)
  Protected  *rawdata,lenght.i
  HTTP_query(*test, #HTTP_METHOD_GET, url)
  HTTP_addQueryHeader(*test, "User-Agent", "PB")
  *test\conn = HTTP_sendQuery(*test)
  *rawdata=HTTP_receiveRawData(*test)
  HTTP_DataProcessing(*test,*rawdata)
  CloseNetworkConnection(*test\conn)
  ProcedureReturn #True
EndProcedure

Procedure HTTP_DownloadToFile(*test.HTTP_Query,url.s,file.s)
  HTTP_DownloadToMem(*test,url.s)
  If *test\data<>0
    CreateFile(0,file)
    WriteData(0,*test\data,MemorySize(*test\data))
    CloseFile(0)
    FreeMemory(*test\data):*test\data=0
    ProcedureReturn #True
  Else  
    ProcedureReturn #False  
  EndIf
EndProcedure


;-Exemple !
CompilerIf Defined(INCLUDEINPROJECT,#PB_Constant)=0
  InitNetwork()
  Procedure test1()
    Protected test.HTTP_Query, string.s, readed.i, conn.i, time.i,*string,*rawdata
    OpenConsole()
    ;HTTP_proxy(@test,"proxy.machin.com",3128)
    HTTP_query(@test, #HTTP_METHOD_FILE, "http://www.thyphoon.com/test.php")
    HTTP_addQueryHeader(@test, "User-Agent", "PB")
    HTTP_addPostData(@test, "pseudo", "lepiaf31")
    HTTP_addPostData(@test, "nom", "Kevin")
    HTTP_addFile(@test, "datafile", OpenFileRequester("Please choose file to load", "", "*.*", 0))
    test\conn = HTTP_sendQuery(@test)
    Debug"receive data"
    *rawdata=HTTP_receiveRawData(@test)
    Debug *rawdata
    HTTP_DataProcessing(@test,*rawdata)
    CloseNetworkConnection(test\conn)
    Print(PeekS(test\data,MemorySize(test\data),#PB_Ascii))
    Input()
  EndProcedure
  test1()
  Procedure test2()
    Protected test.HTTP_Query,url.s
    url="http://www.purebasic.com/images/box.png"
    HTTP_DownloadToFile(@test,url,GetTemporaryDirectory()+GetFilePart(url))
    RunProgram(GetTemporaryDirectory()+GetFilePart(url))
  EndProcedure
CompilerEndIf

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 265
; FirstLine = 261
; Folding = ---
; EnableXP