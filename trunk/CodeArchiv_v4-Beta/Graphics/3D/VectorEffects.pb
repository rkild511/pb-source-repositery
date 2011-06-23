; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11628&highlight=
; Author: dllfreak2001
; Date: 14. January 2007
; OS: Windows
; Demo: Yes

; Usage:
; 1-9   = the different models
; Q     = automatic rotating
; A     = Range +
; Y     = Range -
; left and right     = rotate
; up and down        = rotate vertically


; Bedienung:
; 1-9   = sind verschiedene Models
; Q     = automatisches Rotieren
; A     = Range +
; Y     = Range -
; links und rechts   = drehen
; oben und unten     = vertikal verdrehen


;***Vectordreck***

InitSprite()
InitSprite3D()
InitKeyboard()
Global pi.f
pi = 3.141592
OpenScreen(800,600,32,"My Little Demo v1.0")
#cn = 6000
Dim rx.f(#cn)
Dim ry.f(#cn)
Dim fade.l(#cn)
Dim rad.f(#cn)
Dim spd.l(#cn)
Dim siz.l(#cn)
For x = 0 To #cn
  fade(x) = Random(15)+20
  siz(x) = 1
  rad(x) = Random(128)
  rx(x) = Random(360)
  ry(x) =Random(360)

  spd(x) = Random(16)-8
Next

CreateSprite(0,64,64,#PB_Sprite_Texture)

StartDrawing(SpriteOutput(0))
For x = 1 To 32
  Circle(31,31,32-x,RGB(0,x/1.2,x*2))
Next
For x = 1 To 64
  u = Random(1)
  beginx = Random(32)-16
  beginy = Random(32)-16
  co.l = Point(31+beginx,31+beginy)
  rd.l = Red(co)
  gd.l = Green(co)
  bd.l = Blue(co)
  For y = 1 To 16
    nx = Random(2)-1
    ny = Random(2)-1

    If beginx+nx > 32 Or beginx+nx <-32
      nx = -nx
    EndIf
    If beginy+ny > 32 Or beginy+ny < -32
      ny = -ny
    EndIf
    beginx +nx
    beginy +ny
    If d = 0
      rd= rd - 1
      gd= gd - 1
      bd= bd - 1
      If rd < 0
        rd = 0
      EndIf
      If gd < 0
        gd = 0
      EndIf
      If bd < 0
        bd = 0
      EndIf
    Else
      rd= rd+1
      gd= gd+1
      bd= bd +1
      If rd > 255
        rd = 255
      EndIf
      If gd > 255
        gd = 255
      EndIf
      If bd > 255
        bd = 255
      EndIf
    EndIf

    Plot(31+beginx,31+beginy,RGB(rd,gd,bd))
  Next
Next

StopDrawing()

CreateSprite3D(0,0)



a = 5
b = 7
Repeat

  ExamineKeyboard()
  rot + 1
  If rot > 359
    rot = 0
  EndIf
  If KeyboardPushed(#PB_Key_Up)
    For x = 0 To #cn
      rx(x) + 5
    Next
  EndIf


  If KeyboardPushed(#PB_Key_Down)
    For x = 0 To #cn
      rx(x) - 5
    Next
  EndIf

  If KeyboardPushed(#PB_Key_Left)

    For x = 0 To #cn
      ry(x)+5
    Next
  EndIf
  If KeyboardPushed(#PB_Key_Right)
    For x = 0 To #cn
      ry(x) -5
    Next

  EndIf

  If KeyboardPushed(#PB_Key_A)

    For x = 0 To #cn
      rad(x) + 5
    Next
  EndIf
  If KeyboardPushed(#PB_Key_Z)
    For x = 0 To #cn
      rad(x) - 5
    Next

  EndIf

  rat + 0.1
  If rat > 359
    rat = 0
  EndIf

  If gol = 1
    For x = 0 To #cn
      rx(x) = rx(x) + (Sin(2*pi*(rat/360))*rad(x))/100
      ry(x) = ry(x) + (Cos(2*pi*(rat/360))*rad(x))/50
    Next
  EndIf
  If KeyboardReleased(#PB_Key_Q)
    If gol = 0
      gol = 1
    Else
      gol = 0
    EndIf

  EndIf

  If KeyboardReleased(#PB_Key_F)
    a + 1
    If  a > 27
      a = 0
    EndIf
  EndIf
  If KeyboardReleased(#PB_Key_G)
    b + 1
    If  b > 27
      b = 0
    EndIf
  EndIf


  Start3D()
  Sprite3DBlendingMode(a,b)
  For x = 0 To #cn

    pz.f = rad(x)/(rad(x)-(Cos(2*pi*(ry(x)/360))*((Sin(2*pi*(rx(x)/360))*rad(x))/1.5)))
    py.f = Cos(2*pi*(rx(x)/360))*rad(x)*pz
    px.f = Sin(2*pi*(ry(x)/360))*(Sin(2*pi*(rx(x)/360))*rad(X))*pz

    ZoomSprite3D(0,(pz*20)+siz(x),(pz*20)+siz(x))
    RotateSprite3D(0,rot*spd(x),0)

    DisplaySprite3D(0,400+px-pz*10-siz(x)/2,300+py-pz*10-siz(x)/2,fade(x))
  Next
  Stop3D()
  StartDrawing(ScreenOutput())
  DrawText(0,0,StrF(pz,2)+"   A: " + Str(a)+" B: "+Str(b))
  StopDrawing()

  If KeyboardPushed(#PB_Key_Up)= 0 And  KeyboardPushed(#PB_Key_Down)= 0 And  KeyboardPushed(#PB_Key_Left)= 0 And  KeyboardPushed(#PB_Key_Right)= 0
    Select  KeyboardInkey()
      Case "1"
        For x = 0 To #cn


          rad(x) = Random(256)
          rx(x) = Random(4)*130 - rad(x)
          ry(x) = 90+Random(24)

          spd(x) = Random(16)-8
        Next
        Case"2"
        For x = 0 To #cn


          rad(x) = Random(256)
          rx(x) = Random(8)*45 - rad(x)
          ry(x) = 90+Random(24)

          spd(x) = Random(16)-8
        Next

        Case"3"
        For x = 0 To #cn


          rad(x) = Random(256)
          rx(x) = Random(360)
          ry(x) = 90+Random(12)

          spd(x) = Random(16)-8
        Next
        Case"4"
        For x = 0 To #cn


          rad(x) = Random(256)
          rx(x) = Random(3)*120
          ry(x) = 90+Random(12)

          spd(x) = Random(16)-8
        Next
        Case"5"
        For x = 0 To #cn


          rad(x) = Random(256)
          rx(x) = 90
          ry(x) = Random(360)

          spd(x) = Random(16)-8
        Next

        Case"6"
        For x = 0 To #cn


          rad(x) = 256-Random(48)
          rx(x) = Random(360)
          ry(x) = 90

          spd(x) = Random(16)-8
        Next

        Case"7"
        For x = 0 To #cn


          rad(x) = 256
          rx(x) = Random(180)
          ry(x) = Random(180)

          spd(x) = Random(32)-16
        Next

        Case"8"
        For x = 0 To #cn


          rad(x) = Random(256)
          rx(x) = Random(30)
          ry(x) = Random(30)

          spd(x) = Random(32)-16
        Next
        Case"9"
        For x = 0 To #cn


          rad(x) = 44
          rx(x) = Random(30)
          ry(x) = Random(120)

          spd(x) = Random(32)-16
        Next
    EndSelect
  EndIf

  FlipBuffers()
  ClearScreen(0)
Until KeyboardPushed(#PB_Key_Escape)
CloseScreen()
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP