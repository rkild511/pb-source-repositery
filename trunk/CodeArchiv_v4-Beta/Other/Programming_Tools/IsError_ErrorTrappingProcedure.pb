; German forum: http://www.purebasic.fr/german/viewtopic.php?t=349&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 06. October 2004
; OS: Windows, Linux
; Demo: Yes


Procedure IsError(ProcResult.l, ErrorText.s) 
  If ProcResult = 0 
    MessageRequester("Error", ErrorText, #MB_ICONERROR) 
    End 
  EndIf 
  ProcedureReturn ProcResult 
EndProcedure 

IsError(OpenWindow(0, 0, 0, 400, 300, "ErrorTest", 0), "Fenster konnte nicht erstellt werden.") 

IsError(CreateGadgetList(0), "Gadgetliste konnte nicht erstellt werden")
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger