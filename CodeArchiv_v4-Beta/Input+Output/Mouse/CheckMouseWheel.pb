; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2289&postdays=0&postorder=asc&start=10
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 14. September 2003
; OS: Windows
; Demo: Yes

#WM_MOUSEWHEEL = $20A 

Procedure.w MouseWheelDelta() 
  x.w = ((EventwParam()>>16)&$FFFF) 
  ProcedureReturn -(x / 120) 
EndProcedure 

OpenWindow(0,0,0,400,400,"Mouse Wheel z00m",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  StringGadget(0,0,0,450,400,"20") 

#zoomspeed = 4 
Wheel = 20 
SetGadgetFont(0,LoadFont(0,"Arial",Wheel)) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
    Case #WM_MOUSEWHEEL 
      Wheel + MouseWheelDelta() * #zoomspeed 
      If Wheel < 8:Wheel = 8:EndIf 
      SetGadgetFont(0,LoadFont(0,"Arial",Wheel)) 
      SetGadgetText(0,Str(Wheel)) 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
