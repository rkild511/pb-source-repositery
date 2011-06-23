; German forum: http://www.purebasic.fr/german/viewtopic.php?t=497&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 19. October 2004
; OS: Windows
; Demo: No

Procedure callback(hWnd,Msg,wParam,lParam)

  ; mouse handling
  Static mousedown
  If Msg=#WM_LBUTTONDOWN
    mousedown = 1
    Debug "Gedrckt"
    ProcedureReturn 0
  ElseIf Msg=#WM_LBUTTONDBLCLK
    mousedown = 1
    Debug "Gedrckt"
    ProcedureReturn 0
  ElseIf Msg=#WM_LBUTTONUP
    mousedown = 0
    Debug "Losgelassen"
    ReleaseCapture_()
    ProcedureReturn 0
  ElseIf Msg=#WM_MOUSEMOVE
    If mousedown = 1
      SetCapture_(hWnd)
    EndIf
    ProcedureReturn 0
  EndIf

  ; scroll handling
  If Msg = #WM_VSCROLL
    info.SCROLLINFO
    info\cbSize = SizeOf(SCROLLINFO)
    info\fMask  = #SIF_ALL
    GetScrollInfo_(hWnd,#SB_VERT,@info)
    pos = SetScrollPos_(hWnd,#SB_VERT,info\nTrackPos,1)
    Debug "vertikal scroll"
    ProcedureReturn 0
  ElseIf Msg = #WM_HSCROLL
    info.SCROLLINFO
    info\cbSize = SizeOf(SCROLLINFO)
    info\fMask  = #SIF_ALL
    GetScrollInfo_(hWnd,#SB_HORZ,@info)
    pos = SetScrollPos_(hWnd,#SB_HORZ,info\nTrackPos,1)
    Debug "horizontal scroll"
    ProcedureReturn 0
  EndIf

  ; default processing
  ProcedureReturn DefWindowProc_(hWnd,Msg,wParam,lParam)
EndProcedure

Procedure ClickGadget(parent,x,y,w,h,brush,style)
  Static count
  count+1
  ClassName$ = "ClickGadget_"+StrU(count,#Long)
  wc.WNDCLASSEX
  wc\cbSize          = SizeOf(WNDCLASSEX)
  wc\style           = #CS_DBLCLKS
  wc\lpfnWndProc     = @callback()
  wc\hInstance       = 0
  wc\hCursor         = LoadCursor_(0,#IDC_ARROW)
  wc\hbrBackground   = brush
  wc\lpszClassName   = @ClassName$
  If RegisterClassEx_(@wc)
    ProcedureReturn CreateWindowEx_(0,ClassName$,"",style|#WS_CHILD|#WS_VISIBLE,x,y,w,h,parent,0,0,0)
  EndIf
EndProcedure

If OpenWindow(0,200,100,600,600,"Mein Titel",#PB_Window_SystemMenu)
  hbrush1=CreateSolidBrush_(RGB(0,255,0))
  hbrush2=CreateSolidBrush_(RGB(255,0,0))
  SetClassLong_(WindowID(0), #GCL_HBRBACKGROUND,hbrush1)

  click = ClickGadget(WindowID(0),50,50,500,500,hbrush2,#WS_VSCROLL|#WS_HSCROLL)

  ;  horz=0
  ;  vert=0
  ;  horzscroll.SCROLLINFO
  ;  vertscroll.SCROLLINFO
  ;  horzscroll\fMask=#SIF_ALL
  ;  vertscroll\fMask=#SIF_ALL
  ;  vertscroll\nPage=5
  ;  horzscroll\nPage=5
  ;  horzscroll\nMax=200
  ;  vertscroll\nMax=200
  ;
  ;  SetScrollInfo_(click,#SB_HORZ,horzscroll,#True)
  ;  SetScrollInfo_(click,#SB_VERT,vertscroll,#True)
  ;  SetScrollPos_(click,#SB_VERT,vert,#True)
  ;  SetScrollPos_(click,#SB_HORZ,horz,#True)

  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
    EndSelect
  ForEver

  CloseWindow(0)

  DeleteObject_(hbrush1)
  DeleteObject_(hbrush2)

EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -