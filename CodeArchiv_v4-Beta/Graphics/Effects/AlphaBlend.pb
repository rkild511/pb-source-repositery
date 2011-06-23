; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3268&start=10
; Author: Mischa (updated for PB 4.00 by Flype)
; Date: 30. December 2003
; OS: Windows
; Demo: No


Import "Msimg32.lib" 
  AlphaBlend(dc1, x1, y1, w1, h1, dc2, x2, y2, w2, h2, blend) 
EndImport 

Procedure.l DrawAlphaImage2(hdc, image, x, y, Alpha) 
  Protected tdc.l, object.l, w.l, h.l, blend.l, *blend.BLENDFUNCTION = @blend 
  tdc = CreateCompatibleDC_(hdc) 
  If tdc 
    object = SelectObject_(tdc, ImageID(image)) 
    If object 
      w = ImageWidth(image) 
      h = ImageHeight(image) 
      *blend\SourceConstantAlpha = Alpha 
      AlphaBlend(hdc, x, y, w, h, tdc, 0, 0, w, h, blend) 
      DeleteObject_(object) 
    EndIf 
    DeleteDC_(tdc) 
  EndIf 
EndProcedure 

For i = 1 To 10 
  If CreateImage(i, Random(50)+50, Random(50)+50) 
    If StartDrawing(ImageOutput(i)) 
      Box(0, 0, ImageWidth(i), ImageHeight(i), RGB(Random(255), Random(255), Random(255))) 
      StopDrawing() 
    EndIf 
  EndIf 
Next i 

If OpenWindow(0, 0, 0, 400, 300, "AlphaBlend", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  
  hdc = StartDrawing(WindowOutput(0)) 
  
  If hdc 
    For i = 1 To 100 
      For j = 1 To 10 
        DrawAlphaImage2(hdc, j, Random(375), Random(275), i) 
      Next j 
      WindowEvent() 
      Delay(20) 
    Next i 
  EndIf 
  
  StopDrawing() 

  Repeat 
  Until WaitWindowEvent()=#PB_Event_CloseWindow 

EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger