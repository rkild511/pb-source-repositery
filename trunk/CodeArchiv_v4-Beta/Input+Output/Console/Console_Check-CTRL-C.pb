; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2511&highlight=
; Author: Rings
; Date: 09. October 2003
; OS: Windows
; Demo: No


; Check for CTRL-C in a console application (Windows)
; Überprüfen auf CTRL-C in einer Consolen-Anwendung (Windows)
; ------------------------------------------------------------
; Manchmal ist es sinnvoll mitzubekommen (oder zu unterbeinden), wenn jemand CTRL-C
; in einer Konsolen-Anwendung betätigt. 
; Dieser kleine Api-call macht das: 
OpenConsole() 
ConsoleColor(14,0) 
ConsoleLocate(10,12) 
PrintN("PRESS CTRL-C to goto 'MyTest'") 
SetConsoleCtrlHandler_(?MyTest,#True) 

Repeat ;endless Loop 
Delay(1) 
ForEver 

End 

MyTest: 
Beep_(100,100) 
Beep_(200,100) 
CloseConsole() 
MessageRequester("Test","Hello, this is the end from CTRL-C",0) 
End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
