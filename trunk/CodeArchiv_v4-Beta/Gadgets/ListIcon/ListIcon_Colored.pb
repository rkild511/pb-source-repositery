; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6085&highlight=
; Author: ebs (updated for PB4.00 by blbltheworm)
; Date: 07. May 2003
; OS: Windows
; Demo: Yes

; Emulating Windows Grid Control

#NM_CUSTOMDRAW = #NM_FIRST - 12 

#CDDS_ITEM = $10000 
#CDDS_PREPAINT = $1 
#CDDS_ITEMPREPAINT = #CDDS_ITEM | #CDDS_PREPAINT 
#CDRF_DODEFAULT = $0 
#CDRF_NOTIFYITEMDRAW = $20 

Global ListGadget.l 

; window callback routine to color listview rows 
Declare.l NotifyCallback(WindowID.l, Message.l, wParam.l, lParam.l) 

hWnd.l = OpenWindow(0, 0, 0, 356, 197, "Color List View Rows", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
CreateGadgetList(hWnd) 

; create list with seven columns 
ListGadget = ListIconGadget(1, 10, 10, 336, 177,"", 70, #PB_ListIcon_GridLines) 
AddGadgetColumn(1, 1, "Sun", 35) 
AddGadgetColumn(1, 2, "Mon", 35) 
AddGadgetColumn(1, 3, "Tue", 35) 
AddGadgetColumn(1, 4, "Wed", 35) 
AddGadgetColumn(1, 5, "Thu", 35) 
AddGadgetColumn(1, 6, " Fri", 35) 
AddGadgetColumn(1, 7, "Sat", 35) 

; add some rows 
AddGadgetItem(1, -1, "  9:00 am") 
AddGadgetItem(1, -1, "  9:30 am") 
AddGadgetItem(1, -1, "10:00 am") 
AddGadgetItem(1, -1, "10:30 am") 
AddGadgetItem(1, -1, "11:00 am") 
AddGadgetItem(1, -1, "11:30 am") 
AddGadgetItem(1, -1, "12:00 pm") 
AddGadgetItem(1, -1, "12:30 pm") 
AddGadgetItem(1, -1, "  1:00 pm") 
AddGadgetItem(1, -1, "  1:30 pm") 
AddGadgetItem(1, -1, "  2:00 pm") 
AddGadgetItem(1, -1, "  2:30 pm") 
AddGadgetItem(1, -1, "  3:00 pm") 
AddGadgetItem(1, -1, "  3:30 pm") 
AddGadgetItem(1, -1, "  4:00 pm") 
AddGadgetItem(1, -1, "  4:30 pm") 
AddGadgetItem(1, -1, "  5:00 pm") 

; set callback routine 
SetWindowCallback(@NotifyCallback()) 

Repeat 
Until WaitWindowEvent()=#PB_Event_CloseWindow 

End 

; window callback routine to color listview rows 
Procedure.l NotifyCallback(WindowID.l, Message.l, wParam.l, lParam.l) 
  ; process NOTIFY message only 
  If Message = #WM_NOTIFY 
    ; set stucture pointer 
    *LVCDHeader.NMLVCUSTOMDRAW = lParam 
    ; CUSTOMDRAW message from desired gadget? 
    If *LVCDHeader\nmcd\hdr\hWndFrom = ListGadget And *LVCDHeader\nmcd\hdr\code = #NM_CUSTOMDRAW 
      Select *LVCDHeader\nmcd\dwDrawStage 
        Case #CDDS_PREPAINT 
          ProcedureReturn #CDRF_NOTIFYITEMDRAW 
        Case #CDDS_ITEMPREPAINT 
          ; simple example - change text and background colors every other row 
          Row.l = *LVCDHeader\nmcd\dwItemSpec 
          If (Row/2) * 2 = Row 
            *LVCDHeader\clrText = RGB(255, 0, 0) 
            *LVCDHeader\clrTextBk = RGB(255, 255, 223) 
          Else 
            *LVCDHeader\clrText = RGB(0, 0, 255) 
            *LVCDHeader\clrTextBk = RGB(208, 208, 176) 
          EndIf 
          ProcedureReturn #CDRF_DODEFAULT 
      EndSelect 
    EndIf 
  Else 
    ProcedureReturn #PB_ProcessPureBasicEvents 
  EndIf 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
