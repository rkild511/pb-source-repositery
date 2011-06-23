; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1115&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 24. May 2003
; OS: Windows
; Demo: Yes


#insel=1 
#spielfeld=2 

If InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant initialize DirectX !",#MB_ICONERROR):End 
EndIf 

;seJPEGImageDecoder() 
#SCREEN_W    = 800 
#SCREEN_H    = 600 
#SCREEN_NAME = "ociport" 
If OpenScreen(#SCREEN_W,#SCREEN_H,32,#SCREEN_NAME)=0 
  If OpenScreen(#SCREEN_W,#SCREEN_H,24,#SCREEN_NAME)=0 
    If OpenScreen(#SCREEN_W,#SCREEN_H,16,#SCREEN_NAME)=0 
      MessageRequester("ERROR","Cant open Screen !",#MB_ICONERROR):End 
EndIf:EndIf:EndIf 

Procedure PrepareSprites() 
  If CreateSprite(#insel,100,100)=0 
    Error=1 
  Else 
    StartDrawing(SpriteOutput(#insel)):Circle(50,50,50,$00FFFF):StopDrawing() 
  EndIf 
  If CreateSprite(#spielfeld,600,600)=0 : Error=1 :EndIf 
  If Error 
    CloseScreen():MessageRequester("ERROR","Cant initialize Sprites !",#MB_ICONERROR):End 
  EndIf 
EndProcedure 

PrepareSprites() 

Repeat 
  FlipBuffers() 
  ExamineKeyboard() 

  If IsScreenActive() And ScreenWasSwitched = 0 
    UseBuffer(#spielfeld) 
      ClearScreen(RGB($FF,$00,$FF)) 
      DisplayTransparentSprite(#insel,a,a) 
    UseBuffer(-1) 
    ClearScreen(RGB($00,$00,$FF)) 
    DisplaySprite(#spielfeld,100,100) 
  ElseIf IsScreenActive() And ScreenWasSwitched = 1 
    PrepareSprites() 
    ScreenWasSwitched = 0 
  Else 
    Delay(10) 
    ScreenWasSwitched = 1 
  EndIf 

  If flag 
    a-1 : If a <=   0 : flag=0 : EndIf 
  Else 
    a+1 : If a >= 100 : flag=1 : EndIf 
  EndIf 

Until KeyboardReleased(#PB_Key_Escape)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
