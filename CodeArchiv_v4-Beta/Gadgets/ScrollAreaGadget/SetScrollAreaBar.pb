; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3616&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 03. February 2004
; OS: Windows
; Demo: No

; 
; by Danilo, 03.02.2004 - german forum 
; 
Procedure SetScrollAreaBar_X(gadget,x) 
  ; scrolls ScrollAreaGadget horizontal 
  SetScrollPos_(GadgetID(gadget),#SB_HORZ,x,1) 
  SendMessage_(GadgetID(gadget),#WM_VSCROLL,-1,0) 
EndProcedure 

Procedure SetScrollAreaBar_Y(gadget,x) 
  ; scrolls ScrollAreaGadget vertical 
  SetScrollPos_(GadgetID(gadget),#SB_VERT,x,1) 
  SendMessage_(GadgetID(gadget),#WM_VSCROLL,-1,0) 
EndProcedure 

OpenWindow(0,300,300,300,300,"ScrollArea",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ScrollAreaGadget(1,0,0,300,300,500,400,10) 
    ButtonGadget(2,50,50,100,20,"Button") 
  CloseGadgetList() 

  SetScrollAreaBar_X(1,50) 
  SetScrollAreaBar_Y(1,50) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger