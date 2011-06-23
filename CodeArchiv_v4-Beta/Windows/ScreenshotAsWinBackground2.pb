; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1373&highlight=
; Author: Danilo (updated for PB3.93 by Donald, updated for PB4.00 by blbltheworm)
; Date: 16. June 2003
; OS: Windows
; Demo: No

#Window_Width  = 1024 
#Window_Height = 768 

Image = CreateImage(1,#Window_Width,#Window_Height) 

; make ScreenShot 
hDC = StartDrawing(ImageOutput(1)) 
   BitBlt_(hDC,0,0,#Window_Width,#Window_Height,GetDC_(GetDesktopWindow_()),0,0,#SRCCOPY) 
StopDrawing() 


; paint on ScreenShot 
StartDrawing(ImageOutput(1)) 
   DrawingMode(1) 
   LoadFont(1,"Arial",57)
   DrawingFont(FontID(1)) 
   FrontColor(RGB($FF,$FF,$00)) 
   DrawText(10,50,"PureBasic") 
StopDrawing() 


OpenWindow(1,0,0,#Window_Width,#Window_Height,"",#WS_POPUP) 
   CreateGadgetList(WindowID(1)) 
   ImageGadget(1,0,0,#Window_Width,#Window_Height,Image) 
   ButtonGadget(2,10,10,100,30,"QUIT") 
   DisableGadget(1,1)
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
; EnableXP
; DisableDebugger
