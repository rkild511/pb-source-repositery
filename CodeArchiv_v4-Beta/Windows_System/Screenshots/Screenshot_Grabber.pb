; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2914
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 24. November 2003
; OS: Windows
; Demo: No

; 
; < Screenshot Grabber > 
; 
; by Danilo, 24.11.2003 - german forum 
; 
Global LastImage, LastWindow 

Procedure NewWindow(image) 
  LastWindow + 1 
  Win = LastWindow 
  OpenWindow(Win,0,0,ImageWidth(image),ImageHeight(image),"New Image",#PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_ScreenCentered,WindowID(1)) 
  CreateGadgetList(WindowID(Win)) 
  ImageGadget(Win,0,0,ImageWidth(image),ImageHeight(image),ImageID(image)) 
HideWindow(Win,0) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      CloseWindow(Win) 
      Quit = 1 
  EndSelect 
Until Quit = 1 

EndProcedure 


Procedure OnMouseSelection(x,y,width,height) 
  LastImage + 1 
  GrabImage(1,LastImage,x,y,width,height) 
  CreateThread(@NewWindow(),LastImage) 
EndProcedure 


Procedure DrawMouseSelector(hWnd) 
  Shared WindowProc_MouseSelectStartX, WindowProc_MouseSelectLastX 
  Shared WindowProc_MouseSelectStartY, WindowProc_MouseSelectLastY 
  Shared WindowProc_MouseSelectRect.RECT 

  If WindowProc_MouseSelectStartX > WindowProc_MouseSelectLastX 
    WindowProc_MouseSelectRect\left   = WindowProc_MouseSelectLastX 
    WindowProc_MouseSelectRect\right  = WindowProc_MouseSelectStartX 
  Else 
    WindowProc_MouseSelectRect\left   = WindowProc_MouseSelectStartX 
    WindowProc_MouseSelectRect\right  = WindowProc_MouseSelectLastX 
  EndIf 
  If WindowProc_MouseSelectStartY > WindowProc_MouseSelectLastY 
    WindowProc_MouseSelectRect\top    = WindowProc_MouseSelectLastY 
    WindowProc_MouseSelectRect\bottom = WindowProc_MouseSelectStartY 
  Else 
    WindowProc_MouseSelectRect\top    = WindowProc_MouseSelectStartY 
    WindowProc_MouseSelectRect\bottom = WindowProc_MouseSelectLastY 
  EndIf 

  hDC = GetDC_(hWnd) 
    DrawFocusRect_(hDC,@WindowProc_MouseSelectRect) 
  ReleaseDC_(hWnd,hDC) 
  ;UpdateWindow_(hWnd) ; Win9x fix? 
EndProcedure 


Procedure WindowProc(hWnd,Msg,wParam,lParam) 
  Shared WindowProc_MouseSelect 
  Shared WindowProc_MouseSelectStartX, WindowProc_MouseSelectLastX 
  Shared WindowProc_MouseSelectStartY, WindowProc_MouseSelectLastY 
  Shared WindowProc_MouseSelectRect.RECT 

  If hWnd = WindowID(1) 

    Select Msg 
      Case #WM_LBUTTONDOWN 
        WindowProc_MouseSelect  = 1 
        WindowProc_MouseSelectStartX = lParam&$FFFF 
        WindowProc_MouseSelectStartY = (lParam>>16)&$FFFF 
        GetClientRect_(hWnd,winrect.RECT) 
        MapWindowPoints_(hWnd,0,winrect,2) 
        ClipCursor_(winrect) 
      Case #WM_LBUTTONUP 
        If WindowProc_MouseSelect > 1 
          DrawMouseSelector(hWnd) 
          If WindowProc_MouseSelectRect\left <> WindowProc_MouseSelectRect\right And WindowProc_MouseSelectRect\top <> WindowProc_MouseSelectRect\bottom 
            OnMouseSelection(WindowProc_MouseSelectRect\left,WindowProc_MouseSelectRect\top,WindowProc_MouseSelectRect\right-WindowProc_MouseSelectRect\left,WindowProc_MouseSelectRect\bottom-WindowProc_MouseSelectRect\top) 
            SetCapture_(0) 
          EndIf 
        EndIf 
        ClipCursor_(0) 
        WindowProc_MouseSelect = 0 
      Case #WM_MOUSEMOVE 
        If WindowProc_MouseSelect > 0 And wParam & #MK_LBUTTON 
          If WindowProc_MouseSelect > 1 
            DrawMouseSelector(hWnd) 
          Else 
            WindowProc_MouseSelect + 1 
          EndIf 
          WindowProc_MouseSelectLastX = lParam&$FFFF 
          WindowProc_MouseSelectLastY = (lParam>>16)&$FFFF 
          DrawMouseSelector(hWnd) 
          SetCapture_(hWnd) 
        EndIf 
    EndSelect 
  EndIf 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 


Procedure MakeDesktopScreenshot(ImageNr,x,y,Width,Height) 
   hImage = CreateImage(ImageNr,Width,Height) 
   hDC    = StartDrawing(ImageOutput(ImageNr)) 
   DeskDC = GetDC_(GetDesktopWindow_()) 
      BitBlt_(hDC,0,0,Width,Height,DeskDC,x,y,#SRCCOPY) 
   StopDrawing() 
   ReleaseDC_(GetDesktopWindow_(),DeskDC) 
   ProcedureReturn hImage 
EndProcedure 


DeskWidth  = GetSystemMetrics_(#SM_CXSCREEN) 
DeskHeight = GetSystemMetrics_(#SM_CYSCREEN) 
DeskImage  = MakeDesktopScreenshot(1,0,0,DeskWidth,DeskHeight) 

LastImage  = 1 
LastWindow = 1 

CreatePopupMenu(1) 
  MenuItem(100,"Cut") 
  MenuItem(101,"Copy") 
  MenuItem(102,"Paste") 
  MenuBar() 
  MenuItem(103,"Exit") 

OpenWindow(1,0,0,DeskWidth,DeskHeight,"Mega Mouse Selector",#PB_Window_BorderLess|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
  SetWindowCallback(@WindowProc()) 
  CreateGadgetList(WindowID(1)) 
  ImageGadget(1,0,0,DeskWidth,DeskHeight,DeskImage) 
HideWindow(1,0) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      If EventWindow()=1 
        End 
      EndIf 
    Case #WM_RBUTTONDOWN 
      If EventWindow()=1 
        GetCursorPos_(mouse.POINT) 
        DisplayPopupMenu(1,WindowID(1),mouse\x,mouse\y) 
      EndIf 
    Case #PB_Event_Menu 
      Select EventMenu() 
        Case 103 : End 
      EndSelect 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
