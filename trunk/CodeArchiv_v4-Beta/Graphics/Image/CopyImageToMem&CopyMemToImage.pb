; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1164&highlight=
; Author: freedimension (updated for PB 4.00 by Andre)
; Date: 10. December 2004
; OS: Windows
; Demo: No


Procedure CopyImageToMem(Img.l, mem.l) 
  Protected bmi.BITMAPINFO 
  Protected w.l, h.l, hBmp.l, hDC.l 
  w = ImageWidth(Img) 
  h = ImageHeight(Img) 
  hBmp = ImageID(Img) 
  
  bmi\bmiHeader\biSize        = SizeOf(BITMAPINFOHEADER) 
  bmi\bmiHeader\biWidth       =  w 
  bmi\bmiHeader\biHeight      = -h 
  bmi\bmiHeader\biPlanes      =  1 
  bmi\bmiHeader\biBitCount    = 32 
  bmi\bmiHeader\biCompression = #BI_RGB 
  
  hDC  = StartDrawing( ImageOutput(Img) ) 
  If GetDIBits_(hDC, hBmp, 0, h, mem, bmi, #DIB_RGB_COLORS) 
    StopDrawing() 
    ProcedureReturn #True 
  Else 
    StopDrawing() 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure CopyMemToImage(mem.l, Img.l) 
  Protected bmi.BITMAPINFO 
  Protected w.l, h.l, hBmp.l, hDC.l 
  w    = ImageWidth(Img) 
  h    = ImageHeight(Img) 
  hBmp = ImageID(Img) 
  
  bmi\bmiHeader\biSize        = SizeOf(BITMAPINFOHEADER) 
  bmi\bmiHeader\biWidth       =  w 
  bmi\bmiHeader\biHeight      = -h 
  bmi\bmiHeader\biPlanes      =  1 
  bmi\bmiHeader\biBitCount    = 32 
  bmi\bmiHeader\biCompression = #BI_RGB 
  
  hDC  = StartDrawing( ImageOutput(Img) ) 
  If SetDIBits_(hDC, hBmp, 0, h, mem, bmi, #DIB_RGB_COLORS) 
    StopDrawing() 
    ProcedureReturn #True 
  Else 
    StopDrawing() 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure Filter(mem.l, w.l, h.l) 
  w_1 = w - 1 
  h_1 = h - 1 
  h_2 = h - 2 
  w_2 = w - 2 

  pitch.l = w_1<<2 
  pitch2.l = pitch<<1 
  pitch_return.l = pitch * h_2 - 4 

  Dim dummy(w_1, h_1) 

  ; 1st Pass 
  *pos.LONG = mem 
  *dummy.LONG = @dummy()+4 
  For y = 0 To h_1 
    For x = 1 To w_2 
      c1 = *pos\l 
      *pos + 8 
      c3 = *pos\l 
      *pos - 4 
      c2 = *pos\l 

      red   = (c1 & $FF0000) + (c2 & $FF0000)<<1 + (c3 & $FF0000) 
      green = (c1 & $FF00)   + (c2 & $FF00)<<1   + (c3 & $FF00) 
      blue  = (c1 & $FF)     + (c2 & $FF)<<1     + (c3 & $FF) 
      red   = red   >> 18 
      green = green >> 10 
      blue  = blue  >> 2 

      red   = red   << 16 
      green = green << 8 

      ; Zwischenspeichern 
      *dummy\l = red + green + blue 
      *dummy + 4 
    Next 
    *pos   + 8 
    *dummy + 8 
  Next 
  
  ; 2nd Pass 
  *pos.LONG = @dummy() 
  *dummy.LONG = mem + pitch 
  For x = 0 To w_1 
    For y = 1 To h_2 
      c1 = *pos\l 
      *pos + pitch2 
      c3 = *pos\l 
      *pos - pitch 
      c2 = *pos\l 

      red   = (c1 & $FF0000) + 2*(c2 & $FF0000) + (c3 & $FF0000) 
      green = (c1 & $FF00)   + 2*(c2 & $FF00)   + (c3 & $FF00) 
      blue  = (c1 & $FF)     + 2*(c2 & $FF)     + (c3 & $FF) 
      red   = red   >> 18 
      green = green >> 10 
      blue  = blue  >> 2 
      
      red   = red   << 16 
      green = green << 8 
      
      ; Ins Original schreiben 
      *dummy\l = red + green + blue 
      *dummy + pitch 
    Next 
    *pos - pitch_return 
    *dummy - pitch_return 
  Next 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -