; English forum:
; Author: Unknown (updated for PB3.93 by Donald, updated for PB 4.00 by Andre)
; Date: 31. January 2003
; OS: Windows
; Demo: No

Global hFont
Declare.l ActivateGadgetEx(Gadget)
Declare.l DisableGadgetEx(Gadget, State)
Declare.l FreeGadgetEx(Gadget)
Declare.l GadgetHeightEx(Gadget)
Declare.l GadgetIDEx(Gadget)
Declare.l GadgetToolTipEx(Gadget, Text$)
Declare.l GadgetWidthEx(Gadget)
Declare.l GadgetXEx(Gadget)
Declare.l GadgetYEx(Gadget)
Declare.s GetGadgetTextEx(Gadget)
Declare.l HideGadgetEx(Gadget, State)
Declare.l SetGadgetFontEx(FontID)
Declare.l SetGadgetTextEx(Gadget, Text$)
Declare.l WrapStringGadget(Gadget, x, y, Width, Height, text.s, flags)

Procedure Error(message$, fatal.b)
  *memoryID = AllocateMemory(256)
  FormatMessage_(#FORMAT_MESSAGE_FROM_SYSTEM, 0, GetLastError_(), 0,*memoryID , 256, 0)
  MessageRequester("Error", message$+Chr(10)+Chr(10)+PeekS(*memoryID), 0)
  FreeMemory(*memoryID)
  If fatal
    End
  EndIf
EndProcedure
; To process events we don't want WaitEventWindow() to catch
Procedure WndProc(hWnd, uMsg, wParam, lParam)
  Result = 0
  Select uMsg
    Case #WM_COMMAND
      EditClass.s = Space(4)
      If GetClassName_(hWnd, EditClass, 5)=4
        If (GetWindowLong_(hWnd, #GWL_STYLE|#ES_AUTOHSCROLL))=0 And EditClass="Edit"
          Select wParam>>16
            Case #EN_CHANGE
              Result = #PB_ProcessPureBasicEvents
            Case #EN_KILLFOCUS
              Result = #PB_ProcessPureBasicEvents
            Case #EN_SETFOCUS
              Result = #PB_ProcessPureBasicEvents
          EndSelect
        Else
          Result = #PB_ProcessPureBasicEvents
        EndIf
      Else
        Result = #PB_ProcessPureBasicEvents
      EndIf
    Default
      Result = #PB_ProcessPureBasicEvents
  EndSelect
  ProcedureReturn Result
EndProcedure

If OpenWindow(0, 0, 0, 220, 120, "Wrap string gadget example", #PB_Window_SystemMenu)
  WindowId = WindowID(0)
  If CreateGadgetList(WindowId)
    SetGadgetFontEx(LoadFont(0, "Courier New", 10))
    If WrapStringGadget(0, 10, 10, 200, 100, "", #ES_MULTILINE|#ES_AUTOVSCROLL|#WS_VSCROLL)
      SetGadgetTextEx(0, "Wrap string gadget example: let's get wrapped until we scroll down and down!")
      Debug "GadgetIDEx: "+Str(GadgetIDEx(0))
      Debug "GadgetXEx: "+Str(GadgetXEx(0))
      Debug "GadgetYEx: "+Str(GadgetYEx(0))
      Debug "GadgetWidthEx: "+Str(GadgetWidthEx(0))
      Debug "GadgetHeightEx: "+Str(GadgetHeightEx(0))
      Debug "GadgetIDEx: "+GetGadgetTextEx(0)
      SetWindowCallback(@WndProc())
      If GadgetToolTipEx(0, "WrapEditGadget tooltip")=0
        Error("GadgetToolTipEx() failed", 0)
      EndIf
      Repeat
        EventID = WaitWindowEvent()
        Select EventID
          Case #PB_Event_Gadget
            Select EventGadget()
              Case 0
                Debug "WrapStringGadget event type processed:"+Str(EventType())
            EndSelect
        EndSelect
      Until EventID=#PB_Event_CloseWindow
      DeleteObject_(hFont)
    Else
      Error("WrapStringGadget() failed:", 1)
    EndIf
  Else
    Error("CreateGadgetList() failed:", 1)
  EndIf
Else
  Error("OpenWindow() failed:", 1)
EndIf
End


Procedure WrapStringGadget(Gadget, x, y, Width, Height, Text$, flags)
  WrapStringGadget = CreateWindowEx_(#WS_EX_CLIENTEDGE, "EDIT", Text$, flags|#WS_CHILDWINDOW|#WS_MAXIMIZEBOX|#WS_MINIMIZEBOX|#WS_VISIBLE, x, y, Width, Height, WindowID(0), Gadget, GetModuleHandle_(0), 0)
  If WrapStringGadget
    If hFont
      SendMessage_(WrapStringGadget, #WM_SETFONT, hFont, 1)
    Else
      SendMessage_(WrapStringGadget, #WM_SETFONT, GetStockObject_(#DEFAULT_GUI_FONT), 1)
    EndIf
    UpdateWindow_(WrapStringGadget)
    ShowWindow_(WrapStringGadget, #SW_SHOWNORMAL)
  Else
    Error("CreateWindowEx_() failed:", 1)
  EndIf
  ProcedureReturn WrapStringGadget
EndProcedure
Procedure.s GetGadgetTextEx(Gadget)
  TextWidth = SendMessage_(GadgetIDEx(Gadget), #WM_GETTEXTLENGTH, 0, 0)+1
  Buffer = AllocateMemory(TextWidth)
  SendMessage_(GadgetIDEx(Gadget), #WM_GETTEXT, TextWidth, Buffer)
  Result.s = PeekS(Buffer)
  FreeMemory(Buffer)
  ProcedureReturn Result
EndProcedure
Global GadgetIDEx
Procedure EnumChildProc(hWnd, lParam)
  ID = GetWindowLong_(hWnd, #GWL_ID)
  If ID=lParam
    GadgetIDEx = hWnd
    Result = #False
  Else
    Result = #True
  EndIf
  ProcedureReturn Result
EndProcedure
Procedure GadgetIDEx(Gadget)
  EnumChildWindows_(WindowID(0), @EnumChildProc(), Gadget)
  ProcedureReturn GadgetIDEx
EndProcedure
Procedure DisableGadgetEx(Gadget, State)
  Result = EnableWindow_(GadgetIDEx(Gadget), State)
  ProcedureReturn Result
EndProcedure
Procedure FreeGadgetEx(Gadget)
  Result = DestroyWindow_(GadgetIDEx(Gadget))
  ProcedureReturn Result
EndProcedure
Procedure HideGadgetEx(Gadget, State) 
  If State
    Result = ShowWindow_(GadgetIDEx(Gadget), #SW_HIDE)
  Else
    Result = ShowWindow_(GadgetIDEx(Gadget), #SW_SHOW)
  EndIf
  ProcedureReturn Result
EndProcedure
Procedure GadgetWidthEx(Gadget) 
  GetWindowRect_(GadgetIDEx(Gadget), rc.RECT)
  Result = rc\right-rc\left
  ProcedureReturn Result
EndProcedure
Procedure GadgetHeightEx(Gadget) 
  GetWindowRect_(GadgetIDEx(Gadget), rc.RECT)
  Result = rc\bottom-rc\top
  ProcedureReturn Result
EndProcedure
Procedure GadgetXEx(Gadget) 
  GetWindowRect_(GadgetIDEx(Gadget), rc.RECT)
  Result = rc\left
  ProcedureReturn Result
EndProcedure
Procedure GadgetYEx(Gadget) 
  GetWindowRect_(GadgetIDEx(Gadget), rc.RECT)
  Result = rc\top
  ProcedureReturn Result
EndProcedure
Procedure ActivateGadgetEx(Gadget) 
  Result = SetFocus_(GadgetIDEx(Gadget))
  ProcedureReturn Result
EndProcedure
Procedure SetGadgetTextEx(Gadget, Text$)
  Result = SendMessage_(GadgetIDEx(Gadget), #WM_SETTEXT, 0, Text$)
  ProcedureReturn Result
EndProcedure
Procedure SetGadgetFontEx(FontID)
  If FontID=#PB_Font_Default
    hFont = GetStockObject_(#DEFAULT_GUI_FONT)
  Else
    hFont = FontID
  EndIf
  ProcedureReturn hFont
EndProcedure
Procedure GadgetToolTipEx(Gadget, Text$)
#TTF_DI_SETITEM = $8000
  hToolTip = CreateWindowEx_(0, "Tooltips_class32", 0, 0, 0, 0, 0, 0, WindowID(0), 0, GetModuleHandle_(0), 0)
  If hToolTip
    ti.TOOLINFO
    ti\cbSize = SizeOf(TOOLINFO)
    ti\uFlags = #TTF_SUBCLASS|#TTF_IDISHWND
    ti\hWnd = GadgetIDEx(Gadget)
    ti\uId = GadgetIDEx(Gadget)
    ti\hinst = 0
    ti\lpszText = @Text$
    Result = SendMessage_(hToolTip, #TTM_ADDTOOL, 0, ti)
  Else
    Result = 0
  EndIf
  ProcedureReturn Result
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---