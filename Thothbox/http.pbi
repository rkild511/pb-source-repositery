;*********************************************
;***** Envoi de fichier par requete HTTP *****
;******** Par lepiaf31 le 28/06/2011 *********
;******** client event by DarkPlayer *********
;****** et quelques modif part thyphoon ******
;*********************************************
;TODO Cookie support

EnableExplicit

;-#################################
;- Client Event4 support by DarkPlayer, PureFan
; Source :http://www.purebasic.fr/english/viewtopic.php?f=12&t=42559&hilit=Disconnect
;EDIT 2010-06-13: Improved the MacOS and Linux version, added some checks to prevent crashing in case of incorrect usage
CompilerIf #PB_Compiler_OS = #PB_OS_Linux ;{
  #FIONREAD     = $541B
 
  #__FD_SETSIZE = 1024
  #__NFDBITS    = 8 * SizeOf(LONG)
 
  Macro __FDELT(d)
    ((d) / #__NFDBITS)
  EndMacro
 
  Macro __FDMASK(d)
    (1 << ((d) % #__NFDBITS))
  EndMacro
 
  Structure FD_SET
    fds_bits.l[#__FD_SETSIZE / #__NFDBITS]
  EndStructure
 
  Procedure.i __FD_SET(d.i, *set.FD_SET)
    If d >= 0 And d < #__FD_SETSIZE
      *set\fds_bits[__FDELT(d)] | __FDMASK(d)
    EndIf
  EndProcedure
 
  Procedure.i __FD_ISSET(d.i, *set.FD_SET)
    If d >= 0 And d < #__FD_SETSIZE
      ProcedureReturn *set\fds_bits[__FDELT(d)] & __FDMASK(d)
    EndIf
  EndProcedure
 
  Procedure.i __FD_ZERO(*set.FD_SET)
    FillMemory(*set, SizeOf(FD_SET), 0, #PB_Byte)
  EndProcedure
 
 
  #FD_SETSIZE = #__FD_SETSIZE
  #NFDBITS    = #__NFDBITS
 
  Macro FD_SET(fd, fdsetp)
    __FD_SET(fd, fdsetp)
  EndMacro
 
  Macro FD_ISSET(fd, fdsetp)
    __FD_ISSET(fd, fdsetp)
  EndMacro
 
  Macro FD_ZERO(fdsetp)
    __FD_ZERO(fdsetp)
  EndMacro
 
  ; Returns the minimum value for NFDS
  Procedure.i _NFDS(*set.FD_SET)
    Protected I.i, J.i
   
    For I = SizeOf(FD_SET)/SizeOf(LONG) - 1 To 0 Step -1
      If *set\fds_bits[I]
       
        For J = (#__NFDBITS - 1) To 0 Step -1
          If *set\fds_bits[I] & (1 << J)
            ProcedureReturn I * #__NFDBITS + J + 1
          EndIf
        Next
       
      EndIf
    Next
   
    ProcedureReturn 0
  EndProcedure
  ;}
CompilerEndIf

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS ;{
  #IOC_OUT  = $40000000 ;(__uint32_t)
  Macro _IOR(g,n,t)
    _IOC(#IOC_OUT, (g), (n), (t))
  EndMacro
  #IOCPARM_MASK = $1fff
  Macro _IOC(inout,group,num,len)
    ((inout) | (((len) & #IOCPARM_MASK) << 16) | ((group) << 8) | (num))
  EndMacro
  #FIONREAD = _IOR('f', 127, SizeOf(LONG))
 
  #__DARWIN_FD_SETSIZE = 1024
  #__DARWIN_NBBY       = 8
  #__DARWIN_NFDBITS    = SizeOf(LONG) * #__DARWIN_NBBY
 
  Structure FD_SET
    fds_bits.l[ (#__DARWIN_FD_SETSIZE + #__DARWIN_NFDBITS - 1) / #__DARWIN_NFDBITS ]
  EndStructure
 
  Procedure.i __DARWIN_FD_SET(fd.i, *p.FD_SET)
    If fd >= 0 And fd < #__DARWIN_FD_SETSIZE
      *p\fds_bits[fd / #__DARWIN_NFDBITS] | (1 << (fd % #__DARWIN_NFDBITS))
    EndIf
  EndProcedure
 
  Procedure.i __DARWIN_FD_ISSET(fd.i, *p.FD_SET)
    If fd >= 0 And fd < #__DARWIN_FD_SETSIZE
      ProcedureReturn *p\fds_bits[fd / #__DARWIN_NFDBITS] & (1 << (fd % #__DARWIN_NFDBITS))
    EndIf
  EndProcedure
 
  Procedure.i __DARWIN_FD_ZERO(*p.FD_SET)
    FillMemory(*p, SizeOf(FD_SET), 0, #PB_Byte)
  EndProcedure
 
  #FD_SETSIZE = #__DARWIN_FD_SETSIZE
 
  Macro FD_SET(n, p)
    __DARWIN_FD_SET(n, p)
  EndMacro
 
  Macro FD_ISSET(n, p)
    __DARWIN_FD_ISSET(n, p)
  EndMacro
 
  Macro FD_ZERO(p)
    __DARWIN_FD_ZERO(p)
  EndMacro
 
  ; Returns the minimum value for NFDS
  Procedure.i _NFDS(*p.FD_SET)
    Protected I.i, J.i
   
    For I = SizeOf(FD_SET)/SizeOf(LONG) - 1 To 0 Step -1
      If *p\fds_bits[I]
       
        For J = (#__DARWIN_NFDBITS - 1) To 0 Step -1
          If *p\fds_bits[I] & (1 << J)
            ProcedureReturn I * #__DARWIN_NFDBITS + J + 1
          EndIf
        Next
       
      EndIf
    Next
   
    ProcedureReturn 0
  EndProcedure
  ;}
CompilerEndIf

CompilerIf #PB_Compiler_OS = #PB_OS_Windows ;{
  ; #FIONREAD is already defined
  ; FD_SET is already defined
 
  Macro FD_ZERO(set)
    set\fd_count = 0
  EndMacro
 
  Procedure.i FD_SET(fd.i, *set.FD_SET)
    If *set\fd_count < #FD_SETSIZE
      *set\fd_array[ *set\fd_count ] = fd
      *set\fd_count + 1
    EndIf
  EndProcedure
 
  Procedure.i FD_ISSET(fd.i, *set.FD_SET)
    Protected I.i
    For I = *set\fd_count - 1 To 0 Step -1
      If *set\fd_array[I] = fd
        ProcedureReturn #True
      EndIf
    Next
   
    ProcedureReturn #False
  EndProcedure
 
  Procedure.i _NFDS(*set.FD_SET)
    ProcedureReturn *set\fd_count
  EndProcedure
  ;}
CompilerEndIf
 
 
CompilerIf Defined(TIMEVAL, #PB_Structure) = #False ;{
  Structure TIMEVAL
    tv_sec.l
    tv_usec.l
  EndStructure ;}
CompilerEndIf

Procedure.i Hook_NetworkClientEvent(Connection.i)
  Protected Event.i = NetworkClientEvent(Connection)
  If Event
    ProcedureReturn Event
  EndIf
 
  Protected hSocket.i = ConnectionID(Connection)
  Protected tv.timeval, readfds.fd_set, RetVal.i, Length.i
  tv\tv_sec  = 0 ; Dont even wait, just query status
  tv\tv_usec = 0
 
  FD_ZERO(readfds)
  FD_SET(hSocket, readfds)
 
  ; Check if there is something new
  RetVal = select_(_NFDS(readfds), @readfds, #Null, #Null, @tv)
  If RetVal < 0 ; Seems to be an error
    ProcedureReturn #PB_NetworkEvent_Disconnect
  ElseIf RetVal = 0 Or Not FD_ISSET(hSocket, readfds) ; No data available
    ProcedureReturn 0
  EndIf
 
  ; Check if data is available?
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    RetVal = ioctlsocket_(hSocket, #FIONREAD, @Length)
  CompilerElse
    RetVal = ioctl_(hSocket, #FIONREAD, @Length)
  CompilerEndIf
  If RetVal Or Length = 0 ; Not successful to query for data available OR no data available ? This seems to be an error!
    ProcedureReturn #PB_NetworkEvent_Disconnect
  EndIf
 
  ProcedureReturn 0
EndProcedure

Macro NetworkClientEvent(Connection)
  Hook_NetworkClientEvent(Connection)
EndMacro

;-#################################
;- HTTP by Le Piaf31

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
  *downCallback   ; CallBack funtion procedure()
  *upCallback     ; CallBack funtion procedure()
EndStructure

#HTTP_BUFFER=2048; Buffer size to reveive data

Enumeration
  #HTTP_2xx_Success
  #HTTP_3xx_Redirection
  #HTTP_4xx_Client_Error
  #HTTP_5xx_Server_Error 
  #HTTP_ERROR_NO_CONNEXION
  #HTTP_ERROR_ANSWER_NO_HEADER
EndEnumeration


Enumeration
  #HTTP_METHOD_GET
  #HTTP_METHOD_POST
  #HTTP_METHOD_FILE
EndEnumeration

Procedure HTTP_free(*query.HTTP_Query)
  ;*query\method=0
  ;*query\host=""
  ;*query\path=""
  ;*query\boundary=""
  ClearList(*query\headers())
  ClearList(*query\postData())
  ClearList(*query\files())
  If *query\buffer>0 And MemorySize(*query\buffer)>0:FreeMemory(*query\buffer):EndIf
  If *query\rawdata>0 And MemorySize(*query\rawdata)>0:FreeMemory(*query\rawdata):EndIf
  If *query\data>0 And MemorySize(*query\data)>0:FreeMemory(*query\data):EndIf
  If *query\header>0 And MemorySize(*query\header)>0:FreeMemory(*query\header):EndIf
  *query\error=0;
  *query\downCallback=0;
  *query\upCallback=0;
EndProcedure

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
              ;-Up CallBack
              If *query\upCallback>0
                  CallFunctionFast(*query\upCallback,Loc(file),Lof(file))
              EndIf
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

;-#################################
;- Easy HTTP Function by Thyphoon 

Procedure HTTP_proxy(*query.HTTP_Query,host.s="",port.i=80,login.s="",password.s="")
  *query\proxy\host=host
  *query\proxy\port=port
  *query\proxy\login=login
  *query\proxy\password=password
EndProcedure



Procedure HTTP_receiveRawData(*query.HTTP_Query)
  Protected *rawdata,time.i,readed.i,size.i,NEvent.i
  
  If *query\rawdata>0
    FreeMemory(*query\rawdata):*query\rawdata=0
  EndIf
  
  If *query\header>0
    FreeMemory(*query\header):*query\header=0
  EndIf
  
  If *query\data>0
    FreeMemory(*query\data):*query\data=0
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
                Protected txt.s,nbline.l,line.s,nbFound.l
                txt=PeekS(*query\header,MemorySize(*query\header),#PB_Ascii)
                nbline=CountString(txt,#LF$)
                ;Debug "___Header__"
                For z=1 To nbline
                  line=StringField(txt, z, #LF$)
                  line=ReplaceString(line,#LF$,"")
                  line=ReplaceString(line,#CR$,"")
                  If z=1
                    If CreateRegularExpression(0, "^HTTP.+\s[0-9][0-9][0-9]\s.+")
                      Dim Result$(0)
                      nbFound = ExtractRegularExpression(0, line, Result$())
                      FreeRegularExpression(0)
                    Else
                      Debug RegularExpressionError()
                    EndIf
                    
                    If NbFound>0
                      *query\error=Val(StringField(line,3," "))
                      ;http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html
                      Select   *query\error
                          ;1xx: Informational - Request received, continuing process
                        Case 1:
                          ;"100"  ; Section 10.1.1: Continue
                          ;"101"  ; Section 10.1.2: Switching Protocols
                          
                          ; 2xx: Success - The action was successfully received, understood, And accepted
                        Case 2
                          ;"200"  ; Section 10.2.1: OK
                          ;"201"  ; Section 10.2.2: Created
                          ;"202"  ; Section 10.2.3: Accepted
                          ;"203"  ; Section 10.2.4: Non-Authoritative Information
                          ;"204"  ; Section 10.2.5: No Content
                          ;"205"  ; Section 10.2.6: Reset Content
                          ;"206"  ; Section 10.2.7: Partial Content
                          
                          ; 3xx: Redirection - Further action must be taken in order To complete the request
                        Case 3
                          ;"300"  ; Section 10.3.1: Multiple Choices
                          ;"301"  ; Section 10.3.2: Moved Permanently
                          ;"302"  ; Section 10.3.3: Found
                          ;"303"  ; Section 10.3.4: See Other
                          ;"304"  ; Section 10.3.5: Not Modified
                          ;"305"  ; Section 10.3.6: Use Proxy
                          ;"307"  ; Section 10.3.8: Temporary Redirect
                          
                          ; 4xx: Client Error - The request contains bad syntax Or cannot  be fulfilled
                        Case 4
                          ;"400"  ; Section 10.4.1: Bad Request
                          ;"401"  ; Section 10.4.2: Unauthorized
                          ;"402"  ; Section 10.4.3: Payment Required
                          ;"403"  ; Section 10.4.4: Forbidden
                          ;"404"  ; Section 10.4.5: Not Found
                          ;"405"  ; Section 10.4.6: Method Not Allowed
                          ;"406"  ; Section 10.4.7: Not Acceptable
                          
                          ; 5xx: Server Error - The server failed To fulfill an apparently  valid request
                        Case 5
                          ;"500"  ; Section 10.5.1: Internal Server Error
                          ;"501"  ; Section 10.5.2: Not Implemented
                          ;"502"  ; Section 10.5.3: Bad Gateway
                          ;"503"  ; Section 10.5.4: Service Unavailable
                          ;"504"  ; Section 10.5.5: Gateway Time-out
                          ;"505"  ; Section 10.5.6: HTTP Version not supported
                      EndSelect
                      
                    EndIf
                  Else 
                    ;Debug line
                  EndIf
                Next
                Break;
              EndIf
            Next
          EndIf
          
          ;-Down CallBack
          If *query\downCallback>0
            ;Debug "down callback"
            CallFunctionFast(*query\downCallback,size+readed,lenght)
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
      ;Debug "size:"+Str(size)
      *query\data=AllocateMemory(size)
      CopyMemory(*query\rawdata+MemorySize(*query\header),*query\data,size);
      FreeMemory(*query\rawdata):*query\rawdata=0
      ;Debug "___DATA__"
      ;Debug PeekS(*query\data,MemorySize(*query\data),#PB_Ascii)
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
    ;Debug "Use Proxy:"+*query\proxy\host+" port:"+Str(*query\proxy\port)
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
  
Procedure mytestCallBack(l.i,max.i)
Debug Str(l)+"/"+Str(max)
EndProcedure
  
  
  Procedure test1()
    Protected test.HTTP_Query, string.s, readed.i, conn.i, time.i,*string,*rawdata
    OpenConsole()
    ;HTTP_proxy(@test,"spxy.bpi.fr",3128)
    test\upCallback=@mytestCallBack() ;if you want a call Back
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
  
  
  Procedure test2()
    Protected test.HTTP_Query,url.s
    ;HTTP_proxy(@test,"spxy.bpi.fr",3128)
    url="http://www.purebasic.com/images/box.png"
    test\downCallback=@mytestCallBack() ;if you want a call Back
    HTTP_DownloadToFile(@test,url,GetTemporaryDirectory()+GetFilePart(url))
    RunProgram(GetTemporaryDirectory()+GetFilePart(url))
  EndProcedure
  
  ;test1()
  ;test2()
  
;http://sites.google.com/site/tomihasa/google-language-codes
Procedure.s translate(text.s,langSource.s,langTarget.s)
    Protected test.HTTP_Query,url.s
    text.s="bonjour"
    langSource.s="fr"
    langTarget.s="en"
    url.s="http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q="+text+"&langpair="+langSource+"|"+langTarget
    ;HTTP_proxy(@test,"spxy.bpi.fr",3128) ;<<<<<<<<<<<<<<<if you have a proxy change it
    HTTP_query(@test, #HTTP_METHOD_GET, url)
    ;HTTP_addQueryHeader(@test, "X-Requested-With", "XMLHttpRequest")
    HTTP_sendQuery(@test)
    HTTP_receiveRawData(@test)
    Protected s.l,e.l,result.s
    result.s=PeekS(test\data,MemorySize(test\data),#PB_Ascii)
    s=FindString(result,"translatedText",0)+Len("translatedText")+3
    If s>0
      e=FindString(result,Chr(34)+"}, "+Chr(34),s)
      ProcedureReturn Mid(result,s,e-s)
    Else
      ProcedureReturn ""
    EndIf
  EndProcedure
  

CompilerEndIf

; IDE Options = PureBasic 4.60 Beta 4 (Windows - x86)
; CursorPosition = 6
; Folding = +v-86---
; EnableXP