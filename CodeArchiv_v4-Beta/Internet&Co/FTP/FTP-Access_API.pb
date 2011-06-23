; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8971&highlight=
; Author: Paul (updated for PB4.00 by blbltheworm)
; Date: 02. January 2004
; OS: Windows
; Demo: No


; Here is some simple code I wrote for FTP Access... 
; Basically wrappers for API commands but maybe the syntax makes a little more sense for beginners 
;(Debuger Output added by blbltheworm)

Procedure.l FTPInit() 
  ProcedureReturn InternetOpen_("FTP",1,"","",0) 
EndProcedure 


Procedure.l FTPConnect(hInternet,Server.s,User.s,Password.s,port.l) 
  ProcedureReturn InternetConnect_(hInternet,Server,port,User,Password,1,0,0) 
EndProcedure 


Procedure.l FTPDir(hConnect.l) 
  hFind=FtpFindFirstFile_(hConnect,"*.*",@FTPFile.WIN32_FIND_DATA,0,0) 
  If hFind 
    Find=1 
    Debug PeekS(@FTPFile\cFileName) ;Directories
    While Find 
      Find=InternetFindNextFile_(hFind,@FTPFile) 
      If Find 
        Debug PeekS(@FTPFile\cFileName) ;Files
      EndIf      
    Wend 
  EndIf 
EndProcedure 


Procedure.l FTPSetDir(hConnect.l,Dir.s) 
  ProcedureReturn FtpSetCurrentDirectory_(hConnect,Dir) 
EndProcedure 


Procedure.l FTPCreateDir(hConnect.l,Dir.s) 
  ProcedureReturn FtpCreateDirectory_(hConnect,Dir) 
EndProcedure 


Procedure.l FTPDownload(hConnect.l,Source.s,Dest.s) 
  ProcedureReturn FtpGetFile_(hConnect,Source,Dest,0,0,0,0) 
EndProcedure 


Procedure.l FTPUpload(hConnect.l,Source.s,Dest.s) 
  ProcedureReturn FtpPutFile_(hConnect,Source,Dest,0,0) 
EndProcedure 


Procedure.l FTPClose(hInternet.l) 
  ProcedureReturn InternetCloseHandle_(hInternet) 
EndProcedure 




;-------------------- 
hInternet=FTPInit() 
If hInternet 
  hConnect=FTPConnect(hInternet,"ftp.arcor.de","","",21) 
  If hConnect 
    Debug "Connected"
    Debug "Enter Directory: pub/win32/"
    FTPSetDir(hConnect,"pub/") 
    FTPSetDir(hConnect,"win32/") 
    Debug "ShowDirectory-List"
    FTPDir(hConnect) 
    Debug "-----"
    Debug "Download File"
    FTPDownload(hConnect,"ppp95.txt","C:\download.txt") 
    ;FTPUpload(hConnect,"C:\Download.txt","download.txt") 

    FTPClose(hInternet) 
  EndIf 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
