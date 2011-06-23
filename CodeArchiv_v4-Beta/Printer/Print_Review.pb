; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 14. March 2003
; OS: Windows
; Demo: Yes

Declare ycm(x.f)
Declare xcm(x.f)


Procedure xcm(x.f)
  
  result = x * (675/ 21)
  
  ProcedureReturn result

EndProcedure


Procedure ycm(x.f)
  
  result = x * (467 / 29.7)
  ProcedureReturn result

EndProcedure


Procedure WindowCallback(WindowID, Message, lParam, wParam)
  If Message = #WM_PAINT
    StartDrawing(WindowOutput(0))
    DrawImage(ImageID(0), 50, 50)
    StopDrawing()
  EndIf
  
  ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure


If OpenWindow(0, 100, 100, 600, 500, "PureBasic - Image", #PB_Window_SystemMenu)
  
  Gosub CreateImage
  SetWindowCallback(@WindowCallback())
  
  Repeat
    EventID = WaitWindowEvent()
  Until EventID = #PB_Event_CloseWindow ; If the user has pressed on the close button

EndIf

End

CreateImage :

CreateImage(0, 657, 467) ; this is 1/10 of a 600dpi page

LoadFont(0, "Arial", ycm(1))
LoadFont(1, "Arial", ycm(0.5))

If StartDrawing(ImageOutput(0))

  Box(0, 0, 657, 467,RGB(255,255,255))
  
  DrawingFont(FontID(0))
  
  DrawText(xcm(1), ycm(1),"PureBasic Printer Test")
  
  DrawingFont(FontID(1))
  
  DrawText(xcm(5), ycm(16),"PureBasic Printer Test 2")
  StopDrawing()
  
  ResizeImage(0,500,400)

EndIf

Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -