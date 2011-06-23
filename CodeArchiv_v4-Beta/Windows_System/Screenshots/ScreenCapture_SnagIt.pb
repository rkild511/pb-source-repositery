; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6477&highlight=
; Author: cecilcheah (updated for PB 4.00 by Leonhard)
; Date: 11. June 2003
; OS: Windows
; Demo: No

; Fully functional Screen Capture (like SnagIt)
; ---------------------------------------------
; Feature:
; Left mouse down o start cpature
; Drag while left mouse is still down to define a rectangle to capture.
; Left mouse up to finish capture
; Hotkey (Shift + Ctrl + F11) to start capture.
;
; When the capture start, it will sit there until someone press the hot keys and then you
; should start the capturing process. The captured image will be in the clipboard.


;Drag with left mouse button to select a part of the screen
;Release the left button to paste it as a bitmap to the clipboard and end

Window_Width  = GetSystemMetrics_(#SM_CXSCREEN)
Window_Height = GetSystemMetrics_(#SM_CYSCREEN)

corner1.POINT
corner2.POINT

; Added by Andre to work without include picture
CreateImage(1,200,200)
CreateImage(2,200,200)

If OpenWindow(0,100,150,291,155,"TBK Capture (STRG + F11 für Screenshot)",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(0))
  TextGadget(2, 10, 10, WindowWidth(0)-20, WindowHeight(0)-20, "STRG + F11 für einen Screenshot drücken, danach auf dem Bildschirm den bereich auswählen, der in der Zwischenablage gespeichert werden soll")
  RegisterHotKey_(WindowID(0),1, #MOD_CONTROL,#VK_F11)
 
  Repeat
    WindowEvent = WaitWindowEvent()
   
    Select EventWindow()
      Case 0 ;{ Normale, 1. Fenster
        If WindowEvent = #WM_HOTKEY
          Pic_desktop = CreateImage(1, Window_Width, Window_Height)
         
          hDC = StartDrawing(ImageOutput(1))
            BitBlt_(hDC, 0, 0, Window_Width, Window_Height, GetDC_(GetDesktopWindow_()), 0, 0, #SRCCOPY)
          StopDrawing()
         
          OpenWindow(1, 0, 0, Window_Width, Window_Height, "Capturing", #WS_POPUP)
          CreateGadgetList(WindowID(1))
          StartDrawing(WindowOutput(1))
            DrawImage(ImageID(1), 0, 0)     
            DrawingMode(#PB_2DDrawing_XOr | #PB_2DDrawing_Outlined)
            GetCursorPos_(@corner2)
            Box(corner1\x, corner1\y, corner2\x-corner1\x, corner2\y-corner1\y, $FFFFFF)
          StopDrawing()
          Layer1_desktop = CreateImage(2, Window_Width, Window_Height)
         
          hWnd1 = FindWindow_(0, "Capturing")
          SetForegroundWindow_(hWnd1)
        EndIf
      ;}
      Case 1 ;{ Das Fenster, auf dem man den Bereich auswählt
        Select WindowEvent
          Case #WM_MOUSEMOVE ;{
            If drawbox And SettingCursor=0
              StartDrawing(WindowOutput(1))
                DrawImage(ImageID(1), 0, 0)     
                DrawingMode(#PB_2DDrawing_XOr | #PB_2DDrawing_Outlined)
                GetCursorPos_(@corner2)
                Box(corner1\x, corner1\y, corner2\x-corner1\x, corner2\y-corner1\y, $FFFFFF)
              StopDrawing()
              SettingCursor = 1
              SetCursorPos_(corner2\x, corner2\y)
            Else
              SettingCursor = 0
            EndIf
          ;}
          Case #WM_LBUTTONDOWN ;{
            GetCursorPos_(@corner1)
            ;Debug corner1\x
            drawbox = 1
          ;}
          Case #WM_LBUTTONUP ;{
            StartDrawing(WindowOutput(1)) ; don't grab the boxlines
              DrawImage(ImageID(1),0,0)                   
            StopDrawing()
           
            ;CreateCompatibleBitmap_ cannot handle negative width/height values...
            If corner1\x > corner2\x
              Swap corner2\x, corner1\x
            EndIf
            If corner1\y > corner2\y
              Swap corner2\y, corner1\y
            EndIf
           
            GrabImage(1, 0, corner1\x, corner1\y, corner2\x-corner1\x, corner2\y-corner1\y)
            SetClipboardImage(0)
           
            MessageRequester("", "Das Bild wurde in die Zwischenablage kopiert", #MB_ICONINFORMATION)
           
            drawbox = 0
            Break
          ;}
        EndSelect
      ;}
    EndSelect
  ForEver
EndIf

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP