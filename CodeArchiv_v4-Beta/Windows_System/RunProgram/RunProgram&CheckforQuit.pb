; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2708&highlight=
; Author: NoOneKnows (additional code by Andre, updated for PB4.00 by blbltheworm)
; Date: 31. October 2003
; OS: Windows
; Demo: Yes


; Check, if (a started) program is still running...
; Überwachen, ob das Programm noch läuft: 
Debug "Start program..."
processID.l = RunProgram("notepad.exe","","",#PB_Program_Open) 
Debug "ProcessID = " + Str(processID)

Debug "Quit the program and PureBasic will notice this..."
Repeat 
  Delay(1)
Until ProgramRunning(processID)=0

Debug "Program has ended." 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
