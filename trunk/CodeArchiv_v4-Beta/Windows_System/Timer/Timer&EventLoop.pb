; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=859&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 04. May 2003
; OS: Windows
; Demo: No

; Einsatz eines Timers, der erst dann aktiv wird, wenn sich das Programm in der REPEAT ... Until Schleife
; zur Event- Abfrage befindet, diese dann alle x Sekunden verläßt und dann eine Aktion ausführt.
; Natürlich soll das System so wenig wie möglich belastet werden... 

; mit: SetTimer_() + #WM_TIMER: 

Procedure LowResTimer(num,time) 
  SetTimer_(WindowID(0),num,time,0) 
EndProcedure 

OpenWindow(0,200,200,300,150,"WM_Timer",#PB_Window_SystemMenu) 

LowResTimer(1,1000) ; Timer 1 
LowResTimer(2,2500) ; Timer 2 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow : End 
    Case #WM_TIMER 
      Select EventwParam() 
        Case 1 ; Timer 1 
          Beep_(800,50) 
        Case 2 ; Timer 2 
          Beep_(600,80) 
      EndSelect 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
