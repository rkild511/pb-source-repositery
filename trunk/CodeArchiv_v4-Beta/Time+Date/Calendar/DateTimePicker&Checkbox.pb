; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2821&highlight=
; Author: wichtel (updated for PB4.00 by blbltheworm)
; Date: 13. November 2003
; OS: Windows
; Demo: No


Debug #WS_CHILD
Debug #WS_VISIBLE

OpenWindow(0,200,200,200,200,"test",#PB_Window_SystemMenu)
If CreateGadgetList(WindowID(0))
  ;mit checkbox
  picker1=CreateWindowEx_(0,"SysDateTimePick32","",#WS_CHILD|#WS_VISIBLE|12+2,10,10,100,25,WindowID(0),0,GetModuleHandle_(0),0)
  
  ;ohne checkbox
  picker2=CreateWindowEx_(0,"SysDateTimePick32","",#WS_CHILD|#WS_VISIBLE|12,10,40,100,25,WindowID(0),0,GetModuleHandle_(0),0)
EndIf
Repeat
  EventID=WaitWindowEvent()
Until EventID=#PB_Event_CloseWindow

CloseWindow(0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
