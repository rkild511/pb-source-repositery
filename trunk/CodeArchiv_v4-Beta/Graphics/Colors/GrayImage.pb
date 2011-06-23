; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=722&start=0&postdays=0&postorder=asc&highlight=
; Author: Danilo (updated for PB4.00 by Andre)
; Date: 22. April 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 22.04.2003 - german forum 
; 
Procedure GrayImage(Number) 
  ;> 
  ;> Number     = ImageNumber 
  ;> 
  Structure _GI_BITMAPINFO 
    bmiHeader.BITMAPINFOHEADER 
    bmiColors.RGBQUAD[1] 
  EndStructure 

  Structure _GI_LONG 
   l.l 
  EndStructure 

  Structure _GI_BGR 
   R.b 
   G.b 
   B.b 
   A.b 
  EndStructure 

  hBmp = ImageID(Number) 
  If hBmp 
    hDC  = StartDrawing(ImageOutput(Number)) 
    If hDC 
      ImageWidth  = ImageWidth(Number) : ImageHeight = ImageHeight(Number) 
      mem = GlobalAlloc_(#GMEM_FIXED|#GMEM_ZEROINIT,ImageWidth*ImageHeight*4) 
      If mem 
        bmi._GI_BITMAPINFO 
        bmi\bmiHeader\biSize   = SizeOf(BITMAPINFOHEADER) 
        bmi\bmiheader\biWidth  = ImageWidth 
        bmi\bmiheader\biHeight = ImageHeight 
        bmi\bmiheader\biPlanes = 1 
        bmi\bmiheader\biBitCount = 32 
        bmi\bmiheader\biCompression = #BI_RGB 
        If GetDIBits_(hDC,hBmp,0,ImageHeight(Number),mem,bmi,#DIB_RGB_COLORS) <> 0 
          *pixels._GI_LONG = mem 
          *COLORS._GI_BGR   = mem 
          For a = 1 To ImageWidth*ImageHeight 
            ; color.b = Int((0.299* *COLORS\R) + (0.587* *COLORS\G) + (0.114* *COLORS\B)) 
            color.b = ((299 * *COLORS\R) + (587* *COLORS\G) + (114* *COLORS\B)) /1000   ; improved by Rings
            *pixels\l = RGB(color,color,color) 
            *pixels + 4 
            *COLORS + 4 
          Next a 

          If SetDIBits_(hDC,hBmp,0,ImageHeight(Number),mem,bmi,#DIB_RGB_COLORS) <> 0 
            Result = hBmp 
          EndIf 
        EndIf 
        GlobalFree_(mem) 
      EndIf 
    EndIf 
    StopDrawing() 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

UseJPEGImageDecoder() 
UsePNGImageDecoder() 
UseTIFFImageDecoder() 
UseTGAImageDecoder() 

;FileName$ = OpenFileRequester("SELECT IMAGE","","BMP|*.bmp",0) 
FileName$ = OpenFileRequester("SELECT IMAGE","","Image Files|*.bmp;*.jpg;*.jpeg;*.png;*.tiff;*.tga|All Files|*.*",0) 
;Filename$ = "Test.bmp" 

If FileName$ 
  If LoadImage(1,FileName$) 
    GrayImage(1) 
    OpenWindow(0,0,0,ImageWidth(1),ImageHeight(1),"Image",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
      CreateGadgetList(WindowID(0)) 
      ImageGadget(0,0,0,ImageWidth(1),ImageHeight(1),ImageID(1)) 
    HideWindow(0,0):SetForegroundWindow_(WindowID(0)) 
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
  Else 
    MessageRequester("ERROR","Cant load image!",#MB_ICONERROR) 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
