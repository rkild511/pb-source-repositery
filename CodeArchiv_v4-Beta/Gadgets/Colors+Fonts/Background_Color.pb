; German forum:
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 26. June 2002
; OS: Windows
; Demo: No


hWnd = OpenWindow(1,10,10,300,300,"TEST",#PB_Window_SystemMenu)
CreateGadgetList(hWnd)
listview = ListViewGadget(3,10,10,280,280)
For a = 1 To 10
  AddGadgetItem(3,-1,"COOOOOOL")
Next a
ColorBrush = CreateSolidBrush_(RGB($00,$00 ,$00))            ; BACKGROUND


;---
Procedure mycallback(hWnd, Message, wParam, lParam)
Shared ColorBrush
RetValue = #PB_ProcessPureBasicEvents
   Select Message
      Case #WM_CTLCOLORLISTBOX
       SetTextColor_(wParam,RGB($FF,$FF,$00))                ; FOREGROUND
       SetBkMode_(wParam, #TRANSPARENT)
       RetValue = ColorBrush
   EndSelect
ProcedureReturn RetValue
EndProcedure
SetWindowCallback(@mycallback())
;---

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow

;---
DeleteObject_(ColorBrush)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP