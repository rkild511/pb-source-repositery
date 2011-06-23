; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=11911#11911
; Author: schic
; Date: 13. July 2003
; OS: Windows
; Demo: No

Procedure.s DllPath(dll$)
  DllPath$ = Space(1000) 
  ModulNam$=dll$
  HdlMod=GetModuleHandle_(@ModulNam$) 
  GetModuleFileName_(HdlMod,@DllPath$,1000) 
  ProcedureReturn GetPathPart(DllPath$) 
EndProcedure 

Debug DllPath("Shlwapi.dll")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
