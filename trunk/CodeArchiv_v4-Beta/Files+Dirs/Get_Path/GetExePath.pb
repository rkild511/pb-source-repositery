; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6122&highlight=
; Author: Danilo
; Date: 11. May 2003
; OS: Windows
; Demo: No
; 
; by Danilo, 31.01.2003 
; 
Procedure.s ExePath() 
  ExePath$ = Space(1000) 
  GetModuleFileName_(0,@ExePath$,1000) 
  ProcedureReturn GetPathPart(ExePath$) 
EndProcedure 

MessageRequester("",ExePath(),0) 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
