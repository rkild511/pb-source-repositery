; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3472&highlight=
; Author: Stefan Moebius (updated for PB 4.00 by Deeem2031)
; Date: 18. January 2004
; OS: Windows
; Demo: No

!extrn _PB_Screen_Width 
!extrn _PB_Screen_Height 
!extrn _PB_Screen_Windowed
!extrn _PB_DirectX_PrimaryBuffer 
!extrn _PB_DirectX_BackBuffer 
!extrn _PB_DDrawBase 


Procedure ScreenRequesterCB(hWnd,Msg,wParam,lParam) 
  Addr=GetWindowLong_(hWnd,#GWL_USERDATA) 
  If Addr 
    Result=CallWindowProc_(PeekL(Addr),hWnd,Msg,wParam,lParam) 
    
    If Msg=#WM_DESTROY 
      GlobalFree_(Addr) 
      SetWindowLong_(hWnd,#GWL_USERDATA,0) 
    EndIf 
    
    If Msg=#WM_PAINT Or Msg=#WM_MOVING Or Msg=#WM_MOVE Or Msg=#WM_ERASEBKGND 
      DC=GetDC_(ScreenID()) 
      BitBlt_(DC,0,0,PeekL(Addr+8),PeekL(Addr+12),PeekL(Addr+4),0,0,#SRCCOPY) 
      ReleaseDC_(ScreenID(),DC) 
    EndIf 
  Else 
    Result=DefWindowProc_(hWnd,Msg,wParam,lParam) 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

Procedure ScreenAlertBox(Title.s,Text.s,Buttons.s) 
  Global ScreenWidth,ScreenHeight,Windowed,DDrawBase.IDirectDraw7,BackDDS.IDirectDrawSurface7 
  
  !MOV Eax,[_PB_Screen_Windowed] 
  !MOV [v_Windowed],Eax 
  !MOV Eax,[_PB_Screen_Width] 
  !MOV [v_ScreenWidth],Eax 
  !MOV Eax,[_PB_Screen_Height] 
  !MOV [v_ScreenHeight],Eax 
  
  If Windowed=0 
    !MOV Eax,[_PB_DDrawBase] 
    !MOV [v_DDrawBase],Eax 
    !MOV Eax,[_PB_DirectX_BackBuffer] 
    !MOV [v_BackDDS],Eax 
    DDrawBase\GetGDISurface(@GDI_DDS.IDirectDrawSurface7) 
    If GDI_DDS=BackDDS 
      BackDDS\BltFast(0,0,GDI_DDS,0,0) 
      FlipBuffers() 
    EndIf    
  EndIf 
  ShowCursor_(-1) 
  DC=GetDC_(ScreenID()) 
  MemDC=CreateCompatibleDC_(DC) 
  hBmp=CreateCompatibleBitmap_(DC,ScreenWidth,ScreenHeight) 
  oldBmp=SelectObject_(MemDC,hBmp) 
  BitBlt_(MemDC,0,0,ScreenWidth,ScreenHeight,DC,0,0,#SRCCOPY) 
  ReleaseDC_(ScreenID(),DC) 
  
  If Font=0:Font=GetStockObject_(#SYSTEM_FONT):EndIf 
  Structure Button 
    Text.s 
    Width.l 
  EndStructure 
  Dim Button.Button(100) 
  Buttons+"|" 
  Text+Chr(13) 
  
  TmpDC=CreateCompatibleDC_(0) 
  SelectObject_(TmpDC,Font) 
  
  For M=1 To Len(Buttons) 
    If Mid(Buttons,M,1)="|" 
      GetTextExtentPoint32_(MemDC,@Str$,Len(Str$),sz.size) 
      Button(ButtonAnz)\Width=sz\cx+10 
      Button(ButtonAnz)\Text=Str$ 
      
      If sz\cy+5>ButtonHeight:ButtonHeight=sz\cy+5:EndIf 
      
      GesButtonWidth=GesButtonWidth+sz\cx+10 
      Str$="" 
      ButtonAnz+1 
    Else 
      Str$=Str$+Mid(Buttons,M,1) 
    EndIf 
  Next 
  
  For M=1 To Len(Text) 
    If Mid(Text,M,1)=Chr(13) 
      GetTextExtentPoint32_(MemDC,@Str$,Len(Str$),sz.size) 
      TextHeight+sz\cy 
      If sz\cx+10>TextWidth:TextWidth=sz\cx+10:EndIf 
      Str$="" 
    Else 
      Str$=Str$+Mid(Text,M,1) 
    EndIf 
  Next 
  DeleteDC_(TmpDC) 
  
  WindowWidth=GesButtonWidth+10 
  If WindowWidth<150:WindowWidth=150:EndIf 
  If WindowWidth<TextWidth:WindowWidth=TextWidth:EndIf 
  
  WindowHeight=TextHeight+ButtonHeight+10 
  
  Flags=#PB_Window_ScreenCentered|#PB_Window_TitleBar 
  CreateGadgetList(OpenWindow(1000,0,0,WindowWidth,WindowHeight,Title,Flags,ScreenID()))
  TextGadget(0,XAbs,YAbs,WindowWidth,TextHeight,Text,#PB_Text_Center) 
  ;SetGadgetFont(0,Font) 
  
  XAbs=(WindowWidth-GesButtonWidth)/2 
  YAbs=TextHeight 
  
  X=XAbs 
  For M=0 To ButtonAnz-1 
    ButtonGadget(M+2,X,YAbs,Button(M)\Width,ButtonHeight,Button(M)\Text) 
    ;SetGadgetFont(M+2,Font) 
    X+Button(M)\Width 
  Next 
  OldCB=SetWindowLong_(WindowID(1000),#GWL_WNDPROC,@ScreenRequesterCB()) 
  Addr=GlobalAlloc_(#GMEM_FIXED,16) 
  PokeL(Addr,OldCB) 
  PokeL(Addr+4,MemDC) 
  PokeL(Addr+8,ScreenWidth) 
  PokeL(Addr+12,ScreenHeight) 
  SetWindowLong_(WindowID(1000),#GWL_USERDATA,Addr) 
  
  Quit=0 
  Repeat 
    Event=WaitWindowEvent() 
    Gadget=EventGadget() 
    If Gadget>=2 And Gadget<ButtonAnz+2 And Event=#PB_Event_Gadget:Quit=1:EndIf 
  Until Quit=1 
  Result=Gadget-1 
  
  Repeat:Until WindowEvent()=0 
  ShowCursor_(0) 
  SetWindowPos_(ScreenID(),#HWND_TOPMOST,0,0,0,0,#SWP_NOSIZE|#SWP_NOMOVE) 
  CloseWindow(1000) 
  SetWindowPos_(ScreenID(),#HWND_NOTOPMOST,0,0,0,0,#SWP_NOSIZE|#SWP_NOMOVE) 
  
  DC=GetDC_(ScreenID()) 
  BitBlt_(DC,0,0,ScreenWidth,ScreenHeight,MemDC,0,0,#SRCCOPY) 
  ReleaseDC_(ScreenID(),DC) 
  SelectObject_(MemDC,oldBmp) 
  DeleteObject_(hBmp) 
  DeleteDC_(MemDC) 
  ProcedureReturn Result 
EndProcedure 





Procedure.s ScreenInputRequester(Title$,Text$,Eing$) 
  Global ScreenWidth,ScreenHeight,Windowed,DDrawBase.IDirectDraw7,BackDDS.IDirectDrawSurface7 
  
  !MOV Eax,[_PB_Screen_Windowed] 
  !MOV [v_Windowed],Eax 
  !MOV Eax,[_PB_Screen_Width] 
  !MOV [v_ScreenWidth],Eax 
  !MOV Eax,[_PB_Screen_Height] 
  !MOV [v_ScreenHeight],Eax 
  
  If Windowed=0 
    !MOV Eax,[_PB_DDrawBase] 
    !MOV [v_DDrawBase],Eax 
    !MOV Eax,[_PB_DirectX_BackBuffer] 
    !MOV [v_BackDDS],Eax 
    DDrawBase\GetGDISurface(@GDI_DDS.IDirectDrawSurface7)    
    If GDI_DDS=BackDDS 
      BackDDS\BltFast(0,0,GDI_DDS,0,0) 
      FlipBuffers() 
    EndIf    
  EndIf 
  ShowCursor_(-1) 
  DC=GetDC_(ScreenID()) 
  MemDC=CreateCompatibleDC_(DC) 
  hBmp=CreateCompatibleBitmap_(DC,ScreenWidth,ScreenHeight) 
  oldBmp=SelectObject_(MemDC,hBmp) 
  BitBlt_(MemDC,0,0,ScreenWidth,ScreenHeight,DC,0,0,#SRCCOPY) 
  ReleaseDC_(ScreenID(),DC) 
  
  Flags=#PB_Window_ScreenCentered|#PB_Window_TitleBar 
  OpenWindow(1000,0,0,320,90,Title$,Flags,ScreenID()) 
  OldCB=SetWindowLong_(WindowID(1000),#GWL_WNDPROC,@ScreenRequesterCB()) 
  Addr=GlobalAlloc_(#GMEM_FIXED,16) 
  PokeL(Addr,OldCB) 
  PokeL(Addr+4,MemDC) 
  PokeL(Addr+8,ScreenWidth) 
  PokeL(Addr+12,ScreenHeight) 
  
  SetWindowLong_(WindowID(1000),#GWL_USERDATA,Addr) 
  
  CreateGadgetList(WindowID(1000)) 
  TextGadget(1,0,0,320,60,Text$) 
  gadget=StringGadget(2,0,60,270,20,Eing$) 
  ButtonGadget(3,275,60,40,20,"&Ok",#PB_Button_Default) 
  
  SetFocus_(gadget) 
  SendMessage_(gadget,#EM_SETSEL,0,Len(Eing$)) 
  SetWindowPos_(WindowID(1000),#HWND_TOPMOST,0,0,0,0,#SWP_NOSIZE|#SWP_NOMOVE)  
  Quit=0 
  
  Repeat 
    Event=WaitWindowEvent() 
    
    If EventGadget()=3 And Event=#PB_Event_Gadget:Quit=1:EndIf 
  Until Quit=1 
  Result.s=GetGadgetText(2) 
  
  Repeat:Until WindowEvent()=0 
  ShowCursor_(0) 
  SetWindowPos_(ScreenID(),#HWND_TOPMOST,0,0,0,0,#SWP_NOSIZE|#SWP_NOMOVE) 
  CloseWindow(1000) 
  SetWindowPos_(ScreenID(),#HWND_NOTOPMOST,0,0,0,0,#SWP_NOSIZE|#SWP_NOMOVE) 
  
  DC=GetDC_(ScreenID()) 
  BitBlt_(DC,0,0,ScreenWidth,ScreenHeight,MemDC,0,0,#SRCCOPY) 
  ReleaseDC_(ScreenID(),DC) 
  SelectObject_(MemDC,oldBmp) 
  DeleteObject_(hBmp) 
  DeleteDC_(MemDC)  
  ProcedureReturn Result.s 
EndProcedure 








;Beispiel: 


InitKeyboard() 
InitSprite() 
InitMouse() 
OpenScreen(640,480,16,"ScreenRequester") 
;OpenWindow(1,0,0,640,480,1,"ScreenRequester") 
;OpenWindowedScreen(WindowID(),0,0,640,480,1,0,0) 

CreateSprite(1,640,480) 
StartDrawing(SpriteOutput(1)) 
Box(0,0,640,480,#Blue) 
Circle(320,240,200,#Green) 
StopDrawing() 

S=GetTickCount_() 
Repeat 
  
  DisplaySprite(1,0,0) 
  FlipBuffers() 
  
  If GetTickCount_()-S>2500 
      
    Text$="This is a text"+Chr(13) 
    Text$+"This is a text"+Chr(13) 
    Text$+"This is a text"+Chr(13) 
    Text$+"This is a text"+Chr(13) 
    
    ScreenInputRequester("ScreenInputRequester",Text$,"Text") 
    
     If ScreenAlertBox("ScreenAlertBox",Text$+"Quit ?","&Yes|&No")=1:Quit=1:EndIf 
        
    S=GetTickCount_() 
  EndIf 
  
Until Quit 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
