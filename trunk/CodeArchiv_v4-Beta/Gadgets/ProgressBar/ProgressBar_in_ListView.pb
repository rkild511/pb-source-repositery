; English forum:
; Author: Justin (updated for PB4.00 by blbltheworm)
; Date: 01. October 2002
; OS: Windows
; Demo: No


;Progress bar inside Listview using GDI

; Changes by Andre - 14th June 2003 - to make it work with PB3.70:
; - Commented the two structures (already declared in PB3.70)
; - Changed all "Step" to "Stp", as "Step" is a reserved PB keyword


#NM_CUSTOMDRAW=#NM_FIRST-12

#CDDS_ITEM=65536
#CDDS_PREPAINT=1
#CDDS_SUBITEM=131072
;CDDS_ITEMPREPAINT=#CDDS_ITEM|#CDDS_PREPAINT
#CDRF_DODEFAULT=0
#CDRF_NOTIFYITEMDRAW=32
#CDRF_NOTIFYSUBITEMDRAW=32
#CDRF_NEWFONT=2
#CDRF_SKIPDEFAULT=4

#LVM_GETSUBITEMRECT=#LVM_FIRST+56
#LVIR_BOUNDS=0

;subitem rect structure
rc.RECT

;progress brush
hred=CreateSolidBrush_(RGB(255,0,0))

Procedure listproc(hwnd,msg,wparam,lparam)
  Shared hl,stp,rc,hred,paint
  Retrn=#PB_ProcessPureBasicEvents
  Select msg
    
  Case #WM_NOTIFY
    *ptr.NMLVCUSTOMDRAW=lparam
    
    Select *ptr\nmcd\hdr\code
    Case #NM_CUSTOMDRAW
      
      Select *ptr\nmcd\dwDrawStage
      Case #CDDS_PREPAINT
        Retrn=#CDRF_NOTIFYITEMDRAW
        
      Case #CDDS_ITEM | #CDDS_PREPAINT ;CDDS_ITEMPREPAINT
        Retrn=#CDRF_NOTIFYSUBITEMDRAW
        
      Case #CDDS_SUBITEM | #CDDS_ITEM | #CDDS_PREPAINT ;CDDS_SUBITEM | CDDS_ITEMPREPAINT
        
        If *ptr\nmcd\dwItemSpec=0 ;item 0
          If *ptr\iSubItem=1 ;subitem 1
            If paint=#True
              ;update rect
              rc\right=(rc\right)+stp
              
              ;device context
              hdevice=*ptr\nmcd\hdc
              
              ;paint rect
              FillRect_(hdevice,@rc,hred)
              stp=0 ;10% each time
              paint=#False
              Retrn=#CDRF_SKIPDEFAULT
            Else
              Retrn=#CDRF_DODEFAULT
            EndIf
          EndIf
        EndIf
      EndSelect
      
    EndSelect
    
  EndSelect
  ProcedureReturn Retrn
EndProcedure


hwnd=OpenWindow(0,10,10,500,500,"Custom Draw List View",#PB_Window_SystemMenu)
CreateGadgetList(hwnd)

hl=ListIconGadget(1,10,10,400,400,"File",100,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect)
AddGadgetColumn(1,1,"Progress",100)
AddGadgetColumn(1,2,"Time",80)
AddGadgetItem(1,0,"file" + Chr(10) + "" + Chr(10) + "12")

ButtonGadget(2,20,450,50,20,"step it!")

SetWindowCallback(@listproc())

;get subitem rect
rc\top=1 ;subitem 1
rc\left=#LVIR_BOUNDS
SendMessage_(hl,#LVM_GETSUBITEMRECT,0,@rc) ;item 0

width=(rc\right)-(rc\left) ;subitem width (we already know it)

;reduce rect to 0 width
rc\right=(rc\right)-width

stp=0
Repeat
  eid=WaitWindowEvent()
  If eid=#PB_Event_Gadget
    Select EventGadget()
      
    Case 2 ;10% stp
      stp+10
      paint=#True
      SetGadgetItemText(1,0,"",1) ; activate the painting cycle
      
    EndSelect
  EndIf
Until eid=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger