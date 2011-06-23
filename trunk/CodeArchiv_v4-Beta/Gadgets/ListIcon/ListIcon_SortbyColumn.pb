; English forum:
; Author: Unknown (updated for PB 4.00 by netmaestro)
; Date: 31. December 2002
; OS: Windows
; Demo: No

Structure PB_ListIconItem 
  UserData.l 
EndStructure 

#LVM_SETEXTENDEDLISTVIEWSTYLE = #LVM_FIRST + 54 
#LVM_GETEXTENDEDLISTVIEWSTYLE = #LVM_FIRST + 55 
Global ListIconGadget.l, Buffer1.l, Buffer2.l, lvi.LV_ITEM, updown.l, lastcol.l 
Buffer1 = AllocateMemory(128) 
Buffer2 = AllocateMemory(128) 

Procedure CompareFunc(*item1.PB_ListIconItem, *item2.PB_ListIconItem, lParamSort) 
  result = 0 
  lvi\iSubItem = lParamSort 
  lvi\pszText = Buffer1 
  lvi\cchTextMax = 512 
  lvi\Mask = #LVIF_TEXT 
  SendMessage_(ListIconGadget, #LVM_GETITEMTEXT, *item1\UserData, @lvi) 
  lvi\pszText = Buffer2 
  SendMessage_(ListIconGadget, #LVM_GETITEMTEXT, *item2\UserData, @lvi) 
  Seeker1 = Buffer1 
  Seeker2 = Buffer2 
  done = 0 
  While done=0 
    char1 = Asc(UCase(Chr(PeekB(Seeker1)))) 
    char2 = Asc(UCase(Chr(PeekB(Seeker2)))) 
    result = (char1-char2)*updown 
    If result<>0 Or (Seeker1-Buffer1)>511 
      done = 1 
    EndIf 
    Seeker1+1 
    Seeker2+1 
  Wend 
  ProcedureReturn result 
EndProcedure 

Procedure UpdatelParam() 
  Protected i.l, lTmp.l, lRecs.l, lvi.LV_ITEM 
  lRecs = SendMessage_(ListIconGadget, #LVM_GETITEMCOUNT, 0, 0) 
  For i = 0 To lRecs - 1 
    SetGadgetItemData(GetDlgCtrlID_(ListIconGadget), i, i) 
  Next 
EndProcedure 


Procedure ColumnClickCallback(hwnd, uMsg, wParam, lParam) 
  result = #PB_ProcessPureBasicEvents 
  Select uMsg 
    Case #WM_NOTIFY 
      *msg.NMHDR = lParam 
      If *msg\hwndFrom = ListIconGadget And *msg\code = #LVN_COLUMNCLICK 
        *pnmv.NM_LISTVIEW = lParam 
        If lastcol<>*pnmv\iSubItem 
          updown = 1 
        EndIf 
        SendMessage_(ListIconGadget, #LVM_SORTITEMS, *pnmv\iSubItem, @CompareFunc()) 
        UpdatelParam() 
        UpdateWindow_(ListIconGadget) 
        lastcol = *pnmv\iSubItem 
        updown = -updown 
      EndIf 
    Case #WM_SIZE 
      If hwnd = WindowID(0) And IsIconic_(hwnd)=0 
        WindowWidth = lParam & $FFFF 
        WindowHeight = lParam>>16 
        ResizeGadget(0, 0, 0, WindowWidth, WindowHeight) 
        result = 1 
      EndIf 
  EndSelect 

  ProcedureReturn result 
EndProcedure 

If OpenWindow(0, 384, 288, 640, 480, "ListIconGadget sort example", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget) 
  LVWidth = WindowWidth(0) 
  LVCWidth = Int(LVWidth/4)-1 
  If CreateGadgetList(WindowID(0)) 
    ListIconGadget = ListIconGadget(0, 0, 0, LVWidth, WindowHeight(0), "Column 0", LVCWidth, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
    AddGadgetColumn(0, 1, "Column 1", LVCWidth) 
    AddGadgetColumn(0, 2, "Column 2", LVCWidth) 
    AddGadgetColumn(0, 3, "Column 3", LVCWidth) 
  EndIf 
  AddGadgetItem(0, 0, "Aaa 1"+Chr(10)+"Bcc 3"+Chr(10)+"Cdd 2"+Chr(10)+"Eee 3"+Chr(10), 0) 
  AddGadgetItem(0, 1, "Aab 2"+Chr(10)+"Bbc 2"+Chr(10)+"Ddd 3"+Chr(10)+"Dde 1"+Chr(10), 0) 
  AddGadgetItem(0, 2, "Abb 3"+Chr(10)+"Baa 1"+Chr(10)+"Ccd 1"+Chr(10)+"Dee 2"+Chr(10), 0) 
  updown = 1 
  lastcol = 0 
  UpdatelParam() 
  SetWindowCallback(@ColumnClickCallback()) 

  Repeat 
    EventID = WaitWindowEvent() 
  Until EventID = #PB_Event_CloseWindow 
EndIf 

FreeMemory(Buffer1) 
FreeMemory(Buffer2) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP