; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2693&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 29. October 2003
; OS: Windows
; Demo: No

Procedure MakeWinScreenshot(ImageNr,hWnd,Width,Height) 
   hImage = CreateImage(ImageNr,Width,Height) 
   hDC    = StartDrawing(ImageOutput(ImageNr)) 
   WndDC  = GetDC_(hWnd) 
      BitBlt_(hDC,0,0,Width,Height,WndDC,0,0,#SRCCOPY) 
   StopDrawing() 
   ReleaseDC_(hWnd,WndDC) 
   ProcedureReturn hImage 
EndProcedure 

Procedure MakeDesktopScreenshot(ImageNr,x,y,Width,Height) 
   hImage = CreateImage(ImageNr,Width,Height) 
   hDC    = StartDrawing(ImageOutput(ImageNr)) 
   DeskDC = GetDC_(GetDesktopWindow_()) 
      BitBlt_(hDC,0,0,Width,Height,DeskDC,x,y,#SRCCOPY) 
   StopDrawing() 
   ReleaseDC_(GetDesktopWindow_(),DeskDC) 
   ProcedureReturn hImage 
EndProcedure 



OpenWindow(1,0,0,615,320,"",#PB_Window_SystemMenu|#PB_Window_Invisible|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(1)) 

hShotWindow = FindWindow_(0,"PureBasic") 
If hShotWindow 
   hWinBmp  = MakeWinScreenshot(1,hShotWindow,300,300) 
   hDeskBmp = MakeDesktopScreenshot(2,500,300,300,300) 
   ImageGadget(1,005,10,300,300,hWinBmp) 
   ImageGadget(2,310,10,300,300,hDeskBmp) 
Else 
   hDeskBmp = MakeDesktopScreenshot(2,500,300,600,300) 
   ImageGadget(1,0,0,600,300,hDeskBmp) 
EndIf 

HideWindow(1,0) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
