; German forum:
; Author: Unknown (fixed + updated for PB4.00 by blbltheworm)
; Date: 22. April 2003
; OS: Windows
; Demo: No

#Window1 = 1 
#True  = 1 
#False = 0 

Global hwnd.l 


Procedure SetWinOpacity (hWin.l, Opacity.l)       ; 0: Durchsichtig  <--->  255: Opak 
  SetWindowLong_(hWin, #GWL_EXSTYLE, $00080000)    ; #WS_EX_LAYERED = $00080000 
  SetLayeredWindowAttributes_(hWin, 0, Opacity, 2) ; 
EndProcedure 
Procedure PaintWindowBackground() 
  ww.l = WindowWidth(#Window1) 
  wh.l = WindowHeight(#Window1) 

  hBmp.l    = CreateImage(0, ww, wh) 
  hRgn1.l   = CreateRoundRectRgn_( 4, 4, ww-4, wh-4, 17, 17) 
  hRgn2.l   = CreateRoundRectRgn_( 0, 0, ww  , wh  , 16, 16) 
  hBrush1.l = CreateSolidBrush_( RGB($D4, $D0, $C8) ) 

  hDC = StartDrawing( ImageOutput(0) )              ; Zeichnen des Fensterhintergrunds in der Bitmap 
    Box( 0, 0, ww, wh, RGB($54, $B5, $FF) ) 
    FillRgn_( hDC, hRgn1, hBrush1 ) 
    Line( ww-30,  8, 20, 20, 0) 
    Line( ww-30, 28, 20,-20, 0) 
    
    Line( ww-30, wh-10, 20,-20, 0) 
    Line( ww-20, wh-10, 10,  0, 0) 
    Line( ww-10, wh-10,  0,-10, 0) 
    Line( ww-10, wh-10,-10,-10, 0) 
    
    Line( 10, 20, 20,  0, 0) 
    Line( 20, 10,  0, 20, 0) 
  StopDrawing() 

  hBrush2.l = CreatePatternBrush_(hBmp)            ; Erzeugung einer Brush mit der Bitmap von oben 
  SetClassLong_(hwnd, #GCL_HBRBACKGROUND, hBrush2) ; Setzen des Fensterhintergrundes auf diese Brush 
  InvalidateRect_(hwnd, #Null, #True)              ; Neuzeichnen des Fensters anregen 

  SetWindowRgn_(hwnd, hRgn2, #True)                ; "Beschneiden" des Fensters auf die neuen Maße 

  DeleteObject_( hRgn1 )                           ; Löschen aller temporären GDI-Objekte 
  DeleteObject_( hRgn2 ) 
  DeleteObject_( hBrush1 ) 
  DeleteObject_( hBrush2 ) 
EndProcedure 

hwnd = OpenWindow( #Window1, 100, 100, 1, 1, "SkinTest", #PB_Window_BorderLess) 

; Das Fenster für DoubleClicks empfänglich machen 
dLong = GetClassLong_(hwnd, #GCL_STYLE) | #CS_DBLCLKS   ; alten Style ermitteln und mit CS_DBLCLKS versehen 
SetClassLong_(hwnd, #GCL_STYLE, dLong)                  ; neuen Style setzen 


If hwnd <> 0 
  SetWinOpacity( hwnd, 0) 
  ResizeWindow( #Window1,#PB_Ignore,#PB_Ignore,400, 600) 
  ww.l = 400 ;Standardbreite setzen
  wh.l = 600 ;Standardhöhe setzen
  PaintWindowBackground() 
  For i=0 To 255 Step 10 
    SetWinOpacity( hwnd, i) : While WindowEvent() : Wend 
  Next 
  SetWinOpacity( hwnd, 255) 

  Repeat 
    EventID.l = WaitWindowEvent() 
    mx.l = WindowMouseX( #Window1) 
    my.l = WindowMouseY( #Window1) 

    Select EventID 
      Case #WM_PAINT 
        PaintWindowBackground() 
        While WindowEvent() : Wend ; nötig um eine Endlosschleife zu vermeiden
      Case #WM_LBUTTONDBLCLK 
        ; Minimieren des Fensters ohne MinimizeButton 
        If (mx > 30 And (mx < ww-30) And my > 0 And my < 30) 
          ShowWindow_(hwnd, #SW_MINIMIZE) 
        EndIf 

      Case #WM_LBUTTONDOWN, 15
        ; Bewegen des Fensters ohne Titelleiste 
        If ((mx > 0 And mx < 30) And (my > 0 And my < 30)) 
          ReleaseCapture_() 
          SendMessage_(hwnd, #WM_NCLBUTTONDOWN, #HTCAPTION, NULL) 
        EndIf 
        
        ; Programm beenden 
        If ((mx > ww-30 And mx < ww-10) And (my > 8 And my < 28)) 
          Result.l = MessageRequester("Programm schließen", "Wollen Sie das Programm wirklich beenden?", #PB_MessageRequester_YesNo | #MB_ICONQUESTION) 
          If(Result = #IDYES) 
            EventID = #PB_Event_CloseWindow 
          EndIf 
        EndIf 

        ; WindowResize ohne Fensterrahmen 
        If ((mx > ww-30 And mx < ww) And (my > wh-30 And my < wh)) 
          ReleaseCapture_() 
          SendMessage_(hwnd, #WM_NCLBUTTONDOWN, #HTBOTTOMRIGHT , NULL) 
        EndIf 
        
        ww.l = WindowWidth( #Window1)  ; added by blbltheworm
        wh.l = WindowHeight( #Window1) ; added by blbltheworm
        
        ; Minimalgröße des Fensters einstellen  (added by blbltheworm)
        If ww<90 
          ww=90 
        EndIf 
        If wh<60 
          wh=60 
        EndIf 
        ResizeWindow( #Window1,#PB_Ignore,#PB_Ignore,ww, wh) 
    EndSelect 
    ;Debug EventID ;zu Beginn immer MouseMove, nach Resizen nur noch #PB_Event_Repaint
  Until EventID = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -