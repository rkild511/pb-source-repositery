; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14500&highlight=
; Author: Flype
; Date: 24. March 2005
; OS: Windows
; Demo: No


; Save webpage contents to a file
; Inhalt einer Webseite in eine Datei speichern

; Requires Wininet.dll and Urlmon.dll 

; MSDN InternetGetConnectedState 
; http://msdn.microsoft.com/library/default.asp?url=/library/en-us/wininet/wininet/internetgetconnectedstate.asp 

; MSDN URLDownloadToFile 
; http://msdn.microsoft.com/library/default.asp?url=/workshop/networking/moniker/reference/functions/urldownloadtofile.asp 

url$  = "http://msdn.microsoft.com/library/default.asp?url=/workshop/networking/moniker/reference/functions/urldownloadtofile.asp" 
file$ = "c:\urldownload.txt" 

If InternetGetConnectedState_(@flags,#Null) 
  
  hResult = URLDownloadToFile_(#Null,url$,file$,#Null,#Null) 
  
  If hResult = #S_OK 
    RunProgram("notepad",file$,"") 
  Else 
    MessageRequester("Error","The operation failed. Return Code = "+Hex(hResult),#MB_ICONERROR) 
  EndIf 
  
Else 
  
  MessageRequester("Error","You are connected to internet",#MB_ICONERROR) 
  
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -