; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm + Andre)
; Date: 22. November 2003
; OS: Windows
; Demo: Yes


; A simple trick to show .gif images via the PB Movie library

InitMovie() 

OpenWindow(1,0,0,500,500,"",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
LoadMovie(1, OpenFileRequester("Choose a .gif", "", "Gif (*.gif)|*.gif|Alle Dateien (*.*)|*.*", 0)) 
ResizeMovie(1,0,0,WindowWidth(1),WindowHeight(1)) 
PlayMovie(1, WindowID(1)) 

Repeat 
Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP