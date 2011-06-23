; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=841&highlight=
; Author: J-The-Grey (updated for PB4.00 by blbltheworm)
; Date: 01. May 2003
; OS: Windows
; Demo: No

OpenWindow(0,0,0,600,416,"Hauptfenster",#PB_Window_SystemMenu) 
  OpenWindow(1,20,20,600,416,"Dialogfenster",#PB_Window_SystemMenu) 
  SetWindowPos_(WindowID(1),#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE) 
  EnableWindow_(WindowID(0), #False) 
    
  Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
    Quit = 1 
    EndIf 
  Until Quit = 1 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
