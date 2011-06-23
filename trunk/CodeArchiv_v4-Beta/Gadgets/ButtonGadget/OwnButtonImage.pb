; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0, 0, 0, 100, 200, "OwnButtonImage", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  If CreateImage(0, 50, 50) 
    StartDrawing(ImageOutput(0)) 
      FrontColor(RGB(0,0,255)) 
      Box(5, 5, 40, 40) 
    StopDrawing() 
  EndIf 
  If CreateImage(1,50,50) 
    StartDrawing(ImageOutput(1)) 
      FrontColor(RGB(0,0,255)) 
      Box(5, 5, 10, 5) : Box(15, 5, 10, 5) : Box(30, 5, 10, 5) 
      Box(5, 10, 40, 30) 
    StopDrawing() 
  EndIf 
  If CreateImage(2,50,50) 
    StartDrawing(ImageOutput(2)) 
      FrontColor(RGB(0,0,255)) 
      Box (5, 5, 10, 5) : Box(5, 15, 10, 5) : Box(5, 30, 5, 10, 5) 
      Box (10, 5, 30, 40) 
    StopDrawing() 
  EndIf 
  If CreateGadgetList(WindowID(0)) 
    ButtonImageGadget(507, 20, 10, 50, 50, ImageID(0)) 
    ButtonImageGadget(508, 20, 70, 50, 50, ImageID(1)) 
    ButtonImageGadget(509, 20, 130, 50, 50, ImageID(2)) 
  EndIf 
  Repeat : Until WaitWindowEvent() = #WM_CLOSE 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP