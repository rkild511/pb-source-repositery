; English forum:
; Author: El_Choni (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm + Andre)
; Date: 29. June 2003
; OS: Windows
; Demo: No


; I've been coding for some time a ColorDepth lib to change image color depth, including dither.
; Currently, I have this quantization procedure which uses Fast Adaptive Dissection (an enhancement
; of Median Cut) to quantize colours. But I won't be able to release it until a month or two, too
; much work going on, so I've decided to post the PB source so everybody can benefit and report
; problems or suggestions. Speed and memory usage are not optimized yet, but the procedure seems
; to work. The usage of the procedure is simple: 

; SetDepth(ImageID, PixelDepth) 
 

; So, if you have a 24 bit image and you want it to have a maximum of 256 colours, you would call
; it this way: 

; SetDepth(ImageID, 8) 
 


; If the image already has that number of colours or less after reducing pixel colours to 15 bit
; values, the Procedure returns without doing nothing. I'll code a real 24 bit colour count routine
; when I have some time. 

; Note that it doesn't change the format of the image, it's still a 24 bit image but with a reduced
; number of colours. 

; To use this example, just select an image clicking in the ButtonImageGadget, And launch the
; quantization pressing the space bar. 

; Comments And suggestions are welcome. 

Structure BoundingBox 
  Error.f 
  Low.w 
  Up.w 
  Direction.b 
EndStructure 

#UsedDepth = 31 

Procedure SetDepth(ImageID, PixelDepth) 
  Result = 0 
  GetObject_(ImageID, SizeOf(BITMAP), bm.BITMAP) 
  bmih.BITMAPINFOHEADER 
  bmih\biSize = SizeOf(BITMAPINFOHEADER) 
  bmih\biWidth = bm\bmWidth 
  bmih\biHeight = bm\bmHeight 
  bmih\biPlanes = 1 
  bmih\biBitCount = 32 
  bmih\biCompression = #BI_RGB 
  ImageBits = AllocateMemory(bmih\biWidth*bmih\biHeight*4) 
  WindowID = WindowID(0) 
  hDC = GetDC_(WindowID) 
  GetDIBits_(hDC, ImageID, 0, bmih\biHeight, ImageBits, bmih, 0) 
  ReleaseDC_(WindowID, hDC) 
  BMPSeeker = ImageBits 
  MaxColours = Pow(2, PixelDepth) 
  Global Dim Histogram($8000-1) ; 5/6/4? Otra combinacion? Basada en diferencias en la imagen? 
  For i=0 To bmih\biHeight-1                        ; Tener en cuenta al partir 
    For t=0 To bmih\biWidth-1 
      RGBColour = PeekL(BMPSeeker) 
      r = (RGBColour&$F8)<<7 
      g = (RGBColour&$F800)>>6 
      b = (RGBColour&$F80000)>>19 
      Histogram(r|g|b)+1 
      BMPSeeker+4 
    Next t 
  Next i 
  HColours = $8000-1 
  Global Dim Colours.w(HColours-1, 2) 
  i = 0 
  For r=0 To #UsedDepth 
    For g=0 To #UsedDepth 
      For b=0 To #UsedDepth 
        Colour = ((r<<10)|(g<<5)|b)&$7FFF 
        If Histogram(Colour) 
          Colours(i, 0) = Colour 
          i+1 
        EndIf 
      Next b 
    Next g 
  Next r 
  ImageColours = i-1 
  If ImageColours>MaxColours-1 
    i = 0 
    For g=0 To #UsedDepth 
      For b=0 To #UsedDepth 
        For r=0 To #UsedDepth 
          Colour = ((r<<10)|(g<<5)|b)&$7FFF 
          If Histogram(Colour) 
            Colours(i, 1) = Colour 
            i+1 
          EndIf 
        Next r 
      Next b 
    Next g 
    i = 0 
    For b=0 To #UsedDepth 
      For r=0 To #UsedDepth 
        For g=0 To #UsedDepth 
          Colour = ((r<<10)|(g<<5)|b)&$7FFF 
          If Histogram(Colour) 
            Colours(i, 2) = Colour 
            i+1 
          EndIf 
        Next g 
      Next r 
    Next b 
    Global Dim Region.BoundingBox(MaxColours-1) 
    CurrentRegion = 0 
    Region(CurrentRegion)\Low = 0 
    Region(CurrentRegion)\Up = ImageColours 
    LastHigh = 0 
    LastLow = 0 
    CurrentList = 0 
    Lastdiff.f = 0 
    For i=0 To 2 
      Low = (Colours(Region(CurrentRegion)\Low, i)>>((2-i)*5))&$1F 
      High = (Colours(Region(CurrentRegion)\Up, i)>>((2-i)*5))&$1F 
      Select i 
        Case 0 
          diff.f = (High-Low)*0.59 
        Case 1 
          diff.f = (High-Low)*0.30 
        Case 2 
          diff.f = (High-Low)*0.11 
      EndSelect 
      If diff>Lastdiff 
        CurrentList = i 
        Lastdiff = diff 
      EndIf 
    Next i 
    NewRegion = 1 
    Region(CurrentRegion)\Direction = %11 
    Global Dim leftvec.f(ImageColours) 
    Global Dim rightvec.f(ImageColours) 
    While NewRegion<MaxColours 
      l = Region(CurrentRegion)\Low 
      U = Region(CurrentRegion)\Up 
      If Region(CurrentRegion)\Direction&%1 
        LowR = #UsedDepth 
        LowG = #UsedDepth 
        LowB = #UsedDepth 
        HighR = 0 
        HighG = 0 
        HighB = 0 
        Popularity = 0 
        For i=l To U-1 
          Colour = Colours(i, CurrentList) 
          r = (Colour&$7C00)>>10 
          g = (Colour&$3E0)>>5 
          b = Colour&$1F 
          If r<LowR 
            LowR = r 
          EndIf 
          If r>HighR 
            HighR = r 
          EndIf 
          If g<LowG 
            LowG = g 
          EndIf 
          If g>HighG 
            HighG = g 
          EndIf 
          If b<LowB 
            LowB = b 
          EndIf 
          If b>HighB 
            HighB = b 
          EndIf 
          Popularity+Histogram(Colour) 
          SoR.f = (HighR-LowR)*0.59 
          SoG.f = (HighG-LowG)*0.30 
          SoB.f = (HighB-LowB)*0.11 
          leftvec(i) = Popularity*(Sqr(Pow(SoR, 2)+Pow(SoG, 2))+Pow(SoB, 2)) 
        Next i 
      EndIf 
      If Region(CurrentRegion)\Direction&%10 
        LowR = #UsedDepth 
        LowG = #UsedDepth 
        LowB = #UsedDepth 
        HighR = 0 
        HighG = 0 
        HighB = 0 
        Popularity = 0 
        For i=U To l+1 Step -1 
          Colour = Colours(i, CurrentList) 
          r = (Colour&$7C00)>>10 
          g = (Colour&$3E0)>>5 
          b = Colour&$1F 
          If r<LowR 
            LowR = r 
          EndIf 
          If r>HighR 
            HighR = r 
          EndIf 
          If g<LowG 
            LowG = g 
          EndIf 
          If g>HighG 
            HighG = g 
          EndIf 
          If b<LowB 
            LowB = b 
          EndIf 
          If b>HighB 
            HighB = b 
          EndIf 
          Popularity+Histogram(Colour) 
          SoR.f = (HighR-LowR)*0.59 
          SoG.f = (HighG-LowG)*0.30 
          SoB.f = (HighB-LowB)*0.11 
          rightvec(i) = Popularity*(Sqr(Pow(SoR, 2)+Pow(SoG, 2))+Pow(SoB, 2)) 
        Next i 
      EndIf 
      PreviousError = leftvec(l)+rightvec(l+1) 
      SplitPlace = l 
      For i=l To U-1 
        If leftvec(i)+rightvec(i+1)<PreviousError 
          PreviousError = leftvec(i)+rightvec(i+1) 
          SplitPlace = i 
        EndIf 
      Next i 
      If SplitPlace>l 
        Region(CurrentRegion)\Error = leftvec(SplitPlace) 
      Else 
        Region(CurrentRegion)\Error = 0 
      EndIf 
      Region(CurrentRegion)\Up = SplitPlace 
      Region(CurrentRegion)\Direction = %10 
      If SplitPlace<U-1 
        Region(NewRegion)\Error = rightvec(SplitPlace+1) 
      EndIf 
      Region(NewRegion)\Low = SplitPlace+1 
      Region(NewRegion)\Up = U 
      Region(NewRegion)\Direction = %1 
      LowC = 0 
      HighC = 0 
      For i=0 To 2 
        ThisL = CurrentList+i 
        If ThisL>2:ThisL-3:EndIf 
        LowC = (LowC<<5)|((Colours(l, CurrentList)>>((2-ThisL)*5))&$1F) 
        HighC = (HighC<<5)|((Colours(SplitPlace, CurrentList)>>((2-ThisL)*5))&$1F) 
      Next i 
      Global Dim belowList.w(U-l) 
      Global Dim aboveList.w(U-l) 
      List2 = CurrentList+1 
      If List2>2:List2-3:EndIf 
      List3 = List2+1 
      If List3>2:List3-3:EndIf 
      For d=1 To 2 
        aListIndex = 0 
        bListIndex = 0 
        RCLI = CurrentList+d 
        If RCLI>2:RCLI-3:EndIf 
        For i=l To U 
          OutBounds = 1 
          Colour = Colours(i, RCLI) 
          PColour = 0 
          For z=0 To 2 
            ThisL = CurrentList+z 
            If ThisL>2:ThisL-3:EndIf 
            PColour = (PColour<<5)|((Colour>>((2-ThisL)*5))&$1F) 
          Next z 
          If PColour>=LowC And PColour<=HighC 
            OutBounds = 0 
          EndIf 
          If OutBounds 
            aboveList(aListIndex) = Colour 
            aListIndex+1 
          Else 
            belowList(bListIndex) = Colour 
            bListIndex+1 
          EndIf 
        Next i 
        For i=0 To bListIndex-1 
          Colours(i+l, RCLI) = belowList(i) 
        Next i 
        For i=0 To aListIndex-1 
          Colours(i+l+bListIndex, RCLI) = aboveList(i) 
        Next i 
      Next d 
      For i=0 To NewRegion 
        If Region(i)\Error>Region(CurrentRegion)\Error 
          CurrentRegion = i 
        EndIf 
      Next i 
      Lastdiff.f = 0 
      For i=0 To 2 
        Low = (Colours(Region(CurrentRegion)\Low, i)>>((2-i)*5))&$1F 
        High = (Colours(Region(CurrentRegion)\Up, i)>>((2-i)*5))&$1F 
        Select i 
          Case 0 
            diff.f = (High-Low)*0.59 
          Case 1 
            diff.f = (High-Low)*0.30 
          Case 2 
            diff.f = (High-Low)*0.11 
        EndSelect 
        If diff>Lastdiff 
          CurrentList = i 
          Lastdiff = diff 
        EndIf 
      Next i 
      NewRegion+1 
    Wend 
    Global Dim leftvec.f(0) 
    Global Dim rightvec.f(0) 
    Global Dim belowList.w(0) 
    Global Dim aboveList.w(0) 
    Global Dim Palette(MaxColours-1) 
    PaletteIndex = 0 
    While PaletteIndex<MaxColours 
      AverageR.f = 0 
      AverageG.f = 0 
      AverageB.f = 0 
      ColoursNumber = 0 
      For i=Region(PaletteIndex)\Low To Region(PaletteIndex)\Up 
        Colour = Colours(i, 0)&$7FFF 
        r = (Colour&$7C00)>>10 
        g = (Colour&$3E0)>>5 
        b = Colour&$1F 
        AverageR+(r*Histogram(Colour)) 
        AverageG+(g*Histogram(Colour)) 
        AverageB+(b*Histogram(Colour)) 
        ColoursNumber+Histogram(Colour) 
        Histogram(Colour) = PaletteIndex 
      Next i 
      If ColoursNumber 
        AvR = Int(AverageR*8/ColoursNumber) 
        AvG = Int(AverageG*8/ColoursNumber) 
        AvB = Int(AverageB*8/ColoursNumber) 
        Palette(PaletteIndex) = ((AvB&$FF)<<16)|((AvG&$FF)<<8)|(AvR&$FF) 
      EndIf 
      PaletteIndex+1 
    Wend 
    Global Dim Colours.w(0, 0) 
    Global Dim Region.BoundingBox(0) 
    BMPSeeker = ImageBits 
    For i=0 To bmih\biHeight-1 
      For t=0 To bmih\biWidth-1 
        RGBColour = PeekL(BMPSeeker) 
        r = (RGBColour&$F8)<<7 
        g = (RGBColour&$F800)>>6 
        b = (RGBColour&$F80000)>>19 
        ; Dither aquí 
        PokeL(BMPSeeker, Palette(Histogram(r|g|b))) 
        BMPSeeker+4 
      Next t 
    Next i 
    Global Dim Histogram(0) 
    hDC = GetDC_(WindowID) 
    SetDIBits_(hDC, ImageID, 0, bmih\biHeight, ImageBits, bmih, 0) 
    ReleaseDC_(WindowID, hDC) 
    RedrawWindow_(WindowID, 0, 0, 7) 
    Result = 1 
  ElseIf ImageColours=MaxColours 
    BMPSeeker = ImageBits 
    For i=0 To bmih\biHeight-1 
      For t=0 To bmih\biWidth-1 
        RGBColour = PeekL(BMPSeeker) 
        RGBColour!%1110000011100000111 
        ; Dither aquí 
        PokeL(BMPSeeker, RGBColour) 
        BMPSeeker+4 
      Next t 
    Next i 
    hDC = GetDC_(WindowID) 
    SetDIBits_(hDC, ImageID, 0, bmih\biHeight, ImageBits, bmih, 0) 
    ReleaseDC_(WindowID, hDC) 
    RedrawWindow_(WindowID, 0, 0, 7) 
    Result = 1 
  EndIf 
  FreeMemory(ImageBits) 
  ProcedureReturn Result 
EndProcedure 

hWindow = OpenWindow(0, 0, 0, 320, 256, "Load picture example", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
If hWindow 
  FileName$ = OpenFileRequester("Open image", "", "All supported formats|*.bmp;*.ico;*.cur|BMP image (*.bmp)|*.bmp|Icon file (*.ico)|*.ico|Cursor file (*.cur)|*.cur", 0) 
  If FileName$ 
    CurrentDir$ = GetPathPart(FileName$) 
    ImageID = LoadImage(0, FileName$) 
    If CreateGadgetList(hWindow) 
      If ImageID 
        width = ImageWidth(0) 
        height = ImageHeight(0) 
        ImageGadget(0, 0, 0, width, height, ImageID) 
        ResizeWindow(0,#PB_Ignore,#PB_Ignore,width, height) 
        HideWindow(0, 0) 
        AddKeyboardShortcut(0, #PB_Shortcut_Space, 0) 
        SetForegroundWindow_(hWindow) 
        Repeat 
          EventID = WaitWindowEvent() 
          If EventID=#PB_Event_Gadget 
            Debug EventType()
            If EventType()=#PB_EventType_LeftClick
              FileName$ = OpenFileRequester("Open image", "", "All supported formats|*.bmp;*.ico;*.cur|BMP image (*.bmp)|*.bmp|Icon file (*.ico)|*.ico|Cursor file (*.cur)|*.cur", 0) 
              If FileName$ 
                CurrentDir$ = GetPathPart(FileName$) 
                FreeImage(0) 
                ImageID = LoadImage(0, FileName$) 
                If ImageID 
                  width = ImageWidth(0) 
                  height = ImageHeight(0) 
                  ResizeWindow(0,#PB_Ignore,#PB_Ignore,width, height) 
                  ResizeGadget(0, 0, 0, width, height) 
                  SetGadgetState(0, ImageID) 
                EndIf 
              EndIf 
            Else
              Debug "blub"
              SetDepth(ImageID(0), 8) 
            EndIf 
          EndIf
        Until EventID=#PB_Event_CloseWindow 
      EndIf 
    EndIf 
  EndIf 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP