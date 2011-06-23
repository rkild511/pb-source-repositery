; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8244&highlight=
; Author: freak
; Date: 10. November 2003
; OS: Windows
; Demo: No


; Procedure that will be called for each window... 
Procedure.l EnumProcedure(WindowHandle.l, Parameter.l) 
  
  ; get Title by windowhandle... 
  Title$ = Space(200) 
  GetWindowText_(WindowHandle, @Title$, 200) 
  
  ; do whatever to check... 
  If FindString(Title$, "PureBasic", 1) <> 0 
  
    MessageRequester("","PB Editor found :)") 
  
    ; returning 0 will stop the search 
    ProcedureReturn 0 
  Else 
  
    ; returning <> 0 will continue till all windows are searched 
    ProcedureReturn 1 
  EndIf 
  
EndProcedure 

; find windows... 
EnumWindows_(@EnumProcedure(), 0)  ; the 0 will be passed in Paremeter.l to the procedure 

End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
