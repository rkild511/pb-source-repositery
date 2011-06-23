; German forum:
; Author: Andreas Miethe
; Date: 04. December 2002
; OS: Windows
; Demo: No

;******************************************************************* 
;Einfacher Bildschirmschoner, der aber alles enthaellt was ein 
;Schoner so braucht. Vorschau, Passwort-Abfrage, Passwort-Aenderung 
;usw. 
;Ist als Grundgeruest gedacht ! 
;Nach dem Compilieren die EXE in SCR umbenennen ! 
;Andreas Miethe * Dezember 2002 
;******************************************************************* 

Declare setBlack(wnd) 
Declare SetPassword() 
Declare ConfigSaver() 
Declare.l VerifyPassword(wnd) 
Declare.l CloseSaver(wnd) 
Declare ExecuteSaver(wnd) 
Declare.l PreviewCallback(Wnd, Message, wParam, lParam) 
Declare Preview(wnd) 
Declare.l WindowCallback(Wnd, Message, wParam, lParam) 
Declare Main() 

Global Param$,Param1$;Startparameter 
Global Hwnd.l,SHwnd.l,SParanet.l;Hauptfenster,Vorschaufenster,Elternfenster(Vorschau) 
Global PreviewDC.l;Devicecontext Vorschau 
Global TI.l;Thread fuer Aktionen 
Global Preview.l,HHDC.l;Flag,Devicecontext-Hauptfenster 
Global MaxMouse.l;maximale Mausbewegung 

Global Dim MousePos.Point(0);Mausposition-Start 
Global Dim CurrentMousePos.Point(0);aktuelle Mausposition 
#MainWindow = 1000 
#PreviewWindow = 1001 

Procedure setBlack(wnd) 
  ;schwarzer Hintergrund 
  R1.rect 
  dc = GetDC_(wnd) 
  Blackbrush.l = GetStockObject_(#BLACK_BRUSH) 
  r1\left = 0 
  r1\top = 0 
  r1\right = GetSystemMetrics_(#SM_CXSCREEN) 
  r1\bottom = GetSystemMetrics_(#SM_CYSCREEN) 
  SetBkColor_(dc,RGB(0,0,0)) 
  FillRect_(dc,r1,blackbrush) 
  ReleaseDC_(wnd,dc) 
EndProcedure 

Procedure SetPassword() 
  ;Password setzen 
  If OpenLibrary(0,"mpr.dll") 
  CallFunction(0 ,"PwdChangePasswordA","SCRSAVE",ScrWnd,0,0) 
  CloseLibrary(0) 
  EndIf 
  End 
EndProcedure 

Procedure ConfigSaver() 
  ;Konfiguration des Schoners 
  MessageRequester("Screensaver","© 2002 by ampsoft"+Chr(13)+"Nichts einzurichten",64) 
  End 
EndProcedure 

Procedure.l VerifyPassword(wnd) 
  ;Passwort abfragen 
  If (OSVersion()=#PB_OS_Windows_95) Or (OSVersion()=#PB_OS_Windows_98)Or (OSVersion()=#PB_OS_Windows_ME) 
    Retval = 0 
    hKey.l=0 
    If RegOpenKeyEx_(#HKEY_CURRENT_USER,"'Control Panel\desktop",0,#KEY_READ,@hKey) 
      ;Ist Passwortschutz aktiv ? 
      If OpenLibrary(0,"Password.cpl") 
        ;Abfrage 
        ShowCursor_(1) 
        Retval = CallFunction(0,"VerifyScreenSavePwd",wnd) 
        ShowCursor_(Retval) 
        CloseLibrary(0) 
      EndIf 
      RegCloseKey_(hKey) 
    EndIf 
  EndIf 
  ProcedureReturn Retval 
EndProcedure 

Procedure.l CloseSaver(wnd) 
  ;Schoner beenden und Resourcen freigeben 
  If (OSVersion()=#PB_OS_Windows_95) Or (OSVersion()=#PB_OS_Windows_98)Or (OSVersion()=#PB_OS_Windows_ME) 
    If VerifyPassword(wnd) 
      DeleteDC_(GGDC) 
      KillThread(TI) 
      SystemParametersInfo_(#SPI_SCREENSAVERRUNNING, 0, @oldval, 0) 
      ShowWindow_(wnd,0) 
      DestroyWindow_(wnd) 
      RedrawWindow_(0,0,0,$0581) 
      PostQuitMessage_(0) 
      End 
    Else 
      SetBlack(wnd) 
    EndIf 
  EndIf 
  If (OSVersion()=#PB_OS_Windows_NT_4) Or (OSVersion()=#PB_OS_Windows_2000)Or (OSVersion()<>#PB_OS_Windows_XP)Or (OSVersion()<>#PB_OS_Windows_NT3_51) 
    DeleteDC_(GGDC) 
    KillThread(TI) 
    SystemParametersInfo_(#SPI_SCREENSAVERRUNNING, 0, @oldval, 0) 
    ShowWindow_(wnd,0) 
    DestroyWindow_(wnd) 
    RedrawWindow_(0,0,0,$0581) 
    PostQuitMessage_(0) 
    End 
  EndIf 
  ProcedureReturn Retval 
EndProcedure 

Procedure ExecuteSaver(wnd) 
  ;Hiew laeuft alles ab was beim "Schonen" passieren soll. 
  ;Angepasst an das Elternfenster ( Vorschau oder Vollbild ) 
  HHwnd = CreateWindowEx_(0,"Static","",#WS_VISIBLE|#WS_CHILD|#WS_CLIPSIBLINGS,0,0,0,0,wnd,0,GetModuleHandle_(0),0) 
  HHDC = GetDC_(HHwnd) 
  SetBlack(wnd) 
  Brush = GetStockObject_(#BLACK_BRUSH) 
  wr.RECT 
  GetWindowRect_(wnd,wr) 
  If Preview 
    wr\right = wr\right - wr\left 
    wr\bottom = wr\bottom - wr\top 
  Else 
    wr\left = 0 
    wr\top = 0 
    wr\right = GetSystemMetrics_(#SM_CXSCREEN) 
    wr\bottom = GetSystemMetrics_(#SM_CYSCREEN) 
  EndIf 
  rr.RECT 
  Repeat 
    rr\right = ww 
    rr\bottom = hh 
    FillRect_(HHDC,rr,brush) 
    WW = wr\right / (Random(6)+2) 
    HH = wr\bottom / (Random(6)+2) 
    XX = Random(wr\right) - ww 
    YY = Random(wr\bottom) - hh 
    MoveWindow_(HHWnd,XX,YY,WW,HH,0) 
    PaintDesktop_(HHDC) 
    UpdateWindow_(HHwnd) 
    Delay(200) 
  ForEver 
EndProcedure 

Procedure PreviewCallback(Wnd, Message, wParam, lParam) 
  ;Callback fuer Vorschau 
  Select message 
    Case #WM_PAINT 
      setBlack(Wnd) 
    Case #WM_CLOSE 
      DeleteDC_(PreviewDC) 
      DeleteObject_(Hrgn) 
      DeleteDC_(GGDC) 
      KillThread(TI) 
      UnregisterClass_("MyScrClass",GetModuleHandle_(0)) 
      DestroyWindow_(wnd) 
      End 
  EndSelect 
  Result = DefWindowProc_(wnd,message,wParam,lParam) 
  ProcedureReturn Result 
EndProcedure 

Procedure Preview(wnd) 
  ;Vorschau-Prozedur 
  ;Eigene Fensterklasse fuer die Vorschau anlegen 
  Dim ScrClass.WNDCLASS(0) 
  Classname$ = "MyScrClass" 
  ScrClass(0)\style = #CS_HREDRAW | #CS_VREDRAW 
  ScrClass(0)\lpfnWndProc = @PreviewCallback() 
  ScrClass(0)\cbClsExtra = 0 
  ScrClass(0)\cbWndExtra = 0 
  ScrClass(0)\hInstance = GetModuleHandle_(0) 
  ScrClass(0)\hIcon = 0 
  ScrClass(0)\hCursor = 0 
  ScrClass(0)\hbrBackground = 0 
  ScrClass(0)\lpszMenuName = 0 
  ScrClass(0)\lpszClassName = @Classname$ 
  RegisterClass_(ScrClass(0));Fensterklasse registrieren 

  r.RECT 
  GetWindowRect_(wnd,r) 
  r\right = r\right - r\left 
  r\bottom = r\bottom - r\top 
  SHwnd = CreateWindowEx_(0, "MyScrClass", "",#WS_CHILD|#WS_VISIBLE, 0, 0, r\right,r\bottom, wnd, 0, GetModuleHandle_(0), 0) 
  If Shwnd 
    TI = CreateThread(@ExecuteSaver(),SHWnd) 
    While GetMessage_(m.MSG,0,0,0) 
      TranslateMessage_(m) 
      DispatchMessage_(m) 
    Wend 
  EndIf 
EndProcedure 

Procedure.l WindowCallback(Wnd, Message, wParam, lParam) 
  ;Callback fuer Hauptfenster 
  Result = DefWindowProc_(wnd,message,wParam,lParam) 
  Select message 
    Case #WM_KEYUP 
      If wparam <> 17 ;Strg abfangen 
        result = CloseSaver(wnd) 
      EndIf 
    Case #WM_SYSKEYUP 
      result = CloseSaver(wnd) 
    Case #WM_MOUSEMOVE 
      GetCursorPos_(CurrentMousePos(0)) 
      If ((CurrentMousePos(0)\x - Mousepos(0)\x) > MaxMouse) Or ((CurrentMousePos(0)\y - Mousepos(0)\y) > MaxMouse) 
        result = CloseSaver(wnd) 
        GetCursorPos_(MousePos(0)) 
      EndIf 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

Procedure Main() 
  ;Hauptfenster-Prozedur 
  ShowCursor_(0) 
  Hwnd = OpenWindow(#MainWindow, 0, 0, GetSystemMetrics_(#SM_CXSCREEN),GetSystemMetrics_(#SM_CYSCREEN), "", #PB_Window_BorderLess) 
  If Hwnd 
    SetWindowCallback(@WindowCallback()) 
    SystemParametersInfo_(#SPI_SCREENSAVERRUNNING, 1, @oldval, 0) 
    ;Windows mitteilen dass ein Schoner laeuft 
    SetWindowPos_(Hwnd,#HWND_TOPMOST,0,0,GetSystemMetrics_(#SM_CXSCREEN),GetSystemMetrics_(#SM_CYSCREEN),#SWP_SHOWWINDOW) 
    ;Fenster ganz nach "Oben" bringen 
    GetCursorPos_(MousePos(0)) 
    ;Mausposition ermitteln 
    MaxMouse = 10 
    ;maximale Mausbewegung einstellen 
    setBlack(hwnd) 
    ;Hintergrund schwarz 
    TI = CreateThread(@ExecuteSaver(),Hwnd) 
    ;Thread fuer Aktionen starten 
    While GetMessage_(m.MSG,0,0,0) 
      TranslateMessage_(m) 
      DispatchMessage_(m) 
    Wend 
  EndIf 
EndProcedure 


;Mehrfachstart verhindern 
MutextString$ = "PB-Screensaver" 
MutexHandle.l = CreateMutex_(0,1,MutexString$) 
If GetLastError_() = #ERROR_ALREADY_EXISTS ;Programm läuft schon 
  End 
EndIf 

;Start-Parameter aufbereiten 
;Die Parameter können mit einem - oder / beginnen und zwischen erstem 
;und zweitem Parameter können sich entweder ein Doppelpunkt 
;oder ein Leerzeichen befinden. 
;Sind sie mit einem Doppelpunkt verbunden, 
;erkennt sie PB nicht als zwei Parameter, 
;und speichert beide in ProgrammParameter 1 

Param$ = UCase(ProgramParameter()) 

If Len(Param$) > 2 
  Param1$ = RemoveString(Param$, Left(Param$,2),1) 
Else 
  Param1$ = ProgramParameter() 
EndIf 

Param$ = RemoveString(Param$, Left(Param$,1),1) 
Param$ = Left(Param$,1) 

Select Param$ 
  Case "" 
    ConfigSaver() 
  Case "C" 
    ;Einstellungen 
    ConfigSaver() 
  Case "P" 
    ;Vorschau 
    Preview = 1 
    SParent = Val(Param1$) 
    Preview(SParent) 
  Case "A" 
    ;Passwort 
    SetPassword() 
  Case "S" 
    ;Hauptprogramm 
    Preview = 0 
    Main() 
EndSelect
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --