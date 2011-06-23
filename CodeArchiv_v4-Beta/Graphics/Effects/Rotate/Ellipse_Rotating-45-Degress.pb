; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5129&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 26. July 2004
; OS: Windows
; Demo: No


; Beispiel: Elipse, die sich jetzt in 45Grad-Schritten dreht:)
; ------------------------------------------------------------
; Drehung in einem bestimmten Winkel: hier kann man jetzt den Winkelschritt
; in Grad vorgeben. In diesem Beispiel dreht sich die Ellipse alle 45 Grad
; und bei Erreichen von 360Grad wird der Zähler zurück gesetzt.


#Grad=45
OpenWindow(0,20,20,600,600,"Ellipse in 45Grad-Schritten drehen",#PB_Window_SystemMenu)
Deskfarbe.l=GetSysColor_(#COLOR_ACTIVEBORDER)
HDC.l=GetWindowDC_(WindowID(0))
Repeat
  event = WindowEvent()

  If event = #PB_Event_CloseWindow
    End
  Else
    ;bcol.l=GetSysColor_(#COLOR_ACTIVEBORDER )
    Bogenmass.f=(#Grad*#PI)/180; Winkel in 45 Grad-Schritten

    Trans.XFORM

    If Winkel.f<(#Grad*7*#PI)/180; Einmal herumgedreht?
      Winkel+Bogenmass;45Grad-Winkel-Schritte im Bogenmaß
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
  EndIf
ForEver

ReleaseDC_(WindowID(0),HDC)
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -