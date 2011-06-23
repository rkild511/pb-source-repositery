; English forum: 
; Author: Unknown
; Date: 09. June 2003
; OS: Windows
; Demo: Yes

Procedure KeyCheck() 
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_Escape) : End : EndIf 
EndProcedure 

Procedure.f GSin(angle.f) 
  ProcedureReturn Sin(angle*(2*3.14/360)) 
EndProcedure 

Dim cosarray(1280) 
Dim pcolor(255) 

For i = 0 To 1280 
  cosarray(i) = GSin(360*i/320)* 32 + 32 
Next 

If InitSprite() = 0 
  MessageRequester("Error!","InitSprite failed!",0) 
EndIf 

If InitKeyboard()=0 
  MessageRequester("Error!","InitKeyboard failed!",0) 
EndIf 

If OpenScreen(1024,768,32,"PB-Plasma") = 0 
  MessageRequester("Error!","InitScreen failed!",0) 
EndIf 

; Structure Byte     ; Structure is defined in PB 3.70+
;   l.l 
; EndStructure 

Repeat 
  KeyCheck() 
  FlipBuffers() 

  wave = wave + 6 
  If wave > 320 : wave = 0 : EndIf 
  If StartDrawing(ScreenOutput()) 
    Buffer = DrawingBuffer() 
    Pitch = DrawingBufferPitch() 
    PixelFormat = DrawingBufferPixelFormat() 
    
    If PixelFormat = #PB_PixelFormat_32Bits_RGB 
      For i = 0 To 255 
        pcolor(i) = i << 16 ; Blue is at the 3th pixel 
      Next 
    Else                    ; Else it's 32bits_BGR 
      For i = 0 To 255 
        pcolor(i) = i       ; Blue is at the 1th pixel 
      Next    
    EndIf 
  
    For y = 0 To 480-1 
      pos1 = cosarray(y+wave) 
      
      *Line.LONG = Buffer+y*Pitch 
      
      For x = 0 To 640-1 
        pos2 = (cosarray(x+wave) + cosarray(x+y) + pos1) 
        *Line\l = pcolor(pos2) 
        *Line+4 
      Next 
    Next 
    StopDrawing() 
  EndIf 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger