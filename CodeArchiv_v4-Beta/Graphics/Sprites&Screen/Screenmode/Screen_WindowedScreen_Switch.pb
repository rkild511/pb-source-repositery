; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6086&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 07. May 2003
; OS: Windows
; Demo: No


; Switch from windowed screen to full screen and back with pressing F12...
; Umschalten vom Bildschirm im Fenster ("windowed") in Vollbild und zurück durch Drücken von F12...

Structure WinInfoT 
  ; Windowed 
  pi.l  ; PB Window Identifier 
  ph.l  ; PB Window Handle 
  wx.l  ; Window X offset 
  wy.l  ; Window Y offset 
  ww.l  ; Window 
  wh.l  ; Window 
  wt.s  ; Window 
  wf.l  ; Window 

  ; Screen 
  sm.l  ; Screen Mode (0: Windowed, 1: Fullscreen) 
  sx.l  ; Screen X offset (windowed mode) 
  sy.l  ; Screen Y offset (windowed mode) 
  sw.l  ; Screen Width (fullscreen) 
  sh.l  ; Screen Height (fullscreen) 
  sc.l  ; Screen Colour Bits (fullscreen) 
  sd.l  ; Screen Depth Bits (fullscreen) 

  ws.l  ; Window State (0:  Opening, 1: Active, 2: Closing) 
  
EndStructure 

Global wi.WinInfoT 
Global cBlack,cWhite,cRed,cSky 

cBlack  = RGB(0,0,0) 
cWhite  = RGB(255,255,255) 
cRed    = RGB(255,0,0) 
cSky    = RGB(192, 192, 255) 
  
;============================================================================ 

Procedure.l WinResize(w.l, h.l) 
  wi\ww = w: wi\wh = h 
  CloseScreen() 
  OpenWindowedScreen(wi\ph, wi\sx, wi\sy, wi\sw, wi\sh, 1, 0, 0) 
EndProcedure 

Procedure SwitchScreen() 
  wi\sm = wi\sm ! 1 

  If wi\ws 
    CloseScreen() 
  Else 
    wi\ws=1 
  EndIf 
  
  If wi\sm = 0 ; Windowed 
    wi\ph = OpenWindow(wi\pi, wi\wx, wi\wy, wi\ww, wi\wh, wi\wt, wi\wf) 
    OpenWindowedScreen(wi\ph, wi\sx, wi\sy, wi\ww, wi\wh, 0, 0, 0) 
    SetFocus_(wi\ph) 
  Else 
    If wi\ph : CloseWindow(wi\pi) : wi\ph=0 : EndIf 
    OpenScreen(wi\sw,wi\sh,wi\sc,wi\wt) 
  EndIf 

EndProcedure 

;============================================================================ 

If InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant init DirectX !",#MB_ICONERROR):End 
EndIf 

  w=800: h=600: c=32: d=32: 
  wi\wx = 0: wi\wy = 0 
  wi\ww = 800 
  wi\wh = 600 
  wi\sc = 32 
  wi\wf = #PB_Window_SizeGadget  | #PB_Window_SystemMenu
  wi\wt = "Flip Test" 

  wi\sm = 1 
  wi\sx = 0 
  wi\sy = 0 
  wi\sw = 800 
  wi\sh = 600 

SwitchScreen() 

SetFrameRate(50) 

Repeat 
    FlipBuffers() 
    ExamineKeyboard() 

    If IsScreenActive() 
      ClearScreen(RGB(192,192,255)) 

      StartDrawing(ScreenOutput()) 
        DrawingMode(4) 
        Box(0, 0, wi\sw, wi\sh , cRed) 
        LineXY(0, 0, wi\sw, wi\sh , cRed) 
        LineXY(0, wi\sh, wi\sw, 0 , cRed) 
        Circle((wi\sw-1)/2, (wi\sh-1)/2, (wi\sh-1)/2, cRed) 

        DrawingMode(1) 
        FrontColor(RGB(255,255,255)) 
        DrawText(10,10,Str(wi\ww)+","+Str(wi\wh)) 
        DrawText(10,25,Str(wi\sw)+","+Str(wi\sh)) 
      StopDrawing() 

    EndIf 

    If wi\sm = 0 
      Select WindowEvent() 
        Case #WM_SIZE 
          WinResize(WindowWidth(wi\pi),WindowHeight(wi\pi)) 
        Case #PB_Event_CloseWindow
          quit=1
      EndSelect 
    EndIf 

    If KeyboardReleased(#PB_Key_F12) 
      SwitchScreen() 
    EndIf 

    Delay(1) 
    If KeyboardReleased(#PB_Key_Escape) 
      quit=1
    EndIf
Until quit=1

CloseWindow(wi\pi) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
