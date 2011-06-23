; http://www.purebasic-lounge.de
; Author: edel (updated for PB 4.00 by edel)
; Date: 29. March 2006
; OS: Windows
; Demo: No

Declare CProc(hWnd.l,uMsg.l,wParam.l,lParam.l)

;/ Declare variables
Define hwnd , OldWndProc
Define hInstance.l = GetModuleHandle_(0)
Define wndc.WNDCLASSEX
Define Button0,Button1
Define WindowEvent

;/ Open window
hwnd = OpenWindow(0,#PB_Ignore,#PB_Ignore,220,120,"SUPERCLASSING")

;/ superclassing

;- Klassen Info holen

wndc\cbSize = SizeOf(WNDCLASSEX)
GetClassInfoEx_(hInstance,@"Button",@wndc)

;- alte controlprocadresse speichern
OldWndProc = wndc\lpfnWndProc

;- neue controlprocadresse setzen
wndc\lpfnWndProc = @CProc()

;- neuen Klassennamen setzen
wndc\lpszClassName = @"OWNBUTTONCLASS"
wndc\hInstance = hInstance

;- Neue Klasse registrieren
RegisterClassEx_(@wndc)

;/ neues control erstellen
Button0 = CreateWindowEx_(0,"OWNBUTTONCLASS","Button0",#WS_CHILD|#WS_VISIBLE,10,10,100,100,hwnd,0,hInstance,0)
Button1 = CreateWindowEx_(0,"OWNBUTTONCLASS","Button1",#WS_CHILD|#WS_VISIBLE,110,10,100,100,hwnd,1,hInstance,0)

;/ Window eventloop
Repeat
  WindowEvent = WaitWindowEvent()
Until WindowEvent = #WM_CLOSE

;/ OWNBUTTONCLASS Subproc
Procedure CProc(hWnd.l,uMsg.l,wParam.l,lParam.l)
  Shared OldWndProc
  Protected buffer.s
  ;/ Hier ganz normal die Message verarbeiten.
  If uMsg = #WM_RBUTTONUP
    buffer.s = Space(50)
    SendMessage_(hWnd,#WM_GETTEXT,50,buffer)
    MessageRequester(Str(hwnd),"Rechtsklick -> " + buffer)
  EndIf
  If uMsg = #WM_LBUTTONUP
    buffer.s = Space(50)
    SendMessage_(hWnd,#WM_GETTEXT,50,buffer)
    MessageRequester(Str(hwnd),"Linksklick -> " + buffer)
  EndIf
  ProcedureReturn CallWindowProc_(OldWndProc,hWnd,uMsg,wParam,lParam)
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -