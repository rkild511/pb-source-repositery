; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8331&highlight=
; Author: V2 (updated for PB4.00 by blbltheworm + ts-soft)
; Date: 13. November 2003
; OS: Windows
; Demo: No

Enumeration 
  #Window 
  #cmdStart 
  #progressbar 
  #Frame 
  #cmdExit 
  #Label 
  #Label2 
  #URL 
EndEnumeration 


Procedure.s Reverse(s.s) 
  O.s=Mid(s,Len(s),1) 
  P=Len(s)-1 
  While P>0 
    O.s=O+Mid(s,P,1) 
    P=P-1 
  Wend 
  ProcedureReturn O 
EndProcedure 

Procedure SetProgressbarRange(Gadget.l, Minimum.l, Maximum.l) 
  ;? SetProgressbarRange(#progressbar, 0, 100) 
  PBM_SETRANGE32 = $400 + 6 
  SendMessage_(GadgetID(Gadget), PBM_SETRANGE32, Minimum, Maximum) 
EndProcedure 

Procedure DoEvents() 
  msg.MSG 
  If PeekMessage_(msg,0,0,0,1) 
    TranslateMessage_(msg) 
    DispatchMessage_(msg) 
  Else 
    Sleep_(1) 
  EndIf 
EndProcedure 

Procedure.s GetQueryInfo(hHttpRequest.l, iInfoLevel.l) 
  lBufferLength.l=0 
  lBufferLength = 1024 
  sBuffer.s=Space(lBufferLength) 
  HttpQueryInfo_(hHttpRequest, iInfoLevel, sBuffer, @lBufferLength, 0) 
  ProcedureReturn Left(sBuffer, lBufferLength) 
EndProcedure 

Procedure UrlToFileWithProgress(myFile.s, URL.s) 
  isLoop.b=1 
  Bytes.l=0 
  fBytes.l=0 
  Buffer.l=4096 
  res.s="" 
  tmp.s="" 
  
  OpenType.b=1 
  INTERNET_FLAG_RELOAD.l = $80000000 
  INTERNET_DEFAULT_HTTP_PORT.l = 80 
  INTERNET_SERVICE_HTTP.l = 3 
  HTTP_QUERY_STATUS_CODE.l = 19 
  HTTP_QUERY_STATUS_TEXT.l = 20 
  HTTP_QUERY_RAW_HEADERS.l = 21 
  HTTP_QUERY_RAW_HEADERS_CRLF.l = 22 

  memID=AllocateMemory(Buffer) 

  Result = CreateFile(1, myFile) 
  hInet = InternetOpen_("", OpenType, #Null, #Null, 0) 
  hURL = InternetOpenUrl_(hInet, URL, #Null, 0, INTERNET_FLAG_RELOAD, 0) 
  
  ;get Filesize 
  domain.s = ReplaceString(Left(URL,(FindString(URL, "/",8) - 1)),"http://","") 
  hInetCon = InternetConnect_(hInet,domain, INTERNET_DEFAULT_HTTP_PORT, #Null, #Null, INTERNET_SERVICE_HTTP, 0, 0) 
  If hInetCon > 0 
    hHttpOpenRequest = HttpOpenRequest_(hInetCon, "HEAD", ReplaceString(URL,"http://"+domain+"/",""), "http/1.1", #Null, 0, INTERNET_FLAG_RELOAD, 0) 
    If hHttpOpenRequest > 0 
      iretval = HttpSendRequest_(hHttpOpenRequest, #Null, 0, 0, 0) 
      If iretval > 0 
        tmp = GetQueryInfo(hHttpOpenRequest, HTTP_QUERY_STATUS_CODE) 
        If Trim(tmp) = "200" 
          tmp = GetQueryInfo(hHttpOpenRequest, HTTP_QUERY_RAW_HEADERS_CRLF) 
          If FindString(tmp,"Content-Length:",1)>0 
            ii.l=FindString(tmp, "Content-Length:",1) + Len("Content-Length:") 
            tmp = Mid(tmp, ii, Len(tmp)-ii) 
            myMax = Val(Trim(tmp)) 
          EndIf 
        EndIf 
      EndIf 
    EndIf 
  EndIf 
  
  SetGadgetText(#Label, "Filesize: " + Str(myMax)) 
  SetProgressbarRange(#progressbar,0,myMax) 
  
  ;start downloading 
  Repeat 
    InternetReadFile_(hURL, memID, Buffer, @Bytes) 
    If Bytes = 0 
      isLoop=0 
    Else 
      fBytes=fBytes+Bytes 
        SetGadgetText(#Label2, "Received Bytes: " + Str(fBytes)) 
      If myMax >= fBytes: SetGadgetState(#progressbar, fBytes): EndIf 
      WriteData(1,memID, Bytes) 
    EndIf 
      DoEvents() 
  Until isLoop=0 
  InternetCloseHandle_(hURL) 
  InternetCloseHandle_(hInet) 
  SetGadgetState(#progressbar, 0) 
  CloseFile(1)    
  FreeMemory(memID) 
EndProcedure 



If OpenWindow(#Window, 0, 0, 400, 175, "Download with Progress", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered ) 

  If CreateGadgetList(WindowID(#Window)) 
      StringGadget(#URL, 10, 10, 380, 20, "http://www.largeformatphotography.info/qtluong/sequoias.big.jpeg") 
      ProgressBarGadget(#progressbar, 10, 40, 380, 30, 0,100 , #PB_ProgressBar_Smooth) 
      TextGadget(#Label, 10, 80,300,20,"Filesize:") 
      TextGadget(#Label2, 10, 100,300,20,"Bytes received:") 
      Frame3DGadget(#Frame, -10, 120, 420, 110, "") 
      ButtonGadget(#cmdExit, 160, 140, 110, 25, "Exit") 
      ButtonGadget(#cmdStart, 280, 140, 110, 25, "Start", #PB_Button_Default) 
  EndIf 
        
  Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_Gadget    
      Select EventGadget() 
        Case #cmdStart 
        
          URL.s = GetGadgetText(#URL) 
          
          ;get filename (checking /) 
          myFile.s= Right(URL, FindString(Reverse(URL),"/",1)-1) 
          ;request path 
          myFolder.s = PathRequester ("Where do you want to save '" + myFile + "'?", "C:\") 

          UrlToFileWithProgress(myFolder + myFile, URL) 
        Case #cmdExit 
          End 
      EndSelect 
    EndIf               
  Until EventID = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP