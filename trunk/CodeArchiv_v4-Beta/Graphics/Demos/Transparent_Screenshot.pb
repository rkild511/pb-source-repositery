; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No

#Window_Width  = 500 
#Window_Height = 500 

Image = CreateImage(1,#Window_Width,#Window_Height) 

; make ScreenShot 
hDC = StartDrawing(ImageOutput(1)) 
   BitBlt_(hDC,0,0,#Window_Width,#Window_Height,GetDC_(GetDesktopWindow_()),0,0,#SRCCOPY) 
StopDrawing() 

; paint on ScreenShot 
LoadFont(1,"Arial",57)
StartDrawing(ImageOutput(1)) 
   DrawingMode(1) 
   DrawingFont(FontID(1)) 
   FrontColor(RGB($FF,$FF,$00)) 
   DrawText(10,50,"PureBasic") 
StopDrawing() 


OpenWindow(1,0,0,#Window_Width,#Window_Height,"",#WS_POPUP) 
   CreateGadgetList(WindowID(1)) 
   ImageGadget(1,0,0,#Window_Width,#Window_Height,Image) 
   DisableGadget(1,1)    ; added by Andre for PB3.93 compatibility
   ButtonGadget(2,10,10,100,30,"QUIT") 

Repeat 
  Select WaitWindowEvent() 
     Case #PB_Event_CloseWindow : End 
     Case #PB_Event_Gadget 
        Select EventGadget() 
           Case 2 : End 
        EndSelect      
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -