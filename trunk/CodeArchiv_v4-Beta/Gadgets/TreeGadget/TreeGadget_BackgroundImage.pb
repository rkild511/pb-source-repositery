; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5208&highlight=
; Author: El_Choni (updated for PB4.00 by blbltheworm)
; Date: 26. February 2003
; OS: Windows
; Demo: No


pic$ = "..\..\graphics\gfx\purebasiclogonew.png"     ; here you must define name (and if needed path) of the image to be used
UsePNGImageDecoder()

Global WindowID, OldTreeGadgetProc, hDC, mDC, m2DC, width, height, Painting

Declare TreeGadgetProc(hWnd, uMsg, wParam, lParam)

If OpenWindow(0, 128, 96, 640, 480, "TreeGadget background image example", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget)
  WindowID = WindowID(0)
  If CreateGadgetList(WindowID)
    TreeGadget = TreeGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
    For k=0 To 3
      AddGadgetItem(0, -1, "General "+Str(k))
      AddGadgetItem(0, -1, "ScreenMode")
        AddGadgetItem(0, -1, "640*480",0,1)
        AddGadgetItem(0, -1, "800*600",0,1)
        AddGadgetItem(0, -1, "1024*768",0,1)
        AddGadgetItem(0, -1, "1600*1200",0,1)
      AddGadgetItem(0, -1, "Joystick")
    Next
    LoadImage(0, pic$)
    width = ImageWidth(0)
    height = ImageHeight(0)
    hDC = GetDC_(WindowID)
    mDC = CreateCompatibleDC_(hDC)
    mOldObject = SelectObject_(mDC, ImageID(0))
    m2DC = CreateCompatibleDC_(hDC)
    hmBitmap = CreateCompatibleBitmap_(hDC, width, height)
    m2OldObject = SelectObject_(m2DC, hmBitmap)
    ReleaseDC_(WindowID, hDC)
    OldTreeGadgetProc = SetWindowLong_(TreeGadget, #GWL_WNDPROC, @TreeGadgetProc())
    Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow
    SelectObject_(mDC, mOldObject)
    DeleteDC_(mDC)
    SelectObject_(m2DC, m2OldObject)
    DeleteObject_(hmBitmap)
    DeleteDC_(m2DC)
  EndIf
EndIf
End

Procedure TreeGadgetProc(hWnd, uMsg, wParam, lParam)
  result = 0
  Select uMsg
    Case #WM_ERASEBKGND
      result = 1
    Case #WM_PAINT
      If Painting=0
        Painting = 1
        BeginPaint_(hWnd, ps.PAINTSTRUCT)
        result = CallWindowProc_(OldTreeGadgetProc, hWnd, uMsg, m2DC, 0)
        BitBlt_(m2DC, ps\rcPaint\left, ps\rcPaint\top, ps\rcPaint\right-ps\rcPaint\left, ps\rcPaint\bottom-ps\rcPaint\top, mDC, ps\rcPaint\left, ps\rcPaint\top, #SRCAND)
        BitBlt_(m2DC, 0, 0, width, height, mDC, 0, 0, #SRCAND)
        hDC = GetDC_(hWnd)
        BitBlt_(hDC, ps\rcPaint\left, ps\rcPaint\top, ps\rcPaint\right-ps\rcPaint\left, ps\rcPaint\bottom-ps\rcPaint\top, m2DC, ps\rcPaint\left, ps\rcPaint\top, #SRCCOPY)
        BitBlt_(hDC, 0, 0, width, height, m2DC, 0, 0, #SRCCOPY)
        ReleaseDC_(hWnd, hDC)
        EndPaint_(hWnd, ps)
        Painting = 0
      EndIf
    Default
      result = CallWindowProc_(OldTreeGadgetProc, hWnd, uMsg, wParam, lParam)
  EndSelect
  ProcedureReturn result
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
