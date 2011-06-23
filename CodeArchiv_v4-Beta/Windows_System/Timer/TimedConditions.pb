; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9023&highlight=
; Author: Danilo
; Date: 10. January 2004
; OS: Windows
; Demo: No


; Note: this code needs the timer userlib from PBOSL package, get it from www.purearea.net


; This is how the program works. 

Global X 

; The timer will perform a task every 20 seconds 
; to try And get X to equal true. 
Procedure Timer1() 
  X = Random(1) 
EndProcedure 

StartTimer(1,2000,@Timer1()) ; 2 seconds for the test only 

; Startup code > code that needs condition X to be true. 
Repeat 
  Repeat ; wait until X becomes TRUE 
    Delay(1000) 
    Debug "wait until X becomes TRUE..." 
  Until X 
  
  ; Once X does equal true, 
  ; after a While it will equal false, 
  ; 
  Repeat ; wait until X is false again 
    Delay(1000) 
    Debug "wait until X is false again" 
  Until X=0 
  
  Debug "starting again.." 
  
ForEver ; And the program should start over.
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
