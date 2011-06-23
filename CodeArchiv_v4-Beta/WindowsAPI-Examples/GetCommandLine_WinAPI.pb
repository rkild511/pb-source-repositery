; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1128&highlight=
; Author: Danilo
; Date: 25. May 2003
; OS: Windows
; Demo: No

lpCmdLine = GetCommandLine_() 
If lpCmdLine 
  A$ = PeekS(lpCmdLine) 
  MessageRequester("INFO","Commandline: "+A$,0) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
