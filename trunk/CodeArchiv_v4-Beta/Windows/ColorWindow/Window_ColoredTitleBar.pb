; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2152&highlight=
; Author: Stefan Moebius (updated for PB4.00 by blbltheworm)
; Date: 31. August 2003
; OS: Windows
; Demo: No


; Open windows with colored title bar...

; Mit der Prozedur OpenColoredWindow() lassen sich Fenster mit verschiedenfarbigen Titelzeilen erstellen. 
;  OpenColoredWindow() unterstützt nur folgende flags: 
;  #PB_Window_SizeGadget 
;  #PB_Window_ScreenCentered 
;  #PB_Window_WindowCentered 
;  #PB_Window_Invisible 
;  #PB_Window_TitleBar 

Procedure Window_CB(hWnd,Msg,wParam,lParam) 
  Addr=GetWindowLong_(hWnd,#GWL_USERDATA) 
  
  If GetWindowLong_(hWnd,#GWL_USERDATA)<>0 
    Result=CallWindowProc_(PeekL(Addr),hWnd,Msg,wParam,lParam) 
  Else 
    Result=DefWindowProc_(hWnd,Msg,wParam,lParam) 
  EndIf 
  
  
  If Msg=#WM_SETTEXT Or Msg=#WM_NCPAINT Or Msg=#WM_SIZE Or Msg=#WM_MOVE Or Msg=#WM_SHOWWINDOW Or Msg=#WM_PAINT Or Msg=#WM_DISPLAYCHANGE Or Msg=#WM_ACTIVATE 
    
    RE.RECT 
    GetWindowRect_(hWnd,RE) 
    WindowLx=RE\Right-RE\Left 
    WindowLy=RE\Bottom-RE\Top 
    
    RGB1=PeekL(Addr+4) 
    RGB2=PeekL(Addr+8) 
    TextColor=PeekL(Addr+12) 
    Font=PeekL(Addr+16) 
    
    DC=GetWindowDC_(hWnd) 
    
    CapW=(WindowLx-GetSystemMetrics_(#SM_CXFIXEDFRAME)*2) 
    
    Y=GetSystemMetrics_(#SM_CYCAPTION)-1 
    If Y=Y And #WS_SIZEBOX:Y=Y+1:EndIf 
    
    For X=0 To WindowLx-(GetSystemMetrics_(#SM_CXFIXEDFRAME)*2)    
      R1=Red(RGB1) 
      G1=Green(RGB1) 
      B1=Blue(RGB1) 
      R2=Red(RGB2) 
      G2=Green(RGB2) 
      B2=Blue(RGB2) 
      M=(CapW-X) 
      
      Pen=CreatePen_(#PS_SOLID,1,RGB((R1*M+R2*X)/CapW,(G1*M+G2*X)/CapW,(B1*M+B2*X)/CapW)) 
      SelectObject_(DC,Pen) 
      MoveToEx_(DC,X+GetSystemMetrics_(#SM_CXFIXEDFRAME),GetSystemMetrics_(#SM_CYFIXEDFRAME),0) 
      LineTo_(DC,X+GetSystemMetrics_(#SM_CXFIXEDFRAME),GetSystemMetrics_(#SM_CYFIXEDFRAME)+Y) 
      DeleteObject_(Pen) 
    Next 
    
    Global Dim Rect(3) 
    SelectObject_(DC,Font)    
    Text$=Space(GetWindowTextLength_(hWnd)+1)+Chr(0) 
    GetWindowText_(hWnd,Text$,GetWindowTextLength_(hWnd)+1) 
    
    Txtheight=DrawText_(DC,Text$,Len(Text$),@Rect(0),0) 
    Rect(0)=GetSystemMetrics_(#SM_CXFIXEDFRAME) 
    Rect(1)=(GetSystemMetrics_(#SM_CYCAPTION)+GetSystemMetrics_(#SM_CYFIXEDFRAME))/2-Txtheight/2 
    Rect(2)=WindowLx-GetSystemMetrics_(#SM_CXFIXEDFRAME) 
    Rect(3)=GetSystemMetrics_(#SM_CYCAPTION)+GetSystemMetrics_(#SM_CYFIXEDFRAME) 
    
    SetTextColor_(DC,TextColor) 
    SetBkMode_(DC,1) 
    DrawText_(DC,Text$,Len(Text$),@Rect(0),#DT_CENTER|#DT_VCENTER) 
    ReleaseDC_(hWnd,DC) 
  EndIf 
  
  If Msg=#WM_DESTROY 
    GlobalFree_(Addr) 
    SetWindowLong_(hWnd,#GWL_USERDATA,0) 
  EndIf 
  
  ProcedureReturn Result 
EndProcedure 



Procedure OpenColoredWindow(Nr,X,Y,w,h,style,title$,Color1,Color2,TextColor,Font) 
  If Font=0:Font=GetStockObject_(#ANSI_VAR_FONT):EndIf 
  hWnd=OpenWindow(Nr,X,Y,w,h,title$,style) 
  Addr=GlobalAlloc_(#GMEM_FIXED,20) 
  OldCB=SetWindowLong_(hWnd,#GWL_WNDPROC,@Window_CB()) 
  PokeL(Addr,OldCB) 
  PokeL(Addr+4,Color1) 
  PokeL(Addr+8,Color2) 
  PokeL(Addr+12,TextColor) 
  PokeL(Addr+16,Font) 
  SetWindowLong_(hWnd,#GWL_USERDATA,Addr) 
  ProcedureReturn hWnd 
EndProcedure 










;-Beispiel: 

Font=LoadFont(1,"Arial",12,#PB_Font_Bold) 
;OpenColoredWindow(Nr,x,y,w,h,style,title$,Color1,Color2,TextColor,Font) 
OpenColoredWindow(1,0,0,400,300,#PB_Window_SizeGadget|#PB_Window_ScreenCentered,"OpenColoredWindow(1)",RGB(0,255,255),RGB(255,255,0),0,Font) 



OpenColoredWindow(2,0,0,300,200,#PB_Window_TitleBar,"OpenColoredWindow(2)",RGB(0,  0,255),RGB(255,255,0),RGB(0,255,0),0) 
OpenColoredWindow(3,0,0,200,100,#PB_Window_TitleBar,"OpenColoredWindow(3)",RGB(0,255,  0),RGB(255,  0,0),$FFFFFF     ,0) 

SetParent_(WindowID(2),WindowID(1)) 
SetParent_(WindowID(3),WindowID(2)) 



CreateGadgetList(WindowID(3)) 

ButtonGadget(1,0,0,80,20,"Close") 

Repeat 
  Erg=WaitWindowEvent() 
Until Erg=#PB_Event_CloseWindow  Or Erg=#PB_Event_Gadget 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
