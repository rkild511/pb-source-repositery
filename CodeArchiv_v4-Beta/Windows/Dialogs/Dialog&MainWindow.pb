; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Maxx = GetSystemMetrics_(#SM_CXSCREEN) 
Maxy = GetSystemMetrics_(#SM_CYSCREEN) 

HF = OpenWindow(0,0,0,Maxx,Maxy,"Hauptfenster",#PB_Window_BorderLess) 
KF = OpenWindow(1,20,20,600,416,"Dialogfenster",#PB_Window_WindowCentered|#PB_Window_SystemMenu) 

SetWindowPos_(HF,#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE) 
SetWindowPos_(KF,#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE) 
EnableWindow_(HF,#False) 

Repeat 
   EventID.l = WaitWindowEvent() 
   If EventID = #PB_Event_CloseWindow 
   Quit = 1 
   EndIf 
Until Quit = 1 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -