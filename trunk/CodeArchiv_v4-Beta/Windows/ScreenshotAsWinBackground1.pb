; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=759&highlight=
; Author: Danilo (updated for PB3.93 by Donald, updated for PB4.00 by blbltheworm)
; Date: 26. April 2003
; OS: Windows
; Demo: No

Procedure MakeDesktopScreenshot(ImageNr,x,y,Width,Height) 
   hImage = CreateImage(ImageNr,Width,Height) 
   hDC = StartDrawing(ImageOutput(ImageNr)) 
      BitBlt_(hDC,0,0,Width,Height,GetDC_(GetDesktopWindow_()),x,y,#SRCCOPY) 
   StopDrawing() 
   ProcedureReturn hImage 
EndProcedure 

Width  = GetSystemMetrics_(#SM_CXSCREEN) 
Height = GetSystemMetrics_(#SM_CYSCREEN) 
OpenWindow(1,0,0,Width,Height,"",#PB_Window_Invisible|#PB_Window_BorderLess) 
  CreateGadgetList(WindowID(1)) 
  ImageGadget(0,0,0,Width,Height,MakeDesktopScreenshot(1,0,0,Width,Height)) 
  ButtonGadget(1,10,110,300,50,"EXIT") 
  SetGadgetFont(1,LoadFont(1,"Arial",30)) 
  ListViewGadget(2,10,170,300,100) 
  While a < 1000: AddGadgetItem(2,-1,"Eintrag "+Str(a)):a+1: Wend 
  DisableGadget(0,1)
While WindowEvent():Wend:ShowWindow_(WindowID(1),#SW_SHOWMAXIMIZED) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 1 : End 
      EndSelect 
  EndSelect 
ForEver  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
