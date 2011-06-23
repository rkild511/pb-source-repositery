; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7105&highlight=
; Author: PB (example added + updated for PB4.00 by blbltheworm)
; Date: 06. August 2003
; OS: Windows
; Demo: No


; Question: How to re-activate my app ?

; This procedure gives the focus to any window: 
Procedure ForceFore(handle) 
  thread1=GetWindowThreadProcessId_(GetForegroundWindow_(),0) 
  thread2=GetWindowThreadProcessId_(handle,0) 
  If thread1<>thread2 : AttachThreadInput_(thread1,thread2,#True) : EndIf 
  SetForegroundWindow_(handle) : Sleep_(125) ; Delay to stop fast CPU issues. 
  If thread1<>thread2 : AttachThreadInput_(thread1,thread2,#False) : EndIf 
EndProcedure 

;Example:
OpenWindow(0,25,50,160,60,"Ich wurde zuerst geladen")
OpenWindow(1,10,10,200,200,"Ich wurde danach geladen")

Delay(2000)

ForceFore(WindowID(0))

Delay(2000)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
