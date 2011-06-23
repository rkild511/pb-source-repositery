; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13417&postdays=0&postorder=asc&start=15
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 22. December 2004
; OS: Windows
; Demo: No


; Comments:
; How to make the buttons not stay down?

; Change the button staying down:
; Case #ODS_FOCUS
;             ; --> ClickDown
;             doWhatBrush = buttonBrushClick
;             doFlags = #DFCS_BUTTONPUSH | #DFCS_PUSHED | #DFCS_ADJUSTRECT
;
;
; To button going back up:
; Case #ODS_FOCUS
;             ; --> ClickDown
;             doWhatBrush = buttonBrushLeave
;             doFlags = #DFCS_BUTTONPUSH  | #DFCS_MONO | #DFCS_ADJUSTRECT
;             drawFocus = 1
;
; Then add this after the DrawText_() to draw your focus rect
; If drawFocus = 1
;         DrawFocusRect_(*dis\hDC, *dis\rcItem)
;       EndIf
;


; *************************************************
; Title:          Sparkies Ownerdraw Hover Buttons
; Author:         Spakie
; Start Date:     December 20, 2004 8:50 AM
; Version 0.01B:  December 22, 2004 9:00 AM
; License:        Free to use, optimize, and modify at will :)
; *************************************************
#ODA_DRAWENTIRE = 1
#ODA_FOCUS = 4
#ODA_SELECT = 2
#TME_CANCEL = $80000000
#TME_HOVER = 1
#TME_LEAVE = 2
#TME_NONCLIENT = $10
#TME_QUERY = $40000000
#DFCS_HOT = $1000
;#DFCS_TRANSPARENT = 4800
#ODS_INACTIVE = $80
#ODS_HOTLIGHT = $40
#ODS_NOFOCUSRECT = $200
#WM_MOUSEHOVER = $2A1
#WM_MOUSELEAVE = $2A3
#MyWindow = 0
Enumeration
  #MyButton1 = 100
  #MyButton2
  #MyButton3
EndEnumeration
#DoHover = 1
#DoLeave = 2

; --> Declare Globals
Global doWhat, oldCallback, buttonBrushLeave, buttonBrushClick, buttonBrushHover

; --> For tracking mouse
Structure myTRACKMOUSEEVENT
  cbSize.l
  dwFlags.l
  hwndTrack.l
  dwHoverTime.l
EndStructure
Global mte.myTRACKMOUSEEVENT
mte\cbSize = SizeOf(myTRACKMOUSEEVENT)

; --> Create button background brushes
buttonBrushLeave = CreateSolidBrush_(RGB(237, 233, 177))
buttonBrushClick = CreateSolidBrush_(RGB(207, 203, 147))
buttonBrushHover = CreateSolidBrush_(RGB(255, 100, 100))

