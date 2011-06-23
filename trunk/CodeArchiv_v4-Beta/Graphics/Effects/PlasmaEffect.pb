; English forum: 
; Author: webmatze (updated for PB 4.00 by Deeem2031)
; Date: 31. December 2002
; OS: Windows
; Demo: No


; converted from bb code
; edited by webmatze
; turn debugger off for performance..

#appWidth = 640
#appHeight= 480

Global Dim Palette.l(255)
Global Dim table.l(#appWidth, #appWidth)

; init
Procedure.l FP_Init()
  Shared *Screen.LONG, bufferadr.l, byte_pixel.b, byte_line.l

  StartDrawing(ScreenOutput())
  bufferadr.l = DrawingBuffer()
  byte_pixel.b = Round( ( DrawingBufferPixelFormat() + 1)/2, 1)
  byte_line.l = DrawingBufferPitch()
  StopDrawing()


  *Screen.LONG = bufferadr
  
  ProcedureReturn bufferadr
EndProcedure

Procedure SetupPalette()
  ; create a temporary image...
  CreateImage(0, #appWidth, #appHeight)
  ; ...to draw a nice colour-pattern onto it
  StartDrawing(ImageOutput(0))
    For i = 0 To 63
     LineXY(i,0,i,200, RGB(0, 0, i*4))
    Next

    For i = 0 To 127
     LineXY(i+64,0,i+64,200, RGB(0, (i/2)*4, 63*4))
    Next

    For i = 0 To 63
     LineXY(i+192,0,i+192,200,RGB(i*4, 63*4, 63*4))
    Next
  ; grab palette data
  For x = 0 To 255
    Palette(x) = Point(x,0)
  Next
  StopDrawing()

  ; clean-up
  FreeImage(0)
EndProcedure

Procedure PreCalc()
  For y = 0 To #appHeight-1
    For x = 0 To #appWidth-1
      If x = 0 And y = 0
        table(y,x) = 255
      Else
        table(y,x) = (450000000 / (Sqr(x*x + y*y) * 250000))
      EndIf
    Next
  Next
EndProcedure


If InitSprite() = 0
  End
EndIf

OpenWindow(0, 0, 0, #appWidth, #appHeight, "testing...", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, #appWidth, #appHeight, 0, 0 ,0)

If FP_Init() = 0 : End : EndIf

SetupPalette()
PreCalc()

halfW.l = #appWidth/2
halfH.l = #appHeight/2


Repeat

  If WindowEvent() = #PB_Event_CloseWindow
    quit.b = 1
  EndIf
  
  ; fps
  If GetTickCount_() => zeit + 1000 
    FrameSek = Frames 
    Frames = 0 
    zeit = GetTickCount_() 
  Else 
    Frames + 1 
  EndIf 

  FlipBuffers()

  cosAlfa.f = Cos (alfa.f)
  cosAlfam.f = Cos (-alfa)
  cosAlfa2.f = Cos (alfa*2)
  cosAlfam2.f = Cos (-alfa*2)
  sinAlfa.f = Sin (alfa)
  sinAlfam.f = Sin (-alfa)
  sinAlfa2.f = Sin (alfa*2)
  
  
  
  x1.f = 60 * cosAlfa  + 30 * sinAlfam  + halfW
  y1.f = 30 * cosAlfam2 + 60 * sinAlfa   + halfH
  x2.f = 30 * cosAlfa    + 60 * sinAlfa2 + halfW
  y2.f = 60 * cosAlfa    + 30 * sinAlfa   + halfH
  x3.f = 45 * cosAlfam   + 45 * sinAlfa   + halfW
  y3.f = 45 * cosAlfa2  + 45 * sinAlfam  + halfH
  x4.f = 75 * cosAlfa    + 15 * sinAlfa2 + halfW
  y4.f = 15 * cosAlfam   + 75 * sinAlfa2 + halfH
  x5.f = 35 * cosAlfa    + 10 * sinAlfa   + halfW
  y5.f = 10 * cosAlfa2  + 35 * sinAlfam  + halfH
  x6.f = 40 * cosAlfam   + 30 * sinAlfa2 + halfW
  y6.f = 40 * cosAlfa    + 10 * sinAlfa   + halfH


  alfa.f+0.05
  
  
  For y = 0 To #appHeight-1 Step 2
    a1.l = Abs(y1-y)
    a3.l = Abs(y2-y)
    a5.l = Abs(y3-y)
    a7.l = Abs(y4-y)
    a9.l = Abs(y5-y)
    a11.l = Abs(y6-y)
    *screen1.LONG = bufferadr + y*byte_line
    *screen2.LONG = *screen1 + byte_line
    For x = 0 To #appWidth-1 Step 2
        a2.l = Abs(x1-x)
        a4.l = Abs(x2-x)
        a6.l = Abs(x3-x)
        a8.l = Abs(x4-x)
       a10.l = Abs(x5-x)
       a12.l = Abs(x6-x)

      pixel.l = table(a1, a2) + table(a3, a4) + table(a5, a6) + table(a7,a8) + table(a9, a10) + table(a11, a12)
     
      If pixel>255
        pixel=255
      EndIf
      
      pixel = palette(pixel)
      
      *screen1\l = pixel
      
      *screen1 + byte_pixel
      *screen1\l = pixel

      *screen2\l = pixel
      
      *screen2 + byte_pixel
      *screen2\l = pixel
      
      *screen1 + byte_pixel
      *screen2 + byte_pixel

    Next
  Next

  StartDrawing(ScreenOutput())
    FrontColor(0)
    DrawingMode(0)
    DrawText(5,452,"FPS: "+Str(FrameSek))
  StopDrawing()

Until quit = 1

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger