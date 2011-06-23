; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5129&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 22. July 2004
; OS: Windows
; Demo: No


;Beispiel: Einzelne drehende Ellipse
OpenWindow(0,20,20,600,600,"test",#PB_Window_SystemMenu)
Deskfarbe.l=GetSysColor_(#COLOR_ACTIVEBORDER)
HDC.l=GetWindowDC_(WindowID(0))
Repeat
  ;bcol.l=GetSysColor_(#COLOR_ACTIVEBORDER )


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
  HPen.l=CreatePen_(#PS_SOLID,4,RGB(Random(255),Random(255),Random(255)))
  SelectObject_(HDC,HPen)

  Arc_(HDC,-50,-200,50,200,0,0,0,0)
  DeleteObject_(HPen)
  HPen=CreatePen_(#PS_SOLID,5,Deskfarbe)
  SelectObject_(HDC,HPen)
  Delay(500)
  Arc_(HDC,-50,-200,50,200,0,0,0,0)

  DeleteObject_(HPen)
  Delay(10)
Until WindowEvent()=#PB_Event_CloseWindow

ReleaseDC_(WindowID(0),HDC)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -