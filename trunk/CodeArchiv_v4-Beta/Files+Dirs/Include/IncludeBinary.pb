; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6624&highlight=
; Author: Num3 (updated for PB4.00 by blbltheworm)
; Date: 18. June 2003
; OS: Windows
; Demo: Yes

; You can include anything you like into an exe, just use: 
filestart1: 
  IncludeBinary "Installer.exe" 
fileend1: 

filestart2: 
  IncludeBinary "Installer.doc" 
fileend2: 

filestart3: 
  IncludeBinary "Installer.dll" 
fileend3: 

; Then to extract the files: 
If CreateFile(0, filenamex) 
  WriteData(0, ?filestartx, ?fileendx- ?filestartx) ; (x = filenumber) 
  CloseFile(0) 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
