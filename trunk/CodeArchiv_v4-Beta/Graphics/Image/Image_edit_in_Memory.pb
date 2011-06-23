; German forum:
; Author: HCB (updated for PB4.00 by blbltheworm)
; Date: 10. April 2003
; OS: Windows
; Demo: No


; HCB's Pixel In/Output Test
;
; von HCB (hcb@hcb.de)
; am 10.04.2003 in Pöttmes programmiert.
; http://www.hiho.de
;
; 2003-04-10|v0.1   : Erste Version ...
; THX @ Danilo
;

CreatePreferences("timer.txt")


If 1
  LoadImage(0, "..\gfx\PB.bmp")
  timer.l = GetTickCount_()
  
  picl_X = ImageWidth(0)
  picl_Y = ImageHeight(0)
  picl_D = ImageDepth(0)
  
  
  StartDrawing(ImageOutput(0))
  
  For ay=0 To picl_Y
    For ax=0 To picl_X
      Plot(ax,ay,$FFFFFF-Point(ax,ay))
    Next ax
  Next ay
  StopDrawing()
  
  timer = GetTickCount_()-timer
  
  PreferenceComment("Point,Plot")
  PreferenceComment(Str(timer)+" ms")
  PreferenceComment("")
  
  SaveImage(0, "test0.bmp")
EndIf


LoadImage(0, "..\gfx\PB.bmp")
timer.l = GetTickCount_()

picl_X = ImageWidth(0)
picl_Y = ImageHeight(0)+1 ; Das +1 muss sein ... warum auch immer ...
picl_D = ImageDepth(0)

Structure myBITMAPINFO
  bmiHeader.BITMAPINFOHEADER
  bmiColors.RGBQUAD[1]
EndStructure

Structure RGB
  b.b
  g.b
  r.b
  n.b ;n wie nix
EndStructure

hBmp = ImageID(0)
hDC  = StartDrawing(ImageOutput(0))

mem = AllocateMemory(picl_X*picl_Y*4)
bmi.myBITMAPINFO
bmi\bmiHeader\biSize   = SizeOf(BITMAPINFOHEADER)
bmi\bmiHeader\biWidth  = picl_X
bmi\bmiHeader\biHeight = picl_Y
bmi\bmiHeader\biPlanes = 1
bmi\bmiHeader\biBitCount = 32
bmi\bmiHeader\biCompression = #BI_RGB
GetDIBits_(hDC,hBmp,1,picl_Y,mem,bmi,#DIB_RGB_COLORS)

*pixel.RGB = mem
For ay=1 To picl_Y
  For ax=1 To picl_X
    *pixel\r = 255-*pixel\r
    *pixel\g = 255-*pixel\g
    *pixel\b = 255-*pixel\b
    *pixel + 4
  Next ax
Next ay

SetDIBits_(hDC,hBmp,1,picl_Y,mem,bmi,#DIB_RGB_COLORS)

StopDrawing()

timer = GetTickCount_()-timer

PreferenceComment("GetDIBits,SetDIBits,pixel.RGB")
PreferenceComment(Str(timer)+" ms")
PreferenceComment("")

SaveImage(0, "test1.bmp")


LoadImage(0, "..\gfx\PB.bmp")
timer.l = GetTickCount_()

picl_X = ImageWidth(0)
picl_Y = ImageHeight(0)+1 ; Das +1 muss sein ... warum auch immer ...
picl_D = ImageDepth(0)


hBmp = ImageID(0)
hDC  = StartDrawing(ImageOutput(0))

mem = AllocateMemory(picl_X*picl_Y*4)
bmi.myBITMAPINFO
bmi\bmiHeader\biSize   = SizeOf(BITMAPINFOHEADER)
bmi\bmiHeader\biWidth  = picl_X
bmi\bmiHeader\biHeight = picl_Y
bmi\bmiHeader\biPlanes = 1
bmi\bmiHeader\biBitCount = 32
bmi\bmiHeader\biCompression = #BI_RGB
GetDIBits_(hDC,hBmp,1,picl_Y,mem,bmi,#DIB_RGB_COLORS)

*pixels.LONG = mem
For ay=1 To picl_Y
  For ax=1 To picl_X
    *pixels\l = $FFFFFF - *pixels\l
    *pixels + 4
  Next ax
Next ay

SetDIBits_(hDC,hBmp,1,picl_Y,mem,bmi,#DIB_RGB_COLORS)

StopDrawing()

timer = GetTickCount_()-timer

PreferenceComment("GetDIBits,SetDIBits,pixels.LONG")
PreferenceComment(Str(timer)+" ms")
PreferenceComment("")

SaveImage(0, "test2.bmp")

ClosePreferences()
End


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger