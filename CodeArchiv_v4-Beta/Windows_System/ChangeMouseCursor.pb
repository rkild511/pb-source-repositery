; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 16. July 2003
; OS: Windows
; Demo: No

;
; Fenster mit Gadgets oeffnen
;
hWnd = OpenWindow(1,10,10,400,200,"",#PB_Window_SystemMenu)
CreateGadgetList(hWnd)
   Button1   = ButtonGadget(1,210,10,100,25,"WAIT")
   Button2   = ButtonGadget(2,210,40,100,25,"HELP")
   ListView  = ListViewGadget(3,10,10,200,150)
;
; Standard-Cursor in allen Fenster-Klassen auf 0 setzen
; Ohne dies kann es zum cursor-flickern kommen
;
SetClassLong_(hWnd,#GCL_HCURSOR,0)
SetClassLong_(Button1,#GCL_HCURSOR,0)
SetClassLong_(Button2,#GCL_HCURSOR,0)
SetClassLong_(ListView,#GCL_HCURSOR,0)
;
; Cursor laden
;
#IDC_HELP = 32651
cur0 = LoadCursor_(0, #IDC_CROSS)
cur1 = LoadCursor_(0, #IDC_WAIT)
cur2 = LoadCursor_(0, #IDC_HELP)
cur3 = LoadCursor_(0, #IDC_NO)
;
; Hauptschleife
;
Repeat
  Event = WaitWindowEvent()
  Gosub changecursor
  ;Select Event
  ;EndSelect
Until Event = #PB_Event_CloseWindow
;
; Ende
;
DestroyCursor_(cur0)
DestroyCursor_(cur1)
DestroyCursor_(cur2)
DestroyCursor_(cur3)
End
;
; SUB zum wechseln des MouseCursors
;
changecursor:
  GetCursorPos_(cursorpos.POINT)
  MapWindowPoints_(0, hWnd, cursorpos, 1)
    Select ChildWindowFromPoint_(hWnd, cursorpos\x, cursorpos\y)
      Case Button1   : SetCursor_(cur1)  ; Cursor ueber Button 1
      Case Button2   : SetCursor_(cur2)  ; Cursor ueber Button 2
      Case ListView  : SetCursor_(cur3)  ; Cursor ueber ListView
      Case hWnd      : SetCursor_(cur0)  ; Default, fuer das Hauptfenster
    EndSelect
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -