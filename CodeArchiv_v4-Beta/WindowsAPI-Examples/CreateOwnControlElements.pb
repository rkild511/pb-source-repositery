; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1696&highlight=
; Author: Stefan Moebius (updated for PB4.00 by blbltheworm)
; Date: 15. July 2003
; OS: Windows
; Demo: No


; Example for creating own control elements in PureBasic
; Beispiel für das Erstellen eigener Steuerelemente in PureBasic

#BTN_SETTEXTCOLOR=#WM_USER 
#BTN_SETLIGHTCOLOR=#WM_USER+1 
#BTN_SETSHADOWCOLOR=#WM_USER+2 
#BTN_SETBKCOLOR=#WM_USER+3 
#BTN_SETBKIMAGE=#WM_USER+4 

Procedure Button_CB(hwnd,message.l,wParam.l,lParam.l) 
  Addr=GetWindowLong_(hwnd,#GWL_USERDATA) 
  Global Dim NewRect(4) 
  RE.Rect 
  Paint.PAINTSTRUCT 
  pt.POINT 
  GetWindowRect_(hwnd,RE) 
  WindowLy=RE\Bottom-RE\Top  
  WindowLx=RE\Right-RE\Left 
  OldCB=PeekL(Addr+20) 
  
  If message<>#WM_LBUTTONUP And message<>#WM_LBUTTONDBLCLK And message<>#WM_NCDESTROY And message<>#WM_DESTROY 
    Result=CallWindowProc_(OldCB,hwnd,message,wParam,lParam) 
  EndIf 
  If message=#WM_NCPAINT:message=#WM_PAINT:EndIf 
  If message=#WM_LBUTTONDBLCLK:message=#WM_LBUTTONDOWN:EndIf 
  
  Select message 
    
  Case #BTN_SETBKIMAGE 
    DeleteObject_(PeekL(Addr+12)) 
    PokeL(Addr+12,CreatePatternBrush_(lParam)) 
    SendMessage_(hwnd,#WM_PAINT,0,0) 
    
  Case #BTN_SETBKCOLOR 
    DeleteObject_(PeekL(Addr+12)) 
    PokeL(Addr+12,CreateSolidBrush_(lParam)) 
    SendMessage_(hwnd,#WM_PAINT,0,0) 
    
  Case #BTN_SETSHADOWCOLOR 
    DeleteObject_(PeekL(Addr+8)) 
    PokeL(Addr+8,CreatePen_(0,1,lParam)) 
    SendMessage_(hwnd,#WM_PAINT,0,0) 
    
  Case #BTN_SETLIGHTCOLOR 
    DeleteObject_(PeekL(Addr+4)) 
    PokeL(Addr+4,CreatePen_(0,1,lParam)) 
    SendMessage_(hwnd,#WM_PAINT,0,0) 
    
  Case #BTN_SETTEXTCOLOR 
    PokeL(Addr,lParam) 
    SendMessage_(hwnd,#WM_PAINT,0,0) 
    
  Case #WM_SETFONT 
    PokeL(Addr+16,wParam) 
    SendMessage_(hwnd,#WM_PAINT,0,0) 
    
  Case #WM_LBUTTONDOWN 
    Ret=1 
    NewRect(0)=0:NewRect(1)=0:NewRect(2)=0:NewRect(3)=0 
    Text$=Space(GetWindowTextLength_(hwnd)+1)+Chr(0) 
    GetWindowText_(hwnd,Text$,GetWindowTextLength_(hwnd)+1) 
    ;----------------------------------------------------------- 
    hdc=GetDC_(hwnd) 
    TextCol=PeekL(Addr) 
    PenH=PeekL(Addr+4) 
    PenD=PeekL(Addr+8) 
    BkBrush=PeekL(Addr+12) 
    Font=PeekL(Addr+16) 
    oldBrush=SelectObject_(hdc,BkBrush) 
    Rectangle_(hdc,0,0,WindowLx+1,WindowLy+1) 
    SelectObject_(hdc,PenD) 
    MoveToEx_(hdc,0,WindowLy,0) 
    LineTo_(hdc,0,0) 
    LineTo_(hdc,WindowLx,0) 
    SelectObject_(hdc,PenH) 
    LineTo_(hdc,WindowLx,WindowLy) 
    LineTo_(hdc,0,WindowLy) 
    ;--------------------------- Text ------------------------------ 
    For M=1 To Len(Text$):If Mid(Text$,M,1)=Chr(13):Ret=Ret+1:EndIf:Next 
    OldFont=SelectObject_(hdc,Font) 
    Txtheight=DrawText_(hdc,Text$,Len(Text$),@NewRect(0),0)*Ret 
    NewRect(0)=1 
    NewRect(1)=WindowLy/2-Txtheight/2+1 
    NewRect(2)=WindowLx+1 
    NewRect(3)=WindowLy 
    OldTextCol=SetTextColor_(hdc,TextCol) 
    OldMode=SetBkMode_(hdc,1) 
    DrawText_(hdc,Text$,Len(Text$),@NewRect(0),#DT_CENTER|#DT_VCENTER) 
    ;----------------------------------------------------------------- 
    
    SelectObject_(hdc,oldPen) 
    SelectObject_(hdc,oldBrush) 
    SetBkMode_(hdc,OldMode) 
    SetTextColor_(hdc,OldTextCol) 
    SelectObject_(hdc,OldFont) 
    ReleaseDC_(hwnd,hdc) 
    Result=CallWindowProc_(OldCB,hwnd,message,wParam,lParam) 
    
    
  Case #WM_LBUTTONUP 
    ;MouseY=lParam>>16 
    ;MouseX=(lParam<<16)>>16 
    SendMessage_(hwnd,#WM_PAINT,0,0) 
    Result=CallWindowProc_(OldCB,hwnd,#WM_LBUTTONUP,wParam,lParam) 
    
    
  Case #WM_PAINT 
    ;-------------------------------------------------------------- 
    Ret=1 
    NewRect(0)=0:NewRect(1)=0:NewRect(2)=0:NewRect(3)=0 
    Text$=Space(GetWindowTextLength_(hwnd)+1)+Chr(0) 
    GetWindowText_(hwnd,Text$,GetWindowTextLength_(hwnd)+1) 
    ;-------------------------------------------------------------- 
    hdc=GetDC_(hwnd);BeginPaint_(hWnd,@Paint) 
    TextCol=PeekL(Addr) 
    PenH=PeekL(Addr+4) 
    PenD=PeekL(Addr+8) 
    BkBrush=PeekL(Addr+12) 
    Font=PeekL(Addr+16) 
    oldBrush=SelectObject_(hdc,BkBrush) 
    Rectangle_(hdc,0,0,WindowLx+1,WindowLy+1) 
    SelectObject_(hdc,PenH) 
    MoveToEx_(hdc,0,WindowLy,0) 
    LineTo_(hdc,0,0) 
    LineTo_(hdc,WindowLx,0) 
    SelectObject_(hdc,PenD) 
    LineTo_(hdc,WindowLx,WindowLy) 
    LineTo_(hdc,0,WindowLy) 
    
    ;--------------------------- Text ----------------------------- 
    For M=1 To Len(Text$):If Mid(Text$,M,1)=Chr(13):Ret=Ret+1:EndIf:Next 
    OldFont=SelectObject_(hdc,Font) 
    Txtheight=DrawText_(hdc,Text$,Len(Text$),@NewRect(0),0)*Ret 
    NewRect(0)=0 
    NewRect(1)=WindowLy/2-Txtheight/2 
    NewRect(2)=WindowLx 
    NewRect(3)=WindowLy 
    OldTextCol=SetTextColor_(hdc,TextCol) 
    OldMode=SetBkMode_(hdc,1) 
    DrawText_(hdc,Text$,Len(Text$),@NewRect(0),#DT_CENTER|#DT_VCENTER) 
    ;------------------------------------------------------------------------- 
    SelectObject_(hdc,oldPen) 
    SelectObject_(hdc,oldBrush) 
    SetBkMode_(hdc,OldMode) 
    SetTextColor_(hdc,OldTextCol) 
    SelectObject_(hdc,OldFont) 
    ReleaseDC_(hwnd,hdc) 
    ;EndPaint_(hWnd,@Paint) 
    Result=0 
    
  Case #WM_DESTROY 
    If Addr<>0 
      DeleteObject_(PeekL(Addr+4));Pen 
      DeleteObject_(PeekL(Addr+8));Pen 
      DeleteObject_(PeekL(Addr+12));Brush 
      GlobalFree_(Addr) 
    EndIf 
    Result=CallWindowProc_(OldCB,hwnd,message,wParam,lParam) 
  Default 
    Result = DefWindowProc_(hwnd,message,wParam,lParam) 
EndSelect 
ProcedureReturn Result 
EndProcedure 


Procedure OwnButtonGadget(hMenu,x,y,lx,ly,Text$) 
  Handle=ButtonGadget(hMenu,x,y,lx,ly,Text$,#WS_CHILD|#WS_VISIBLE|#BS_OWNERDRAW) 
  ;Handle=CreateWindowEx_(0,"button",Text$,#WS_CHILD|#WS_VISIBLE|#BS_OWNERDRAW,x,y,lx,ly,Win,hMenu,0,0) 
  OldCB=SetWindowLong_(Handle,#GWL_WNDPROC,@Button_CB()) 
  Addr=GlobalAlloc_(#GMEM_FIXED,24) 
  PokeL(Addr,0)   ; Farbe 
  PokeL(Addr+4,CreatePen_(0,1,GetSysColor_(#COLOR_3DHILIGHT))) 
  PokeL(Addr+8,CreatePen_(0,1,GetSysColor_(#COLOR_3DSHADOW))) 
  PokeL(Addr+12,CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE))) 
  PokeL(Addr+16,GetStockObject_(#ANSI_VAR_FONT)) 
  PokeL(Addr+20,OldCB) 
  SetWindowLong_(Handle,#GWL_USERDATA,Addr) 
  ShowWindow_(Handle,#SW_NORMAL) 
  ProcedureReturn Handle 
EndProcedure 








;Beispiel: 

OpenWindow(1,0,0,200,150,"Eigene Steuerelemente",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(1)) 
Font=LoadFont(1,"Arial",15) 


Gadget1=OwnButtonGadget(1, 5, 5, 76, 22,"&Button 1") 
Gadget2=OwnButtonGadget(2, 5,35, 76, 22,"&Button 2") 
Gadget3=OwnButtonGadget(3, 5,65, 76, 22,"&Button 3") 
Gadget4=OwnButtonGadget(4, 5,95, 76, 22,"&Button 4") 
OwnButtonGadget(5,85,10,100,100,"&Button 5"+Chr(13)+"&Button 5"+Chr(13)+"&Button 5") 


SendMessage_(Gadget1,#BTN_SETTEXTCOLOR,0,RGB(0,255,0)) 
SendMessage_(Gadget1,#BTN_SETBKCOLOR,0,RGB(0,128,255)) 
SendMessage_(Gadget1,#BTN_SETSHADOWCOLOR,0,RGB(0,0,0)) 
SendMessage_(Gadget1,#BTN_SETLIGHTCOLOR,0,RGB(255,255,255)) 

SendMessage_(Gadget2,#WM_SETFONT,Font,0) 

SendMessage_(Gadget3,#BTN_SETBKCOLOR,0,RGB(220,220,220)) 
SendMessage_(Gadget3,#BTN_SETSHADOWCOLOR,0,RGB(128,128,128)) 
SendMessage_(Gadget3,#BTN_SETLIGHTCOLOR,0,RGB(255,255,255)) 

SendMessage_(Gadget4,#BTN_SETTEXTCOLOR,0,RGB(0,96,0)) 
SendMessage_(Gadget4,#BTN_SETSHADOWCOLOR,0,RGB(0,96,0)) 
SendMessage_(Gadget4,#BTN_SETLIGHTCOLOR,0,RGB(164,255,164)) 
SendMessage_(Gadget4,#BTN_SETBKCOLOR,0,RGB(0,191,0)) 


Repeat 
  Erg=WaitWindowEvent() 
  If Erg=#PB_Event_Gadget:MessageRequester("","Button "+Str(EventGadget()),0):EndIf 
Until Erg=#PB_Event_CloseWindow 
FreeFont(1) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
