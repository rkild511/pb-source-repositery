; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2366&highlight=
; Author: Martin (updated for PB4.00 by blbltheworm)
; Date: 23. September 2003
; OS: Windows
; Demo: No


; Every 10 seconds it will call the Beep_() function...
; Ruft aller 10 Sekunden die Beep_() Funktion auf...

; Anmerkung: Das Timer Ereignis von Windows hat die niedrigste Priorität. D.h., dass der
;            Timer tatsächlich - je nach Auslastung deines Systems - ungenau ist. 
;            Wenn du also von Millisekunden abhängig bist, musst du etwas anderes nehmen.
;            Zum regelmässigen aktualisieren eines Fortschrittbalkens oder so ist der
;            Windows Timer aber ausreichend. 

#Timer = 1 

Procedure WindowsCallback(WindowID.l, Message.l, wParam.l, lParam.l)  
  Select Message 
    Case  #WM_TIMER 
      Beep_(1000,50) 
  EndSelect  
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

Procedure HauptSchleife() 
hwnd.l = OpenWindow(0,50,50,300,200, "Timer" ,#PB_Window_SystemMenu) 
  If hwnd 
    SetTimer_(hwnd, #Timer,10000,#Null) 
    SetWindowCallback(@WindowsCallback())  
    Repeat 
      Event.l = WaitWindowEvent() 
    Until Event=#PB_Event_CloseWindow 
  EndIf 
EndProcedure 
HauptSchleife() 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
