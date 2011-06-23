; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1339&highlight=
; Author: Freak
; Date: 12. June 2003
; OS: Windows
; Demo: No


; Erstellungs-Datum/Uhrzeit einer Datei ermitteln
hFile.l = OpenFile(0,"c:\autoexec.bat")     ; change to your own path/file

GetFileTime_(hFile, @Create.FILETIME, @Access.FILETIME, @WRITE.FILETIME) 
FileTimeToSystemTime_(@Create, @SysTime.SYSTEMTIME) 

Debug SysTime\wDay 
Debug SysTime\wMonth 
Debug SysTime\wYear 
Debug SysTime\wHour 
Debug SysTime\wMinute
Debug SysTime\wSecond

; usw...

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
