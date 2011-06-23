; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2233&highlight=
; Author: Rob (updated for PB4.00 by blbltheworm)
; Date: 07. September 2003
; OS: Windows
; Demo: Yes

#winMain=1

Procedure WindowResize(WindowID, Message, wParam, lParam) 
    Result = #PB_ProcessPureBasicEvents 
    If Message = #WM_SIZE 
      ResizeGadget(0,5,5,WindowWidth(#winMain)-10,WindowHeight(#winMain)-10) 
    EndIf    
    ProcedureReturn Result 
EndProcedure 

OpenWindow(#winMain,0,0,300,200, "PanelResize",#PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget) 
SetWindowCallback(@WindowResize()) 

CreateGadgetList(WindowID(#winMain)) 
PanelGadget(0,5,5,290,190) 
  AddGadgetItem(0,1,"Eins") 
  AddGadgetItem(0,2,"Zwei") 
  AddGadgetItem(0,3,"Drei") 

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
