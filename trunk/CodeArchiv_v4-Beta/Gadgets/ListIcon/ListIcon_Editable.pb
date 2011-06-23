; English forum:
; Author: El Choni (updated for PB3.92+ by Andre, updated for PB4.00 by blbltheworm)
; Date: 09. May 2003
; OS: Windows
; Demo: No

Procedure LoWord(value) 
  ProcedureReturn value & $FFFF 
EndProcedure 

Procedure HiWord(value) 
  ProcedureReturn value >> 16 & $FFFF 
EndProcedure 

#NM_CUSTOMDRAW = #NM_FIRST-12 

#CDDS_ITEM = $10000 
#CDDS_SUBITEM = $20000 
#CDDS_PREPAINT = $1 
#CDDS_ITEMPREPAINT = #CDDS_ITEM|#CDDS_PREPAINT 
#CDDS_SUBITEMPREPAINT = #CDDS_SUBITEM|#CDDS_ITEMPREPAINT 
#CDRF_DODEFAULT = $0 
#CDRF_NEWFONT = $2 
#CDRF_NOTIFYITEMDRAW = $20 
#CDRF_NOTIFYSUBITEMDRAW = $20 

#LVM_SUBITEMHITTEST = #LVM_FIRST+57 
#LVM_GETSUBITEMRECT = #LVM_FIRST+56 

Global ListGadget, OldLViewProc, OldEditProc, hEdit, rct.RECT, CellSelectOn, CurItem, CurSubItem, CurSelItem, CurSelSubItem 

Declare EditProc(hwnd, uMsg, wParam, lParam) 
Declare LViewProc(hwnd, uMsg, wParam, lParam) 
Declare WndProc(hwnd, uMsg, wParam, lParam) 
Declare KillFocus() 
Declare DrawRectangle(hwnd, *rc.RECT) 

#CCM_SETVERSION = #CCM_FIRST+7 

Global FontReg, FontBold 
FontReg = LoadFont(1, "Tahoma", 9) 
FontBold = LoadFont(2, "Tahoma", 9, #PB_Font_Bold) 

If OpenWindow(0, 0, 0, 400, 260, "Color List View Rows", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)=0:End:EndIf 
If CreateGadgetList(WindowID(0))=0:End:EndIf 

ListGadget = ListIconGadget(1, 10, 10, 380, 240, "", 70, #PB_ListIcon_GridLines|#LVS_NOSORTHEADER) 

SendMessage_(ListGadget, #CCM_SETVERSION, 5, 0) 

AddGadgetColumn(1, 1, "Sun", 35) 
AddGadgetColumn(1, 2, "Mon", 35) 
AddGadgetColumn(1, 3, "Tue", 35) 
AddGadgetColumn(1, 4, "Wed", 35) 
AddGadgetColumn(1, 5, "Thu", 35) 
AddGadgetColumn(1, 6, "Fri", 35) 
AddGadgetColumn(1, 7, "Sat", 35) 

For i=18 To 34 
  hour12 = i 
  If hour12>25 
    hour12-24 
    Hour$ = " pm" 
  Else 
    Hour$ = " am" 
  EndIf 
  If hour12&1 
    Hour$=Str(hour12/2)+":30"+Hour$;LSet(Str(hour12/2)+":30"+Hour$, 9, " ") 
  Else 
    Hour$=Str(hour12/2)+":00"+Hour$;LSet(Str(hour12/2)+":00"+Hour$, 9, " ") 
  EndIf 
  AddGadgetItem(1, -1, Hour$+Chr(10)+Str(hour12/2)+"1"+Chr(10)+Str(hour12/2)+"2"+Chr(10)+Str(hour12/2)+"3"+Chr(10)+Str(hour12/2)+"4"+Chr(10)+Str(hour12/2)+"5"+Chr(10)+Str(hour12/2)+"6"+Chr(10)+Str(hour12/2)+"7") 
Next i 

SendMessage_(ListGadget, #LVM_SETBKCOLOR, 0, RGB(255, 255, 223)) 

CreateGadgetList(ListGadget) 
OldLViewProc = SetWindowLong_(ListGadget, #GWL_WNDPROC, @LViewProc()) 
SetWindowCallback(@WndProc()) 

For i=0 To 7 
  SendMessage_(ListGadget, #LVM_SETCOLUMNWIDTH, i, #LVSCW_AUTOSIZE_USEHEADER) 
Next i 

Repeat 
Until WaitWindowEvent()=#PB_Event_CloseWindow 

End 

Procedure KillFocus() 
  If hEdit 
    SetGadgetItemText(1, CurItem, GetGadgetText(2), CurSubItem) 
    FreeGadget(2) 
    hEdit = 0 
  EndIf 
EndProcedure 

Procedure DrawRectangle(hwnd, *rc.RECT) 
  hDC = GetDC_(hwnd) 
  OldPen = SelectObject_(hDC, GetStockObject_(#BLACK_PEN)) 
  OldBrush = SelectObject_(hDC, GetStockObject_(#NULL_BRUSH)) 
  Rectangle_(hDC, *rc\left, *rc\top, *rc\right, *rc\bottom) 
  SelectObject_(hDC, OldBrush) 
  SelectObject_(hDC, OldPen) 
  ReleaseDC_(hwnd, hDC) 
EndProcedure 

Procedure EditProc(hwnd, uMsg, wParam, lParam) 
  result = 0 
  Select uMsg 
    Case #WM_KEYDOWN 
      result = CallWindowProc_(OldEditProc, hwnd, uMsg, wParam, lParam) 
      If wParam=#VK_RETURN 
        KillFocus() 
      EndIf 
    Default 
      result = CallWindowProc_(OldEditProc, hwnd, uMsg, wParam, lParam) 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

Procedure LViewProc(hwnd, uMsg, wParam, lParam) 
  result = 0 
  Select uMsg 
    Case #WM_LBUTTONDBLCLK 
      If hwnd<>hEdit 
        KillFocus() 
        pInfo.LVHITTESTINFO 
        pInfo\pt\x = LoWord(lParam) 
        pInfo\pt\y = HiWord(lParam) 
        SendMessage_(hwnd, #LVM_SUBITEMHITTEST, 0, pInfo) 
        rc.RECT 
        rc\top = pInfo\iSubItem 
        rc\left = #LVIR_BOUNDS 
        SendMessage_(hwnd, #LVM_GETSUBITEMRECT, pInfo\iItem, rc) 
        If hEdit=0 
          UseGadgetList(hwnd) 
          CurItem = pInfo\iItem 
          CurSubItem = pInfo\iSubItem 
          Text$ = GetGadgetItemText(1, CurItem, CurSubItem) 
          If CurSubItem=0 
            rc\right = rc\left+SendMessage_(hwnd, #LVM_GETCOLUMNWIDTH, 0, 0) 
          EndIf 
          hEdit = StringGadget(2, rc\left+1, rc\top, rc\right-rc\left-1, rc\bottom-rc\top-1, Text$, #PB_String_BorderLess) 
          If CurSubItem=0 
            SendMessage_(hEdit, #WM_SETFONT, FontBold, #True) 
          Else 
            SendMessage_(hEdit, #WM_SETFONT, FontReg, #True) 
          EndIf 
          OldEditProc = SetWindowLong_(hEdit, #GWL_WNDPROC, @EditProc()) 
          SetFocus_(hEdit) 
        EndIf 
      Else 
        result = CallWindowProc_(OldLViewProc, hwnd, uMsg, wParam, lParam) 
      EndIf 
    Case #WM_LBUTTONDOWN 
      If hwnd<>hEdit 
        KillFocus() 
        pInfo.LVHITTESTINFO 
        pInfo\pt\x = LoWord(lParam) 
        pInfo\pt\y = HiWord(lParam) 
        SendMessage_(hwnd, #LVM_SUBITEMHITTEST, 0, pInfo) 
        rc.RECT 
        rc\top = pInfo\iSubItem 
        rc\left = #LVIR_BOUNDS 
        SendMessage_(hwnd, #LVM_GETSUBITEMRECT, pInfo\iItem, rc) 
        rc\left+1 
        rc\bottom-1 
        If CellSelectOn 
          InvalidateRect_(hwnd, rct, #True) 
        EndIf 
        CellSelectOn = 1 
        CurSelItem = pInfo\iItem 
        CurSelSubItem = pInfo\iSubItem 
        If CurSelSubItem=0 
          rc\right = rc\left+SendMessage_(hwnd, #LVM_GETCOLUMNWIDTH, 0, 0) 
        EndIf 
        DrawRectangle(hwnd, rc) 
        CopyMemory(rc, rct, SizeOf(RECT)) 
      Else 
        SetFocus_(hEdit) 
        result = CallWindowProc_(OldLViewProc, hwnd, uMsg, wParam, lParam) 
      EndIf 
    Case #WM_CTLCOLOREDIT 
      If GetFocus_()=lParam 
        SetBkMode_(wParam, #TRANSPARENT) 
        If CurItem&1=0 
          TextBkColor = RGB(255, 255, 223) 
          If CurSubItem=3 
            TextColor = RGB(255, 0, 0) 
          EndIf 
        Else 
          TextBkColor = RGB(208, 208, 176) 
          If CurSubItem=3 
            TextColor = RGB(0, 0, 255) 
          EndIf 
        EndIf 
        SetTextColor_(wParam, TextColor) 
        result = CreateSolidBrush_(TextBkColor) 
      Else 
        result = CallWindowProc_(OldLViewProc, hwnd, uMsg, wParam, lParam) 
      EndIf 
    Case #WM_VSCROLL 
      result = CallWindowProc_(OldLViewProc, hwnd, uMsg, wParam, lParam) 
      rc.RECT 
      TopVisibleItem = SendMessage_(hwnd, #LVM_GETTOPINDEX, 0, 0) 
      If CellSelectOn 
        rc\top = CurSelSubItem 
        rc\left = #LVIR_BOUNDS 
        SendMessage_(hwnd, #LVM_GETSUBITEMRECT, CurSelItem, rc) 
        rct\top = rc\top 
        rct\bottom = rc\bottom-1 
        If TopVisibleItem<=CurSelItem 
          DrawRectangle(hwnd, rct) 
        EndIf 
      EndIf 
      If hEdit 
        If TopVisibleItem<=CurItem 
          ResizeGadget(2,#PB_Ignore, rc\top,#PB_Ignore,#PB_Ignore) 
          HideGadget(2, #False) 
          RedrawWindow_(hEdit, 0, 0, #RDW_INTERNALPAINT|#RDW_ERASE|#RDW_INVALIDATE) 
        Else 
          HideGadget(2, #True) 
        EndIf 
        SetFocus_(hEdit) 
      EndIf 
    Case #WM_HSCROLL 
      result = CallWindowProc_(OldLViewProc, hwnd, uMsg, wParam, lParam) 
      rc.RECT 
      TopVisibleItem = SendMessage_(hwnd, #LVM_GETTOPINDEX, 0, 0) 
      If CellSelectOn 
        rc\top = CurSelSubItem 
        rc\left = #LVIR_BOUNDS 
        SendMessage_(hwnd, #LVM_GETSUBITEMRECT, CurSelItem, rc) 
        rct\left = rc\left+1 
        rct\right = rc\right 
        If TopVisibleItem<=CurSelItem 
          DrawRectangle(hwnd, rct) 
        EndIf 
      EndIf 
      If hEdit 
        If TopVisibleItem<=CurItem 
          ResizeGadget(2, rc\left,#PB_Ignore,#PB_Ignore,#PB_Ignore) 
          HideGadget(2, #False) 
          RedrawWindow_(hEdit, 0, 0, #RDW_INTERNALPAINT|#RDW_ERASE|#RDW_INVALIDATE) 
        Else 
          HideGadget(2, #True) 
        EndIf 
        SetFocus_(hEdit) 
      EndIf 
    Default 
      result = CallWindowProc_(OldLViewProc, hwnd, uMsg, wParam, lParam) 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

Procedure WndProc(hwnd, uMsg, wParam, lParam) 
  result = #PB_ProcessPureBasicEvents 
  Select uMsg 
    Case #WM_NOTIFY 
      *pnmh.NMHDR = lParam 
      Select *pnmh\code 
        Case #NM_CUSTOMDRAW 
          *LVCDHeader.NMLVCUSTOMDRAW = lParam 
          If *LVCDHeader\nmcd\hdr\hWndFrom=ListGadget 
            Select *LVCDHeader\nmcd\dwDrawStage 
              Case #CDDS_PREPAINT 
                result = #CDRF_NOTIFYITEMDRAW 
              Case #CDDS_ITEMPREPAINT 
                result = #CDRF_NOTIFYSUBITEMDRAW 
              Case #CDDS_SUBITEMPREPAINT 
                Row = *LVCDHeader\nmcd\dwItemSpec 
                Col = *LVCDHeader\iSubItem 
                If Col=0 
                  SelectObject_(*LVCDHeader\nmcd\hDC, FontBold) 
                Else 
                  SelectObject_(*LVCDHeader\nmcd\hDC, FontReg) 
                EndIf 
                If Row&1=0 
                  *LVCDHeader\clrTextBk = RGB(255, 255, 223) 
                  If Col=3 
                    *LVCDHeader\clrText = RGB(255, 0, 0) 
                  Else 
                    *LVCDHeader\clrText = RGB(0, 0, 0) 
                  EndIf 
                Else 
                  *LVCDHeader\clrTextBk = RGB(208, 208, 176) 
                  If Col=3 
                    *LVCDHeader\clrText = RGB(0, 0, 255) 
                  Else 
                    *LVCDHeader\clrText = RGB(0, 0, 0) 
                  EndIf 
                EndIf 
                result = #CDRF_NEWFONT 
            EndSelect 
          EndIf 
      EndSelect 
  EndSelect 
  ProcedureReturn result 
EndProcedure 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --