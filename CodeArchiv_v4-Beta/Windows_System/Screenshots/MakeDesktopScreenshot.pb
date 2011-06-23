; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Procedure MakeDesktopScreenshot(ImageNr,x,y,Width,Height) 
   hImage = CreateImage(ImageNr,Width,Height) 
   hDC    = StartDrawing(ImageOutput(ImageNr)) 
   DeskDC = GetDC_(GetDesktopWindow_()) 
      BitBlt_(hDC,0,0,Width,Height,DeskDC,x,y,#SRCCOPY) 
   StopDrawing() 
   ReleaseDC_(GetDesktopWindow_(),DeskDC) 
   ProcedureReturn hImage 
EndProcedure

ExamineDesktops()

MakeDesktopScreenshot(0, 0, 0, DesktopWidth(0), DesktopHeight(0)) 
SaveImage(0, "C:\DesktopScreenshot.bmp")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -