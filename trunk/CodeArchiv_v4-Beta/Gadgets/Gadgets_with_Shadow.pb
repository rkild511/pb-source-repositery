; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11525
; Author: Andreas
; Date: 07. Janaury 2007
; OS: Windows
; Demo: No

;####################################
; Gadgets mit Schatten versehen
; Author : Andreas Januar 2007
;####################################


Enumeration
  ;Windows
  #Main
  ;ButtonGadgets
  #Button1
  ;EditorGadgets
  #Editor1
  ;CalendarGadgets
  #Calender1
  ;TextGedgets
  #Text1
  ;TextBorder
  #Text2
  ;Dategadgets
  #Date1
EndEnumeration

Procedure ShadowProc(wnd,lparam)
  ;TextGadgets ausnehmen
  If (GetDlgCtrlID_(wnd) < #Text1) Or (GetDlgCtrlID_(wnd) >= #Text2)
    Protected x.l,y.l,w.l,h.l
    Brush = GetStockObject_(#DKGRAY_BRUSH)
    Pen   = GetStockObject_(#NULL_PEN)
    OldBrush = SelectObject_(lParam,Brush)
    OldPen   = SelectObject_(lParam,Pen)
    x = GadgetX(GetDlgCtrlID_(wnd))+6
    y = GadgetY(GetDlgCtrlID_(wnd))+6
    w = GadgetX(GetDlgCtrlID_(wnd))+6+GadgetWidth(GetDlgCtrlID_(wnd))
    h = GadgetY(GetDlgCtrlID_(wnd))+6+GadgetHeight(GetDlgCtrlID_(wnd))
    OldBrush = SelectObject_(lParam,Brush)
    Rectangle_(lParam,x,y,w,h)
    SelectObject_(lParam,OldBrush)
    SelectObject_(lParam,OldPen)
    DeleteObject_(Brush)
    DeleteObject_(Pen)
  EndIf
  ProcedureReturn #True
EndProcedure

Procedure WCB(wnd,msg,wparam,lparam)
  Shared FullDrag.l
  Result = #PB_ProcessPureBasicEvents
  Select msg
    Case #WM_NCHITTEST
    Case #WM_PAINT
      BeginPaint_(wnd,ps.PAINTSTRUCT)
      EnumChildWindows_(wnd,@ShadowProc(),ps\hdc)
      EndPaint_(wnd,ps.PAINTSTRUCT)
  EndSelect
  ProcedureReturn Result
EndProcedure


If OpenWindow(#Main, 100, 200, 400, 420, "Mein Fenster",#PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
  If CreateGadgetList(WindowID(0))
    ButtonGadget(#Button1, 10,10,80,24,"Ende")
    EditorGadget(#Editor1, 10,50,300,100)
    CalendarGadget(#Calender1, 10, 170,200,180)
    TextGadget(#Text1,10,370,350,30,"Sieht nicht gut aus mit Schatten, darum werden TextGadgets ohne Rand nicht behandelt")
    TextGadget(#Text2,260,190,100,16,FormatDate("%dd.%mm.%yyyy %hh:%ii", Date()),#SS_CENTER|#WS_BORDER)
    DateGadget(#Date1, 100, 10, 180, 25, "Datum: %dd/%mm/%yyyy Zeit: %hh:%ii")
  EndIf
  SetWindowCallback(@WCB())
  InvalidateRect_(WindowID(0),0,0)
  SetForegroundWindow_(WindowID(#Main))
  Repeat
    EventID = WaitWindowEvent()
    Select EventID
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 1
            SendMessage_(WindowID(0),#WM_CLOSE,0,0)
        EndSelect
      Case #PB_Event_CloseWindow
        Quit = 1
    EndSelect
  Until Quit = 1
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP