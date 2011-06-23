; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8562&highlight=
; Author: Danilo
; Date: 14. December 2003
; OS: Windows
; Demo: No


; Please note, that the window name "PureBasic - Debug Output" must be updated to 
; its real name, else the window clearing will not work!

; 
; by Danilo, 14.12.2003 - english forum 
; 
Procedure DebugClear_Callback(hWnd,Value) 
  result = 1 
  ClassName$ = Space(100) 
  GetClassName_(hWnd,@ClassName$,100) 
  If ClassName$ = "ListBox" 
     Count = SendMessage_(hWnd,#LB_GETCOUNT,0,0) 
     If Count > 0 
       SendMessage_(hWnd,#WM_SETREDRAW,0,0) 
       For a = 0 To Count - 1 
         SendMessage_(hWnd,#LB_DELETESTRING,0,0) 
       Next a 
       SendMessage_(hWnd,#WM_SETREDRAW,1,0) 
       InvalidateRect_(hWnd,0,1) 
     EndIf 
     result = 0 
  EndIf 
  ProcedureReturn result 
EndProcedure 

Procedure DebugClear() 
  hDebug = FindWindow_(0,"PureBasic - Debug Output") 
  If hDebug 
    EnumChildWindows_(hDebug,@DebugClear_Callback(),0) 
;  Else 
;    MessageRequester("DEBUG CLEAR","Debugger Disabled!",#MB_ICONERROR) 
  EndIf 
EndProcedure 


For a = 1 To 100 
  Debug Str(a) 
Next a 

Delay(1000) 

DebugClear() 

Debug 12
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
