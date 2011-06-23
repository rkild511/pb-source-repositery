; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3766&highlight=
; Author: ara (updated for PB 4.00 by Andre)
; Date: 21. February 2004
; OS: Windows
; Demo: No

; Fade in & out of a transparent image.
; The color of the first pixel stays transparent.

; Transparentes Bild ein- und ausblenden.
; die Farbe des ersten Pixels auf dem Bild bleibt transparent.

Global hwnd
Global transparent
Global Wait
TWait=5000
Global Start

Procedure MyWindowCallback(WindowID, Message, wParam, lParam)
  Result = #PB_ProcessPureBasicEvents
  Select WindowID
    ;Case WindowID(1)
      ; ...
    Case WindowID(2)
      Select message
        Case #WM_NCHITTEST
          result=#HTCAPTION
        Case #WM_TIMER
          result=0
          Select wParam
            Case 1
              If transparent<255
                transparent +1
              ElseIf transparent=255
                KillTimer_(hwnd,1)
                SetTimer_(hWnd,2,TWait,0)
              EndIf
              SetLayeredWindowAttributes_(hwnd,0,transparent,2)    ;
            Case 2
              Delay(800)
              KillTimer_(hwnd,2)
              SetTimer_(hWnd,3,3,0)
            Case 3  ;
              If transparent>0
                transparent -1
              ElseIf transparent=0
                KillTimer_(hwnd,3)
                start=1
              EndIf
              SetLayeredWindowAttributes_(hwnd,0,transparent,2)    ;
          EndSelect
      EndSelect
  EndSelect
  ProcedureReturn Result
EndProcedure

OpenWindow(1,0,0,600,400,"Main Window", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
hwnd= OpenWindow(2, 1,1, 553, 300, "",#PB_Window_BorderLess | #PB_Window_Invisible | #WS_POPUP )
SetWindowPos_(hwnd,#HWND_TOPMOST,(GetSystemMetrics_(#SM_CXSCREEN)/2)-(WindowWidth(2)/2),(GetSystemMetrics_(#SM_CYSCREEN)/2)-(WindowHeight(2)/2),553,300, 0 )

If hwnd
  SetWindowLong_(hwnd,#GWL_EXSTYLE,$00080000|#WS_EX_PALETTEWINDOW)
  SetLayeredWindowAttributes_(hwnd,0,0,2)
  h = CreateRoundRectRgn_(3, 3, 553, 300, 20, 20)
  Skin = CreateRectRgn_(0, 0, 0, 0)
  If  CatchImage(0, ?Logo)
    StartDrawing (ImageOutput (0))
    Height = ImageHeight(0)
    Width = ImageWidth(0)
    BackColor = Point (0, 0)

    For Line = 0 To Height - 1
      Split = 0
      While Split < Width
        While Split < Width And Point(Split, Line) = BackColor
          Split = Split + 1
        Wend
        Start = Split
        While Split < Width And Point(Split, Line) <> BackColor
          Split = Split + 1
        Wend
        If Split > Width
          Split = Width
        EndIf

        Temp = CreateRectRgn_(Start, Line, Split , Line + 1 )
        CombineRgn_(Skin, Skin, Temp, 2)
        DeleteObject_(Temp)
      Wend
    Next
    StopDrawing ()
  EndIf
  If  CatchImage(0, ?Logo)
    If CreateGadgetList(WindowID(2))
      SetWindowRgn_(hwnd, Skin, True)
      ImageGadget(0, 0, 0, 0, 0, ImageID(0))
      SetWindowLong_(GadgetID(0),#WS_BORDER,0)
      HideWindow(2,0)
      SetWindowCallback(@MyWindowCallback())
      SetTimer_(hWnd,1,3,0)
      Repeat
        WaitWindowEvent()
      Until start=1
      CloseWindow(1)
      Repeat
      Until start=1
    EndIf
  EndIf
EndIf

End

Procedure ErrorMessage(Error.l)
  Value.s=Space(255)
  FormatMessage_(#FORMAT_MESSAGE_FROM_SYSTEM,#FORMAT_MESSAGE_FROM_STRING,Error,0,@Value,Len(Value),0)
  MessageRequester("Windows - Error", Value, #MB_ICONSTOP)
EndProcedure

DataSection
  Logo: IncludeBinary "..\Gfx\tools.bmp"
EndDataSection
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -