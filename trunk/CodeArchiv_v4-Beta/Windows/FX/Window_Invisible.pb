; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=767&highlight=
; Author: Andreas
; Date: 26. April 2003
; OS: Windows
; Demo: No


; Quit with ALT + F4
; Beenden mit ALT + F4
Global Appname.s,hWnd.l,MainBrush.l,Maxx.l,Maxy.l 
MainBrush = GetStockObject_(#NULL_BRUSH) 
AppName = "MyClassWindow" 
Maxx = GetSystemMetrics_(#SM_CXSCREEN) 
Maxy = GetSystemMetrics_(#SM_CYSCREEN) 

Procedure WndProc(wnd,Message,wParam,lParam) 
Ret.l = DefWindowProc_(wnd, Message, wParam, lParam) 
Select Message 
; *********************** 
  Case #WM_CLOSE 
; *********************** 
  UnregisterClass_(AppName$,hInstance) 
  DeleteObject_(MainBrush) 
  PostQuitMessage_(0) 
EndSelect 
ProcedureReturn Ret 
EndProcedure 

wc.WNDCLASS 
wc\style          =  #CS_VREDRAW | #CS_HREDRAW 
wc\lpfnWndProc    =  @WndProc() 
wc\cbClsExtra     =  0 
wc\cbWndExtra     =  0 
wc\hInstance      =  GetModuleHandle_(0) 
wc\hIcon          =  LoadIcon_(hInstance, "#1") 
wc\hCursor        =  LoadCursor_(0, #IDC_ARROW) 
wc\hbrBackground  =  MainBrush 
wc\lpszMenuName   =  0 
wc\lpszClassName  =  @AppName 
RegisterClass_(wc) 


hWnd = CreateWindowEx_(0,Appname,"",#WS_POPUP|#WS_VISIBLE,0,0,Maxx,Maxy,0,0,GetModuleHandle_(0),0) 
Text$ = "Das ist ein unsichtbares Fenster, das sich über den gesamten Bildschrim erstreckt " 
TextOut_(GetDC_(hWnd),0,0,Text$,Len(Text$)) 
If hWnd 
While GetMessage_(m.MSG, 0, 0, 0) 
  TranslateMessage_(m) 
  DispatchMessage_(m) 
Wend 
EndIf 
End  
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
