; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1033&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 16. May 2003
; OS: Windows
; Demo: No


Declare.l WndProc(Wnd, Message, wParam, lParam) 
Declare XHiWord(a.l) 
Declare XLoWord(a.l) 

Global Appname.s,hMenu.l 
Appname = "Meinfenster" 

wc.WNDCLASS 
wc\style          =  #CS_VREDRAW | #CS_HREDRAW 
wc\lpfnWndProc    =  @WndProc() 
wc\cbClsExtra     =  0 
wc\cbWndExtra     =  0 
wc\hInstance      =  hInstance 
wc\hIcon          =  LoadIcon_(hInstance, "#1") 
wc\hCursor        =  LoadCursor_(0, #IDC_ARROW) 
wc\hbrBackground  =  CreateSolidBrush_(GetSysColor_(15)) 
wc\lpszMenuName   =  0 
wc\lpszClassName  =  @Appname 
RegisterClass_(wc) 
hWnd = CreateWindowEx_(0,Appname,Caption$,#WS_OVERLAPPEDWINDOW,#CW_USEDEFAULT,0,#CW_USEDEFAULT,0,0,0,hInstance,0) 

UpdateWindow_(hWnd) 
ShowWindow_(hWnd,#SW_SHOWNORMAL) 
SetForegroundWindow_(hWnd) 

;der Einfachheit halber Menü mit PB 
hMenu = CreateMenu(0,hWnd) 
MenuTitle("File") 
MenuItem( 1, "Load") 
MenuItem( 2, "Save") 
MenuItem( 3, "Save As") 
MenuBar() 
MenuItem( 4, "Ende") 

CreateGadgetList(hWnd) 
ButtonGadget(100,10,10,80,24,"Drück mich") 


While GetMessage_(m.MSG, 0, 0, 0) 
  TranslateMessage_(m) 
  DispatchMessage_(m) 
Wend 

Procedure WndProc(Wnd,Message,wParam,lParam) 
  Returnval.l = DefWindowProc_(Wnd, Message, wParam, lParam) 
  Select Message 
  ; *************************************************************************** 
    Case #WM_COMMAND 
          Select XLoWord(wParam) 
          Case 1 
          MessageRequester("Meldung","Load gewählt",0) 
          Case 2 
          MessageRequester("Meldung","Save gewählt",0) 
          Case 3 
          MessageRequester("Meldung","Save as...gewählt",0) 
          Case 4 
          PostQuitMessage_(0) 
          Case 100 
          MessageRequester("Meldung","Button gedrückt",0) 
          EndSelect 
  ; *************************************************************************** 
  ; *************************************************************************** 
    Case #WM_CLOSE 
  ; *************************************************************************** 
    UnregisterClass_(Appname,hInstance) 
    PostQuitMessage_(0) 
  EndSelect 
  ProcedureReturn Returnval 
EndProcedure 

Procedure.l XHiWord(a.l) 
  ProcedureReturn Int(a / $10000) 
EndProcedure 

Procedure.l XLoWord(a.l) 
  ProcedureReturn Int(a - (Int(a/$10000)*$10000)) 
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
