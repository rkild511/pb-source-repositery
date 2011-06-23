; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7628&highlight=
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 23. September 2003
; OS: Windows
; Demo: No

; Change a string gadget to and from readonly dynamically...
If OpenWindow(0,200,200,300,200,"test",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  StringGadget(0,10,10,200,20,"Click the LMB on this window") 
  Repeat 
    ev=WaitWindowEvent() 
    If ev=#WM_LBUTTONDOWN 
      locked=1-locked : SendMessage_(GadgetID(0),#EM_SETREADONLY,locked,0) 
    EndIf 
  Until ev=#PB_Event_CloseWindow 
EndIf 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
