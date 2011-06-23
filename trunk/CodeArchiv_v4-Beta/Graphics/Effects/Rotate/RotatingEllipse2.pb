; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5129&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 22. July 2004
; OS: Windows
; Demo: No


;Beispiel: Offene Ellipsen die sich dank Stefan Moebius auch drehen.
OpenWindow(0,20,20,600,600,"test",#PB_Window_SystemMenu)
Repeat

  HDC=GetWindowDC_(WindowID(0))
  HPen=CreatePen_(#PS_SOLID,3,RGB(Random(255),Random(255),Random(255)))
  SelectObject_(HDC,HPen)

  Trans.XFORM

  If Winkel.f<3
    Winkel+0.1;+0.1;Winkel im Bogenmaß
  Else
    Winkel = 0
  EndIf

  Trans\eM11=Cos(Winkel.f)
  Trans\eM12=Sin(Winkel.f)
  Trans\eM21=-Sin(Winkel.f)
  Trans\eM22=Cos(Winkel.f)

  ;Rotationsmittelpunkt
  Trans\ex=300
  Trans\ey=300

  SetGraphicsMode_(HDC,#GM_ADVANCED)
  SetWorldTransform_(HDC,Trans)


  Arc_(HDC,-50,-200,50,200,0,0,0,0)
  DeleteObject_(HPen)
  ReleaseDC_(WindowID(0),HDC)
  Delay(10)
Until WindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -