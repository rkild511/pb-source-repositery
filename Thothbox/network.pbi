Procedure servercall()
  Protected http.HTTP_Query,*rawdata,lenght.l
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  HTTP_addPostData(@http, "info", "")
  http\conn=HTTP_sendQuery(@http)

;   Protected *string,time.l,readed
;    If http\conn
;       *string = AllocateMemory(2048)
;       time = ElapsedMilliseconds()
;       Repeat
;         If NetworkClientEvent(http\conn) = #PB_NetworkEvent_Data
;          
;           readed = ReceiveNetworkData(http\conn, *string, 2048)
;           Debug(PeekS(*string,readed,#PB_Ascii))
;           time = ElapsedMilliseconds()
;         EndIf
;         Delay(100)
;       Until ElapsedMilliseconds() - time >= 3000
;     EndIf
    *rawdata=HTTP_receiveRawData(@http)
    HTTP_DataProcessing(@http,*rawdata)
    Protected txt.s,nbline.l,z.l,line.s,sepa.l,key.s,value.s
    If http\data<>0
      ClearMap(gp\serverInfos())
      txt.s=PeekS(http\data,MemorySize(http\data),#PB_Ascii);
      nbline=CountString(txt,#LFCR$)
      Debug nbline
      For z=1 To nbline
        line=StringField(txt, z, #LFCR$)
        sepa=FindString(line,":",0)
        If sepa>0
          key=Trim(Mid(line,0,sepa-1))
          value=Trim(Mid(line,sepa+1,Len(line)-sepa))
          gp\serverInfos(key)=value
        EndIf
      Next
      

    ;gp\serverInfos
    
    
    
    MessageRequester("Server Back",PeekS(http\data,MemorySize(http\data),#PB_Ascii))
  Else
    MessageRequester("Server Back","Error")
  EndIf
EndProcedure
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 37
; Folding = -
; EnableXP