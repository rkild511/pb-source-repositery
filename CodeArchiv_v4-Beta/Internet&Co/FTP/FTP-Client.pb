; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5983&highlight=
; Author: El_Choni (updated for PB4.00 by blbltheworm)
; Date: 25. April 2003
; OS: Windows
; Demo: No

  #FTPServer=0 
  #UserName=1 
  #Password=2 
  #FileNameGet=3 
  #FileNameSend=4 
  #txt1=5 
  #txt2=6 
  #txt3=7 
  #txt4=8 
  #txt5=9 
  #Info=10 
  #Send=11 

  #INTERNET_SERVICE_FTP=1 
  #INTERNET_OPEN_TYPE_DIRECT=1 
  #FTP_PORT=21 
  #FTP_TRANSFER_ASCII=1 
  #FTP_TRANSFER_BINARY=2 

  hWnd=OpenWindow(#Info,(GetSystemMetrics_(#SM_CXSCREEN)-200)/2,(GetSystemMetrics_(#SM_CYSCREEN)-180)/2,200,245,"Lifter",#PB_Window_TitleBar|#PB_Window_SystemMenu) 

  If hWnd=0 Or CreateGadgetList(hWnd)=0:End:EndIf 

  TextGadget(#txt1,10,10,180,20,"FTP Server:") 
  TextGadget(#txt2,10,50,180,20,"User Name:") 
  TextGadget(#txt3,10,90,180,20,"Password:") 
  TextGadget(#txt4,10,130,180,20,"File Name:") 
  TextGadget(#txt5,10,170,180,20,"Location:") 

  StringGadget(#FTPServer,10,25,180,20,"") 
  StringGadget(#UserName,10,65,180,20,"") 
  StringGadget(#Password,10,105,180,20,"") 
  StringGadget(#FileNameGet,10,145,180,20,"") 
  StringGadget(#FileNameSend,10,185,180,20,"") 

  ButtonGadget(#Send,75,225,50,22,"Send") 

;  Proxy.s=""  ; Can't use empty strings in InternetOpen_() (valid name or #NULL) 
;  ProxyBypass.s="" 

  Repeat 
    EventID = WaitWindowEvent() 
    If EventID=#PB_Event_Gadget 
      If EventGadget()=#Send 

        ServerName.s=GetGadgetText(#FTPServer) 
        UserName.s=GetGadgetText(#UserName) 
        Password.s=GetGadgetText(#Password) 
        localfile.s=GetGadgetText(#FileNameGet) 
        remotefile.s=GetGadgetText(#FileNameSend) 

        hInternet=InternetOpen_("FTP",#INTERNET_OPEN_TYPE_DIRECT,Proxy,ProxyBypass,0) 
        hConnect=InternetConnect_(hInternet,ServerName,#FTP_PORT,UserName,Password,#INTERNET_SERVICE_FTP,0,0) 

        If FtpPutFile_(hConnect,localfile,remotefile,#FTP_TRANSFER_ASCII,0) 
          MessageRequester("","File has been sent",0) 
        Else
        MessageRequester("","Error sending File",0) ;<- added by blbltheworm
        EndIf 

        If hInternetConnect 
          InternetCloseHandle_(hInternetConnect) 
        EndIf 

        If hInternetSession 
          InternetCloseHandle_(hInternetSession) 
        EndIf 
        
      EndIf 
    EndIf 
  Until EventID=#PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
