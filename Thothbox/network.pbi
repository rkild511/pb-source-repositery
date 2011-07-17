Procedure servercall()
  Protected http.HTTP_Query,*rawdata,lenght.l
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  HTTP_addPostData(@http, "info", "")
  http\conn=HTTP_sendQuery(@http)
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
    
  Else
    MessageRequester("Server Back Call","Error")
  EndIf
EndProcedure

Procedure serverSearch(keywords.s)
  Protected http.HTTP_Query,*rawdata,lenght.l
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  HTTP_addPostData(@http, "search", keywords)
  http\conn=HTTP_sendQuery(@http)
  *rawdata=HTTP_receiveRawData(@http)
  HTTP_DataProcessing(@http,*rawdata)
  Debug PeekS(http\header,MemorySize(http\header),#PB_Ascii);
  Debug PeekS(http\data,MemorySize(http\data),#PB_Ascii);
  If http\data<>0
    Protected txt.s,nbline.l,z.l,line.s,sepa.l,key.s,value.s
    ClearGadgetItems(#gdt_result)
    txt.s=PeekS(http\data,MemorySize(http\data),#PB_Ascii);
    nbline=CountString(txt,#LFCR$)
    For z=1 To nbline
      line=StringField(txt, z, #LFCR$)
      AddGadgetItem(#gdt_result,z,StringField(line, 2, ";")+Chr(10)+StringField(line, 3, ";")+Chr(10)+StringField(line, 4, ";"))
      SetGadgetData(z, Val(StringField(line, 1, ";")))
    Next
  Else
    MessageRequester("Server Back Search","Error")
  EndIf
EndProcedure 

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 52
; FirstLine = 5
; Folding = -
; EnableXP