; --> Main WindowCallback
Procedure myWindowCallback(hwnd, msg, wparam, lparam)
  result = #PB_ProcessPureBasicEvents
  Select msg
    Case #WM_DRAWITEM
      *dis.DRAWITEMSTRUCT = lparam
      If *dis\CtlType = #ODT_BUTTON
        buttonNum = *dis\CtlID
        ; --> Default button attributes
        SetBkMode_(*dis\hDC, #TRANSPARENT)
        doWhatBrush = buttonBrushLeave
        doFlags = #DFCS_FLAT | #DFCS_BUTTONPUSH | #DFCS_MONO | #DFCS_ADJUSTRECT
        Select *dis\itemState
          Case 0
            ; --> DoHover or DoLeave
            If *dis\itemAction = 1 And doWhat = #DoHover
              ; --> DoHover
              doWhatBrush = buttonBrushHover
              doFlags = #DFCS_BUTTONPUSH | #DFCS_MONO | #DFCS_ADJUSTRECT
            ElseIf *dis\itemAction = 1 And doWhat = #DoLeave
              ; --> DoLeave
              doWhatBrush = buttonBrushLeave
              doFlags = #DFCS_FLAT | #DFCS_BUTTONPUSH | #DFCS_MONO | #DFCS_ADJUSTRECT
            EndIf
          Case #ODS_FOCUS
            ; --> ClickDown
            doWhatBrush = buttonBrushClick
            doFlags = #DFCS_BUTTONPUSH | #DFCS_PUSHED | #DFCS_ADJUSTRECT
          Case #ODS_FOCUS | #ODS_SELECTED
            ; --> ClickUp
            doWhatBrush = buttonBrushClick
            doFlags = #DFCS_BUTTONPUSH | #DFCS_PUSHED | #DFCS_ADJUSTRECT
        EndSelect
      EndIf
      DrawFrameControl_(*dis\hDC, *dis\rcItem, #DFC_BUTTON, doFlags)
      FillRect_(*dis\hDC, *dis\rcItem, doWhatBrush)
      DrawText_(*dis\hDC, GetGadgetText(buttonNum), Len(GetGadgetText(buttonNum)), *dis\rcItem, #DT_CENTER | #DT_SINGLELINE | #DT_VCENTER)
  EndSelect
  ProcedureReturn result
EndProcedure

; --> ButtonCallback
Procedure myButtonCallback(hwnd, msg, wparam, lparam)
  Shared mouseLeave, hover, hot
  result = CallWindowProc_(oldCallback, hwnd, msg, wparam, lparam)
  buttonID = GetDlgCtrlID_(hwnd)
  Select msg
    Case #WM_MOUSEMOVE
      If wparam <> #MK_LBUTTON And mouseLeave = 0
        mouseLeave = 1
        doWhat = #DoHover
        ; --> Force #WM_DRAWITEM
        InvalidateRect_(GadgetID(buttonID), 0, 0)
        ; Track mouse leaving button
        mte\dwFlags = #TME_LEAVE
        mte\hwndTrack = GadgetID(buttonID)
        TrackMouseEvent_(mte)
      EndIf
    Case #WM_MOUSELEAVE
      mouseLeave = 0
      doWhat = #DoLeave
      ; --> Force #WM_DRAWITEM
      InvalidateRect_(GadgetID(buttonID), 0, 0)
    Case #WM_LBUTTONDOWN
      ; --> Set flag to reset previous down botton
      doWhat = #DoLeave
  EndSelect
  ProcedureReturn result
EndProcedure
If OpenWindow(#MyWindow, 100, 100, 250, 200, "Custom Hover Buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(#MyWindow))
  SetWindowCallback(@myWindowCallback())
  CreateStatusBar(0, WindowID(#MyWindow))
  StringGadget(0, 75, 10, 100, 20, "Ownerdraw Buttons", #PB_String_BorderLess | #PB_String_ReadOnly)
  ButtonGadget(#MyButton1, 75, 50, 100, 20, "Testing")
  ButtonGadget(#MyButton2, 75, 80, 100, 20, "Customized")
  ButtonGadget(#MyButton3, 75, 110, 100, 20, "Buttons")
  ; --> Remove #BS_PUSHBUTTON and add #BS_OWNERDRAW to buttons
  For b = #MyButton1 To #MyButton3
    bStyle = GetWindowLong_(GadgetID(b), #GWL_STYLE)
    SetWindowLong_(GadgetID(b), #GWL_STYLE, bStyle &~#BS_PUSHBUTTON | #BS_OWNERDRAW)
    oldCallback = SetWindowLong_(GadgetID(b), #GWL_WNDPROC, @myButtonCallback())
  Next b
  Repeat
    event = WaitWindowEvent()
    Select event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 0
            StatusBarText(0, 0, "No Button seelcted")
          Case #MyButton1
            StatusBarText(0, 0, "Selected button ID# " + Str(#MyButton1) + " text is: Testing")
          Case #MyButton2
            StatusBarText(0, 0, "Selected button ID# " + Str(#MyButton2) + " text is: Customized")
          Case #MyButton3
            StatusBarText(0, 0, "Selected button ID# " + Str(#MyButton3) + " text is: Buttons")
        EndSelect
    EndSelect
  Until event = #PB_Event_CloseWindow
EndIf
DeleteObject_(buttonBrushLeave)
DeleteObject_(buttonBrushClick)
DeleteObject_(buttonBrushHover)
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -