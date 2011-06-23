; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14532&highlight=
; Author: MrMat (updated for PB 4.00 by Andre)
; Date: 25. March 2005
; OS: Windows
; Demo: Yes


; Create a 24 bit bitmap from scratch, then use CatchImage to grab it and 
; display it in a window...

; Set image parameters 
width = 250 
height = 100 

bitcount = 24 ; Should be 24 bits for this example 

; Rows need to be a multiple of 4 bytes so calculate extra bytes needed 
extrabytesperrow = (4 - (width * bitcount / 8) % 4) % 4 

; Allocate memory for bitmap 
sizeheaders = SizeOf(BITMAPFILEHEADER) + SizeOf(BITMAPINFOHEADER) 
sizeimage = (width * bitcount / 8 + extrabytesperrow) * height 

*bitmap = AllocateMemory(sizeheaders + sizeimage) 
If *bitmap = 0 
  Debug("Couldn't allocate memory for bitmap") 
  End 
EndIf 

; Set bitmap headers 
*bitmapfile.BITMAPFILEHEADER = *bitmap 
*bitmapfile\bfType = Asc("B") + Asc("M") << 8 
*bitmapfile\bfSize = sizeheaders +sizeall 
*bitmapfile\bfOffBits = sizeheaders 

*bitmapinfo.BITMAPINFOHEADER = *bitmap + SizeOf(BITMAPFILEHEADER) 
*bitmapinfo\biSize = SizeOf(BITMAPINFOHEADER) 
*bitmapinfo\biWidth = width 
*bitmapinfo\biHeight = height 
*bitmapinfo\biPlanes = 1 
*bitmapinfo\biBitCount = bitcount 
*bitmapinfo\biCompression = 0 
*bitmapinfo\biSizeImage = sizeimage 

*bitmapdata = *bitmap + sizeheaders 

; Create 24 bit image in bitmap 
*bitmapdatapos = *bitmapdata 
For j = 0 To height - 1 ; j = 0 corresponds to bottom of image 
  For i = 0 To width - 1 
    PokeB(*bitmapdatapos, 255 * (i / (width - 1.0))) ; Blue 
    PokeB(*bitmapdatapos + 1, Cos(Pow((i - width / 2), 2) + Pow((j - height / 2), 2))) ; Green 
    PokeB(*bitmapdatapos + 2, 255 * (j / (height - 1.0))) ; Red 
    *bitmapdatapos + bitcount / 8 
  Next 
  *bitmapdatapos + extrabytesperrow 
Next 

; Grab bitmap 
If CatchImage(0, *bitmap) = 0 
  Debug("Something wrong with bitmap") 
  End 
EndIf 

; Plot bitmap in a window 
InitSprite() 
OpenWindow(0, 300, 300, width, height, "Bitmap example", #PB_Window_ScreenCentered | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget) 
OpenWindowedScreen(WindowID(0), 0, 0, width, height, 0, 0, 0) 

StartDrawing(ScreenOutput()) 
DrawImage(ImageID(0), 0, 0) 
StopDrawing() 

Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 

FreeImage(0) 
FreeMemory(*bitmap)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger