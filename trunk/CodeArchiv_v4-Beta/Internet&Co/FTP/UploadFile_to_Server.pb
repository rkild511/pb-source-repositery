; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown
; Date: 22. November 2003
; OS: Windows
; Demo: No

#INTERNET_SERVICE_FTP=1
#INTERNET_OPEN_TYPE_DIRECT=1
#FTP_PORT=21
#FTP_TRANSFER_ASCII=1
#FTP_TRANSFER_BINARY=2
Proxy.s=""
ProxyBypass.s=""
ServerName.s="namedesftpservers"
UserName.s="testuser"
Password.s="testepass"
localfile.s="iptext.txt"
remotefile.s="iptext.txt"

hInternet=InternetOpen_("FTP",#INTERNET_OPEN_TYPE_DIRECT,Proxy,ProxyBypass,0)
If hInternet
  hConnect=InternetConnect_(hInternet,ServerName,#FTP_PORT,UserName,Password,#INTERNET_SERVICE_FTP,0,0)
  If hConnect
    If FtpPutFile_(hConnect,localfile,remotefile,#FTP_TRANSFER_ASCII,0)
      MessageRequester("","File has been sent",0)
    Else
      MessageRequester("Error", "Failure while sending file...",0)
    EndIf
  Else
    MessageRequester("Error", "Couldn't get a connection to the server!",0)
  EndIf
  InternetCloseHandle_(hInternet)
Else
  MessageRequester("Error", "Internet isn't reachable.",0)
EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -