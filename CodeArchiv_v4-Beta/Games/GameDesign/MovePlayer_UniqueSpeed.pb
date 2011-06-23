; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9177&start=15
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 18. January 2004
; OS: Windows
; Demo: No


; You move sprites with the same speed on different PCs with 
; the following 'multiplicator' calculation: 

; The sprite moves with same speed on all PCs, whatever you 
; use: 60, 72, 85, 100 FPS...


; Some details about the InitGameTimer() procedure:
; It initializes the highres timer to the lowest possible value 
; thats available, usually 1ms - but on some old systems 
; like Win95 and Win98 it *can* be higher, like 5ms. 
; On NT-Systems (NT4,2k,XP) it should always be 1ms. 
;
; It works on most systems without the initialization, but its 
; the correct way to do it - and i like correct programming if possible.  
;
; I've seen the difference on my dual-PIII-1000, some code 
; didnt work correctly. I wondered, read some MSDN, and 
; found the correct way. 
; With the correct initialization it works fine everywhere.


;- procedures 
Procedure InitGameTimer() 
  Shared _GT_DevCaps.TIMECAPS 
  timeGetDevCaps_(_GT_DevCaps,SizeOf(TIMECAPS)) 
  timeBeginPeriod_(_GT_DevCaps\wPeriodMin) 
EndProcedure 

Procedure StopGameTimer() 
  Shared _GT_DevCaps.TIMECAPS 
  timeEndPeriod_(_GT_DevCaps\wPeriodMin) 
EndProcedure 


;- variables 
Global player1_move.f, player1_x.f, player1_y.f 

;- _program start 
;- _Init 
If InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant init DirectX !",#MB_ICONERROR):End 
EndIf 

If OpenScreen(800,600,32,"Timing")=0 
  If OpenScreen(800,600,24,"Timing")=0 
    If OpenScreen(800,600,16,"Timing")=0 
      MessageRequester("ERROR","Cant open screen !",#MB_ICONERROR):End 
EndIf:EndIf:EndIf 

If CreateSprite(1,32,32)=0 
  CloseScreen() 
  MessageRequester("ERROR","Cant create sprite !",#MB_ICONERROR):End 
Else 
  StartDrawing(SpriteOutput(1)) 
    Box (0,0,32,32,$00FFFF) 
    Line(0,0,32,32,$000000) 
    Line(32,0,0,32,$000000) 
  StopDrawing() 
EndIf 

player1_speed.f = 0.350 

; timer initialisieren 
InitGameTimer() 
StartTime = timeGetTime_() 
time      = StartTime 

;SetFrameRate(75) 

;- _game loop 
Repeat 
  ; calculate multiplicator 
  multiplicator.f = StartTime 
  StartTime = timeGetTime_() 
  multiplicator   = StartTime - multiplicator 

  ; calc framerate 
  If timeGetTime_()-time >= 1000 
    time   = timeGetTime_() 
    FPS    = Frames-1 
    Frames = 1 
  Else 
    Frames+1 
  EndIf 

  ClearScreen(RGB(0,0,0)) 

  ; show framerate 
  StartDrawing(ScreenOutput()) 
    DrawingMode(1):FrontColor(RGB($80,$FF,$00)) 
    DrawText(50,50,"FrameRate: "+Str(FPS)) 
  StopDrawing() 

  ExamineKeyboard() 
  
  ; calc move-step for player1 
  player1_move = player1_speed * multiplicator 
  
  If KeyboardPushed(#PB_Key_Left) 
    player1_x - player1_move : EndIf 
  If KeyboardPushed(#PB_Key_Right) 
    player1_x + player1_move : EndIf 
  If KeyboardPushed(#PB_Key_Up) 
    player1_y - player1_move : EndIf 
  If KeyboardPushed(#PB_Key_Down) 
    player1_y + player1_move : EndIf 

  If player1_x < -32 : player1_x = 800 : EndIf 
  If player1_x > 800 : player1_x = -32 : EndIf 
  If player1_y < -32 : player1_y = 600 : EndIf 
  If player1_y > 600 : player1_y = -32 : EndIf 

  DisplaySprite(1,player1_x,player1_y) 

  FlipBuffers() 
Until KeyboardPushed(#PB_Key_Escape) 

;- _program end 
StopGameTimer()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
