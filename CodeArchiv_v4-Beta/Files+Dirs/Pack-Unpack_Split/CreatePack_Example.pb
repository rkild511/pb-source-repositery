; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2778
; Author: Topsoft
; Date: 08. November 2003
; OS: Windows
; Demo: Yes

If CreatePack("C:\Datenarchiv.dat") = 0 
     Debug "Kann Datei C:\Datenarchiv.dat nicht erstellen!" 
     End 
EndIf 

If AddPackFile("C:\Daten.bin" ,0)                         ;Datei muß natürlich vorhanden sein! 
     Debug "Datei C:\Daten.bin erfolgreich gepackt" 
Else 
     Debug "Datei konnte nicht gepackt werden" 
EndIf 

ClosePack() 
End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
