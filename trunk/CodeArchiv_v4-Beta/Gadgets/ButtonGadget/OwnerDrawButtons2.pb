; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13417&postdays=0&postorder=asc&start=15
; Author: Christian (updated for PB 4.00 by Andre)
; Date: 22. December 2004
; OS: Windows
; Demo: No


; Author: Christian
; Date: 22. December 2004

; --> This is needed for PB's drawing functions to work
Structure PBDrawingStruct
  Type.l
  WindowHandle.l
  DC.l
  ReleaseProcedure.l
EndStructure
Global mydraw.PBDrawingStruct
mydraw\Type = 1

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Procedures
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; --> Windowcallback
Procedure myWindowCallback(hwnd, msg, wparam, lparam)
  result = #PB_ProcessPureBasicEvents
  Select msg
  Case #WM_DRAWITEM
    ; -- Get handle and DeviceContext
    *lpdis.DRAWITEMSTRUCT = lparam
    mydraw\WindowHandle = *lpdis\hwndItem
    hDC = GetDC_(mydraw\WindowHandle)
    
    ; -- Get GadgetRect
    XPos = *lpdis\rcItem\left
    YPos = *lpdis\rcItem\top
    Width = *lpdis\rcItem\right-*lpdis\rcItem\left
    Height = *lpdis\rcItem\bottom-*lpdis\rcItem\top
    
    ; -- Get font information and GadgetText
    GadgetFont = SendMessage_(mydraw\WindowHandle, #WM_GETFONT, 0, 0)
    GetObject_(GadgetFont, SizeOf(LOGFONT), @lf.LOGFONT)
    FontHeight.l = Abs(lf\lfHeight)
    
    GadgetText.s = Space(1000)
    GetWindowText_(mydraw\WindowHandle, @GadgetText, 1000)
    
    ; -- Start with OwnerDrawing
    Select *lpdis\CtlType
    Case #ODT_BUTTON
      ; -- Draw selected/pushed button
      If *lpdis\itemState & #ODS_SELECTED
        If StartDrawing(mydraw)
          ; -- Border
          LineXY(XPos, YPos, Width, 0, GetSysColor_(3))
          LineXY(XPos, YPos, 0, Height - 1, GetSysColor_(3))
          LineXY(XPos + Width, YPos, XPos + Width, YPos + Height - 1, GetSysColor_(5))
          LineXY(XPos, YPos + Height - 1, XPos + Width, YPos + Height - 1, GetSysColor_(5))
          
          ; -- BackgroundColor
          Box(XPos + 1, YPos + 1, Width - 1, Height - 2, GetSysColor_(4))
          
          ; -- Text
          DrawingMode(1) : FrontColor(RGB(0, 0, 0))
          DrawingFont(GadgetFont)
          
          DrawText((Width - XPos - TextWidth(GadgetText))/2 + 1, (Height - YPos - FontHeight)/2 + 1, GadgetText)
          StopDrawing()
        EndIf
      Else
        ; -- Draw normal button
        If StartDrawing(mydraw)
          ; -- Border
          LineXY(XPos, YPos, Width, 0, GetSysColor_(5))
          LineXY(XPos, YPos, 0, Height - 1, GetSysColor_(5))
          LineXY(XPos + Width, YPos, XPos + Width, YPos + Height - 1, GetSysColor_(3))
          LineXY(XPos, YPos + Height - 1, XPos + Width, YPos + Height - 1, GetSysColor_(3))
          
          ; -- BackgroundColor
          Box(XPos + 1, YPos + 1, Width - 1, Height - 2, GetSysColor_(4))
          
          ; -- Text
          DrawingMode(1) : FrontColor(RGB(0, 0, 0))
          DrawingFont(GadgetFont)
          
          DrawText((Width - XPos - TextWidth(GadgetText))/2, (Height - YPos - FontHeight)/2, GadgetText)
          StopDrawing()
        EndIf
      EndIf
      If *lpdis\itemState & #ODS_FOCUS
        ; -- Draw the FocusRect
        *lpdis\rcItem\left + 3
        *lpdis\rcItem\top + 3
        *lpdis\rcItem\right - 3
        *lpdis\rcItem\bottom - 3
        DrawFocusRect_(hDC, *lpdis\rcItem)
      EndIf
      
    EndSelect
    result = #True
  EndSelect
  ProcedureReturn result
EndProcedure

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Program
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If OpenWindow(0, 0, 0, 480, 260,"Christians OwnerDrawn Buttons",#PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  SetWindowCallback(@myWindowCallback())
  
  ButtonGadget(0, 50, 50, 200, 50, "Owner Drawn Button 1", #BS_OWNERDRAW)
  ButtonGadget(1, 50, 105, 200, 50, "Owner Drawn Button 2", #BS_OWNERDRAW)
  
  Repeat
    event = WaitWindowEvent()
    Select event
    Case #PB_Event_Gadget
      Select EventGadget()
      Case 0
        MessageRequester("Info", "Button 1 pressed!", 0)
        
      Case 1
        MessageRequester("Info", "Button 2 pressed!", 0)
      EndSelect
    EndSelect
  Until event = #PB_Event_CloseWindow
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -