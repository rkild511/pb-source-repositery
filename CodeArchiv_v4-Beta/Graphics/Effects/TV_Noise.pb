; English forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3369&postdays=0&postorder=asc&start=10
; Author: Benny (speed-improved by Danilo, updated for PB4.00 by blbltheworm)
; Date: 18. January 2004
; OS: Windows
; Demo: No


; [updated release]

;------------------------------------------------------------------------------------ 
; TV-Noise 
; convert from a C-example by Gaffer 
; to PureBasic 
; by benny! / weltenkonstrukteur.de 
; in 2oo4 
; 
; Thanks to Deeem2031 for the TransformColor-Procedure 
; 
; !!!!!!!!!!!!!!!!!! DISABLE DEBUGGER !!!!!!!!!!!!!!!!!!!!! 

Procedure.l TransformColor(R.b,G.b,b.b) 
  Select DrawingBufferPixelFormat() 
    Case #PB_PixelFormat_32Bits_RGB 
      ProcedureReturn R+G<<8+b<<16 
    Case #PB_PixelFormat_32Bits_BGR 
      ProcedureReturn b+G<<8+R<<16 
    Case #PB_PixelFormat_24Bits_RGB 
      ProcedureReturn R+G<<8+b<<16 
    Case #PB_PixelFormat_24Bits_BGR 
      ProcedureReturn b+G<<8+R<<16 
    Case #PB_PixelFormat_16Bits 
      ProcedureReturn b>>3+(G&%11111100)<<3+(R&%11111000)<<8 
    Case #PB_PixelFormat_15Bits 
      ProcedureReturn R&%11111000>>3+(G&%11111000)<<2+(b&%11111000)<<7 
  EndSelect 
EndProcedure 

; For Speed-Optimation - Original by Danilo! 

Procedure InitGameTimer() 
  ; initialize highres timing function TimeGetTime_() 
  Shared _GT_DevCaps.TIMECAPS 
  timeGetDevCaps_(_GT_DevCaps,SizeOf(TIMECAPS)) 
  timeBeginPeriod_(_GT_DevCaps\wPeriodMin) 
EndProcedure 

Procedure StopGameTimer() 
  ; de-initialize highres timing function TimeGetTime_() 
  Shared _GT_DevCaps.TIMECAPS 
  timeEndPeriod_(_GT_DevCaps\wPeriodMin) 
EndProcedure 


#SCREEN_X     = 640 
#SCREEN_Y     = 480 

#LOOPTIME   = 1000/40  ; 40 Frames in 1000ms (1second) 

If InitSprite()=0 Or InitMouse()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant init DirectX !",#MB_ICONERROR):End 
EndIf 

hWnd = OpenWindow(0, 0, 0, #SCREEN_X, #SCREEN_Y, "TV-Noise by benny! / weltenkonstrukteur.de (c) 2oo4", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) 

If OpenWindowedScreen(hWnd, 0, 0, #SCREEN_X, #SCREEN_Y, 0, 0, 0) = 0 
;If OpenScreen(#SCREEN_X, #SCREEN_Y, 32, "j")=0 
  MessageRequester("ERROR","Cant open screen !",#MB_ICONERROR):End 
EndIf 

StartDrawing(ScreenOutput()) 
  Select DrawingBufferPixelFormat() 
  Case #PB_PixelFormat_8Bits       ; 1 bytes per pixel, palettized 
    PixelStep = 1 
  Case #PB_PixelFormat_15Bits      ; 2 bytes per pixel 
    PixelStep = 2 
  Case #PB_PixelFormat_16Bits      ; 2 bytes per pixel 
    PixelStep = 2 
  Case #PB_PixelFormat_24Bits_RGB  ; 3 bytes per pixel (RRGGBB) 
    PixelStep = 3 
  Case #PB_PixelFormat_24Bits_BGR  ; 3 bytes per pixel (BBGGRR) 
    PixelStep = 3 
  Case #PB_PixelFormat_32Bits_RGB  ; 4 bytes per pixel (RRGGBB) 
    PixelStep = 4 
  Case #PB_PixelFormat_32Bits_BGR  ; 4 bytes per pixel (BBGGRR) 
    PixelStep = 4 
  EndSelect 

  Pitch = DrawingBufferPitch() 

StopDrawing() 


White = TransformColor(255,255,255) 
Noise = 0 
Carry = 0 
Index = 0 
Seed  = $12345 

InitGameTimer() 

While quit=0 
  FlipBuffers() 
  ExamineMouse() 
  ExamineKeyboard() 
  If IsScreenActive() 

    StartDrawing(ScreenOutput())      
      *Screen = DrawingBuffer() 
      For y = 1 To #SCREEN_Y 
        *Line.LONG = *Screen 
        For x = 2 To #SCREEN_X 
          noise = seed; 
          noise = noise >> 3 
          noise = noise ! seed 
          carry = noise & 1 
          seed = seed >> 1 
          seed = seed | ( carry << 30) 
          noise = noise & $FF 
          *Line\l = (noise<<16) | (noise << 8) | noise 
          *Line + PixelStep 
        Next x 
        *Screen + Pitch 
      Next y 
      
    StopDrawing() 
  EndIf 

  Repeat 
   Event=WindowEvent() 
   If Event=#PB_Event_CloseWindow 
     quit = 2 
   ElseIf Event=0 
     While ( timeGetTime_()-LoopTimer )<#LOOPTIME : Delay(1) : Wend 
     LoopTimer = timeGetTime_() 
   EndIf 
  Until Event=0 

  If KeyboardPushed(#PB_Key_Escape) 
    quit = 2 
  EndIf 
  
;  Delay(80) 

Wend 

StopGameTimer()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger