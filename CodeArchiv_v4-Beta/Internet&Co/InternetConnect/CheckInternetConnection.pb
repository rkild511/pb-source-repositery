; English forum: 
; Author: MrVainSCL
; Date: 19. January 2003
; OS: Windows
; Demo: No


;Here is a normal version:


; ------------------------------------------------------------
;
; PureBasic Win32 API - CheckInternetConnection - Example v1.0
;
; by MrVainSCL! aka Thorsten   19/Jan/2003    PB v3.51+
;
; ------------------------------------------------------------
;
    If InternetGetConnectedState_(0, 0) 
      result$ = "Online"
    Else
      result$ = "Offline"
    EndIf
    ;
    MessageRequester("Are we connected to the Internet?","We are "+result$,0)
End
;
; ------------------------------------------------------------



;Here is a Procedure() version:


; ------------------------------------------------------------
;
; PureBasic Win32 API - CheckInternetConnection - Example v1.0
;
; by MrVainSCL! aka Thorsten   19/Jan/2003    PB v3.51+
;
; ------------------------------------------------------------
;
    Procedure MyCheckInternetConnection()
        If InternetGetConnectedState_(0, 0) 
          result = 1
        Else
          result = 0
        EndIf
        ;
        ProcedureReturn result
    EndProcedure
    ;
    ; -------- Check if user is connected to internet -------- 
    ;
    If MyCheckInternetConnection() = 1
      state$ = "Online"
    Else
      state$ = "Offline"
    EndIf
    ;
    MessageRequester("Are we connected to the Internet?","We are "+state$,0)
End
;
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -