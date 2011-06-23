; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3499
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 20. January 2004
; OS: Windows
; Demo: Yes


; Modified Lorenz Attractor - example 1
; Modifiziertes Lorenz-Attraktor - Beispiel 1

; Some ideas taken from:
; http://astronomy.swin.edu.au/~pbourke/fractals/

ExamineDesktops()
sx=DesktopWidth(0)
sy=DesktopHeight(0)
sd=32

InitSprite()
InitKeyboard()

Define.f  x0,y0,z0,x1,y1,z1
h.f=0.01
a.f=10.0
b.f=28.0
c.f=8.0/3.0

n=10000
x0=0.1
y0=0
z0=0

If OpenScreen(sx,sy,sd,"Lorenz")
  Repeat
    ExamineKeyboard()

    FlipBuffers()
    ClearScreen(RGB(0,0,0))

    If KeyboardPushed(#PB_Key_Right)
      a.f+0.1
    ElseIf KeyboardPushed(#PB_Key_Left)
      a.f-0.1
    ElseIf KeyboardPushed(#PB_Key_Up)
      b.f+0.1
    ElseIf KeyboardPushed(#PB_Key_Down)
      b.f-0.1
    ElseIf KeyboardPushed(#PB_Key_PageUp)
      c.f+0.1
    ElseIf KeyboardPushed(#PB_Key_PageDown)
      c.f-0.1
    EndIf


    StartDrawing(ScreenOutput())
    For i=0 To n-1
      x1=x0+h*a*(y0-x0)
      y1 = y0 + h * (x0 * (b - z0) - y0);
      z1 = z0 + h * (x0 * y0 - c * z0)
      x0 = x1
      y0 = y1
      z0 = z1

      xp=x0*10+Round(sx/2,1)
      yp=y0*10+Round(sy/2,1)
      If (i>100) And xp>0 And xp<sx And yp>0 And yp<sy
        Plot(xp,yp,i/100*16777000)
      EndIf
    Next
    StopDrawing()

    Delay(5)
  Until KeyboardPushed(1)
  CloseScreen()

Else
  MessageRequester("Error","Can't open screen",0)
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -