; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2826&highlight=
; Author: RayMan1970 (updated for PB4.00 by blbltheworm)
; Date: 26. November 2003
; OS: Windows
; Demo: No

InitSprite() 

ScreenWidth = GetSystemMetrics_(#SM_CXSCREEN) 
ScreenHeight = GetSystemMetrics_(#SM_CYSCREEN) 



OpenWindow(1,0,0,ScreenWidth,ScreenHeight,"Test", #PB_Window_ScreenCentered | #PB_Window_BorderLess) ; #PB_Window_SystemMenu 
OpenWindowedScreen(WindowID(1),0,0,ScreenWidth,ScreenHeight,0,0,0) 

ClearScreen(RGB(255,255,255)) 

StartDrawing( ScreenOutput() ) 
  Circle(ScreenWidth/2,ScreenHeight/2,ScreenWidth/4,RGB( 255,0,0) ) 
StopDrawing() 

FlipBuffers() 

MessageRequester("Test", "Text",#PB_MessageRequester_Ok ) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
