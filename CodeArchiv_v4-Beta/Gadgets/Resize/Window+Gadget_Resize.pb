; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6058&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 04. May 2003
; OS: Windows
; Demo: Yes


Procedure WinCallback(Win,Msg,wParam,lParam) 
  Select Msg 
    Case #WM_SIZE 
      ResizeGadget(1,5,5,WindowWidth(0)-10,WindowHeight(0)-10) 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

OpenWindow(0,0,0,200,30,"Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_SizeGadget) 
  CreateGadgetList(WindowID(0)) 
  ButtonGadget(1,5,5,190,20,"Button") 
  
SetWindowCallback(@WinCallback()) 

Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
