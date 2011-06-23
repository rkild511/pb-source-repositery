; English forum:
; Author: Danilo
; Date: 21. January 2003
; OS: Windows
; Demo: No


Procedure.s ExeFilename()
  tmp$ = Space(1000)
  GetModuleFileName_(0,@tmp$,1000)
  ProcedureReturn GetFilePart(tmp$)
EndProcedure

Procedure.s ExePath()
  tmp$ = Space(1000)
  GetModuleFileName_(0,@tmp$,1000)
  ProcedureReturn GetPathPart(tmp$)
EndProcedure

MessageRequester("INFO","Path: "+ExePath()+Chr(13)+"FileName: "+ExeFileName(),0)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -