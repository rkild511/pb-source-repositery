; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 10. May 2003
; OS: Windows
; Demo: Yes

CreateImage(1,400,300)
 
If OpenWindow(0,0,0,ImageWidth(1),ImageHeight(1),"",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  CreateGadgetList(WindowID(0))
  ImageGadget(1,0,0,ImageWidth(1),ImageHeight(1),ImageID(1))
  
  FirstX.l=Random(ImageWidth(1))
  FirstY.l=Random(ImageHeight(1))
  
  oldx=FirstX
  oldy=FirstY
  
  StartDrawing(WindowOutput(0))
    For i=0 To 20
      newX.l=Random(ImageWidth(1))
      newY.l=Random(ImageHeight(1))
      LineXY(oldx,oldy,newX,newY,RGB(0,200,0))
      oldx=newX
      oldy=newY
    Next
    LineXY(oldy,oldy,FirstX,FirstY,RGB(0,200,0))
  StopDrawing()
  
  Repeat
    eventid=WaitWindowEvent()
    If eventid=#WM_LBUTTONUP
      StartDrawing(WindowOutput(0))
        FillArea(WindowMouseX(0),WindowMouseY(0),RGB(0,200,0),RGB(Random(255),Random(255),255))
      StopDrawing()
    EndIf
  Until eventid=#PB_Event_CloseWindow
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -