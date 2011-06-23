; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3096&highlight=
; Author: Danilo
; Date: 23. April 2005
; OS: Windows
; Demo: No

; 
; 
; by Danilo, 23.04.2005 - german forum 
; 
; 
#BS_LEFT         =    $00000100 
#BS_RIGHT        =    $00000200 
#BS_TOP          =    $00000400 
#BS_BOTTOM       =    $00000800 

#DI_NORMAL       =    $00000003 

#iconsize        =    16 


Structure IconButton 
  oldWndProc.l 
  icon.l 
EndStructure 


Procedure DrawIconOnButton(hWnd,*p.IconButton,clicked) 
  hDC = GetDC_(hWnd) 
  GetClientRect_(hWnd,rect.RECT) 
  style = GetWindowLong_(hWnd,#GWL_STYLE) 
  If style & #BS_LEFT 
    x = rect\right - 10 - #iconsize 
    y = rect\bottom/2 - #iconsize/2 
  ElseIf style & #BS_RIGHT 
    x = 10 
    y = rect\bottom/2 - #iconsize/2 
  ElseIf style & #BS_TOP 
    x = rect\right/2 - #iconsize/2 
    y = rect\bottom - 5 - #iconsize 
  ElseIf style & #BS_BOTTOM 
    x = rect\right/2 - #iconsize/2 
    y = 5 
  EndIf 
  If clicked 
    x+1 
    y+1 
  EndIf 
  If GetWindowLong_(hWnd,#GWL_STYLE) & #WS_DISABLED 
    DrawState_(hDC,GetStockObject_(#LTGRAY_BRUSH),0,*p\icon,0,x+1,y+1,#iconsize,#iconsize,#DST_ICON|#DSS_MONO) 
    DrawState_(hDC,GetStockObject_(#GRAY_BRUSH)  ,0,*p\icon,0,x  ,y  ,#iconsize,#iconsize,#DST_ICON|#DSS_MONO) 
  Else 
    DrawIconEx_(hDC,x,y,*p\icon,#iconsize,#iconsize,1,0,#DI_NORMAL) 
  EndIf 
  ReleaseDC_(hWnd,hDC) 
EndProcedure 


Procedure IconButtonProc(hWnd,Msg,wParam,lParam) 
  *p.IconButton = GetWindowLong_(hWnd,#GWL_USERDATA) 
  If *p 
    If *p\oldWndProc 
      retval = CallWindowProc_(*p\oldWndProc,hWnd,Msg,wParam,lParam) 
      If Msg = #WM_PAINT And *p\icon 
        state = SendMessage_(hWnd,#BM_GETSTATE,0,0) 
        If state = #BST_CHECKED Or state=#BST_PUSHED 
          clicked=1 
        EndIf 
        DrawIconOnButton(hWnd,*p,clicked) 
      ElseIf Msg = #WM_LBUTTONDOWN Or Msg = #WM_LBUTTONDBLCLK 
        DrawIconOnButton(hWnd,*p,1) 
      ElseIf Msg = #WM_LBUTTONUP 
        DrawIconOnButton(hWnd,*p,0) 
      ElseIf Msg = #WM_MOUSEMOVE And wParam = #MK_LBUTTON 
        GetWindowRect_(hWnd,rect.RECT) 
        GetCursorPos_(pt.POINT) 
        If PtInRect_(@rect,pt\x,pt\y) 
          clicked = 1 
        EndIf 
        DrawIconOnButton(hWnd,*p,clicked) 
      EndIf 
      ProcedureReturn retval 
    EndIf 
  EndIf 
  ProcedureReturn DefWindowProc_(hWnd,Msg,wParam,lParam) 
EndProcedure 


Procedure IconButtonGadget(x,y,w,h,text$,icon,flags) 
  btn = ButtonGadget(#PB_Any,x,y,w,h,text$,flags) 
  If btn 
    *p.IconButton = AllocateMemory(SizeOf(IconButton)) 
    If *p 
      SetWindowLong_(GadgetID(btn),#GWL_USERDATA,*p) 
      *p\icon       = icon 
      *p\oldWndProc = SetWindowLong_(GadgetID(btn),#GWL_WNDPROC,@IconButtonProc()) 
    Else 
      FreeGadget(btn) 
      btn=0 
    EndIf 
  EndIf 
  ProcedureReturn btn 
EndProcedure 


; 
; LOAD YOUR OWN 16x16 ICONs here!! 
; 
icon1 = LoadIcon_(0,#IDI_ASTERISK)    ; LoadImage(1,"16x16.ico") !! 
icon2 = LoadIcon_(0,#IDI_EXCLAMATION) ; LoadImage(2,"16x16.ico") !! 
icon3 = LoadIcon_(0,#IDI_HAND)        ; LoadImage(3,"16x16.ico") !! 
icon4 = LoadIcon_(0,#IDI_QUESTION)    ; LoadImage(4,"16x16.ico") !! 

OpenWindow(0,0,0,300,300,"IconButtonGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  btn1 = IconButtonGadget( 10,10,80,35,"Button 1",icon1,#BS_LEFT) 
  btn2 = IconButtonGadget(100,10,80,35,"Button 2 ",icon2,#BS_RIGHT) 
  btn3 = IconButtonGadget( 10,55,80,40,"Button 3" ,icon3,#BS_TOP) 
  btn4 = IconButtonGadget(100,55,80,40,"Button 4" ,icon4,#BS_BOTTOM) 

  DisableGadget(btn3,1) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      Break 
    Case #PB_Event_Gadget 
      MessageRequester("INFO",GetGadgetText(EventGadget())) 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -