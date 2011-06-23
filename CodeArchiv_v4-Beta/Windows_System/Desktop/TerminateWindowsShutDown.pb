; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2328&highlight=
; Author: dige (updated for PB4.00 by blbltheworm)
; Date: 18. September 2003
; OS: Windows
; Demo: No

; Erklärung:
; Wenn Windows vom Nutzer heruntergefahren wird oder der Nutzer sich 
; abmeldet und dies nicht mit der Option FORCE geschieht, wird an alle 
; laufenden Prozesse eine #WM_QUERYENDSESSION Message gesendet. 
; 
; Diese ist mit #True oder #False zu beantworten. Wird allerdings ein 
; #False übergeben, wird der Shutdown Prozess komplett abgebrochen! 
; 
; Dies kann man verwenden um ein Programm rechtzeitig sauber zu beenden 
; oder den Shutdown Prozess abzufangen... 

Procedure.b TerminateProgram() 
  Shared Quit.b 
  ; Wird bei Windows-Shutdown aufgerufen 
  If MessageRequester( "Windows Shutdown", "Windows wirklich beenden?", #MB_ICONEXCLAMATION | #MB_YESNO ) = 6 
    Quit.b = 1 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure WindowsCallback(WindowID, Message, wParam, lParam)  
  If Message = #WM_QUERYENDSESSION 
    ProcedureReturn TerminateProgram() 
  Else 
    ProcedureReturn #PB_ProcessPureBasicEvents 
  EndIf    
EndProcedure 

OpenWindow( 0,90,90,300,100, "Warte auf Windows Shutdown" ,#PB_Window_SystemMenu) 

SetWindowCallback(@WindowsCallback())  

Repeat 
  Event = WindowEvent() 
  Delay ( 100 ) 
Until Quit.b Or Event = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
