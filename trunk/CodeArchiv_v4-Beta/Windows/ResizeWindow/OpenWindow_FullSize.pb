; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2840&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 15. November 2003
; OS: Windows
; Demo: No

OpenWindow(0,0,0,0,0,"ICC",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_TitleBar) 
  SystemParametersInfo_(#SPI_GETWORKAREA,0,rect.RECT,0) 
  MoveWindow_(WindowID(0),0,0,rect\right,rect\bottom,1) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
