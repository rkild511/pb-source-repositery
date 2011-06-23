; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8945&highlight=
; Author: Fred (Debug output extended by Andre)
; Date: 31. December 2003
; OS: Windows
; Demo: No

; WinAPI memory function....
GlobalMemoryStatus_(Memory.MEMORYSTATUS) 
Debug Str(Memory\dwTotalPhys)+" Byte of RAM installed"
Debug "in MByte: "+Str(Memory\dwTotalPhys/1024/1024)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
