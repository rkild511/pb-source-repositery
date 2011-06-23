; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11526
; Author: Andreas
; Date: 07. Janaury 2007
; OS: Windows
; Demo: No


;####################################
; Ownerdraw - Buttons
; Author : Andreas Januar 2007
;####################################

Enumeration
  ;Windows
  #Main
  ;ButtonGadgets
  #Button1
  #Button2
EndEnumeration

Structure ButtonData
  Col.l
  TextCol.l
  SelCol.l
  SelTextCol.l
  DisCol.l
  DisTextCol.l
  HotCol.l
  HotTextCol.l
EndStructure

Global G

Procedure BCB(wnd,msg,wParam,lParam)
  Select msg
    Case #WM_MOUSEMOVE
      If G = 0
        *B.ButtonData = GetProp_(wnd,"COLS")
        dc = GetDC_(wnd)
        GetWindowRect_(wnd,rcItem.RECT)
        MapWindowPoints_(GetDesktopWindow_(),wnd,rcItem,2)

        DrawFrameControl_(dc,rcItem,#DFC_BUTTON,#DFCS_BUTTONPUSH)
        Brush = CreateSolidBrush_(*B\HotCol)
        r.Rect
        SetRect_(r,rcItem\left+1,rcItem\top+1,rcItem\right-1,rcItem\Bottom-1)
        FillRect_(dc,r,Brush)
        SetBkMode_(dc,#TRANSPARENT)
        SetTextColor_(dc,*B\HotTextCol)
        SelectObject_(dc,GetStockObject_(#ANSI_VAR_FONT))
        Text$ = GetGadgetText(GetDlgCtrlID_(wnd))
        DrawText_(DC,Text$,Len(Text$),rcItem,#DT_CENTER|#DT_SINGLELINE|#DT_VCENTER)
        SelectObject_(dc,Old)
        DeleteObject_(Brush)
        If GetFocus_() = wnd
          r.Rect
          SetRect_(r,2,2,rcItem\right-2,rcItem\bottom-2)
          DrawFocusRect_(dc,r)
        EndIf
        G = 1
      EndIf
  EndSelect
  ProcedureReturn CallWindowProc_(GetProp_(wnd,"BCB"),wnd,msg,wParam,lParam)
EndProcedure

Procedure RemoveProp(wnd,lParam)
  RemoveProp_(wnd,"COLS")
  RemoveProp_(wnd,"BCB")
  ProcedureReturn #True
EndProcedure

Procedure SetButtonData(wnd,lparam)
  SendMessage_(wnd,#WM_SETFONT,GetStockObject_(#ANSI_VAR_FONT),#True)
  SetProp_(wnd,"COLS",lparam)
  SetProp_(wnd,"BCB",SetWindowLong_(wnd,#GWL_WNDPROC,@BCB()))
EndProcedure


Procedure WCB(wnd,msg,wparam,lparam)
  Result = #PB_ProcessPureBasicEvents
  Select msg
    Case #WM_MOUSEMOVE
      If G = 1
        InvalidateRect_(wnd,0,0)
        G = 0
      EndIf
    Case #WM_NCDESTROY
      EnumChildWindows_(WindowID(0),@RemoveProp(),0)
    Case #WM_DRAWITEM
      *lpdis.DRAWITEMSTRUCT = lParam
      *B.ButtonData = GetProp_(*lpdis\hwndItem,"COLS")
      Text$ = GetGadgetText(*lpdis\CtlID)
      If *b
        If *lpdis\CtlType = #ODT_BUTTON
          DrawFrameControl_(*lpdis\hdc,*lpdis\rcItem,#DFC_BUTTON,#DFCS_BUTTONPUSH)
          Brush = CreateSolidBrush_(*B\Col)
          r.Rect
          SetRect_(r,*lpdis\rcItem\left+1,*lpdis\rcItem\top+1,*lpdis\rcItem\right-1,*lpdis\rcItem\Bottom-1)
          FillRect_(*lpdis\hdc,r,Brush)
          SetBkMode_(*lpdis\hdc,#TRANSPARENT)
          SetTextColor_(*lpdis\hdc,*B\TextCol)
          DrawText_(*lpdis\hDC,Text$,Len(Text$),*lpdis\rcItem,#DT_CENTER|#DT_SINGLELINE|#DT_VCENTER)
          SelectObject_(*lpdis\hdc,Old)
          DeleteObject_(Brush)
        EndIf

        If *lpdis\itemState & #ODS_SELECTED
          DrawFrameControl_(*lpdis\hdc,*lpdis\rcItem,#DFC_BUTTON,#DFCS_BUTTONPUSH|#DFCS_PUSHED)
          Brush = CreateSolidBrush_(*B\SelCol)
          r.Rect
          SetRect_(r,*lpdis\rcItem\left+2,*lpdis\rcItem\top+2,*lpdis\rcItem\right-2,*lpdis\rcItem\Bottom-2)
          FillRect_(*lpdis\hdc,r,Brush)
          SetBkMode_(*lpdis\hdc,#TRANSPARENT)
          SetTextColor_(*lpdis\hdc,*B\SelTextCol)
          DrawText_(*lpdis\hDC,Text$,Len(Text$),*lpdis\rcItem,#DT_CENTER|#DT_SINGLELINE|#DT_VCENTER)
          SelectObject_(*lpdis\hdc,Old)
          DeleteObject_(Brush)
        EndIf

        If *lpdis\itemState & #ODS_DISABLED
          DrawFrameControl_(*lpdis\hdc,*lpdis\rcItem,#DFC_BUTTON,#DFCS_BUTTONPUSH)
          Brush = CreateSolidBrush_(*B\DisCol)
          r.Rect
          SetRect_(r,*lpdis\rcItem\left+2,*lpdis\rcItem\top+2,*lpdis\rcItem\right-2,*lpdis\rcItem\Bottom-2)
          FillRect_(*lpdis\hdc,r,Brush)
          Old = SelectObject_(*lpdis\hdc,Brush)
          SetBkMode_(*lpdis\hdc,#TRANSPARENT)
          SetTextColor_(*lpdis\hdc,*B\DisTextCol)
          DrawText_(*lpdis\hDC,Text$,Len(Text$),*lpdis\rcItem,#DT_CENTER|#DT_SINGLELINE|#DT_VCENTER)
          SelectObject_(*lpdis\hdc,Old)
          DeleteObject_(Brush)
        EndIf
        If *lpdis\itemState & #ODS_FOCUS
          ReleaseDC_(wnd,*lpdis\hDC)
          r.Rect
          SetRect_(r,2,2,*lpdis\rcItem\right-2,*lpdis\rcItem\bottom-2)
          DrawFocusRect_(*lpdis\hDC,r)
        EndIf
      EndIf
  EndSelect
  ProcedureReturn Result
EndProcedure

If OpenWindow(#Main, 100, 200, 400, 420, "Ownerdraw-Buttons",#PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
  If CreateGadgetList(WindowID(0))
    ButtonGadget(#Button1, 10,10,80,24,"Ende",#BS_OWNERDRAW)
    ButtonGadget(#Button2, 10,50,80,24,"Cancel",#BS_OWNERDRAW)
    BD.ButtonData
    BD\Col = RGB(0,0,128)
    BD\TextCol = RGB(255,255,255)
    BD\SelCol = RGB(0,255,0)
    BD\SelTextCol = RGB(0,0,0)
    BD\DisCol = RGB(222,222,222)
    BD\DisTextCol = RGB(255,255,255)
    BD\HotCol = RGB(0,255,255)
    BD\HotTextCol = RGB(0,0,0)
    SetButtonData(GadgetID(#Button1),BD)
    BD1.ButtonData
    BD1\Col = RGB(0,0,196)
    BD1\TextCol = RGB(255,255,0)
    BD1\SelCol = RGB(255,0,0)
    BD1\SelTextCol = RGB(0,0,0)
    BD1\DisCol = RGB(222,222,222)
    BD1\DisTextCol = RGB(255,255,255)
    BD1\HotCol = RGB(255,0,255)
    BD1\HotTextCol = RGB(0,0,0)
    SetButtonData(GadgetID(#Button2),BD1)
  EndIf
  DisableGadget(#Button1,1)
  SetWindowCallback(@WCB())
  SetForegroundWindow_(WindowID(#Main))
  Repeat
    EventID = WaitWindowEvent()
    Select EventID
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 1
            SendMessage_(WindowID(0),#WM_CLOSE,0,0)
          Case 2
            DisableGadget(#Button1,0)
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