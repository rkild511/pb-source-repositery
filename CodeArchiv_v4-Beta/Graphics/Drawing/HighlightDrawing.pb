; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 11. October 2003
; OS: Windows
; Demo: No

#background = $602020

Procedure MyWindowCallBack(WindowID.l, Message.l, wParam.l, lParam.l)
Result.l
  Result = #PB_ProcessPureBasicEvents
  Select Message
    Case #WM_PAINT
      StartDrawing(WindowOutput(0))
        DrawImage(ImageID(0), 0, 0)
      StopDrawing()
    Case #PB_Event_Repaint
      StartDrawing(WindowOutput(0))
        DrawImage(ImageID(0), 0, 0)
      StopDrawing()
    Case #PB_Event_MoveWindow
      StartDrawing(WindowOutput(0))
        DrawImage(ImageID(0), 0, 0)
      StopDrawing()
    Default
  EndSelect
  ProcedureReturn Result  
EndProcedure

;
; Main starts here
;

  Quit.l = #False
  Over.l = #False
  WindowXSize.l = 320
  WindowYSize.l = 240

  hWnd.l = OpenWindow(0, 200, 200, WindowXSize, WindowYSize, "MyWindow", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar)
  If hWnd
      AddKeyboardShortcut(0, #PB_Shortcut_Escape, 99)
      
      LoadFont(0, "Verdana", 12)
      FontID.l = FontID(0)
      
      SetWindowCallback(@MyWindowCallBack())
      
      If CreateImage(0, WindowXSize, WindowYSize)
          ImageID.l = ImageID(0)
          StartDrawing(ImageOutput(0))
            Box(0, 0, WindowXSize, WindowYSize, #background)
            For i.l = 1 To 1000
              Plot(Random(WindowXSize), Random(WindowYSize), RGB(Random(256), Random(256), Random(256)))
            Next
            DrawingFont(FontID) : FrontColor(RGB(255,255,0)) : DrawingMode(1) : DrawText(WindowXSize / 2, WindowYSize / 2,"Hello world")
            TextWidth.l = TextWidth("Hello world")
          StopDrawing()
      EndIf
      
      StartDrawing(WindowOutput(0))
        DrawImage(ImageID, 0, 0)
      StopDrawing()
      
      x1.l = WindowXSize / 2
      x2.l = WindowXSize / 2 + TextWidth
      y1.l = WindowYSize / 2
      y2.l = WindowYSize / 2 + 20
      
      Repeat
        WMX.l = WindowMouseX(0)
        WMY.l = WindowMouseY(0) - 20
          If WMX > x1 And WMX < x2 And WMY > y1 And WMY < y2 And Over = #False
              Over = #True
              StartDrawing(WindowOutput(0))
                DrawingFont(FontID) : FrontColor(RGB(255,0,0)) : DrawingMode(1) : DrawText(WindowXSize / 2, WindowYSize / 2,"Hello world")
              StopDrawing()
            ElseIf Over = #True
              Over = #False
              StartDrawing(WindowOutput(0))
                DrawingFont(FontID) : FrontColor(RGB(255,255,0)) : DrawingMode(1) : DrawText(WindowXSize / 2, WindowYSize / 2,"Hello world")
              StopDrawing()
          EndIf
        Select WaitWindowEvent()
          Case #PB_Event_CloseWindow
            Quit = #True
          Case #PB_Event_Menu
            Select EventMenu()
              Case 99
                Quit = #True
            EndSelect
          Case #WM_LBUTTONDOWN
            StartDrawing(WindowOutput(0))
              DrawingMode(4)
              Box(x1, y1, x2-x1, y2-y1)
            StopDrawing()
            If WMX > x1 And WMX < x2 And WMY > y1 And WMY < y2
                ReleaseCapture_()
                SendMessage_(hWnd, #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
            EndIf
        EndSelect
      Until Quit
      
  EndIf

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -