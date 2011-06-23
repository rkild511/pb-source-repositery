; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No

; Updated for PB3.70+  09 June 2003 by Andre Beer

;- Set Listview Colors
ListViewTextColor = RGB(255,255,000)
ListViewBackColor = RGB(000,000,000)

;- Init for ListView Coloring
ListViewBackBrush = CreateSolidBrush_(ListViewBackColor)

;- Open Window with Gadget
hWnd = OpenWindow(0,100,100,400,400,"Colored ListView",#PB_Window_SystemMenu)
       CreateGadgetList(hWnd)
       ;- Font
       hFont = LoadFont(1,"Lucida Console",14)
       SetGadgetFont(#PB_Default,hFont)
       ;- ListView Gadget
       ListViewGadget(0,10,10,380,380)

;- add ListView entries
For a = 1 To 1000
    AddGadgetItem(0,-1,"ListView Line "+Str(a))
Next a

;- Window Callback
Procedure myWinCallback(Window, Message, wParam, lParam)
Shared ListViewTextColor, ListViewBackBrush  ; <<<--- TextColor and Backbrush SHARED or GLOBAL
Result = #PB_ProcessPureBasicEvents
   If Message = #WM_CTLCOLORLISTBOX
      SetBkMode_(wParam, #TRANSPARENT)
      SetTextColor_(wParam, ListViewTextColor)
      Result = ListViewBackBrush
   EndIf
ProcedureReturn Result
EndProcedure
SetWindowCallback(@myWinCallback())

;- Event loop
While WaitWindowEvent() <> #PB_Event_CloseWindow : Wend

;- Cleanup
DeleteObject_(ListViewBackBrush)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP