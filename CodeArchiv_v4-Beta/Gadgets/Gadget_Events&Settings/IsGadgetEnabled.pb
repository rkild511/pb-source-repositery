; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1774
; Author: Danilo
; Date: 22. July 2003
; OS: Windows
; Demo: No

; IsGadgetEnabled(#gadget) returns 0, if gadget is disabled, else it returns a value <> 0.
; IsGadgetEnabled(#gadget) gibt 0 zurück, wenn es disabled ist, ansonsten einen Wert ungleich 0.
Procedure IsGadgetEnabled(gadget) 
  ProcedureReturn IsWindowEnabled_(GadgetID(gadget)) 
EndProcedure 
 



; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
