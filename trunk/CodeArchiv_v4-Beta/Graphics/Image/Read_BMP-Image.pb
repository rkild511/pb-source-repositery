; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3289&highlight=
; Author: Forlom (updated for PB4.00 by blbltheworm)
; Date: 31. December 2003
; OS: Windows
; Demo: No


; Read BMP image with own routine. Only works if the number of bytes per line could be
; devided by 4. Else its recommended to use SetDIBitsToDevice_()
; Einlesen eines BMP Bildes mit eigener Routine. Funktioniert jedoch nur, wenn die Anzahl der
; Bytes pro Linie durch 4 teilbar ist. Andernfalls sollte SetDIBitsToDevice_() benutzt werden.


InitSprite() 
InitKeyboard() 

Structure _Bitmap 
  BmpFileHeader.BITMAPFILEHEADER 
  BmpInfoHeader.BITMAPINFOHEADER 
  lpData.l 
EndStructure 

Structure BmpWA 
  Bitmap.b[0] 
EndStructure 

Bitmap._Bitmap 

If OpenFile( 0,"..\Gfx\PB2.bmp") = 0 
  Debug("Unable to open Bitmap") 
  End 
EndIf 

  ReadData( 0, @Bitmap\BmpFileHeader,SizeOf(BITMAPFILEHEADER)) 
  ReadData( 0, @Bitmap\BmpInfoHeader,SizeOf(BITMAPINFOHEADER)) 
  
  Bitmap\lpData = GlobalAlloc_(#GMEM_FIXED|#GMEM_ZEROINIT, Bitmap\BmpInfoHeader\biSizeImage) 
  
  *Bmp.BmpWA = Bitmap\lpData 
  
  ReadData( 0, Bitmap\lpData, Bitmap\BmpInfoHeader\biSizeImage) 
  
  CloseFile(0) 
    
  OpenScreen(800,600,32,"BmpTest") 
  
  ClearScreen(RGB(100,100,100)) 
  
  StartDrawing( ScreenOutput()) 
  yy = Bitmap\BmpInfoHeader\biHeight 
  For y =  0 To Bitmap\BmpInfoHeader\biHeight -1  
    For x  = 0 To Bitmap\BmpInfoHeader\biWidth -1    
      red.b   = *Bmp\Bitmap[(y*Bitmap\BmpInfoHeader\biWidth+x)*3 + 2]      
      green.b = *Bmp\Bitmap[(y*Bitmap\BmpInfoHeader\biWidth+x)*3 + 1] 
      blue.b  = *Bmp\Bitmap[(y*Bitmap\BmpInfoHeader\biWidth+x)*3 + 0] 
      Plot(x,(yy -y)  ,RGB(red,green,blue)) 
    Next 
  Next 
  
  
  DrawText(0,Bitmap\BmpInfoHeader\biHeight+8,"So sollte es aussehen:") 
  
  StopDrawing() 
  
  LoadSprite(0,"..\Gfx\PB2.bmp") 
  DisplaySprite(0,0,Bitmap\BmpInfoHeader\biHeight+25) 
  
  FlipBuffers() 
  
  Repeat 
    
    ExamineKeyboard() 
    
  Until KeyboardPushed( #PB_Key_All) 
  
  GlobalFree_(lpBild) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
