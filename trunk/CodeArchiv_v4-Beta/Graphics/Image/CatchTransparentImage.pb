; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3139&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 14. December 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 14.12.2003 - german forum 
; 
Procedure CatchTransparentImage(Number,ImageLabel,TransColor,NewColor) 
  ;> 
  ;> Number     = ImageNumber 
  ;> ImageLabel = Label of the included Image 
  ;> TransColor = RGB: Transparent Color,        -1 = First Color in Picture 
  ;> NewColor   = RGB: New Color for TransColor, -1 = System Window Background 
  ;> 
  Structure _CTI_BITMAPINFO 
    bmiHeader.BITMAPINFOHEADER 
    bmiColors.RGBQUAD[1] 
  EndStructure 

  Structure _CTI_LONG 
   l.l 
  EndStructure 

  Structure _CTI_WORD 
   w.w 
  EndStructure 

  hBmp = CatchImage(Number,ImageLabel) 
  If hBmp 
    hDC  = StartDrawing(ImageOutput(Number)) 
    If hDC 
      ImageWidth  = ImageWidth(Number) : ImageHeight = ImageHeight(Number) : ImageDepth = ImageDepth(Number) 
      mem = GlobalAlloc_(#GMEM_FIXED|#GMEM_ZEROINIT,ImageWidth*ImageHeight*4) 
      If mem 
        bmi._CTI_BITMAPINFO 
        bmi\bmiHeader\biSize   = SizeOf(BITMAPINFOHEADER) 
        bmi\bmiHeader\biWidth  = ImageWidth 
        bmi\bmiHeader\biHeight = ImageHeight 
        bmi\bmiHeader\biPlanes = 1 
        bmi\bmiHeader\biBitCount = ImageDepth 
        bmi\bmiHeader\biCompression = #BI_RGB 
        If GetDIBits_(hDC,hBmp,0,ImageHeight(Number),mem,bmi,#DIB_RGB_COLORS) <> 0 
          If TransColor = -1 
            If ImageDepth=32 
              *pixels._CTI_LONG = mem+((ImageHeight-1)*ImageWidth*4) 
              TransColor = *pixels\l 
              Debug Hex(TransColor) 
            ElseIf ImageDepth=16 
              *pixelsW._CTI_WORD = mem+((ImageHeight-1)*ImageWidth*2) 
              TransColor2 = *pixelsW\w&$FFFF 
              Debug Hex(TransColor2) 
            EndIf 
          Else 
            If ImageDepth=32 
              TransColor = RGB(Blue(TransColor),Green(TransColor),Red(TransColor)) 
            ElseIf ImageDepth=16 
              r.l = ((TransColor>>3)&%11111) 
              g.l = ((TransColor>>6)&%11111100000) 
              b.l = ((TransColor>>9)&%1111100000000000) 
              TransColor2 = (r|g|b)&$FFFF 
              Debug Hex(TransColor2) 
            EndIf 
          EndIf 

          If NewColor = -1 
            NewColor = GetSysColor_(#COLOR_BTNFACE) ; #COLOR_WINDOW 
          EndIf 
          NewColor = RGB(Blue(NewColor),Green(NewColor),Red(NewColor)) 

          If ImageDepth=32 
            *pixels._CTI_LONG = mem 
            For a = 1 To ImageWidth*ImageHeight 
              If *pixels\l = TransColor 
                *pixels\l = NewColor 
              EndIf 
              *pixels + 4 
            Next a 
          ElseIf ImageDepth=16 
            r = ((NewColor>>3)&%11111) 
            g = ((NewColor>>6)&%11111100000) 
            b = ((NewColor>>9)&%1111100000000000) 
            NewColor2.w   = (b|g|r)&$FFFF 
            *pixelsW._CTI_WORD = mem 
            For a = 1 To ImageWidth*ImageHeight 
              If *pixelsW\w&$FFFF = TransColor2 
                *pixelsW\w  = NewColor2 
              EndIf 
              *pixelsW + 2 
            Next a 
          EndIf 

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

image1 = CatchTransparentImage(1,?Image_01,-1,255) 
If image1 
  OpenWindow(0,0,0,ImageWidth(1),ImageHeight(1),"Image",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
    CreateGadgetList(WindowID(0)) 
    ImageGadget(0,0,0,ImageWidth(1),ImageHeight(1),image1) 
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
Else 
  MessageRequester("ERROR","Cant load image!",#MB_ICONERROR) 
EndIf 


DataSection 
  Image_01: 
    IncludeBinary "..\Gfx\Geebee2.bmp" 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
