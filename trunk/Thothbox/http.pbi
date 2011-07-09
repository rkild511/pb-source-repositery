;*********************************************
;***** Envoi de fichier par requete HTTP *****
;******** Par lepiaf31 le 28/06/2011 *********
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

  ProcedureReturn 0
EndProcedure

Procedure HTTP_proxy(*test.HTTP_Query,host.s="",port.i=80,login.s="",password.s="")
  *test\proxy\host=host
  *test\proxy\port=port
  *test\proxy\login=login
  *test\proxy\password=password
EndProcedure

Procedure HTTP_query(*test.HTTP_Query,method.b,url.s)
  Protected host.s,port.l,path.s,login.s,pass.s,res.s,string.s
  ; si on a un proxy
  If *test\proxy\host<>""
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

;-Exemple !
CompilerIf Defined(INCLUDEINPROJECT,#PB_Constant)=0

Procedure main()
  Protected test.HTTP_Query, string.s, readed.i, conn.i, time.i,*string
  InitNetwork()
  OpenConsole()
    HTTP_proxy(@test,"spxy.bpi.fr",3128)
    HTTP_query(@test, #HTTP_METHOD_FILE, "http://www.thyphoon.com/test.php")
    ;HTTP_createQuery(@test, #HTTP_METHOD_FILE, "/test.php", "www.thyphoon.com")
    HTTP_addQueryHeader(@test, "User-Agent", "PB")
    HTTP_addPostData(@test, "pseudo", "lepiaf31")
    HTTP_addPostData(@test, "nom", "Kevin")
    HTTP_addFile(@test, "datafile", OpenFileRequester("Please choose file to load", "", "*.*", 0))
    conn = HTTP_sendQuery(@test)
    If conn
      *string = AllocateMemory(2048)
      time = ElapsedMilliseconds()
      Repeat
        If NetworkClientEvent(conn) = #PB_NetworkEvent_Data
         
          readed = ReceiveNetworkData(conn, *string, 2048)
          Print(PeekS(*string,readed,#PB_Ascii))
          time = ElapsedMilliseconds()
        EndIf
        Delay(100)
      Until ElapsedMilliseconds() - time >= 3000
    EndIf
    Input()
  EndProcedure
  main()
CompilerEndIf

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 227
; FirstLine = 217
; Folding = --
; EnableXP