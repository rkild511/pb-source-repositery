; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2325&highlight=
; Author: bingo
; Date: 05. March 2005
; OS: Windows
; Demo: No

Structure LASTINPUTINFO 
cbSize.l 
dwTime.l 
EndStructure 

PLASTINPUTINFO.LASTINPUTINFO 


PLASTINPUTINFO\cbSize = SizeOf(PLASTINPUTINFO) 

Repeat 

GetLastInputInfo_(@PLASTINPUTINFO) 

Debug PLASTINPUTINFO\dwTime ;letzte maus/key - "bewegung" 
Debug GetTickCount_() ;system count 

Delay(100) 

ForEver 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -