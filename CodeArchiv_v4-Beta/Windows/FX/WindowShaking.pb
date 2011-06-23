; German forum: http://www.purebasic.fr/german/viewtopic.php?t=717&highlight=
; Author: Lukaso (updated for PB 4.00 by Andre)
; Date: 02. November 2004
; OS: Windows
; Demo: No

; Shaking window
; Fenster schütteln

If OpenWindow(0, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 

SetTimer_(WindowID(0), 1, 50, 0) 
  
Repeat 
  EventID.l = WaitWindowEvent() 
  
  
  If EventID = #PB_Event_CloseWindow 
    Quit = 1 
    
  ElseIf EventID = #WM_TIMER 
    ResizeWindow(0,WindowX(0)+2, WindowY(0)+2,#PB_Ignore,#PB_Ignore) 
    Delay(25) 
    ResizeWindow(0,WindowX(0)-2, WindowY(0)-2,#PB_Ignore,#PB_Ignore) 
  EndIf 
  
Until Quit = 1 
  
EndIf 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -