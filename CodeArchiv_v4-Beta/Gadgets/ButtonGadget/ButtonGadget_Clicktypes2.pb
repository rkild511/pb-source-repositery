; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10149&postdays=0&postorder=asc&start=60
; Author: hardfalcon (completely new code, originally written by CyberRun8)
; Date: 19. November 2006
; OS: Windows
; Demo: No


; 19.11.2006 by hardfalcon 
; Determine the type of mouseclick if a button gadget has been clicked. 
; Caution: As this code filters out unnecessary "single click" events 
; which normally preceed a double click event, all single clicks are 
; handled with the delay defined by GetDoubleClickTime_() (usually 500ms) 


If OpenWindow(0,0,0,200,200,"Button Gadget: Detect mouse click type",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ButtonGadget(0,50,50,100,100,"Click me!") 
    Repeat 
    Event = WaitWindowEvent() 
    
    If Event = #WM_LBUTTONDOWN 
      GetCursorPos_(@pt.POINT) 
      If GadgetID(0) = WindowFromPoint_(pt\x,pt\y) 
        If timer 
          KillTimer_(WindowID(0),0) 
        EndIf 
        timer = SetTimer_(WindowID(0),0,GetDoubleClickTime_(),0) 
        mousebutton = event 
      EndIf 
    ElseIf Event = #WM_LBUTTONDBLCLK 
      timer = 0 
      KillTimer_(WindowID(0),0) 
      mousebutton = 0 
      Debug "Left doubleclick" 
      
    ElseIf Event = #WM_MBUTTONDOWN 
      GetCursorPos_(@pt.POINT) 
      If GadgetID(0) = WindowFromPoint_(pt\x,pt\y) 
        If timer 
          KillTimer_(WindowID(0),0) 
        EndIf 
        timer = SetTimer_(WindowID(0),0,GetDoubleClickTime_(),0) 
        mousebutton = event 
      EndIf 
    ElseIf Event = #WM_MBUTTONDBLCLK 
      timer = 0 
      KillTimer_(WindowID(0),0) 
      mousebutton = 0 
      Debug "Middle doubleclick"      
      
    ElseIf Event = #WM_RBUTTONDOWN 
      GetCursorPos_(@pt.POINT) 
      If GadgetID(0) = WindowFromPoint_(pt\x,pt\y) 
        If timer 
          KillTimer_(WindowID(0),0) 
        EndIf 
        timer = SetTimer_(WindowID(0),0,GetDoubleClickTime_(),0) 
        mousebutton = event 
      EndIf 
    ElseIf Event = #WM_RBUTTONDBLCLK 
      timer = 0 
      KillTimer_(WindowID(0),0) 
      mousebutton = 0 
      Debug "Right doubleclick" 
      
    ElseIf Event = #WM_TIMER 
      timer = 0 
      KillTimer_(WindowID(0),0) 
      If mousebutton = #WM_LBUTTONDOWN 
        Debug "Left click" 
      ElseIf mousebutton = #WM_MBUTTONDOWN 
        Debug "Middle click" 
      ElseIf mousebutton = #WM_RBUTTONDOWN 
        Debug "Right click" 
      EndIf 
      mousebutton = 0 
    
    ElseIf Event = #PB_Event_CloseWindow 
      End 
    EndIf 
  ForEver 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP