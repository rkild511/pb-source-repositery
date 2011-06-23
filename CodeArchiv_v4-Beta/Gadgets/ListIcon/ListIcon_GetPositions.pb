; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6203&highlight=
; Author: El_Choni (updated for PB4.00 by blbltheworm)
; Date: 23. May 2003
; OS: Windows
; Demo: No

#ListIcon = 1 
#LVM_GETSUBITEMRECT = #LVM_FIRST+56 
                        
Procedure Callback(Window.l, Message.l, wParam.l, lParam.l) 
  result = #PB_ProcessPureBasicEvents 
  Select Message 
    Case #WM_NOTIFY        ; these events are send as notification messages 
      *pnmh.NMHDR = lParam  ; lParam points to a structure with more info 
      If *pnmh\hwndFrom = GadgetID(#ListIcon) ; see if it is the right gadget 
        Select *pnmh\code  ; code contains actual message 
          Case #LVN_COLUMNCLICK ; user clicked on the Header of a column 
            *pnmv.NMLISTVIEW = lParam ; another info structure 
            Column.l = *pnmv\iSubItem ; clicked column 
            MessageRequester("Column Header Click","Clicked on Column"+Str(Column),0) 
          Case #NM_CLICK  ; user clicked in the ListView 
            *lpnmitem.NMITEMACTIVATE = lParam 
            Row.l = *lpnmitem\iItem 
            Column.l = *lpnmitem\iSubItem 
            ; there is also 
            ; #NM_DBLCLK  - doublecklick 
            ; #NM_RCLICK  - right button 
            ; #NM_RDBLCLK - right doubleclick 
            ; they work the same as #NM_CLICK 
            rc.RECT 
            rc\top = Column 
            rc\left = #LVIR_BOUNDS 
            SendMessage_(*pnmh\hwndFrom, #LVM_GETSUBITEMRECT, Row, rc) 
            ; now rc holds coords relative to ListGadget topleft corner 
            MessageRequester("Listview Click","Row: "+Str(Row)+" Column: "+Str(Column)+Chr(10)+"Item left: "+Str(rc\left)+" Item top: "+Str(rc\top-1), 0) 
        EndSelect 
      EndIf 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

If OpenWindow(0,0,0,400,400, "Listicon test...",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(0)) 
    ListIconGadget(#ListIcon, 10, 10, 380, 380, "Column0",100,#PB_ListIcon_FullRowSelect) 
    ; Fullrowselect must be set, because otherwiese only the first 
    ; column will be clickable 
    AddGadgetColumn(#ListIcon, 1, "Column1", 100) 
    AddGadgetColumn(#ListIcon, 1, "Column2", 100) 
    AddGadgetItem(#ListIcon, 0, "Row0"+Chr(10)+"XXX"+Chr(10)+"XXX") 
    AddGadgetItem(#ListIcon, 1, "Row1"+Chr(10)+"XXX"+Chr(10)+"XXX") 
    AddGadgetItem(#ListIcon, 2, "Row2"+Chr(10)+"XXX"+Chr(10)+"XXX") 
    AddGadgetItem(#ListIcon, 3, "Row3"+Chr(10)+"XXX"+Chr(10)+"XXX") 
    SetWindowCallback(@Callback()) 
    Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow 
  EndIf 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
