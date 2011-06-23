; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=655&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm + Andre)
; Date: 18. April 2003
; OS: Windows
; Demo: No


;- Konstanten 
#SCREEN_W       = 800 
#SCREEN_H       = 600 
#SCREEN_TITLE   = "Grafik Test Programm" 

#BALL           = 1 

#ANZAHL         = 150 

;- Variablen 
Dim x.l(#ANZAHL) 
Dim y.l(#ANZAHL) 
Dim a.l(#ANZAHL) 
Dim b.l(#ANZAHL) 
Dim Sprite.l(#ANZAHL) 

;- Init 
If InitKeyboard()=0 Or InitSprite()=0 
  MessageRequester("ERROR","Cant initialize DirectX!",#MB_ICONERROR):End 
EndIf 

If OpenScreen(#SCREEN_W,#SCREEN_H,32,#SCREEN_TITLE) = 0 
  If OpenScreen(#SCREEN_W,#SCREEN_H,24,#SCREEN_TITLE) = 0 
    If OpenScreen(#SCREEN_W,#SCREEN_H,16,#SCREEN_TITLE) = 0 
      MessageRequester("ERROR","Cant open DirectX screen!",#MB_ICONERROR):End 
EndIf:EndIf:EndIf 

For a = 1 To 10 
  If CreateSprite(a,24,24) 
    StartDrawing(SpriteOutput(a)) 
      Circle(12,12,12,RGB(Random($FF),Random($FF),Random($FF))) 
    StopDrawing() 
  Else 
    CloseScreen() 
    MessageRequester("ERROR","Cant create Sprite!",#MB_ICONERROR):End 
  EndIf 
Next a 

For a = 1 To #ANZAHL 
  x(a) = Random(#SCREEN_W/2) : y(a) = Random(#SCREEN_H/2) 
  a(a) = Random(5)+1         : b(a) = Random(5)+1 
  Sprite(a) = Random(9)+1 
Next a 

oldtime.f = timeGetTime_() 

;- Hauptschleife 
Repeat 
  FlipBuffers() 
  ExamineKeyboard() 
  If IsScreenActive() 
    ClearScreen(RGB(0,0,0)) 

    For a = 1 To #ANZAHL 
      If x(a)>#SCREEN_W-24 Or x(a)<0 
        a(a)=-a(a) 
      EndIf 
      If y(a)>#SCREEN_H-24 Or y(a)<0 
        b(a)=-b(a) 
      EndIf 
      x(a)+a(a) 
      y(a)+b(a) 
      DisplayTransparentSprite(Sprite(a),x(a),y(a)) 
    Next a 

    If GetTickCount_() => zeit + 1000 
      FrameSek = Frames 
      Frames = 0 
      zeit = GetTickCount_() 
    Else 
      Frames + 1 
    EndIf      

    If StartDrawing(ScreenOutput()) 
      DrawingMode(1) 
      FrontColor(RGB($FF,$FF,$00)) 
      DrawText(20,20,"Frames/Sekunde: "+Str(FrameSek)) 
      StopDrawing() 
    EndIf 
  Else 
    Delay(10) 
  EndIf 
Until KeyboardPushed(#PB_Key_Escape) 
;- Ende 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
