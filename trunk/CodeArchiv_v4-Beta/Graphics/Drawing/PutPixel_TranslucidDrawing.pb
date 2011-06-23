; German forum: http://www.purebasic.fr/german/viewtopic.php?t=788&highlight=
; Author: Kekskiller (updated for PB 4.00 by Andre)
; Date: 06. November 2004
; OS: Windows
; Demo: Yes


; Kleine Transparenz-Bildengine
; -----------------------------
; Transparenz: 0 (unsichtbar) bis 1 (rübergelegt).
; Alles dazwischen ist entsprechend durchscheinend.

; Bitte (wer es kann) auf 32 bit umschalten, da sich somit die mögliche
; Farbpracht besser entfalten kann


;Putpixel - plots a translucid pixel
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;Ich weiss nicht genau, wie PutPixel
;in höheren Farbtiefen läuft, müsste
;aber im Prinzip relativ fehlerfrei
;laufen. Benutzung auf eigene Gefahr ;]
;
;best viewed in jaPBe

Global mx,my,z

Declare PutPixel(x.w,y.w, ired.w,igre.w,iblu.w, t.f)

; #ScreenWidth=1024
; #ScreenHeight=768

ExamineDesktops()
Global ScreenWidth  = DesktopWidth(0)
Global ScreenHeight = DesktopHeight(0)



Dim rect(20,4)
For z=1 To 20
  rect(z,0)=Random(ScreenWidth-50)
  rect(z,1)=Random(ScreenHeight-50)
  rect(z,2)=Random(100)+155
  rect(z,3)=Random(100)+155
  rect(z,4)=Random(100)+155
Next


InitSprite()
OpenScreen(640,480, 16, "test")
InitMouse()

Repeat
  ExamineMouse()
  ClearScreen(RGB(255,255,255))
  StartDrawing(ScreenOutput())
  DrawingMode(0)
  For z=1 To 20
    Box(rect(z,0),rect(z,1), 50,50, RGB(rect(z,2),rect(z,3),rect(z,4)))
  Next
  mx=MouseX()
  my=MouseY()
  DrawingMode(4)
  Box(mx-1,my-1, 42,42, 0)
  For zx=0 To 39
    For zy=0 To 39
      PutPixel(mx+zx,my+zy, 100,255,155, 0.5)
    Next
  Next
  StopDrawing()
  FlipBuffers()
Until MouseButton(1)

Procedure PutPixel(x.w,y.w, ired.w,igre.w,iblu.w, t.f)
  If x.w>=0 And y.w>=0 And x.w<ScreenWidth And y.w<ScreenHeight
    ocol.l = Point(x.w,y.w)
    ored.w = Red(ocol.l)
    ogre.w = Green(ocol.l)
    oblu.w = Blue(ocol.l)

    If ored.w<ired.w
      fred.w = ored.w + ( Abs(ored.w - ired.w) * t.f )
    ElseIf ored.w>ired.w
      fred.w = ired.w + ( Abs(ored.w - ired.w) * t.f )
    ElseIf ored.w=ired.w
      fred.w=ored.w
    EndIf

    If ogre.w<igre.w
      fgre.w = ogre.w + ( Abs(ogre.w - igre.w) * t.f )
    ElseIf ogre.w>igre.w
      fgre.w = igre.w + ( Abs(ogre.w - igre.w) * t.f )
    ElseIf ogre.w=igre.w
      fgre.w=ogre.w
    EndIf

    If oblu.w<iblu.w
      fblu.w = oblu.w + ( Abs(oblu.w - iblu.w) * t.f )
    ElseIf oblu.w>iblu.w
      fblu.w = iblu.w + ( Abs(oblu.w - iblu.w) * t.f )
    ElseIf oblu.w=iblu.w
      fblu.w=oblu.w
    EndIf

    Plot(x.w, y.w, RGB(fred.w,fgre.w,fblu.w))
  EndIf
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger