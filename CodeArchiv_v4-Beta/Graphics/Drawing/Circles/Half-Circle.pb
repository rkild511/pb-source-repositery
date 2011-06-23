; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: Yes

If InitSprite()And InitKeyboard()And OpenScreen(640, 480, 32, "test") 
  #Resolution = 1 
  WinkelAnf.f = 0 
  WinkelEnd.f = #PI ; half-circle from 0° to 90°
  
  RadiusX.l = 200 
  RadiusY.l = 200 
  MX.l = 319 
  MY.l = 239 
  
  StartDrawing(ScreenOutput()) 
    If RadiusX > RadiusY : Radius.l = RadiusX : Else : Radius = RadiusY : EndIf 
    FrontColor(RGB(255,255,255)) 
    For a.l = WinkelAnf * Radius To WinkelEnd * Radius ;Step 2 
      x.f = Cos(a / Radius) * RadiusX + MX 
      y.f = Sin(a / Radius) * RadiusY + MY 
      Plot(x,  y) 
    Next 
  StopDrawing() 
  FlipBuffers() 
  
  Repeat 
    ExamineKeyboard() 
  Until KeyboardPushed(#PB_Key_Escape) 
  
  CloseScreen() 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -