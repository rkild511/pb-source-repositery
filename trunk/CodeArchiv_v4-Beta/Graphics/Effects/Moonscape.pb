; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14532&highlight=
; Author: MrMat (updated for PB 4.00 by Andre)
; Date: 27. March 2005
; OS: Windows
; Demo: Yes

width = 400 
height = 300 

widthsprite = 2 * width 
heightsprite = 2 * height 

rand = 64 

If InitSprite() = 0 
  Debug("Requires DirectX 7 or later") 
  End 
EndIf 

OpenWindow(0, 0, 0, width, height, "Moonscape", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
OpenWindowedScreen(WindowID(0), 0, 0, width, height, 0, 0 ,0) 

CreateSprite(0, widthsprite, heightsprite) 

If StartDrawing(SpriteOutput(0)) 
  *buffer = DrawingBuffer() 
  
  bytesperpixel = DrawingBufferPixelFormat() / 2 + 1 
  bytesperline = DrawingBufferPitch() 
  extrabytesperline = bytesperline - widthsprite * bytesperpixel 
  
  min = 0 
  max = 0 
  *scan = *buffer 
  For j = 0 To heightsprite - 1 
    col = 0 
    For i = 0 To widthsprite - 1 
      If j <> 0 
        col + PeekL(*scan - bytesperline) 
      EndIf 
      col >> 1 
      col + Random(rand) - rand >> 1 
      PokeL(*scan, col) 
      If col > max 
        max = col 
      ElseIf col < min 
        min = col 
      EndIf 
      *scan + bytesperpixel 
    Next 
    *scan + extrabytesperline 
  Next 
  
  If min <> max 
    *scan = *buffer 
    For j = 0 To heightsprite - 1 
      For i = 0 To widthsprite - 1 
        col = 255 * (PeekL(*scan) - min)/(max - min) 
        PokeL(*scan, col + col << 8 + col << 16) 
        *scan + bytesperpixel 
      Next 
      *scan + extrabytesperline 
    Next 
  EndIf 
  StopDrawing() 
EndIf 

iter = 0 
Repeat 
  FlipBuffers() 
  DisplaySprite(0, width * (Cos(iter / 100) - 1) / 2, height * (Sin(iter / 100) - 1) / 2) 
  Delay(10) 
  iter + 1 
Until WindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -