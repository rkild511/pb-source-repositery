; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1764
; Author: Danilo
; Date: 21. July 2003
; OS: Windows
; Demo: No


; Vielleicht sind auch die folgenden 2 Proceduren von dem ein oder anderen 
; mal zu gebrauchen, da sie die Gr��e der Scrollbars an der Seite zur�ckgeben. 
; Das ScrollAreaGadget beachtet diese Gr��e zwar selbst bei der 
; Berechnung der richtigen ScrollAreaGr��e, aber wer wei�... 

Procedure ScrollbarWidth() 
  ProcedureReturn GetSystemMetrics_(#SM_CXHSCROLL) 
EndProcedure 

Procedure ScrollbarHeight() 
  ProcedureReturn GetSystemMetrics_(#SM_CYVSCROLL) 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
