; www.purebasic.com
; Author: Fred
; Date: 07. March 2005
; OS: Windows
; Demo: Yes

;
; Direct Screen Access (DSA) in PureBasic !
;

; Some comments by Fred from relating thread in english forum:
; http://www.purebasicforums.com/english/viewtopic.php?t=14301&highlight=

; The FlipBuffers() function is in the Sprite section, this isprobably what 
; you are looking for. About fast plotting, you just has to use the 
; Plot(x,y,color) function (note the color param, if you use the shorter 
; form Plot(x,y) it won't be accelerated). You have to use a ScreenOutput() 
; or a SpriteOutput() to have acceleration on. If you are more experienced 
; and need more speed, you can still use 'DrawingBuffer()' and 
; 'DrawingBufferPitch()' to get access directory to the buffer and use a 
; pointer to read/write it directly.

ExamineDesktops()
ScreenWidth  = DesktopWidth(0)
ScreenHeight = DesktopHeight(0)

; #ScreenWidth  = 800  ; Feel free to change this to see the pixel filling speed !
; #ScreenHeight = 600

If InitSprite() = 0 Or InitKeyboard()=0
  MessageRequester("Error","DirectX 7+ is needed.",0)
EndIf

Structure Pixel
  Pixel.l
EndStructure

Procedure.f GSin(angle.f)
  ProcedureReturn Sin(angle*(2*3.14/360))
EndProcedure

Dim CosTable(ScreenWidth*2)
Dim ColorTable(255)

For i = 0 To ScreenWidth*2
  CosTable(i) = GSin(360*i/320)* 32 + 32
Next


If OpenScreen(ScreenWidth, ScreenHeight, 32, "PB Plasma")

  Repeat

    Wave+6
    If Wave > 320 : Wave = 0 : EndIf
    
    If StartDrawing(ScreenOutput())
      Buffer      = DrawingBuffer()             ; Get the start address of the screen buffer
      Pitch       = DrawingBufferPitch()        ; Get the length (in byte) took by one horizontal line
      PixelFormat = DrawingBufferPixelFormat()  ; Get the pixel format. 
      
      If PixelFormat = #PB_PixelFormat_32Bits_RGB
        For i = 0 To 255
          ColorTable(i) = i << 16 ; Blue is at the 3th pixel
        Next
      Else                       ; Else it's 32bits_BGR
        For i = 0 To 255
          ColorTable(i) = i       ; Blue is at the 1th pixel
        Next    
      EndIf
    
      For y = 0 To ScreenHeight-1
        pos1 = CosTable(y+wave)
        
        *Line.Pixel = Buffer+Pitch*y
        
        For x = 0 To ScreenWidth-1
          pos2 = (CosTable(x+Wave) + CosTable(x+y) + pos1)
          *Line\Pixel = ColorTable(pos2) ; Write the pixel directly to the memory !
          *Line+4
        Next
      Next
      
      StopDrawing()
    EndIf
    
    ExamineKeyboard()
    
    FlipBuffers()
     
  Until KeyboardPushed(#PB_Key_Escape)

Else
  MessageRequester("Error","Can't open the screen !",0)
EndIf



End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger