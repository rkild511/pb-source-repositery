; English forum:
; Author: Justin (updated for PB4.00 by blbltheworm) 
; Date: 02. November 2002
; OS: Windows
; Demo: Yes

;window callback
Procedure wndproc(hwnd,msg,wParam,lParam)
  Shared hlv
  retrn=#PB_ProcessPureBasicEvents
  
  Select msg
    
    Case #WM_NOTIFY
      *pnmhdr.NMHDR=lParam
      If *pnmhdr\code=#LVN_COLUMNCLICK   ;column click
        *pnmlistview.NMLISTVIEW=lParam
        If *pnmlistview\hdr\hwndFrom=hlv ;comes from our listicon
          column=*pnmlistview\iSubItem
          MessageRequester("",Str(column),0)
        EndIf
      EndIf

  EndSelect
ProcedureReturn retrn
EndProcedure


hwnd=OpenWindow(0,100,100,300,150,"Column Click",#PB_Window_SystemMenu)
CreateGadgetList(hwnd)

hlv=ListIconGadget(1,10,10,250,100,"Column 0",80)

AddGadgetColumn(1,1,"Column 1",80)
AddGadgetColumn(1,2,"Column 2",80)

SetWindowCallback(@wndproc())

Repeat
Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm