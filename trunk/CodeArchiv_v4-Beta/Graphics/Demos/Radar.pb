; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2887&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 20. November 2003
; OS: Windows
; Demo: No


;>------------------------------------ 
; 
; by Danilo, 20.11.2003 - german forum 
; 
;>------------------------------------ 

;#Width  = 1600 
;#Height = 1200 
#Width  = 1280 
#Height = 1024 
;#Width  = 1024 
;#Height = 768 
;#Width  = 800 
;#Height = 600 

#rotator_speed = 3 

#max_objects = 10 

Structure _OBJ 
  x.l 
  y.l 
  Transparency.l 
  Degree.f 
EndStructure 

Global Dim Objects._OBJ(#max_objects) 


Procedure.f GSin(winkel.f) 
   ProcedureReturn Sin(winkel*(2*3.14159265/360)) 
EndProcedure 


Procedure.f GCos(winkel.f) 
   ProcedureReturn Cos(winkel*(2*3.14159265/360)) 
EndProcedure 


Procedure ObjectSound(x) 
  Beep_(800,50) 
EndProcedure 


Procedure MakeSprites() 

  h = #Height-100 

  If CreateSprite(1,512,512,#PB_Sprite_Texture)=0 Or CreateSprite(2,256,256,#PB_Sprite_Texture)=0 Or CreateSprite(3,h,h)=0 
    CloseScreen() 
    MessageRequester("ERROR","Cant create Sprites !",#MB_ICONERROR) 
    End 
  EndIf 

  If CreateSprite3D(1,1)=0 Or CreateSprite3D(2,2)=0 
    CloseScreen() 
    MessageRequester("ERROR","Cant create 3D Sprites !",#MB_ICONERROR) 
    End 
  EndIf 

  ; Radar rotator (green > black) 
  StartDrawing(SpriteOutput(1)) 
    angle.f=90 
    Repeat 
      Line(255,255,GSin(angle)*255.0,GCos(angle)*255,RGB(0,Int(angle*2.8),0)) 
      angle.f - 0.001 
    Until angle <=0 
  StopDrawing() 

  ; Radar objects 
  StartDrawing(SpriteOutput(2)) 
    For a = 127 To 0 Step -1 
      Circle(127,127,a,RGB(255-2*a,255-2*a,255-2*a)) 
    Next a 
  StopDrawing() 
  ZoomSprite3D(2,32,32) 

  ; Radar chassis 
  StartDrawing(SpriteOutput(3)) 
    Circle(h/2,h/2,h/2,RGB($40,$40,$40)) 
    Circle(h/2,h/2,h/2-10,RGB($00,$00,$00)) 
    DrawingMode(4) 
    For a = 0 To 5 
      Circle(h/2,h/2,h/10*a,RGB($40,$40,$40)) 
    Next a 
    For a = -2 To 2 
      Line(0,h/2+a,h,0,RGB($40,$40,$40)) 
    Next a 
    For a = -2 To 2 
      Line(h/2+a,0,0,h,RGB($40,$40,$40)) 
    Next a 
    For a = 30 To 330 Step 30 
      Line(h/2,h/2,GSin(a)*h/2,GCos(a)*h/2,RGB($40,$40,$40)) 
    Next a 
  StopDrawing() 

EndProcedure 


;- Start 
If InitKeyboard()=0 Or InitSprite()=0 Or InitSprite3D()=0 
  MessageRequester("ERROR","Cant init DirectX !",#MB_ICONERROR) 
EndIf 

If OpenScreen(#Width,#Height,32,"Radar")=0 
  If OpenScreen(#Width,#Height,24,"Radar")=0 
    If OpenScreen(#Width,#Height,16,"Radar")=0 
      MessageRequester("ERROR","Cant open screen !",#MB_ICONERROR) 
EndIf:EndIf:EndIf 
SetFrameRate(60)

MakeSprites() 


;- Init objects 
Objects(1)\x      = (#Width/2-16)  -50 
Objects(1)\y      = (#Height/2-16) -20 
Objects(1)\Degree = 110 

Objects(2)\x      = (#Width/2-16)  +100 
Objects(2)\y      = (#Height/2-16) -80 
Objects(2)\Degree = 230 

Objects(3)\x      = (#Width/2-16)  +50 
Objects(3)\y      = (#Height/2-16) +#Height/4 
Objects(3)\Degree = 350 

Objects(4)\x      = (#Width/2-16)  -#Height/4+50 
Objects(4)\y      = (#Height/2-16) +#Height/4+50 
Objects(4)\Degree = 30 

Objects(5)\x      = (#Width/2-16)  -20 
Objects(5)\y      = (#Height/2-16) -#Height/2+150 
Objects(5)\Degree = 170 

;- Main loop 
Repeat 
  time = timeGetTime_() 
  ExamineKeyboard() 
  If IsScreenActive() And ScreenDeactivated = #False 
    angle.f - #rotator_speed 
    If angle < 0:angle+360:EndIf    
    ClearScreen(RGB(0,0,0)) 
    Start3D() 
      Sprite3DQuality(1) 
      ZoomSprite3D(1,#Height-100,#Height-100) 
      RotateSprite3D(1,angle,1) 
      DisplaySprite3D(1,(#Width-#Height)/2+50,50) 

      Sprite3DBlendingMode(5,2) 
      ; Objects 
      For a = 0 To #max_objects 
        If Objects(a)\x Or Objects(a)\y 
          DisplaySprite3D(2,Objects(a)\x,Objects(a)\y,Objects(a)\Transparency) 
        EndIf 
      Next a 
    Stop3D() 
    
    DisplayTransparentSprite(3,(#Width-#Height)/2+50,50) 

    For a = 0 To #max_objects 
      If Objects(a)\x Or Objects(a)\y 
        If angle < Objects(a)\Degree And angle > Objects(a)\Degree-#rotator_speed-2 And Objects(a)\Transparency<200 
          Objects(a)\Transparency=255 
          CreateThread(@ObjectSound(),0) 
        EndIf 
      EndIf 
    Next a 

    For a = 0 To #max_objects 
      If Objects(a)>0 
        Objects(a)\Transparency-#rotator_speed 
        If Objects(a)\Transparency<0 
          Objects(a)\Transparency=0 
        EndIf 
      EndIf 
    Next a 

  ElseIf ScreenDeactivated = #False 
    ScreenDeactivated = #True 
  ElseIf IsScreenActive() And ScreenDeactivated = #True 
      ScreenDeactivated = #False 
      FlipBuffers() 
      MakeSprites() 
  EndIf 
  FlipBuffers() 
  Repeat:Delay(1):Until timeGetTime_()-20>=time 
Until KeyboardPushed(#PB_Key_Escape) 
;- End


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
