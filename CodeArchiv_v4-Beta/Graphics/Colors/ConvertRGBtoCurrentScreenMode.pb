; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1314&highlight=
; Author: Deeem2031 (updated for PB4.00 by blbltheworm)
; Date: 05. October 2003
; OS: Windows
; Demo: Yes


; Procedure, die die Farbe in den aktuellen Farbmodus umwandelt.
; (Bei 15-bit bin ich mir nicht sicher ob das so richtig ist, konnte es nicht testen...)
Procedure.l TransformColor(R.b,G.b,b.b) 
  Select DrawingBufferPixelFormat() 
    Case #PB_PixelFormat_32Bits_RGB 
      ProcedureReturn R+G<<8+b<<16 
    Case #PB_PixelFormat_32Bits_BGR 
      ProcedureReturn b+G<<8+R<<16 
    Case #PB_PixelFormat_24Bits_RGB 
      ProcedureReturn R+G<<8+b<<16 
    Case #PB_PixelFormat_24Bits_BGR 
      ProcedureReturn b+G<<8+R<<16 
    Case #PB_PixelFormat_16Bits 
      ProcedureReturn b>>3+(G&%11111100)<<3+(R&%11111000)<<8 
    Case #PB_PixelFormat_15Bits 
      ProcedureReturn R&%11111000>>3+(G&%11111000)<<2+(b&%11111000)<<7 
  EndSelect 
EndProcedure 

;Example
InitSprite() : InitScreen()
OpenScreen(640,480,16,"Test")
StartDrawing(ScreenOutput())
  DrawingBuffer() ;Funktioniert nur, wenn vorher StartDrawing() aufgerufen wurde
  Debug TransformColor(255,0,0)
StopDrawing()
End


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
