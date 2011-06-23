; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11884&highlight=
; Author: edel
; Date: 04. February 2007
; OS: Windows
; Demo: Yes

hwnd = OpenWindow(0,0,0,300,300,"") 

CreateGadgetList(hwnd) 
TextGadget(0,20,20,100,30,"TextGadget",#SS_NOTIFY)    ; #SS_NOTIFY is needed for a working tooltip
GadgetToolTip(0, "ToolTip") 

Repeat 
  e = WaitWindowEvent() 
  
Until e = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP