; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9286&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 25. January 2004
; OS: Windows
; Demo: Yes

Procedure WindowProc(hWnd,Msg,wParam,lParam) 
  result = #PB_ProcessPureBasicEvents 
  If Msg = #WM_SIZE And hWnd = WindowID(0) 
    ResizeGadget(5,0,0,lParam&$FFFF,(lParam>>16)&$FFFF) 
    result = 0 
  EndIf 
  ProcedureReturn result 
EndProcedure 

OpenWindow(0,0,0,500,400,"Split",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget) 
  CreateGadgetList(WindowID(0)) 
  SetWindowCallback(@WindowProc()) 

  ListIconGadget(1,0,0,0,0,"Title",200,#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
  EditorGadget(2,0,0,0,0) 
  EditorGadget(3,0,0,0,0) 

  ; splitter1: listicon and editor1 
  SplitterGadget(4,0,0,500,300,1,2,#PB_Splitter_Vertical|#PB_Splitter_Separator) 
    SetGadgetState(4,350) ; Set splitter width 

  ; splitter2: splitter1 and editor2 
  SplitterGadget(5,0,0,500,400,4,3,#PB_Splitter_Separator) 
    SetGadgetState(5,300) ; Set splitter width 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP