; French forum: http://purebasic.hmt-forum.com/viewtopic.php?t=2997
; Author: Dr. Dri (updated for PB 4.00 by Andre)
; Date: 04. November 2005
; OS: Windows
; Demo: Yes

Procedure SpriteCollisionLocation(Sprite1.l, x1.l, y1.l, Sprite2.l, x2.l, y2.l, *location.POINTS)
  Protected w1.l, h1.l, w2.l, h2.l
  Protected xl.l, xr.l, yt.l, yb.l
  Protected x.l, y.l, u.l, v.l, yy.l, vv.l
  Protected i.l, j.l, cx.l, cy.l, nb.l, collision.l

  w1 = SpriteWidth (Sprite1)
  h1 = SpriteHeight(Sprite1)
  w2 = SpriteWidth (Sprite2)
  h2 = SpriteHeight(Sprite2)

  collision = #True

  If x1 < x2
    If (x1 + w1) > x2
      xl = x2
      u  =  0
      x  = xl - x1
    Else
      collision = #False
    EndIf
  Else
    If (x2 + w2) > x1
      xl = x1
      x  =  0
      u  = xl - x2
    Else
      collision = #False
    EndIf
  EndIf

  If y1 < y2
    If (y1 + h1) > y2
      yt = y2
      v  =  0
      y  = yt - y1
    Else
      collision = #False
    EndIf
  Else
    If (y2 + h2) > y1
      yt = y1
      y  =  0
      v  = yt - y2
    Else
      collision = #False
    EndIf
  EndIf

  If collision = #True

    If (x1 + w1) < (x2 + w2)
      xr = x1 + w1
    Else
      xr = x2 + w2
    EndIf

    If (y1 + h1) < (y2 + h2)
      yb = y1 + h1
    Else
      yb = y2 + h2
    EndIf

    xr - 1
    yb - 1
    w1 - 1
    h1 - 1
    w2 - 1
    h2 - 1
  EndIf

  If collision = #True
    Dim pt1.l(w1, h1)
    If StartDrawing( SpriteOutput(Sprite1) )
      For i = xl To xr
        For j = yt To yb
          pt1(i-xl+x, j-yt+y) = Point(i-xl+x, j-yt+y)
        Next j
      Next i
      StopDrawing()
    Else
      collision = #False
    EndIf
  EndIf

  If collision = #True
    Dim pt2.l(w2, h2)
    If StartDrawing( SpriteOutput(Sprite2) )
      For i = xl To xr
        For j = yt To yb
          pt2(i-xl+u, j-yt+v) = Point(i-xl+u, j-yt+v)
        Next j
      Next i
      StopDrawing()
    Else
      collision = #False
    EndIf
  EndIf

  If collision = #True
    yy = y
    vv = v

    For i = xl To xr
      y = yy
      v = vv
      For j = yt To yb

        If pt1(x, y) And pt2(u, v)
          cx + i
          cy + j
          nb + 1
        EndIf

        y + 1
        v + 1
      Next j
      x + 1
      u + 1
    Next i

    If nb > 0 And *location
      *location\x = cx / nb
      *location\y = cy / nb
    EndIf

  EndIf

  ProcedureReturn nb
EndProcedure

InitSprite()
InitMouse()
InitKeyboard()

x = 500
y = 500

ExamineDesktops()
If OpenScreen(DesktopWidth(0), DesktopHeight(0), DesktopDepth(0), "")

  TransparentSpriteColor(#PB_Default, RGB(0, 0, 0))

  CreateSprite(0, 320, 240)
  CreateSprite(1,  60,  60)
  CreateSprite(2,   3,   3)

  If StartDrawing( SpriteOutput(0) )
    Ellipse(160, 120, 160, 120, $0000FF)
    Ellipse(160, 120,  80,  60, $000000)
    StopDrawing()
  EndIf

  If StartDrawing( SpriteOutput(1) )
    Circle( 0, 30, 30, $00FF00)
    Circle(60, 30, 30, $00FF00)
    Circle(30, 30, 20, $000000)
    StopDrawing()
  EndIf

  If StartDrawing( SpriteOutput(2) )
    Box(0, 0, 3, 3, $FF0000)
    StopDrawing()
  EndIf

  Repeat
    ExamineMouse()
    ExamineKeyboard()
    ClearScreen(RGB(0, 0, 0))

    x + MouseDeltaX()
    y + MouseDeltaY()

    DisplayTransparentSprite(0, 80, 80)
    DisplayTransparentSprite(1,  x,  y)

    If SpriteCollisionLocation(0, 80, 80, 1, x, y, @Location.POINTS)
      DisplaySprite(2, Location\x-1, Location\y-1)
    EndIf

    FlipBuffers()
  Until KeyboardPushed(#PB_Key_Escape)

  CloseScreen()
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger