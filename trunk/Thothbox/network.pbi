Procedure myCallBack(l.i,max.i)
SetGadgetText(#gdt_waitTxt,Str(l))
EndProcedure
;http://www.koakdesign.info/thothbox/thothbox.php



Procedure OpenWaitWindow()
  OpenWindow(#win_Wait,0,0,320,200,"",#PB_Window_WindowCentered,WindowID(0))
  TextGadget(#gdt_waitTxt,20,20,320,20,"Please Wait...")
  StickyWindow(#win_Wait,1)
  DisableWindow(#win_Main,1)
EndProcedure

Procedure CloseWaitWindow()
  CloseWindow(#win_Wait)
  DisableWindow(#win_Main,0)
EndProcedure
Procedure servercall()
  Protected http.HTTP_Query
  OpenWaitWindow()
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  http\callback=@myCallBack()
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  HTTP_addPostData(@http, "info", "")
  HTTP_sendQuery(@http)
  HTTP_receiveRawData(@http)
  Protected txt.s,nbline.l,z.l,line.s,sepa.l,key.s,value.s
  If http\data<>0
    MessageRequester("Server Info",PeekS(http\data,MemorySize(http\data),#PB_Ascii))
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
  CloseWaitWindow()
EndProcedure

Procedure serverSearch(keywords.s)
  Protected http.HTTP_Query
  OpenWaitWindow()
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  HTTP_addPostData(@http, "search", keywords)
  HTTP_sendQuery(@http)
  HTTP_receiveRawData(@http)
  ;HTTP_DataProcessing(@http)
  ;Debug PeekS(http\header,MemorySize(http\header),#PB_Ascii);
  If http\data<>0
    Debug PeekS(http\data,MemorySize(http\data),#PB_Ascii);
    Protected txt.s,nbline.l,z.l,line.s,sepa.l,key.s,value.s,id.l
    ClearGadgetItems(#gdt_result)
    txt.s=PeekS(http\data,MemorySize(http\data),#PB_Ascii);
    Debug txt
    nbline=CountString(txt,#LFCR$)
    For z=1 To nbline
      line=ReplaceString(StringField(txt, z, #LFCR$),Chr(13),"")
      Debug line
      AddGadgetItem(#gdt_result,z-1,StringField(line, 2, ";")+Chr(10)+StringField(line, 3, ";")+Chr(10)+StringField(line, 4, ";"))
      id=Val(StringField(line, 1, ";"))
      SetGadgetItemData(#gdt_result,z-1, id)
    Next
  Else
    MessageRequester("serverSearch()","Error")
  EndIf
  CloseWaitWindow()
EndProcedure 

Procedure getFilesListFromServer(id.l)
  Protected http.HTTP_Query
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  HTTP_addPostData(@http, "code", Str(id))
  HTTP_sendQuery(@http)
  HTTP_receiveRawData(@http)
  ;HTTP_DataProcessing(@http)
  ;Debug PeekS(http\header,MemorySize(http\header),#PB_Ascii);
  If http\data<>0
    MessageRequester("Files List",PeekS(http\data,MemorySize(http\data),#PB_Ascii))
    Protected txt.s,nbline.l,z.l,line.s,sepa.l,key.s,value.s
    txt.s=PeekS(http\data,MemorySize(http\data),#PB_Ascii);
    nbline=CountString(txt,#LFCR$)
    For z=1 To nbline
      line=StringField(txt, z, #LFCR$)
      Debug line
    Next
  Else
    MessageRequester("getFilesListFromServer()","Error")
  EndIf
EndProcedure 

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 1
; Folding = --
; EnableXP