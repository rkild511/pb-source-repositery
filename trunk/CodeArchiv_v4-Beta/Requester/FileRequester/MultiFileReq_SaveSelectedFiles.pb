; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2247&highlight=
; Author: Lars
; Date: 09. September 2003
; OS: Windows
; Demo: Yes

NewList FileList.s() 
Files.s = OpenFileRequester("Bitte Dateien auswählen ...","","Alle Dateien|*.*",0,#PB_Requester_MultiSelection) 
Repeat 
  Files = NextSelectedFileName() 
  AddElement(FileList()) 
  FileList.s() = Files 
  Debug Files 
Until Files = "" 

ResetList(FileList()) 
NextElement(FileList()) 
Debug FileList()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
