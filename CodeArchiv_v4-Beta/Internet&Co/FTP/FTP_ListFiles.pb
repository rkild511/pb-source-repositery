; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2258&highlight=
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 11. September 2003
; OS: Windows
; Demo: No


; Hinweise:
; GetFTPinfo() gibt die FTP Informationen auf der Konsole aus.
; GetFTPdirectory() speichert das komplette Verzeichnis in einer LinkedList.
; PrintFileData() gibt den Namen und die Grösse für ein Listenelement auf der Konsole aus,
; bei Verzeichnissen nur den /namen/ 

; Mit dem Strukturen-Anzeiger kannst Du alle Elemente von WIN32_FIND_DATA anschauen. 
; So funktioniert ein FtpDeleteFile_(hConnect, @FindFileData()\cFileName) mit der Liste.

#INTERNET_SERVICE_FTP = 1 
;#INTERNET_FLAG_ASYNC = $10000000                    ; this request is asynchronous (where supported) 
;#INTERNET_FLAG_PASSIVE = $8000000                   ; used for FTP connections 
;#INTERNET_OPEN_TYPE_PRECONFIG = 0            ; use registry configuration 
#INTERNET_OPEN_TYPE_DIRECT = 1               ; direct to net 
;#INTERNET_OPEN_TYPE_PROXY = 3                ; via named proxy 
;#INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY = 4   ; prevent using java/script/INS 

#Verzeichniss = 16 
#Datei = 128 

Global NewList FindFileData.WIN32_FIND_DATA() 

Procedure GetFTPdirectory(hConnect.l, Pfad$) 
  AddElement(FindFileData()) 
  hFind.l = FtpFindFirstFile_(hConnect, Pfad$ + "*", @FindFileData(), 0, 0) 
  AddElement(FindFileData()) 
  While InternetFindNextFile_(hFind , @FindFileData()) 
    AddElement(FindFileData()) 
  Wend 
  DeleteElement(FindFileData()) 
  InternetCloseHandle_(hFind) 
EndProcedure 

Procedure PrintFileData() 
  Name$ = PeekS(@FindFileData()\cFileName) 
  Select FindFileData()\dwFileAttributes 
    Case #Datei 
      Size.l = FindFileData()\nFileSizeLow + FindFileData()\nFileSizeHigh<<8 
      PrintN(Name$ + "    " + Str(Size) + " bytes") 
    Case #Verzeichniss 
      If Name$ <> "." And Name$ <> ".." 
        PrintN("/" + Name$ + "/") 
      EndIf 
    Default 
      Debug "unbekannter Attributwert: " + Str(FindFileData()\dwFileAttributes) 
  EndSelect 
EndProcedure 

Procedure GetFTPinfo() 
  InternetGetLastResponseInfo_(@lpdwError.l, 0, @lpdwBufferLength.l) 
  If lpdwBufferLength > 0 
    lpszBuffer$ = Space(lpdwBufferLength) 
    If InternetGetLastResponseInfo_(@lpdwError, @lpszBuffer$, @lpdwBufferLength) 
      CRLF$ = Chr(13) + Chr(10) 
      posA.l = FindString(lpszBuffer$, CRLF$, 0) 
      If posA 
        PrintN(Left(lpszBuffer$, posA - 1)) 
        posA + 2 
        posB.l = FindString(lpszBuffer$, CRLF$, posA) 
        While posB 
          PrintN(Mid(lpszBuffer$, posA, posB - posA)) 
          posA = posB + 2 
          posB = FindString(lpszBuffer$, CRLF$, posA) 
        Wend 
      Else 
        PrintN(lpszBuffer$) 
      EndIf 
    EndIf 
    PrintN("") 
  EndIf 
EndProcedure 

OpenConsole() 
; --------------------------------- 
url$ = "ftp.avm.de" 
user$ = "anonymous" 
pass$ = "anonymous@home.de" 
hInternet.l = InternetOpen_("", #INTERNET_OPEN_TYPE_DIRECT, 0, 0, 0) 
hConnect.l = InternetConnect_(hInternet, @url$, port, @user$, @pass$, #INTERNET_SERVICE_FTP, 0, 0) 
GetFTPinfo() 
GetFTPdirectory(hConnect, "/") ; root verzeichniss einlesen 
ResetList(FindFileData()) 
While NextElement(FindFileData()) 
  PrintFileData() 
Wend 
InternetCloseHandle_(hConnect) 
; --------------------------------- 
PrintN("") 
Print("press enter to exit") 
Input() 
CloseConsole() 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
