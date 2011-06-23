; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8740&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 15. December 2003
; OS: Windows
; Demo: Yes


#DLL = 1

ProcedureDLL TryIt() 
  OpenWindow(1,300,300,300,200,"TryIt",#PB_Window_SystemMenu) 
  
  Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndProcedure 

CompilerIf #DLL<>1 
  TryIt() 
CompilerEndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
