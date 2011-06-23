; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1030&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 16. May 2003 
; OS: Windows
; Demo: Yes

Procedure WinCallback(Win,Msg,wParam,lParam) 
  If Msg = #WM_SIZE 
      ResizeGadget(1,5,5,WindowWidth(0)-10,WindowHeight(0)-10) 
  EndIf 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

OpenWindow(0,0,0,200,200,"Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_SizeGadget) 
  CreateGadgetList(WindowID(0)) 
  ListViewGadget(1,5,5,190,190) 
  
SetWindowCallback(@WinCallback()) 

Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
