; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3267&highlight=
; Author: Deeem2031 (updated for PB4.00 by blbltheworm)
; Date: 29. December 2003
; OS: Windows
; Demo: Yes


Procedure DrawResizedArea(SourceOutput,SourceX,SourceY,SourceWidth,SourceHeight,TargetOutput,TargetX,TargetY,TargetWidth,TargetHeight) 
  StartDrawing(SourceOutput) 
  DrawingBuffer = DrawingBuffer() 
  DrawingBufferPitch = DrawingBufferPitch() 
  DrawingBufferPixelFormat = DrawingBufferPixelFormat() 
  StopDrawing() 
  StartDrawing(TargetOutput) 
  TargetDrawingBuffer = DrawingBuffer() 
  TargetDrawingBufferPitch = DrawingBufferPitch() 
  StopDrawing() 
  If DrawingBufferPixelFormat >= #PB_PixelFormat_32Bits_RGB 
    tmp_xv.f = SourceWidth *4/TargetWidth 
    tmp_yv.f = SourceHeight  /TargetHeight 
    For y = 0 To TargetHeight-1 
      *target.LONG = TargetDrawingBuffer+TargetX*4+TargetDrawingBufferPitch*(y+TargetY) 
      For x = 0 To TargetWidth-1 
        tmp_x = Int(x*tmp_xv)+SourceX*4 
        *source.LONG = DrawingBuffer+tmp_x-tmp_x%4+DrawingBufferPitch*(Int(y*tmp_yv)+SourceY) 
        *target\l = *source\l 
        *target + 4 
      Next 
    Next 
  ElseIf DrawingBufferPixelFormat >= #PB_PixelFormat_24Bits_RGB 
    tmp_xv.f = SourceWidth *3/TargetWidth 
    tmp_yv.f = SourceHeight  /TargetHeight 
    For y = 0 To TargetHeight-1 
      *target.LONG = TargetDrawingBuffer+TargetX*3+TargetDrawingBufferPitch*(y+TargetY) 
      For x = 0 To TargetWidth-1 
        tmp_x = Int(x*tmp_xv)+SourceX*3 
        *source.LONG = DrawingBuffer+tmp_x-tmp_x%3+DrawingBufferPitch*(Int(y*tmp_yv)+SourceY) 
        *target\l = *source\l 
        *target + 3 
      Next 
    Next 
  ElseIf DrawingBufferPixelFormat = #PB_PixelFormat_16Bits 
    tmp_xv.f = SourceWidth *2/TargetWidth 
    tmp_yv.f = SourceHeight  /TargetHeight 
    For y = 0 To TargetHeight-1 
      *target.LONG = TargetDrawingBuffer+TargetX*2+TargetDrawingBufferPitch*(y+TargetY) 
      For x = 0 To TargetWidth-1 
        tmp_x = Int(x*tmp_xv)+SourceX*2 
        *source.LONG = DrawingBuffer+tmp_x-tmp_x%2+DrawingBufferPitch*(Int(y*tmp_yv)+SourceY) 
        *target\l = *source\l 
        *target + 2 
      Next 
    Next 
  Else 
    tmp_xv.f = SourceWidth /TargetWidth 
    tmp_yv.f = SourceHeight/TargetHeight 
    For y = 0 To TargetHeight-1 
      *target.LONG = TargetDrawingBuffer+TargetX+TargetDrawingBufferPitch*(y+TargetY) 
      For x = 0 To TargetWidth-1 
        *source.LONG = DrawingBuffer+Int(x*tmp_xv)+SourceX+DrawingBufferPitch*(Int(y*tmp_yv)+SourceY) 
        *target\l = *source\l 
        *target + 1 
      Next 
    Next 
  EndIf 
EndProcedure

InitSprite() 
InitKeyboard() 
OpenScreen(800,600,32,"") 
CreateSprite(0,200,200) 
StartDrawing(SpriteOutput(0)) 
For x = 0 To 199 
  For y = 0 To 199 
    Plot(x,y,Random(255|255<<8|255<<16)) 
  Next 
Next 
LineXY(0,0,199,199,255) 
LineXY(0,199,199,0,255<<8) 
StopDrawing() 
Repeat 
  ClearScreen(RGB(0,0,0)) 
  i+1 
  DrawResizedArea(SpriteOutput(0),0,0,SpriteWidth(0),SpriteHeight(0),ScreenOutput(),0,0,i%200+1,i%200+1) 
  ;DrawResizedArea(ScreenOutput(),0,0,1,1,ScreenOutput(),0,200,i%200+1,i%200+1) 

  DisplaySprite(0,210,0) 
  ExamineKeyboard() 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
