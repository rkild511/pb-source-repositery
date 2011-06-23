; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6097&highlight=
; Author: Berikco (updated for PB 4.00 by Andre)
; Date: 09. May 2003
; OS: Windows
; Demo: No

; Start more than onece, to see the first running programm closed automatically
ERROR_ALREADY_EXISTS = 183 
Global WM_ACTIVATEOLDINST 
WM_ACTIVATEOLDINST = RegisterWindowMessage_("WM_ACTIVATEOLDINST_PB") 
MutexName$ = "mylittletestapp" 

Procedure MyWindowCallback(WindowID, Message, wParam, lParam)  
  Result = #PB_ProcessPureBasicEvents  
  If message = WM_ACTIVATEOLDINST 
    CloseHandle_(hMutex) 
    OpenConsole() 
    PrintN("closing app") 
    Delay(2000) 
    End 
  EndIf 
  ProcedureReturn Result  
EndProcedure  

hMutex = CreateMutex_(0, 0, @MutexName$) 
If GetLastError_() = ERROR_ALREADY_EXISTS 
  SendMessage_(#HWND_BROADCAST, WM_ACTIVATEOLDINST, 0, 0) 
  Delay(100) 
EndIf 


If OpenWindow(0,100,150,450,200,"MyLittleTestApp " + Str(Random(500))) 
  SetWindowCallback(@MyWindowCallback()) 
  Repeat 
    ev=WaitWindowEvent() 
  Until ev=#PB_Event_CloseWindow 
EndIf 

If hMutex <> 0 
CloseHandle_(hMutex) 
EndIf 

End 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
