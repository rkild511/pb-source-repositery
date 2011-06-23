; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No

win.l
run.l
tc.l
temp.l
#WS_VISIBLE = $10000000
#WS_CILD = $40000000
#TCM_INSERTITEM = $1307
;#TCN_SELCHANGE = 32772
#TCM_GETCURSEL = 4875

Procedure.l CreateTabControl_W(hwnd.l, num.l, x.l, y.l, x1.l, y1)
  win = CreateWindowEx_(0, "systabcontrol32", "", #WS_VISIBLE|#WS_CHILD, x, y, x1, y1, hwnd, 2024 + num, 0, 0)
  ProcedureReturn win
EndProcedure


Procedure AddTab(wnd.l, index.l, text.s)
  Structure TCM_ITEM
    mask.l
    res1.l
    res2.l
    pszText.s
    cchTextMax.l
    ilmage.l
    IParam.l
  EndStructure
  
  Define.TCM_ITEM tie
  
  tie\mask = 1
  tie\res1 = 0
  tie\res2 = 0
  tie\pszText = text
  tie\cchTextMax = Len(text)
  tie\ilmage = -1
  IParam = 0
  
  SendMessage_(wnd, #TCM_INSERTITEM, index, tie)
EndProcedure

Procedure.l GetSelectedTab(wnd.l)
  temp.l
  temp = SendMessage_(wnd, #TCM_GETCURSEL, 0, 0)
  ProcedureReturn temp
EndProcedure

Procedure DeleteTabControl(wnd.l)
  DestroyWindow_(wnd)
EndProcedure


If OpenWindow(0, 100, 100, 600, 460, "Fenster", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget)
  hwnd = WindowID(0)
  If CreateGadgetList(WindowID(0))
    TextGadget(1, 5, 10, 70, 25, "")
  EndIf
  
  tc = CreateTabControl_W(hwnd, 1, 5, 50, 300, 200)
  AddTab(tc, 0, "First Tab")
  AddTab(tc, 1, "Tab 2")
  AddTab(tc, 2, "Tab 3")
  ; hier müsste dann noch irgendwie für jeden Tab Stringgadgets, Buttongadgets, Optiongadgets usw. hinein
  
  Repeat
    EventID.l = WaitWindowEvent()
    Select EventID
    Case #PB_Event_CloseWindow
      DeleteTabControl(tc)
      Quit = 1
      
    Case #TCN_SELCHANGE
      ; geht noch nicht (welche Funktion gibt mir #TCN_SELCHANGE zurück ?)
      temp = GetSelectedTab(tc)
      SetGadgetText(1, "Tab#" + Str(temp) + " was selected.")
    EndSelect
    
  Until Quit = 1
  
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger