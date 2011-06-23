; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3167&highlight=
; Author: Falko
; Date: 17. December 2003
; OS: Windows
; Demo: No


; Write a file to the TEMP directory
; Schreibt eine Datei ins TEMP-Verzeichnis 

Path.s = Space (1000) 
GetTempPath_(1000,@Path) 

If ReadFile(0, Path+"Test1.Fal") 
   MessageRequester("Achtung","Die Datei existiert schon",#PB_MessageRequester_Ok) 
   CloseFile(0) 
   End 
Else 
   CreateFile(0,Path+"Test1.Fal") 
    ; hier könnten weitere Write-Befehle stehen 
   CloseFile(0) 
   MessageRequester("Alles klar","Die Datei wurde erfolgreich in ## "+Path+" ## geschrieben",#PB_MessageRequester_Ok) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
