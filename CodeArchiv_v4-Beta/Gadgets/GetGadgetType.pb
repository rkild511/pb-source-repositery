; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7603&highlight=
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 21. September 2003
; OS: Windows
; Demo: No


; Note: starting with PB v4 there is also a native command GadgetType() available
; Hinweis: seit PB v4 ist auch ein nativer Befehl GadgetType() verfügbar

Procedure.s GetGadgetType(gadget) 
  class$=Space(255) : GetClassName_(GadgetID(gadget),class$,255) 
  ProcedureReturn class$ 
EndProcedure 

If OpenWindow(1,300,250,400,200,"Window",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(1)) 
  ButtonGadget(1,20,50,60,25,"Button") : Debug GetGadgetType(1) 
  StringGadget(2,20,80,300,20,"String") : Debug GetGadgetType(2) 
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP