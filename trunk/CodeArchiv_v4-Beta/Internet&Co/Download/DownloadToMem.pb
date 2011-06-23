; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2808&highlight=
; Author: dige (updated for PB4.00 by blbltheworm)
; Date: 12. November 2003
; OS: Windows
; Demo: No

Procedure.l DownloadToMem ( URL.s, *lpRam, ramsize.l ) 
  Protected agent.s, hInet.l, hData.l, Bytes.l 
  
  ;  #INTERNET_OPEN_TYPE_DIRECT    = 1 
  ;  #INTERNET_DEFAULT_HTTP_PORT   = 80 
  ;  #INTERNET_SERVICE_HTTP        = 3 
  ;  #INTERNET_FLAG_NO_CACHE_WRITE = $4000000 
  ;  #INTERNET_FLAG_RELOAD         = $8000000 

  agent.s = "Mozilla/4.0 (compatible; ST)" 
  hInet.l = InternetOpen_ ( @agent.s,0,0,0,0 ) 
  hData.l = InternetOpenUrl_ ( hInet, @URL.s, "", 0, $8000000, 0 ) 
  
  If hData > 0 : InternetReadFile_ ( hData, *lpRam, ramsize.l, @Bytes.l ) : Else : Bytes = -1 : EndIf 
  
  InternetCloseHandle_ (hInet) 
  InternetCloseHandle_ (hFile) 
  InternetCloseHandle_ (hData) 
  
  ProcedureReturn Bytes.l 
EndProcedure 

; Bsp: 
UseJPEGImageDecoder() 
mem.s = Space(63000) 
;CallDebugger
If DownloadToMem ( "http://www.purearea.net/pb/pics/purearea4.jpg", @mem, 63000 ) 
  If CatchImage(0, @mem) 
    hWnd = OpenWindow(0, 0, 0, ImageWidth(0), ImageHeight(0), "PB-Logo" , #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
    CreateGadgetList( hWnd ) 
    ImageGadget(0, 0, 0, WindowWidth(0), WindowHeight(0), ImageID(0)) 
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
