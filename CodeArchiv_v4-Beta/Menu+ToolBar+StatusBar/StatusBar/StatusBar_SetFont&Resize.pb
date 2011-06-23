; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3180&highlight=
; Author: Falko (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 19. December 2003
; OS: Windows
; Demo: No


LoadFont (0, "Courier", 15)            ; Load Courrier Font, Size 15 
LoadFont (1, "Arial", 25)              ; Load Arial Font, Size 25 


Procedure SizeCallback(WindowId, Message, wParam, lParam) 

  ReturnValue = #PB_ProcessPureBasicEvents 
  
  If Message = #WM_SIZE 
    ; UpdateStatusBar(0) 
    ReturnValue = 1       ; Tell the PureBasic internal event handler than the Size event is processed by the user callback 
  EndIf 
  
  ProcedureReturn  ReturnValue 
EndProcedure 


If OpenWindow(0, 100, 150, 400, 200, "PureBasic - StatusBar Example", #PB_Window_SystemMenu | #PB_Window_SizeGadget) 

  Hdl.l = CreateStatusBar(0, WindowID(0)) 
  If Hdl 
    AddStatusBarField(100) 
    AddStatusBarField(150) 
    AddStatusBarField(100) 
  EndIf 
  
    StatusBarText(0, 0, "Area 1") 
    StatusBarText(0, 1, "Area 2", #PB_StatusBar_BorderLess) 
    StatusBarText(0, 2, "Area 3", #PB_StatusBar_Right | #PB_StatusBar_Raised) 
  SendMessage_(Hdl,#WM_SETFONT,FontID(1),#True) ; hier wird Arial eingesetzt 
   Delay(1000) 
  SendMessage_(Hdl,#WM_SETFONT,FontID(0),#True) ; und hier Courier 
  ;UpdateStatusBar(0) 
  SetWindowCallback(@SizeCallback()) 
  
  Repeat 

  Until WaitWindowEvent() = #PB_Event_CloseWindow 
  
EndIf  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
