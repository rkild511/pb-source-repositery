; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6067&highlight=
; Author: PB
; Date: 05. May 2003
; OS: Windows
; Demo: No

; Get the location of the Windows folder. 
windir$=Space(255) : GetWindowsDirectory_(@windir$,255) : If Right(windir$,1)<>"\" : windir$+"\" : EndIf 

; Get the right version of the command interpreter for this PC. 
cmd$=Space(255) : GetEnvironmentVariable_("comspec",@cmd$,255) ; Returns "command.com" (9x/ME) or "cmd.exe" (NT/2K/XP). 

; Now create a text file ("c:\list.txt") using the DIR command on the Windows folder. 
ShellExecute_(0,0,cmd$,"/c dir.exe "+Chr(34)+windir$+"*.*"+Chr(34)+" > "+Chr(34)+"C:\List.txt"+Chr(34),windir$,0) 

; instead of ShellExecute is also following possible:
; RunProgram(cmd$,"/c dir.exe "+Chr(34)+windir$+"*.*"+Chr(34)+" > "+Chr(34)+"C:\List.txt"+Chr(34),windir$,0) 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
