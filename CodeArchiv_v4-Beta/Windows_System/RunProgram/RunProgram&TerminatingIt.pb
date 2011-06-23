; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2708&highlight=
; Author: NoOneKnows  (additional code by Andre, updated for PB4.00 by blbltheworm)
; Date: 31. October 2003
; OS: Windows
; Demo: Yes


; Start a process and later terminate it yourself...
; Prozess beenden: 
Debug "Start program..."
processID.l = RunProgram("notepad.exe","","",#PB_Program_Open) 
Debug "ProcessID = " + Str(processID)

Debug "We will wait 3 seconds now..."
Delay(1000)
Debug "We will wait 2 seconds now..."
Delay(1000)
Debug "We will wait 1 seconds now..."
Delay(1000)

KillProgram(processID)
CloseProgram(processID)

Debug "Program terminated..."

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
