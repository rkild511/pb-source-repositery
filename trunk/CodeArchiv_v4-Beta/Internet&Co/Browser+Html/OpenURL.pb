; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7857&highlight=
; Author: ricardo (based on older Forum code, updated for PB4.00 by blbltheworm)
; Date: 11. October 2003
; OS: Windows
; Demo: No

Procedure.s OpenURL(Url.s, OpenType.b) 
  isLoop.b=1 
  INET_RELOAD.l=$80000000 
  hInet.l=0: hURL.l=0: Bytes.l=0 
  Buffer.s=Space(2048) 
  
  hInet = InternetOpen_("PB@INET", OpenType, #Null, #Null, 0) 
  hURL = InternetOpenUrl_(hInet, Url, #Null, 0, INET_RELOAD, 0) 
  
  Repeat 
    
    Delay(1) 
    InternetReadFile_(hURL, @Buffer, Len(Buffer), @Bytes) 
    If Bytes = 0 
      isLoop=0 
    Else 
      res.s = res + Left(Buffer, Bytes) 
    EndIf 
  Until isLoop=0 
  InternetCloseHandle_(hURL) 
  InternetCloseHandle_(hInet) 
  ProcedureReturn res 
EndProcedure 
 


; To use it just call it: 
Url$ = "http://www.purearea.net" 
Html$ =  OpenURL(Url$,1) ;<< Always the second parameter is 1 

Debug Html$

; Then in the Html$ string you will have the html code. 
; Note: If the file is bigger, then you should use memory because the string has a limited size.

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
