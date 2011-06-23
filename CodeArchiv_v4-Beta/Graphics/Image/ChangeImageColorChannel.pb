; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=719&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 22. April 2003
; OS: Windows
; Demo: No


; Example how to change each of the RGB colors in an image...
; -----------
; Kleines Beispiel wie man die RGB-Farben in einem Bild einzeln 
; ändern kann. Sozusagen ein RGB-Filter. 

; 
; by Danilo, 22.04.2003 - german forum 
; 
; 
Procedure ChangeImageColorChannel(SourceImage,DestImage,Red,Green,Blue) 
  ;> 
  ;> OriginalImage  = number of Source Image 
  ;> DestImage      = number of New Image that gets changed (must be same size!) 
  ;> 
  ;> Red,Green,Blue = How much change this color channel ? 
  ;>                  -255 -> Reduce color completely (fade out color) 
  ;>                     0 -> dont touch, change nothing 
  ;>                   255 -> add color to color channel (fade in) 
  ;> 
  Structure _CIC_BITMAPINFO 
    bmiHeader.BITMAPINFOHEADER 
    bmiColors.RGBQUAD[1] 
  EndStructure 

  Structure _CIC_LONG 
   l.l 
  EndStructure 

  If ImageID(SourceImage)=0 Or ImageID(DestImage)=0 
    ProcedureReturn 0 
  EndIf 

  hBmp = ImageID(SourceImage) 
  hDC  = StartDrawing(ImageOutput(SourceImage)) 
  If hDC 
    ImageWidth1  = ImageWidth(SourceImage) : ImageHeight1 = ImageHeight(SourceImage) 
    mem = GlobalAlloc_(#GMEM_FIXED|#GMEM_ZEROINIT,ImageWidth1*ImageHeight1*4) 
    If mem 
      bmi._CIC_BITMAPINFO 
      bmi\bmiHeader\biSize   = SizeOf(BITMAPINFOHEADER) 
      bmi\bmiHeader\biWidth  = ImageWidth1 
      bmi\bmiHeader\biHeight = ImageHeight1 
      bmi\bmiHeader\biPlanes = 1 
      bmi\bmiHeader\biBitCount = 32 
      bmi\bmiHeader\biCompression = #BI_RGB 
      If GetDIBits_(hDC,hBmp,0,ImageHeight1,mem,bmi,#DIB_RGB_COLORS) <> 0 
        StopDrawing() 
        hBmp = ImageID(DestImage) 
        hDC = StartDrawing(ImageOutput(DestImage)) 
        If hDC 
            
           *pixels._CIC_LONG = mem 
           For a = 1 To ImageWidth1*ImageHeight1 
              
             RED2  = (*pixels\l >>16) & $FF 
             GREEN2= (*pixels\l >> 8) & $FF 
             BLUE2 = (*pixels\l     ) & $FF 
              
             If RED2 < Red And Red>0 
               RED2 = Red 
             ElseIf Red<0 
               RED2 = RED2+Red 
               If RED2<0:RED2=0:EndIf 
             EndIf 

             If GREEN2 < GREEN And GREEN>0 
               GREEN2 = GREEN 
             ElseIf GREEN<0 
               GREEN2 = GREEN2+GREEN 
               If GREEN2<0:GREEN2=0:EndIf 
             EndIf 

             If BLUE2 < BLUE And BLUE>0 
               BLUE2 = BLUE 
             ElseIf BLUE<0 
               BLUE2 = BLUE2+BLUE 
               If BLUE2<0:BLUE2=0:EndIf 
             EndIf 

             *pixels\l = (RED2<<16)|(GREEN2<<8)|(BLUE2) 
             *pixels + 4 
           Next a 

          If SetDIBits_(hDC,hBmp,0,ImageHeight1,mem,bmi,#DIB_RGB_COLORS) <> 0 
            Result = 1 
          EndIf 
        EndIf 
        StopDrawing() 
      EndIf 
      GlobalFree_(mem) 
    Else 
      StopDrawing() 
    EndIf 
  Else 
    StopDrawing() 
  EndIf 
  ProcedureReturn Result 
EndProcedure 


;- PROGRAM START 

UseJPEGImageDecoder() 
UsePNGImageDecoder() 
UseTIFFImageDecoder() 
UseTGAImageDecoder() 

;FileName$ = OpenFileRequester("SELECT IMAGE","","BMP|*.bmp",0) 
FileName$ = OpenFileRequester("SELECT IMAGE","","Image Files|*.bmp;*.jpg;*.jpeg;*.png;*.tiff;*.tga|All Files|*.*",0) 
;Filename$ = "Test.bmp" 
If FileName$ 
  If LoadImage(1,FileName$) 
    ImageWidth  = ImageWidth(1) 
    ImageHeight = ImageHeight(1) 
    If ImageWidth >800:ImageWidth =800:Resize=1:EndIf 
    If ImageHeight>600:ImageHeight=600:Resize=1:EndIf 
    If Resize 
      ResizeImage(1,ImageWidth,ImageHeight) 
    EndIf 
    
    If CreateImage(2,ImageWidth,ImageHeight) 
      WinWidth  = ImageWidth+140 
      WinHeight = ImageHeight : If WinHeight < 300:WinHeight=300:EndIf 
      OpenWindow(0,0,0,WinWidth,WinHeight,"Image",#PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_Invisible) 
        CreateGadgetList(WindowID(0)) 
        TrackBarGadget(1,ImageWidth+10,18,40,250,0,255*2,#PB_TrackBar_Vertical):SetGadgetState(1,255) 
        TrackBarGadget(2,ImageWidth+50,18,40,250,0,255*2,#PB_TrackBar_Vertical):SetGadgetState(2,255) 
        TrackBarGadget(3,ImageWidth+90,18,40,250,0,255*2,#PB_TrackBar_Vertical):SetGadgetState(3,255) 
        TextGadget(8,ImageWidth+10,270,40,20,"R:  000") 
        TextGadget(9,ImageWidth+50,270,40,20,"G:  000") 
        TextGadget(0,ImageWidth+90,270,40,20,"B:  000") 
        ImageGadget(7,0,0,WinWidth-140,ImageHeight,ImageID(1)) 
      HideWindow(0,0):SetForegroundWindow_(WindowID(0)) 
        ;- PROGRAM EVENT LOOP 
        Repeat 
          Select WaitWindowEvent() 
            Case #PB_Event_CloseWindow:End 
            Case #PB_Event_Gadget 
              Gadget = EventGadget() 
              Select Gadget 
                Case 1:RED   = GetGadgetState(1)-255:SetGadgetText(8,"R: "+RSet(Str(RED  ),4," ")):ChangeImageColorChannel(1,2,RED,GREEN,BLUE):SetGadgetState(7,ImageID(2)) 
                Case 2:GREEN = GetGadgetState(2)-255:SetGadgetText(9,"G: "+RSet(Str(GREEN),4," ")):ChangeImageColorChannel(1,2,RED,GREEN,BLUE):SetGadgetState(7,ImageID(2)) 
                Case 3:BLUE  = GetGadgetState(3)-255:SetGadgetText(0,"B: "+RSet(Str(BLUE ),4," ")):ChangeImageColorChannel(1,2,RED,GREEN,BLUE):SetGadgetState(7,ImageID(2)) 
              EndSelect 
          EndSelect 
        ForEver 
    Else 
      MessageRequester("ERROR","Cant create image!",#MB_ICONERROR) 
    EndIf 
  Else 
    MessageRequester("ERROR","Cant load image!",#MB_ICONERROR) 
  EndIf 
EndIf 
;-PROGRAM END

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
