; www.PureArea.net
; Author: Andre Beer (updated by Progi1984)
; Date: 30. January 2007
; OS: Windows, Linux
; Demo: Yes


; A BlitzBasic conversion, originally written by ashcroftman
; returns true if two lines 'touch'
; Uses maths, not 'per-pixel' so is pretty fast...

Procedure LineIntersection(x1,y1,x2,y2,u1,v1,u2,v2)
  b1.f = (y2 - y1) / (x2 - x1)
  b2.f = (v2 - v1) / (u2 - u1)
  a1.f = y1 - b1 *x1
  a2.f = v1 - b2 *u1
  xi = - (a1-a2)/(b1-b2)
  yi = a1+b1*xi
  If (x1 - xi)*(xi-x2)> -1 And (u1-xi)*(xi - u2)> 0 And (y1-yi)*(yi-y2)>-1 And (v1-yi)*(yi-v2)>-1
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

OpenWindow(0, 0, 0, 300, 300, "Line Intersection Test", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
If CreateGadgetList(WindowID(0))
  ImageGadget (0,   0,   0, 300, 280, 0)
  TextGadget  (1,  10, 280, 250,  18, "Line Intersection Text...")
  ButtonGadget(2, 250, 280,  50,  22, "Next test")
EndIf

CreateImage(0, 300, 280, #PB_Image_DisplayFormat)


Repeat
  event = WaitWindowEvent()

  If event = #PB_Event_Gadget
    If EventGadget() = 2
      x1 = Random(150)       ; first line
      Repeat
        y1 = Random(140)
      Until y1<>x1
      x2 = 150 + Random(150)
      Repeat
        y2 = 140 + Random(140)
      Until y2<>x2
      x3 = Random(150)       ; second line
      Repeat
        y3 = Random(140)
      Until y3<>x3
      x4 = 150 + Random(150)
      Repeat
        y4 = 140 + Random(140)
      Until y4<>x4
      StartDrawing(ImageOutput(0))
      Box(0, 0, 300, 280, RGB(255, 255, 255))
      LineXY(x1, y1, x2, y2, RGB(0, 0, 0))
      LineXY(x3, y3, x4, y4, RGB(255, 0, 0))
      StopDrawing()
      SetGadgetState(0, ImageID(0))  ; update the ImageGadget

      If LineIntersection(x1, y1, x2, y2, x3, y3, x4, y4) = #True
        SetGadgetText(1, "Lines are intersecting...")
      Else
        SetGadgetText(1, "Lines are not intersecting...")
      EndIf
    EndIf

  EndIf


Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP