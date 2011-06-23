; English forum:
; Author: F.Weil (updated for PB4.00 by blbltheworm)
; Date: 05. September 2002
; OS: Windows
; Demo: No


;================================================================
;
; F.Weil - 20020905
;
; This Mandelbrot drawing is a case study to manage a scrolling drawing window.
;
; User features are given in menus and added shortcuts :
;
; W to update window size to image size (limitation to 1024 x 768 screen
; B to save the bitmap in a file (BMP only ! )
;
; The interesting featuer for me is the callback procedure handling scrollbars.
;
; The program is not perfect (some bugs in image / window sizing) but works rather well.
;
; As it is a simplified version of the original program, you will not find the possibility to
; zoom - unzoom or select any part of the drawing ...
;
; Just a case study for scrolling a drawing window I said !
;
; 

#background = $3C1E1E

Global HScrollLevel.l, VScrollLevel.l, OldHScrollLevel.l, OldVScrollLevel.l, ImageXPosition.l, ImageYPosition.l, WindowXSize.l, WindowYSize.l, ImageXSize.l, ImageYSize.l
Global hWnd.l, ImageID0.l

Global xmin.f, ymin.f, xmax.f, ymax.f

Procedure.l IMin(a.l, b.l)
  If b < a
    ProcedureReturn b
  Else
    ProcedureReturn a
  EndIf
EndProcedure

Procedure.l IMax(a.l, b.l)
  If b > a
    ProcedureReturn b
  Else
    ProcedureReturn a
  EndIf
EndProcedure

Procedure RedrawScreen()
  StartDrawing(WindowOutput(0))
    Box(0, 0, WindowXSize, WindowYSize, #background)
    DrawImage(ImageID0, ImageXPosition, ImageYPosition)
  StopDrawing()
  ProcedureReturn
EndProcedure

Procedure MyDrawImage(NIter, FontID)
  FreeImage(0)
  If CreateImage(0, ImageXSize, ImageYSize)
    ImageID0 = ImageID(0)
  EndIf
  StartDrawing(ImageOutput(0))
    DrawingFont(FontID)
    Box(0, 0, ImageXSize, ImageYSize, #background)
    n.l = NIter
    nx.l = ImageXSize
    ny.l = ImageYSize
    c.f = (xmax - xmin) / nx
    d.f = (ymax - ymin) / ny
    For j.l = 0 To ny
      b.f = ymin + j * d
      For i.l = 0 To nx
        a.f = xmin + i * c
        x.f = a
        y.f = b
        For k.l = 0 To n
          u.f = x * x
          v.f = y * y
          y.f = 2 * x * y + b
          x.f = u - v + a
          If (u + v) > n
            Goto Label1
          EndIf
        Next k
        Label1:
        col.l = 256 * k / n
        Color = col << 2 + col << 9 + col << 16
        Plot(i, ImageYSize - j, Color)
      Next i
    Next j
    DrawingMode(1)
    FrontColor(RGB(255,255,180))
    DrawText(20, ImageYSize - 20,"Mandelbrot drawing - A F.Weil application program")
    DrawText(20, ImageYSize - 10,"Powered by PureBasic")
  StopDrawing()
  RedrawScreen()
  ProcedureReturn
EndProcedure

Procedure MyWindowCallBack(WindowID.l, Message.l, wParam.l, lParam.l)
  Result.l
  Result = #PB_ProcessPureBasicEvents
  Select Message
    Case #WM_LBUTTONDOWN ; Mouse left button pushed
      ReleaseCapture_()
      SendMessage_(hWnd, #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
    Case #WM_HSCROLL ; Horizontal Scroll features
      Select wParam
        Case 0 ; Scroll left button
          HScrollLevel = IMax(HScrollLevel - 10000, 0)
        Case 1 ; Scroll right button
          HScrollLevel = IMin(HScrollLevel + 10000, 6553600)
        Case 2 ; Scroll page rigth
          HScrollLevel = IMax(HScrollLevel - 1000000, 0)
        Case 3 ; Scroll page left
          HScrollLevel = IMin(HScrollLevel + 1000000, 6553600)
        Case 8
        Default
          HScrollLevel = wParam
      EndSelect
      If HScrollLevel <> OldHScrollLevel
      OldHScrollLevel = HScrollLevel
      ImageXPosition = (HScrollLevel / 100) * (WindowXSize - ImageXSize) / 65536
      EndIf
      RedrawScreen()
      SetScrollPos_(WindowID, #SB_HORZ, HScrollLevel / 65536, #True)
    Case #WM_VSCROLL ; Vertical Scroll features
      Select wParam
        Case 0 ; Scroll up button
          VScrollLevel = IMax(VScrollLevel - 10000, 0)
        Case 1 ; Scroll down button
          VScrollLevel = IMin(VScrollLevel + 10000, 6553600)
        Case 2 ; Scroll page up
          VScrollLevel = IMax(VScrollLevel - 1000000, 0)
        Case 3 ; Scroll page down
          VScrollLevel = IMin(VScrollLevel + 1000000, 6553600)
        Case 8
        Default
          VScrollLevel = wParam
      EndSelect
      If VScrollLevel <> OldVScrollLevel
        OldVScrollLevel = VScrollLevel
        ImageYPosition = (VScrollLevel / 100) * (WindowYSize - ImageYSize) / 65536
      EndIf
      RedrawScreen()
      SetScrollPos_(WindowID, #SB_VERT, VScrollLevel / 65536, #True)
    Case #WM_PAINT ; 
      RedrawScreen()
    Case #WM_SIZE ; Window size gadget used
      If WindowID = hWnd
        If WindowXSize <> WindowWidth(0) Or WindowYSize <> WindowHeight(0) - 40
          WindowXSize = WindowWidth(0)
          WindowYSize = WindowHeight(0) - 40
        EndIf
        RedrawScreen()
      EndIf
  EndSelect
  ProcedureReturn Result 
EndProcedure

;
; Main starts here
;

WID.l
WEvent.l
EventMenu.l
Quit.l
FontID.l
FileName.s
NIter.l

Quit = #False
WindowXSize = 320
WindowYSize = 240
ImageXSize = 320
ImageYSize = 240
NIter = 100

xmin.f = -2.2
xmax.f = 1
ymin.f = -1.2
ymax.f = 1.2

hWnd = OpenWindow(0, (GetSystemMetrics_(#SM_CXSCREEN) - WindowXSize) / 2, (GetSystemMetrics_(#SM_CYSCREEN) - WindowYSize) / 2, WindowXSize, WindowYSize + 40, "Mandelbrot fractal", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #WS_VSCROLL | #WS_HSCROLL)
If hWnd
  AddKeyboardShortcut(0, #PB_Shortcut_B, 102)
  AddKeyboardShortcut(0, #PB_Shortcut_W, 123)
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, 99)
  LoadFont(0, "Arial", 7)
  FontID = FontID(0)

  If CreateMenu(0, WindowID(0))
    OpenSubMenu("Main")
    MenuItem( 1, "New")
    MenuItem(120, "Save image")
    MenuItem( 99, "Quit")
    CloseSubMenu()
    OpenSubMenu("Size")
    MenuItem( 10, " 160 x 120")
    MenuItem( 11, " 320 x 240")
    MenuItem( 12, " 640 x 480")
    MenuItem( 13, " 800 x 600")
    MenuItem( 14, "1024 x 768")
    MenuItem( 15, "1280 x 960")
    MenuItem( 16, "3200 x 2400")
    MenuItem( 17, "4000 x 3000")
    CloseSubMenu()
    OpenSubMenu("Iterations")
    MenuItem( 20, " 100")
    MenuItem( 21, " 250")
    MenuItem( 22, " 1000")
    MenuItem( 23, " 5000")
    MenuItem( 24, "10000")
    CloseSubMenu()
  EndIf

  SetWindowCallback(@MyWindowCallBack())

  If CreateImage(0, ImageXSize, ImageYSize)
    ImageID0 = ImageID(0)
  EndIf
  MyDrawImage(NIter, FontID)

  Repeat

    WID = WindowID(0)
    WEvent = WaitWindowEvent()
    EventType = EventType()

    Select WEvent
      Case #PB_Event_CloseWindow
        Quit = #True
      Case #PB_Event_Menu
        EventMenu = EventMenu()
        Select EventMenu
          Case 1
            ImageXSize = 320
            ImageYSize = 240
            WindowXSize = 320
            WindowYSize = 240
            NIter = 100
            xmin.f = -2.2
            xmax.f = 1
            ymin.f = -1.2
            ymax.f = 1.2
            MyDrawImage(NIter, FontID)
          Case 10
            ImageXSize = 160
            ImageYSize = 120
            MyDrawImage(NIter, FontID)
          Case 11
            ImageXSize = 320
            ImageYSize = 240
            MyDrawImage(NIter, FontID)
          Case 12
            ImageXSize = 640
            ImageYSize = 480
            MyDrawImage(NIter, FontID)
          Case 13
            ImageXSize = 800
            ImageYSize = 600
            MyDrawImage(NIter, FontID)
          Case 14
            ImageXSize = 1024
            ImageYSize = 768
            MyDrawImage(NIter, FontID)
          Case 15
            ImageXSize = 1280
            ImageYSize = 960
            MyDrawImage(NIter, FontID)
          Case 16
            ImageXSize = 3200
            ImageYSize = 2400
            MyDrawImage(NIter, FontID)
          Case 17
            ImageXSize = 4000
            ImageYSize = 3000
            MyDrawImage(NIter, FontID)
          Case 20
            NIter = 100
            MyDrawImage(NIter, FontID)
          Case 21
            NIter = 250
            MyDrawImage(NIter, FontID)
          Case 22
            NIter = 1000
            MyDrawImage(NIter, FontID)
          Case 23
            NIter = 5000
            MyDrawImage(NIter, FontID)
          Case 24
            NIter = 10000
            MyDrawImage(NIter, FontID)
          Case 99
            Quit = #True
          Case 102
            FileName = SaveFileRequester("Choose a file name", "C:\*.bmp", "", 0)
            If FileName <> ""
              SaveImage(0, FileName)
            EndIf
          Case 123
            ResizeWindow(0,#PB_Ignore,#PB_Ignore,IMin(ImageXSize, 1024), IMin(ImageYSize + 40, 768))
          Default
        EndSelect
      Default
    EndSelect
  Until Quit

EndIf

End
;================================================================

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger