; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2510&highlight=
; Author: Danilo
; Date: 10. October 2003
; OS: Windows
; Demo: Yes

; Move the mouse cursor to see the effect...

#SCREEN_X     = 800 
#SCREEN_Y     = 600 

If InitSprite()=0 Or InitMouse()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant init DirectX !",#MB_ICONERROR):End 
EndIf 

If OpenScreen(#SCREEN_X,#SCREEN_Y,32,"Screen")=0 
  MessageRequester("ERROR","Cant open screen !",#MB_ICONERROR):End 
EndIf 

StartDrawing(ScreenOutput()) 
  PixelFormat  = DrawingBufferPixelFormat() 
  Pitch        = DrawingBufferPitch() 
StopDrawing() 

;MouseLocate(243,243) 

Repeat 
  FlipBuffers() 
  ExamineKeyboard() 
  ExamineMouse() 
  If IsScreenActive() 
    ;ClearScreen(0,0,0) 

    StartDrawing(ScreenOutput()) 
      *Screen.LONG = DrawingBuffer() 

      *Screen + (Pitch*MouseY())+(MouseX()*4) 
      
      If PixelFormat = #PB_PixelFormat_32Bits_RGB 
        *Screen\l = $FFFF0000 
      ElseIf PixelFormat = #PB_PixelFormat_32Bits_BGR 
        *Screen\l = $00FFFF00 
      EndIf 
    StopDrawing() 
  EndIf 

Until KeyboardPushed(#PB_Key_Escape) 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
