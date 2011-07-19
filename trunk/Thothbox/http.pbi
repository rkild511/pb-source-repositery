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
  method.b         ;see enumeration under structure
  host.s
  port.i
  path.s
  boundary.s
  proxy.HTTP_Proxy
  List headers.s()
  List postData.s()
  List files.HTTP_file()
  conn.i          
  *buffer         ; buffer to received data
  *rawdata        ; all datareceived header and data mixed
  *data           ; complete received data
  *header         ; received header data
  error.b         ; return error
  *callback       ; CallBack funtion procedure()
EndStructure

#HTTP_BUFFER=2048; Buffer size to reveive data

Enumeration
  #HTTP_METHOD_GET
  #HTTP_METHOD_POST
  #HTTP_METHOD_FILE
  #HTTP_ERROR_NO_CONNEXION
  #HTTP_ERROR_ANSWER_NO_HEADER
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
  Protected head.s, postData.s, size.i, fileHeaderSize.i, file.i, readed.i, *buffer,*tmpbuffer
  
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
  
  *query\conn = OpenNetworkConnection(*query\host, *query\port)
  If *query\conn
    Select *query\method
      Case #HTTP_METHOD_GET
        head + #CRLF$
        SendNetworkAscii(*query\conn,head)
        
      Case #HTTP_METHOD_POST
        ForEach *query\postData()
          postData + *query\postData() + "&"
        Next
        postData = Left(postData, Len(postData)-1)
        
        head + "Content-Length: "+Str(Len(postData)) + #CRLF$
        head + #CRLF$
        head + postData
        SendNetworkAscii(*query\conn, head)
        
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
        SendNetworkAscii(*query\conn,head)
        *buffer = AllocateMemory(2048)
        ForEach *query\files()
          postData = "--"+*query\boundary+#CRLF$
          postData + "Content-Disposition: form-data; name="+Chr(34)+*query\files()\name+Chr(34) +"; filename="+Chr(34)+GetFilePart(*query\files()\path)+Chr(34)+#CRLF$
          postData + "Content-Type: application/octet-stream" + #CRLF$ + #CRLF$
          SendNetworkAscii(*query\conn,postData)
          file = OpenFile(#PB_Any, *query\files()\path)
          
          If file
            While Eof(file) = 0
              readed = ReadData(file, *buffer, 2048)
              SendNetworkData(*query\conn, *buffer, readed)
            Wend
            SendNetworkAscii(*query\conn,#CRLF$)
            CloseFile(file)
          EndIf
        Next
        FreeMemory(*buffer)
        
        postData = "--"+*query\boundary+"--"
        SendNetworkData(*query\conn, @postData, Len(postData))
    EndSelect
    
    ProcedureReturn #True
  Else
    *query\error=#HTTP_ERROR_NO_CONNEXION
    MessageRequester("Http Error","No Connexion"+#CRLF$+*query\host+" port:"+Str(*query\port))
    ProcedureReturn #False
  EndIf
EndProcedure
;- Nouvelles fonctions
;###############################################################################################################
Procedure HTTP_proxy(*query.HTTP_Query,host.s="",port.i=80,login.s="",password.s="")
  *query\proxy\host=host
  *query\proxy\port=port
  *query\proxy\login=login
  *query\proxy\password=password
EndProcedure



Procedure HTTP_receiveRawData(*query.HTTP_Query)
  Protected *rawdata,time.i,readed.i,size.i,NEvent.i
  
  If *query\rawdata>0
    FreeMemory(*query\rawdata)
  EndIf
  
  If *query\header>0
    FreeMemory(*query\header)
  EndIf
  
  If *query\data>0
    FreeMemory(*query\data)
  EndIf
  
  If *query\conn
    *query\buffer = AllocateMemory(#HTTP_BUFFER)
    *query\rawdata=AllocateMemory(1)
    time = ElapsedMilliseconds()
    Repeat
      NEvent=NetworkClientEvent(*query\conn);NetworkClientEvent(*query\conn) 
      If NEvent=#PB_NetworkEvent_Data
        readed = ReceiveNetworkData(*query\conn, *query\buffer, #HTTP_BUFFER)
        If readed>0
          size=MemorySize(*query\rawdata)
          If size=1:size=0:EndIf
          *query\rawdata=ReAllocateMemory(*query\rawdata,size+readed)
          CopyMemory(*query\buffer,*query\rawdata+size,readed)
          ;-Search Header
          If *query\header=0
            ;found the lenght of the header
            Protected z.i,lenght.i
            For z=-4 To readed-5
              ;If PeekB(*query\rawdata+size+z)=13 And PeekB(*query\rawdata+size+z+1)=10 And PeekB(*query\rawdata+size+z+2)=13 And PeekB(*query\rawdata+size+z+3)=10
              If size+z>=0 And PeekL(*query\rawdata+size+z)=168626701
                lenght=size+z+4
                *query\header=AllocateMemory(lenght)
                CopyMemory(*query\rawdata,*query\header,lenght);
                ;Analyse the header !
                Protected txt.s,nbline.l,line.s
                txt=PeekS(*query\header,MemorySize(*query\header),#PB_Ascii)
                nbline=CountString(txt,#LF$)
                Debug "___Header__"
                For z=1 To nbline
                  line=StringField(txt, z, #LF$)
                  line=ReplaceString(line,#LF$,"")
                  line=ReplaceString(line,#CR$,"")
                  Debug line
                Next
                Break;
              EndIf
            Next
          EndIf
          
          ;-CallBack
          If *query\callback>0
            Debug "callback"
            CallFunctionFast(*query\callback,size+readed,lenght)
          EndIf
        Else 
          Debug "HTTP_receiveRawData() rien"
        EndIf
        time = ElapsedMilliseconds()
      EndIf
      Delay(10)
      
    Until NEvent=#PB_NetworkEvent_Disconnect ;ElapsedMilliseconds() - time >= 3000
    CloseNetworkConnection(*query\conn)
    FreeMemory(*query\buffer):*query\buffer=0;
    ;-Search Data
    If *query\header>0
      size=MemorySize(*query\rawdata)-MemorySize(*query\header)
      *query\data=AllocateMemory(size)
      CopyMemory(*query\rawdata+MemorySize(*query\header),*query\data,size);
      FreeMemory(*query\rawdata):*query\rawdata=0
      Debug "___DATA__"
      Debug PeekS(*query\data,MemorySize(*query\data),#PB_Ascii)
      ProcedureReturn #True
    Else
      Debug "HTTP_ERROR_ANSWER_NO_HEADER"
      *query\error=#HTTP_ERROR_ANSWER_NO_HEADER
      ProcedureReturn #False
    EndIf
    
    
  Else
    Debug "no Networkconnection"
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure HTTP_query(*query.HTTP_Query,method.b,url.s)
  Protected host.s,port.l,path.s,login.s,pass.s,res.s,string.s
  ; si on a un proxy
  If *query\proxy\host<>""
    Debug "Use Proxy:"+*query\proxy\host+" port:"+Str(*query\proxy\port)
    HTTP_createQuery(*query, method, url, *query\proxy\host,*query\proxy\port,*query\proxy\login,*query\proxy\password)
    ;si on a pas de proxy 
  Else
    host = GetURLPart(url, #PB_URL_Site); the main domain
    path =GetURLPart(url,#PB_URL_Path); the path
    port= Val(GetURLPart(url, #PB_URL_Port))
    If port=0:port=80:EndIf
    HTTP_createQuery(*query, method, "/"+path, host,port)
  EndIf
  ;si on a une protection part login/password via un htacess
  login=GetURLPart(url, #PB_URL_User)
  pass=GetURLPart(url, #PB_URL_Password)
  If login <> ""
    string = login+":"+pass
    res = Space(Len(string)*4)
    Base64Encoder(@string, Len(string), @res, Len(string)*4)
    HTTP_addQueryHeader(*query, "Authorization", "Basic "+res)
  EndIf
  
  
  
EndProcedure

Procedure HTTP_DownloadToMem(*query.HTTP_Query,url.s)
  Protected  *rawdata,lenght.i
  HTTP_query(*query, #HTTP_METHOD_GET, url)
  HTTP_addQueryHeader(*query, "User-Agent", "PB")
  HTTP_sendQuery(*query)
  HTTP_receiveRawData(*query)
  ProcedureReturn #True
EndProcedure

Procedure HTTP_DownloadToFile(*query.HTTP_Query,url.s,file.s)
  HTTP_DownloadToMem(*query,url.s)
  If *query\data<>0
    CreateFile(0,file)
    WriteData(0,*query\data,MemorySize(*query\data))
    CloseFile(0)
    FreeMemory(*query\data):*query\data=0
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
    HTTP_sendQuery(@test)
    HTTP_receiveRawData(@test)
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
; CursorPosition = 271
; FirstLine = 248
; Folding = ---
; EnableXP