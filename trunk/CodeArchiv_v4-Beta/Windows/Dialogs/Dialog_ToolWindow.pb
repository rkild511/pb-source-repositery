; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=841&start=20
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 05. May 2003
; OS: Windows
; Demo: No

OpenWindow(1,200,200,640,480,"Hauptfenster",#PB_Window_SystemMenu) 
  OpenWindow(2,480, 80,200,300,"ToolWindow 1",0) 
  SetWindowLong_(WindowID(2),#GWL_HWNDPARENT,WindowID(1)) 
  CreateGadgetList(WindowID(2)) : StringGadget(1,5,10,180,20,"Test") 
Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow And EventWindow()=1 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
