; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2002&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 16. August 2003
; OS: Windows
; Demo: No

Procedure IEGetFile(file.s,page.s); - Download a file from the internet 
  If URLDownloadToFile_(#Null,@page,@file,#Null,#Null) = #S_OK 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

;Beispiel:
Debug IEGetFile("test.jpg","http://www.purearea.net/pb/pics/purearea4.jpg")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
