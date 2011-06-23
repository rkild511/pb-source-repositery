; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8736&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 14. December 2003
; OS: Windows
; Demo: No

; 
; Bitmap Bits Test 
; Danilo, 10.04.2003 

Structure myBITMAPINFO 
  bmiHeader.BITMAPINFOHEADER 
  bmiColors.RGBQUAD[1] 
EndStructure 

hBmp = CreateImage(1,300,100) 
hDC  = StartDrawing(ImageOutput(1)) 
  ImageWidth  = ImageWidth(1) 
  ImageHeight = ImageHeight(1) 
  mem = AllocateMemory(ImageWidth*ImageHeight*4) 
  bmi.myBITMAPINFO 
  bmi\bmiHeader\biSize   = SizeOf(BITMAPINFOHEADER) 
  bmi\bmiHeader\biWidth  = ImageWidth 
  bmi\bmiHeader\biHeight = ImageHeight 
  bmi\bmiHeader\biPlanes = 1 
  bmi\bmiHeader\biBitCount = 32 
  bmi\bmiHeader\biCompression = #BI_RGB 
  If GetDIBits_(hDC,hBmp,0,ImageHeight(1),mem,bmi,#DIB_RGB_COLORS) <> 0 
    ; Fill 
    *pixels.LONG = mem 
    For a = 1 To ImageWidth*(ImageHeight/3) 
      *pixels\l = $FFFF00 
      *pixels + 4 
    Next a 
    
    ; Copy back 
    If SetDIBits_(hDC,hBmp,0,ImageHeight(1),mem,bmi,#DIB_RGB_COLORS) <> 0 
      StopDrawing() 
      OpenWindow(0,0,0,ImageWidth,ImageHeight,"Image",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
        CreateGadgetList(WindowID(0)) 
        ButtonImageGadget(0,0,0,ImageWidth,ImageHeight,hBmp) 
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
    Else 
      StopDrawing() 
    EndIf 
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
