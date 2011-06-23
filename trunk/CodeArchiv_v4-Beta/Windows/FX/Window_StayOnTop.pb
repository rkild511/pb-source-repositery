; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9492&highlight=
; Author: einander (updated for PB 4.00 by Andre)
; Date: 13. February 2004
; OS: Windows
; Demo: No

hWnd=OpenWindow(0,0,0,400,300,"Stay on top",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
SetWindowPos_(hWnd,#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE) 
Repeat 
    Event = WaitWindowEvent() 
    If Event= #PB_Event_CloseWindow  : Quit=1: EndIf 
Until Quit= 1 
End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger