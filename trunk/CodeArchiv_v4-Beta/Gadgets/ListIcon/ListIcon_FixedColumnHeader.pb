; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2341&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 20. September 2003
; OS: Windows
; Demo: No


; Problem: Möglichkeit, die einzelnen Spalten des ListIcons "fest" zu machen? Also so, dass man
;          sie nicht mehr per Maus vergrößern/verkleinern kann (wenn der Header angeschaltet ist).
; Lösung:  Dafuer habe ich im Moment keine Message parat, bzw. ich habe ich keine gefunden was
;          aber nicht heissen soll dass es keine gibt. 
;          Mit einem SubClassing fuer das Listview geht es aber doch. Dazu musst Du eine
;          CallBack-Funktion fuer das Listview schreiben. Im CallBack wird dann die entsprechende
;          Meldung abgefangen. 


#LISTVIEW = 10 
#LVM_FIRST = $1000 
#LVM_GETHEADER = (#LVM_FIRST + 31) 

#HDN_FIRST = (-300) 
#HDN_BEGINTRACKW = (#HDN_FIRST-26) 

Global hwnd.l,OldProc.l,Header.l,HeaderID.l 

  Procedure HeaderCallBack(wnd,uMsg,wParam,lParam) 
    Select uMsg 
      Case #WM_NOTIFY 
        *hdr.NMHDR = lParam 
        If *hdr\code= #HDN_BEGINTRACKW And *hdr\idFrom = HeaderID 
          Result = #True 
        EndIf  
      Default 
        Result = CallWindowProc_(OldProc,wnd,uMsg,wParam,lParam) 
    EndSelect 
    ProcedureReturn Result 
  EndProcedure 
  
  
  hwnd = OpenWindow(0, 100, 100, 400, 400, "Test", #PB_Window_SystemMenu|#PB_Window_Invisible|#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    LII = ListIconGadget(#LISTVIEW, 0,30,400,310,"Wochentag",80,#PB_ListIcon_FullRowSelect) 
    SendMessage_(LII,#LVM_SETBKCOLOR,0,$D5FFFF) 
    SendMessage_(LII,#LVM_SETTEXTBKCOLOR,0,$D5FFFF) 
    SendMessage_(LII,#LVM_SETTEXTCOLOR,0,RGB(0,0,196)) 
    AddGadgetColumn(#LISTVIEW,1,"Tag.Monat",80) 
    AddGadgetColumn(#LISTVIEW,2,"Beschreibung",236) 
  EndIf 
  
  ShowWindow_(hwnd,#SW_SHOWNORMAL) 
  
  Header.l = SendMessage_(LII,#LVM_GETHEADER,0,0) 
  HeaderID = GetDlgCtrlID_(Header) 
  OldProc = SetWindowLong_(LII,#GWL_WNDPROC,@HeaderCallBack()) 
  
  Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow  ; If the user has pressed on the close button 
      Quit = 1 
    EndIf 
  Until Quit = 1 
  End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
