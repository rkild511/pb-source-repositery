; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=716&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 22. April 2003
; OS: Windows
; Demo: No

Procedure MakeWinScreenshot(ImageNr,hWnd,Width,Height) 
   hImage = CreateImage(ImageNr,Width,Height) 
   hDC = StartDrawing(ImageOutput(ImageNr)) 
      BitBlt_(hDC,0,0,Width,Height,GetDC_(hWnd),0,0,#SRCCOPY) 
   StopDrawing() 
   ProcedureReturn hImage 
EndProcedure 

OpenWindow(1,0,0,600,300,"",#PB_Window_SystemMenu|#PB_Window_Invisible|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(1)) 

  hShotWindow = FindWindow_(0,"PureBasic")   ; enter the right name here!
  If hShotWindow 
    hWinBmp  = MakeWinScreenshot(1,hShotWindow,600,300) 
    ImageGadget(1,0,0,600,300,hWinBmp) 
  EndIf 

HideWindow(1,0) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow : End 
  EndSelect 
ForEver 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
