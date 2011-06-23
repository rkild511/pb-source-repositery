; English forum: http://www.purebasic.fr/english/viewtopic.php?t=2369
; Author: MikeB (updated for PB4.00 by blbltheworm)
; Date: 05. September 2003
; OS: Windows
; Demo: No

Procedure.l MyImage(ImageNumber.l, Width.l, Height.l, Color.l,a$,x,y)
  ImageID.l = CreateImage(ImageNumber, Width, Height)
  StartDrawing(ImageOutput(ImageNumber))
  DrawingMode(1)
  Box(0, 0, Width, Height, Color)
  FrontColor(RGB(0,0,0))
  DrawText(x,y,a$)
  StopDrawing()
  ProcedureReturn ImageID
EndProcedure


mywin=OpenWindow(0,0,0,218,68,"Coloured buttons",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
If mywin
  wbrush=CreateSolidBrush_(RGB(0,0,255))
  SetClassLong_(mywin, #GCL_HBRBACKGROUND, wbrush)
  If CreateGadgetList(mywin)
    hGadget=ContainerGadget (0,10,10,198,48,#PB_Container_Raised)
    hBrush = CreateSolidBrush_(RGB(255,255,0))
    SetClassLong_(hGadget, #GCL_HBRBACKGROUND, hBrush)
    ;
    ButtonImageGadget(1, 10, 8, 80, 24,MyImage(1,80,24,RGB(255,155,0),"Button 1",13,4))
    ;
    ButtonImageGadget(2, 100, 8, 80, 24,MyImage(2,80,24,RGB(255,155,0),"Button 2",13,4))
    CloseGadgetList()
  EndIf
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
