; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13198&highlight=
; Author: griz (updated by El_Choni, updated for PB 4.00 by Andre)
; Date: 24. November 2004
; OS: Windows
; Demo: No


; Anti -Aliased line demo by Griz Nov 2004

ExamineDesktops()

Global Done               : Done = #False
Global ScreenWidth        : ScreenWidth = DesktopWidth(0)
Global screenheight       : ScreenHeight = DesktopHeight(0)
Global ScreenDepth        : ScreenDepth = DesktopDepth(0)
Global Radius             : Radius = ScreenWidth/4
Global CircleAX           : CircleAX = Radius
Global CircleAY           : CircleAY = Radius+2
Global CircleBX           : CircleBX = Radius*3-2
Global CircleBY           : CircleBY = Radius+2
Global Angle.f            : Angle = 3.1416
Global Lcol               : Lcol = $FFFFFF
Global ScreenShot         : Screen_Shot = #False
Global Fps.f              : Fps = 0.0
Global FpsTimerCount      : FpsTimerCount = 0
Global CurrentFps.f       : CurrentFps = 0.0
Global FpsTimer           : FpsTimer = ElapsedMilliseconds()


; Here is a bit of code I ported from Blitz a while ago.
; It draws anti-aliased lines. It's FAR slower than the
; built-in PB lineXY() command.
Procedure MergePixel(x, y, r, g, b, w)
  col = Point(x, y):r2 = col&$FF
  g2 = (col&$FF00)>>8:b2 = (col&$FF0000)>>16
  rnew = ((r*w)>>8)+((r2*(255-w))>>8)
  gnew = ((g*w)>>8)+((g2*(255-w))>>8)
  bnew = ((b*w)>>8)+((b2*(255-w))>>8)
  Plot(x, y, (rnew&$FF)|(gnew<<8)|(bnew<<16))
EndProcedure

Procedure AntiLineXY(x1, y1, x2, y2, col)
  r = col&$FF
  g = (col&$FF00)>>8
  b = (col&$FF0000)>>16
  Plot(x1, y1, col)
  Plot(x2, y2, col)
  xd = x2-x1
  yd = y2-y1
  If (xd=0 Or yd=0)
    LineXY(x1, y1, x2, y2)
    ProcedureReturn
  EndIf
  If Abs(xd)>Abs(yd)
    If (x1>x2)
      tmp = x1: x1 = x2: x2 = tmp
      tmp = y1: y1 = y2: y2 = tmp
      xd = x2-x1
      yd = y2-y1
    EndIf
    grad = yd<<16/xd
    yf = y1<<16
    For x=x1+1 To x2-1
      yf+grad
      w = (yf>>8)&$FF
      y = yf>>16
      MergePixel(x, y, r, g, b, 255-w)
      MergePixel(x, y+1, r, g, b, w)
    Next
  Else
    If (y1>y2)
      tmp = x1: x1 = x2: x2 = tmp
      tmp = y1: y1 = y2: y2 = tmp
      xd = x2-x1
      yd = y2-y1
    EndIf
    grad = xd<<16/yd
    xf = x1<<16
    For y=y1+1 To y2-1
      xf+grad
      w = (xf>>8)&$FF
      x = xf>>16
      MergePixel(x , y, r, g, b, 255-w)
      MergePixel(x+1, y, r, g, b, w)
    Next
  EndIf
EndProcedure

; initialize direct X
If InitSprite()=0 Or InitKeyboard()=0
  MessageRequester("Error", "Can't Open Direct X!", 0)
  End
EndIf

; open full screen
If OpenScreen(screenwidth, screenheight, screendepth, "Antialiased Line Demo")=0
  MessageRequester("Error", "Can't Open Screen!", 0)
  End
EndIf

#speed = 0.03
#radia = 32
#inter = 6.2832/#radia

Repeat
  ExamineKeyboard()
  If KeyboardPushed(#PB_Key_Escape)
    Done = #True
  EndIf
  FlipBuffers()
  ClearScreen(RGB(0, 0, 0))
  StartDrawing(ScreenOutput())
  ; draw lines
  a2.f = 0
  While a2<6.2832
    a3.f = a2+Angle
    LineXY(CircleAX, CircleAY, CircleAX-Radius*Cos(a3), CircleAY-Radius*Sin(a3), Lcol)
    AntiLineXY(CircleBX, CircleBY, CircleBX-Radius*Cos(a3), CircleBY-Radius*Sin(a3), Lcol)
    a2+#inter
  Wend
  ; draw frames per second
  DrawingMode(1)
  FrontColor(RGB(128, 128, 128))
  DrawText(CircleAX-TextWidth("Non-antialiased")/2, CircleAY*2, "Non-antialiased")
  DrawText(CircleBX-TextWidth("Antialiased")/2, CircleAY*2, "Antialiased")
  Status$="fps = "+Str(CurrentFps)
  DrawText((CircleBX-CircleAX)-(TextWidth(status$)/2), CircleAY*2, status$)
  StopDrawing()
  If Done=#True And ScreenShot=#True
    g = GrabSprite(#PB_Any, 0, 0, ScreenWidth, ScreenHeight)
    SaveSprite(g, "out.bmp")
    FreeSprite(g)
  EndIf
  Angle+#speed
  If Angle>6.2832:Angle-6.2832:EndIf
  Fps+1
  FpsTimerCount = ElapsedMilliseconds()
  If FpsTimerCount-FpsTimer=>1000
    CurrentFps = Fps
    Fps = 0
    FpsTimer = ElapsedMilliseconds()
  EndIf
Until done=#True
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger