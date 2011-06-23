; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9371&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 01. February 2004
; OS: Windows
; Demo: Yes


; Problem: how to get a pixel' color of a sprite without using startdrawing() and point() ?

; Solution (by Danilo):
;
; StartDrawing(SpriteOutput(#SPRITE)) 
;  Mem    = DrawingBuffer() 
;  Pitch  = DrawingBufferPitch() 
;  Format = DrawingBufferPixelFormat() 
;
;  ; Write to memory directly 
;
; StopDrawing() 

; This should work with ScreenOutput() and SpriteOutput(), so 
; you can access the video buffer directly. Writing and reading. 


ExamineDesktops()
ScreenWidth  = DesktopWidth(0)
ScreenHeight = DesktopHeight(0)

#SpriteWidth  = 300 
#SpriteHeight = 300 

If InitSprite()=0 Or InitKeyboard()=0 Or InitMouse()=0 
  MessageRequester("ERROR","Cant init DirectX !",#MB_ICONERROR):End 
EndIf 

If OpenScreen(ScreenWidth,ScreenHeight,32,"Screen") 

  If CreateSprite(1,#SpriteWidth,#SpriteHeight)=0 
    CloseScreen() 
    MessageRequester("ERROR","Cant create sprite !",#MB_ICONERROR):End 
  EndIf 

  If StartDrawing(SpriteOutput(1)) 
    Mem    = DrawingBuffer() 
    Pitch  = DrawingBufferPitch() 
    Format = DrawingBufferPixelFormat() 

    factorX.f = 255/#SpriteWidth 
    factorY.f = 255/#SpriteHeight 

    g = 255 

    ; Write to memory directly 
    For y = 0 To #SpriteHeight-1 
      *Line.LONG = Mem + y*Pitch 
      For x = 0 To #SpriteWidth-1 
        r = 255 - x*factorX 
        b = x*factorX 
        If Format = #PB_PixelFormat_32Bits_RGB 
          *Line\l = (b << 16) | (g << 8) | (r) ; bgr - reversed? 
          *Line + 4 
        Else;If Format = #PB_PixelFormat_32Bits_BGR 
          *Line\l = (r << 16) | (g << 8) | (b) ; rgb - reversed? 
          *Line + 4 
        EndIf 
      Next x 
      g = 255 - y*factorY 
    Next y 

    StopDrawing() 
  EndIf 
  
  MouseLocate(ScreenWidth/2,ScreenHeight/2) 
  
  Repeat 
    ExamineKeyboard() 
    ExamineMouse() 
    If IsScreenActive() 
      FlipBuffers() 
      ClearScreen(RGB(0,0,0))
      DisplaySprite(1,MouseX()-#SpriteWidth/2,MouseY()-#SpriteHeight/2) 
    EndIf 
    Delay(5) 
  Until KeyboardPushed(#PB_Key_Escape) 

Else 
  MessageRequester("ERROR","Cant open screen !",#MB_ICONERROR):End 
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -