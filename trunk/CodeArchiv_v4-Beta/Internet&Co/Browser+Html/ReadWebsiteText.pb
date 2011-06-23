; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3197&start=10
; Author: Andre (based on code of Dige, posted by Epyx)
; Date: 01. May 2005
; OS: Windows
; Demo: No


; Get text contents of an internet site
; Text einer Internetseite auslesen
Procedure.l GB_DownloadToMem ( url.s, *lpRam, ramsize.l ) 
  Protected agent.s, hINet.l, hData.l, bytes.l 

  
  ;  #INTERNET_OPEN_TYPE_DIRECT    = 1 
  ;  #INTERNET_DEFAULT_HTTP_PORT   = 80 
  ;  #INTERNET_SERVICE_HTTP        = 3 
  ;  #INTERNET_FLAG_NO_CACHE_WRITE = $4000000 
  ;  #INTERNET_FLAG_RELOAD         = $8000000 
  

  agent.s = "Mozilla/4.0 (compatible; ST)" 
  hINet.l = InternetOpen_ ( @agent.s,0,0,0,0 ) 
  hData.l = InternetOpenUrl_ ( hINet, @url.s, "", 0, $4000000, 0 ) 
  
  If hData > 0 : InternetReadFile_ ( hData, *lpRam, ramsize.l, @bytes.l ) : Else : bytes = -1 : EndIf 
  
  InternetCloseHandle_ (hINet) 
  InternetCloseHandle_ (hFile) 
  InternetCloseHandle_ (hData) 
  ProcedureReturn bytes.l 
EndProcedure 


*MemoryID = AllocateMemory(50000)
If *MemoryID
  sitelength = GB_DownloadToMem("http://www.purearea.net", *MemoryID, 50000)
  If sitelength > 0
    Debug "Die geladene Internetseite hat eine Größe von: " + Str(sitelength) + " Bytes"
    text$ = PeekS(*MemoryID)
    Debug text$
  Else
    Debug "Konnte angeforderte Internetseite nicht laden!"
  EndIf
Else
  Debug "Konnte den angeforderten Speicher nicht reservieren!"
EndIf


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -