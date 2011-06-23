; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3180&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 27. April 2005
; OS: Windows
; Demo: No


; Auswahlbox mit der Maus selektieren
; ------------------------------------
; In der Prozedur 'DrawMouseSelector' brauchst Du nur die 
; letzten 4 Zeilen anpassen. Dort kannst Du dann auch einen 
; Rahmen schwarz/weiß hinmalen - halt was Du willst. 
; 
; 
; modified by Danilo, 27.04.2005 - german forum 
; 
;   original version: Window Selector.pb 
;   (by Danilo, 24.11.2003 - german forum) 
; 
Global gadget1, gadget2, gadget3, gadget4 


Procedure OnMouseSelection(hWnd,x,y,width,height) 
  Select hWnd 
    Case GadgetID(gadget1) : Gadget$ = "gadget 1" 
    Case GadgetID(gadget2) : Gadget$ = "gadget 2" 
    Case GadgetID(gadget3) : Gadget$ = "gadget 3" 
    Case GadgetID(gadget4) : Gadget$ = "gadget 4" 
    Default: Gadget$ = "unbekannt" 
  EndSelect 

  Debug "-----" 
  Debug "Selected:" 
  Debug "hWnd  : "+Gadget$ 
  Debug "X     : "+Str(x) 
  Debug "Y     : "+Str(y) 
  Debug "Width : "+Str(width) 
  Debug "Height: "+Str(height) 
EndProcedure 


Procedure DrawMouseSelector(hWnd) 
  Shared WindowProc_MouseSelectStartX, WindowProc_MouseSelectLastX 
  Shared WindowProc_MouseSelectStartY, WindowProc_MouseSelectLastY 
  Shared WindowProc_MouseSelectRect.RECT 

  If WindowProc_MouseSelectStartX > WindowProc_MouseSelectLastX 
    WindowProc_MouseSelectRect\left   = WindowProc_MouseSelectLastX 
    WindowProc_MouseSelectRect\right  = WindowProc_MouseSelectStartX 
  Else 
    WindowProc_MouseSelectRect\left   = WindowProc_MouseSelectStartX 
    WindowProc_MouseSelectRect\right  = WindowProc_MouseSelectLastX 
  EndIf 
  If WindowProc_MouseSelectStartY > WindowProc_MouseSelectLastY 
    WindowProc_MouseSelectRect\top    = WindowProc_MouseSelectLastY 
    WindowProc_MouseSelectRect\bottom = WindowProc_MouseSelectStartY 
  Else 
    WindowProc_MouseSelectRect\top    = WindowProc_MouseSelectStartY 
    WindowProc_MouseSelectRect\bottom = WindowProc_MouseSelectLastY 
  EndIf 

  hDC = GetDC_(hWnd) 
    InvertRect_(hDC,@WindowProc_MouseSelectRect) 
    ;DrawFocusRect_(hDC,@WindowProc_MouseSelectRect) 
  ReleaseDC_(hWnd,hDC) 
  ;UpdateWindow_(hWnd) ; Win9x fix? 
EndProcedure 


Procedure WindowProc(hWnd,Msg,wParam,lParam) 
  Shared WindowProc_MouseSelect 
  Shared WindowProc_MouseSelectStartX, WindowProc_MouseSelectLastX 
  Shared WindowProc_MouseSelectStartY, WindowProc_MouseSelectLastY 
  Shared WindowProc_MouseSelectRect.RECT 

  Select Msg 
    Case #WM_LBUTTONDOWN 
      WindowProc_MouseSelect  = 1 
      WindowProc_MouseSelectStartX = lParam&$FFFF 
      WindowProc_MouseSelectStartY = (lParam>>16)&$FFFF 
      GetClientRect_(hWnd,winrect.RECT) 
      MapWindowPoints_(hWnd,0,winrect,2) 
      ClipCursor_(winrect) 
      ProcedureReturn 0 
    Case #WM_LBUTTONUP 
      If WindowProc_MouseSelect > 1 
        DrawMouseSelector(hWnd) 
        If WindowProc_MouseSelectRect\left <> WindowProc_MouseSelectRect\right And WindowProc_MouseSelectRect\top <> WindowProc_MouseSelectRect\bottom 
          OnMouseSelection(hWnd,WindowProc_MouseSelectRect\left,WindowProc_MouseSelectRect\top,WindowProc_MouseSelectRect\right-WindowProc_MouseSelectRect\left,WindowProc_MouseSelectRect\bottom-WindowProc_MouseSelectRect\top) 
          SetCapture_(0) 
        EndIf 
      EndIf 
      ClipCursor_(0) 
      WindowProc_MouseSelect = 0 
      ProcedureReturn 0 
    Case #WM_MOUSEMOVE 
      If WindowProc_MouseSelect > 0 And wParam & #MK_LBUTTON 
        If WindowProc_MouseSelect > 1 
          DrawMouseSelector(hWnd) 
        Else 
          WindowProc_MouseSelect + 1 
        EndIf 
        WindowProc_MouseSelectLastX = lParam&$FFFF 
        WindowProc_MouseSelectLastY = (lParam>>16)&$FFFF 
        DrawMouseSelector(hWnd) 
        SetCapture_(hWnd) 
      EndIf 
      ProcedureReturn 0 
  EndSelect 
  old=GetWindowLong_(hWnd,#GWL_USERDATA) 
  If old 
    ProcedureReturn CallWindowProc_(old,hWnd,Msg,wParam,lParam) 
  Else 
    DefWindowProc_(hWnd,Msg,wParam,lParam) 
  EndIf 
EndProcedure 



Procedure SelectorImage(x,y,w,h,hImage) 
  img = ImageGadget(#PB_Any,x,y,w,h,hImage) 
  If img 
    old = SetWindowLong_(GadgetID(img),#GWL_WNDPROC,@WindowProc()) 
    SetWindowLong_(GadgetID(img),#GWL_USERDATA,old) 
  EndIf 
  ProcedureReturn img 
EndProcedure 

OpenWindow(0,0,0,630,630,"Mega Mouse Selector",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
  If CreateImage(1,300,300)=0 
    MessageRequester("ERROR","Cant create image"):End 
  EndIf 

  If StartDrawing(ImageOutput(1)) 
    For y = 0 To 299 Step 2 
      For x = 0 To 299 Step 2 
        Plot(x,y,Random($FFFFFF)) 
      Next x 
    Next y 
    StopDrawing() 
  EndIf 

  CreateGadgetList(WindowID(0)) 
  gadget1 = SelectorImage( 10, 10,300,300,ImageID(1)) 
  gadget2 = SelectorImage(320, 10,300,300,ImageID(1)) 
  gadget3 = SelectorImage( 10,320,300,300,ImageID(1)) 
  gadget4 = SelectorImage(320,320,300,300,ImageID(1)) 
HideWindow(0,0) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -