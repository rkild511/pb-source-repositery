; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No


; You can set #Example = 0 or = 1, depending on which code you want to use...
#Example = 0
CompilerIf #Example = 0

  If URLDownloadToFile_(0,"http://www.wip3000.de/test.htm","c:\my_test.htm",0,0) = #S_OK
    ; hat geklappt
  Else
    MessageRequester("Error","Couldn't download file...",0)
  EndIf
  
CompilerElse
  
  Datei$ = Space(2000)
  If URLDownloadToCacheFile_(0,"http://www.wip3000.de/test.htm",Datei$,Len(Datei$),0,0) = #S_OK
    ; Datei$ enthält den Name der Datei
    ; in der es gespeichert wurde
    MessageRequester("INFO","Filename: "+Datei$,0)
  Else
    MessageRequester("Error","Couldn't download file...",0)
  EndIf
  
CompilerEndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -