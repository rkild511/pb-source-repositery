; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14457&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 20. March 2005
; OS: Windows
; Demo: Yes


; ListIcon - realtime detection of the state of a checkbox when an item 
; becomes checked or unchecked.

#LVN_ITEMCHANGED = #LVN_FIRST-1 
#MyWindow = 0 
#MyGadget = 1 
Procedure myWindowCallback(hWnd, msg, wParam, lParam) 
  result = #PB_ProcessPureBasicEvents 
  Select msg 
    Case #WM_NOTIFY 
      *pnmhdr.NMHDR = lParam 
      Select *pnmhdr\code 
        Case #LVN_ITEMCHANGED 
          *lvChange.NMLISTVIEW = lParam 
          Debug *lvChange\uNewState >>12 &$FFFF 
          ;--> Read the State image mask value ( 1 = un-checked   2 = checked 
          Select *lvChange\uNewState >>12 &$FFFF 
            Case 1 
              StatusBarText(0, 0, "Item " + Str(*lvChange\iItem) + " has been un-checked") 
            Case 2 
              StatusBarText(0, 0, "Item " + Str(*lvChange\iItem) + " has been checked") 
          EndSelect 
      EndSelect 
  EndSelect 
  ProcedureReturn result 
EndProcedure 
If OpenWindow(#MyWindow, 100, 100, 350, 140, "ListIcon Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(#MyWindow)) 
  CreateStatusBar(0, WindowID(#MyWindow)) 
  ListIconGadget(#MyGadget, 5, 5, 340, 110, "Name", 100, #PB_ListIcon_CheckBoxes | #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
  AddGadgetColumn(#MyGadget, 1, "Address", 250) 
  AddGadgetItem(#MyGadget, -1, "Harry Rannit" + Chr(10) + "12 Parliament Way, Battle Street, By the Bay") 
  AddGadgetItem(#MyGadget, -1, "Ginger Brokeit" + Chr(10) + "130 PureBasic Road, BigTown, CodeCity") 
  SetWindowCallback(@myWindowCallback()) 
  Repeat 
    event = WaitWindowEvent() 
  Until event = #PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -