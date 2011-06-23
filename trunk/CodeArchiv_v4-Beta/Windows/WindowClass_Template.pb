; http://www.purebasic-lounge.de
; Author: edel 
; Date: 06. Februar 2007 
; OS: Windows 
; Demo: No 
  
Procedure ControlProc(hwnd,msg,wParam,lParam) 
  Protected ps.PAINTSTRUCT 
  Protected rc.RECT 
  Protected hdc 
  
  Select msg 
    Case #WM_CREATE 
    Case #WM_PAINT 
      
      GetClientRect_(hwnd,@rc) 
      
      hdc = BeginPaint_(hwnd,@ps) 
      
      RoundRect_(hdc,rc\left,rc\top,rc\right,rc\bottom,10,10) 
      
      EndPaint_(hwnd,@ps) 
      
      ProcedureReturn 0 
      
    Case #WM_SIZE 
    Case #WM_DESTROY 
  EndSelect 
  
  ProcedureReturn DefWindowProc_(hwnd,msg,wParam,lParam) 
EndProcedure 
  
;######################################################### 
  
Procedure RegisterControl() 
  Protected wndC.WNDCLASS 
  
  With wndC 
    \style          = #CS_VREDRAW | #CS_HREDRAW       ; Eigenschaften der Klasse 
    \lpfnWndProc    = @ControlProc()                  ; Procedure der Klasse 
    \hCursor        = LoadCursor_(0, #IDC_CROSS)      ; Mauszeiger 
   ;\hbrBackground  = #COLOR_WINDOW                   ; Hintergrund der Klasse 
    \lpszClassName  = @"Control"                      ; Name der Klasse 
  EndWith 
  
  ProcedureReturn RegisterClass_(wndC)                ; Klasse registrieren 
EndProcedure 


;- Beispiel 

hwnd = OpenWindow(0,0,0,260,260,"Register Control Example",#WS_OVERLAPPEDWINDOW|#PB_Window_ScreenCentered) 

;muss einmal vor CreateWindowEx 
;aufgerufen werden damit "Control" 
;registriert wird 
RegisterControl() 

; erstellen von vier "Control" Gadgets 
CreateWindowEx_(0,"Control",0,#WS_VISIBLE|#WS_CHILD ,20,20,100,100,hwnd,0,0,0)  
CreateWindowEx_(0,"Control",0,#WS_VISIBLE|#WS_CHILD ,140,20,100,100,hwnd,0,0,0) 
CreateWindowEx_(0,"Control",0,#WS_VISIBLE|#WS_CHILD ,20,140,100,100,hwnd,0,0,0) 
CreateWindowEx_(0,"Control",0,#WS_VISIBLE|#WS_CHILD ,140,140,100,100,hwnd,0,0,0) 

Repeat 
  event = WaitWindowEvent() 
  
Until event = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP