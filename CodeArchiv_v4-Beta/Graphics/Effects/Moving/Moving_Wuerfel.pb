; German forum:
; Author: Deeém2031 (updated for PB4.00 by blbltheworm)
; Date: 22. March 2003
; OS: Windows
; Demo: Yes

; Was noch kommen soll: 
; - Automatisches erkennen der Überlappung von Dreiecken -> richtiges Darstellen 
; - Texturen 
; - Kontrollieren ob das Dreieck (die Linie) hinter einem liegt -> nicht zeichnen 
; - Das Zeichnen nicht nur in Kavalierperspektive 

; (Das Kommentar steht immer vor der Sache die es beschreibt) 

Procedure d_triangle(x1.l,y1.l,x2.l,y2.l,x3.l,y3.l) 
  Global Dim punkte.l(2,1) 
  ; Sortieren der Punkte 
  If y1 <= y2 And y1 <= y3 
    punkte(0,1) = y1 
    punkte(0,0) = x1 
    If y2 <= y3 
      punkte(1,1) = y2 
      punkte(1,0) = x2 
      punkte(2,1) = y3 
      punkte(2,0) = x3 
    Else 
      punkte(1,1) = y3 
      punkte(1,0) = x3 
      punkte(2,1) = y2 
      punkte(2,0) = x2 
    EndIf 
  EndIf 
  If y2 < y1 And y2 <= y3 
    punkte(0,1) = y2 
    punkte(0,0) = x2 
    If y1 <= y3 
      punkte(1,1) = y1 
      punkte(1,0) = x1 
      punkte(2,1) = y3 
      punkte(2,0) = x3 
    Else 
      punkte(1,1) = y3 
      punkte(1,0) = x3 
      punkte(2,1) = y1 
      punkte(2,0) = x1 
    EndIf 
  EndIf 
  If y3 < y2 And y3 < y1 
    punkte(0,1) = y3 
    punkte(0,0) = x3 
    If y1 < y2 
      punkte(1,1) = y1 
      punkte(1,0) = x1 
      punkte(2,1) = y2 
      punkte(2,0) = x2 
    Else 
      punkte(1,1) = y2 
      punkte(1,0) = x2 
      punkte(2,1) = y1 
      punkte(2,0) = x1 
    EndIf 
  EndIf 
  ; Malen des Dreiecks (Teil 1) 
  s1.f = (punkte(2,0)-punkte(0,0))/(punkte(2,1)-punkte(0,1)) 
  If punkte(0,1) < punkte(1,1) 
  s2.f = (punkte(1,0)-punkte(0,0))/(punkte(1,1)-punkte(0,1)) 
  For y = punkte(0,1) To punkte(1,1) 
    lx1.l = punkte(0,0)+Round(s1*(y-punkte(0,1)),0) 
    lx2.l = punkte(0,0)+Round(s2*(y-punkte(0,1)),0) 
    LineXY(lx1,y,lx2,y) 
  Next y 
  EndIf 
  ; Malen des Dreiecks (Teil 2) 
  If punkte(1,1) < punkte(2,1) 
  s3.f = (punkte(2,0)-punkte(1,0))/(punkte(2,1)-punkte(1,1)) 
  For y = punkte(1,1) To punkte(2,1) 
    lx1.l = punkte(0,0)+Round(s1*(y-punkte(0,1)),0) 
    lx2.l = punkte(2,0)+Round(s3*(y-punkte(2,1)),0) 
    LineXY(lx1,y,lx2,y) 
  Next y 
  EndIf 
EndProcedure 

Procedure d_init3d(scrw.w,scrh.w) ;scrw = Screenwidth ; scrh = Screenheight 
  ; sin und cos in Array schreiben 
  Global Dim _sin.f(360) 
  Global Dim _cos.f(360) 
  For x = 0 To 360 
    _sin(x) = Sin(x/(180/3.141)) 
    _cos(x) = Cos(x/(180/3.141)) 
  Next x 
  ; Die Bildschirmgröße verarbeiten 
  Global scrw2.w 
  Global scrh2.w 
  scrw2.w = Round((scrw/2),0) 
  scrh2.w = Round((scrh/2),0) 
EndProcedure 

Procedure d_line3d(x1.f,y1.f,z1.f,x2.f,y2.f,z2.f,wx.w,wy.w,wz.w) 
  ; Drehung berechnen 
  xx.f = _Cos(wy) * _cos(wz) * x1 - _cos(wy) * _sin(wz) * y1 + _sin(wy) * z1 
  yy.f = (_cos(wx) * _sin(wz) + _sin(wx) * _sin(wy) * _cos(wz)) * x1 + (_cos(wx) * _cos(wz) - _sin(wx) * _sin(wy) * _sin(wz)) * y1 - _sin(wx) * _cos(wy) * z1 
  zz.f = (_sin(wx) * _sin(wz) - _cos(wx) * _sin(wy) * _cos(wz)) * x1 + (_sin(wx) * _cos(wz) + _cos(wx) * _sin(wy) * _sin(wz)) * y1 + _cos(wx) * _cos(wy) * z1 
  xx2.f = _cos(wy) * _cos(wz) * x2 - _cos(wy) * _sin(wz) * y2 + _sin(wy) * z2 
  yy2.f = (_cos(wx) * _sin(wz) + _sin(wx) * _sin(wy) * _cos(wz)) * x2 + (_cos(wx) * _cos(wz) - _sin(wx) * _sin(wy) * _sin(wz)) * y2 - _sin(wx) * _cos(wy) * z2 
  zz2.f = (_sin(wx) * _sin(wz) - _cos(wx) * _sin(wy) * _cos(wz)) * x2 + (_sin(wx) * _cos(wz) + _cos(wx) * _sin(wy) * _sin(wz)) * y2 + _cos(wx) * _cos(wy) * z2 
  ; Weiß nicht warum (muss aber) 
  yy = -yy 
  yy2 = -yy2 
  ; 1. In 2D-Coordianten umwandeln 2. Malen 
  LineXY(Round(xx-zz/2.828,0)+scrw2,Round(yy-zz/2.828,0)+scrh2,Round(xx2-zz2/2.828,0)+scrw2,Round(yy2-zz2/2.828,0)+scrh2) 
EndProcedure 

Procedure d_triangle3d(x1.f,y1.f,z1.f,x2.f,y2.f,z2.f,x3.f,y3.f,z3.f,wx.w,wy.w,wz.w) 
  ; Drehung berechnen 
  xx.f = _Cos(wy) * _cos(wz) * x1 - _cos(wy) * _sin(wz) * y1 + _sin(wy) * z1 
  yy.f = (_cos(wx) * _sin(wz) + _sin(wx) * _sin(wy) * _cos(wz)) * x1 + (_cos(wx) * _cos(wz) - _sin(wx) * _sin(wy) * _sin(wz)) * y1 - _sin(wx) * _cos(wy) * z1 
  zz.f = (_sin(wx) * _sin(wz) - _cos(wx) * _sin(wy) * _cos(wz)) * x1 + (_sin(wx) * _cos(wz) + _cos(wx) * _sin(wy) * _sin(wz)) * y1 + _cos(wx) * _cos(wy) * z1 
  xx2.f = _cos(wy) * _cos(wz) * x2 - _cos(wy) * _sin(wz) * y2 + _sin(wy) * z2 
  yy2.f = (_cos(wx) * _sin(wz) + _sin(wx) * _sin(wy) * _cos(wz)) * x2 + (_cos(wx) * _cos(wz) - _sin(wx) * _sin(wy) * _sin(wz)) * y2 - _sin(wx) * _cos(wy) * z2 
  zz2.f = (_sin(wx) * _sin(wz) - _cos(wx) * _sin(wy) * _cos(wz)) * x2 + (_sin(wx) * _cos(wz) + _cos(wx) * _sin(wy) * _sin(wz)) * y2 + _cos(wx) * _cos(wy) * z2 
  xx3.f = _cos(wy) * _cos(wz) * x3 - _cos(wy) * _sin(wz) * y3 + _sin(wy) * z3 
  yy3.f = (_cos(wx) * _sin(wz) + _sin(wx) * _sin(wy) * _cos(wz)) * x3 + (_cos(wx) * _cos(wz) - _sin(wx) * _sin(wy) * _sin(wz)) * y3 - _sin(wx) * _cos(wy) * z3 
  zz3.f = (_sin(wx) * _sin(wz) - _cos(wx) * _sin(wy) * _cos(wz)) * x3 + (_sin(wx) * _cos(wz) + _cos(wx) * _sin(wy) * _sin(wz)) * y3 + _cos(wx) * _cos(wy) * z3 
  ; Weiß nicht warum (muss aber) 
  yy = -yy 
  yy2 = -yy2 
  yy3 = -yy3 
  ; 1. In 2D-Coordianten umwandeln 2. Malen 
  d_triangle(Round((xx-zz/2.828),0)+scrw2,Round((yy-zz/2.828),0)+scrh2,Round((xx2-zz2/2.828),0)+scrw2,Round((yy2-zz2/2.828),0)+scrh2,Round((xx3-zz3/2.828),0)+scrw2,Round((yy3-zz3/2.828),0)+scrh2) 
EndProcedure 

#breite = 800 
#hoehe = 600 

;- Init-Zeugs 

InitSprite() 
InitMouse() 
d_init3d(#breite,#hoehe) 

OpenScreen(#breite,#hoehe,16,"Deeem2031 - 3D-Engine") 

;- Hauptprogramm 

z = 0 ; Drehung um die Z-Achse 
Repeat 
ExamineMouse() 
x = MouseX() ; Drehung um die X-Achse 
y = MouseY() ; Drehung um die Y-Achse 

; Verhindern das x oder y < 0 oder > 360 (sonst Fehler) 
If y >= 360 
  Repeat 
    y - 360 
  Until y >= 0 And y < 360 
EndIf 
If y < 0 
  Repeat 
    y + 360 
  Until y >= 0 And y < 360 
EndIf 
If x >= 360 
  Repeat 
    x - 360 
  Until x >= 0 And x < 360 
EndIf 
If x < 0 
  Repeat 
    x + 360 
  Until x >= 0 And x < 360 
EndIf 

ClearScreen(RGB(0,0,0)) 
StartDrawing(ScreenOutput()) 
  FrontColor(RGB(0,0,255)) 
  d_triangle3d(-50,-50,-50,50,-50,-50,-50,50,-50,x,y,z) 
  
  FrontColor(RGB(0,255,0)) 
  d_triangle3d(50,50,-50,50,-50,-50,-50,50,-50,x,y,z) 

  FrontColor(RGB(255,255,255)) 
  d_line3d(-50,-50,-50, 50,-50,-50,x,y,z) 
  d_line3d(-50,-50,-50,-50, 50,-50,x,y,z) 
  d_line3d(-50,-50,-50,-50,-50, 50,x,y,z) 
  d_line3d(-50,-50, 50, 50,-50, 50,x,y,z) 
  d_line3d( 50,-50, 50, 50,-50,-50,x,y,z) 
  d_line3d(-50, 50,-50, 50, 50,-50,x,y,z) 
  d_line3d( 50,-50,-50, 50, 50,-50,x,y,z) 
  d_line3d(-50, 50,-50,-50, 50, 50,x,y,z) 
  d_line3d(-50, 50, 50,-50,-50, 50,x,y,z) 
  
  Plot(MouseX(),MouseY()) 

StopDrawing() 
FlipBuffers() 

Until MouseButton(1)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -