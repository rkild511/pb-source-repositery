; www.purearea.net (Sourcecode collection by cnesm)
; Author: Deeem2031 (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: Yes

; - Programmiert von Deeém2031 
; Was noch kommen soll: 
; - Automatisches erkennen der Überlappung von Dreiecken -> richtiges Darstellen 
; - Texturen 
; - Kontrollieren ob das Dreieck (die Linie) hinter einem liegt -> nicht zeichnen 
; - Das Zeichnen nicht nur in Kavalierperspektive 

; (Das Kommentar steht immer vor der Sache die es beschreibt) 

; - Erweitert von Franco 
; - Code etwas geaendert -> immer wiederkehrende Berechnungen in Proceduren gepackt, 
; - damit ist der code etwas besser verstaendlich (zumindest fuer mich ;) ) 
; - Cameraposition aendern mit den SeiteHoch/SeiteRunter (PageUP/PageDown) Tasten 

Pi.f=3.1415926 
TwoTimesRootOfTwo.f = 2 * Sqr(2) 
CameraPosition.f = 1 

Procedure d_triangle(x1.l,y1.l,x2.l,y2.l,x3.l,y3.l) 
  Shared Pi, TwoTimesRootOfTwo 
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
  Shared Pi, TwoTimesRootOfTwo 
  ; sin und cos in Array schreiben 
  Global Dim _sin.f(360) 
  Global Dim _cos.f(360) 
  For x = 0 To 360 
    _sin(x) = Sin(x/(180/Pi)) 
    _cos(x) = Cos(x/(180/Pi)) 
  Next x 
  ; Die Bildschirmgröße verarbeiten 
  Global scrw2.w 
  Global scrh2.w 
  scrw2.w = Round((scrw/2),0) 
  scrh2.w = Round((scrh/2),0) 
EndProcedure 

Procedure.f CalcXRotation(x.f,y.f,z.f,wx.w,wy.w,wz.w) 
  Result.f = _Cos(wy) * _cos(wz) * x - _cos(wy) * _sin(wz) * y + _sin(wy) * z 
  ProcedureReturn Result 
EndProcedure 

Procedure.f CalcYRotation(x.f,y.f,z.f,wx.w,wy.w,wz.w) 
  Result.f =  (_cos(wx) * _sin(wz) + _sin(wx) * _sin(wy) * _cos(wz)) * x + (_cos(wx) * _cos(wz) - _sin(wx) * _sin(wy) * _sin(wz)) * y - _sin(wx) * _cos(wy) * z 
  Result = - Result 
  ProcedureReturn Result 
EndProcedure 

Procedure.f CalcZRotation(x.f,y.f,z.f,wx.w,wy.w,wz.w) 
  Result.f =  (_sin(wx) * _sin(wz) - _cos(wx) * _sin(wy) * _cos(wz)) * x + (_sin(wx) * _cos(wz) + _cos(wx) * _sin(wy) * _sin(wz)) * y + _cos(wx) * _cos(wy) * z 
  Result = - Result 
  ProcedureReturn Result 
EndProcedure 

Procedure CheckXRotation(x.l) 
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
  ProcedureReturn x 
EndProcedure 

Procedure CheckYRotation(y.l) 
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
  ProcedureReturn y 
EndProcedure 
  
Procedure CheckZRotation(z.l) 
  If z >= 360 
    Repeat 
      z - 360 
    Until z >= 0 And z < 360 
  EndIf 
  If z < 0 
    Repeat 
      z + 360 
    Until z >= 0 And z < 360 
  EndIf 
  ProcedureReturn z 
EndProcedure 

Procedure d_circle3d(x1.f,y1.f,z1.f,diameter.f,wx.w,wy.w,wz.w) 
  Shared Pi, TwoTimesRootOfTwo, CameraPosition 
  ; Drehung berechnen 
  xx.f = CalcXRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition,wx,wy,wz) 
  yy.f = CalcYRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition,wx,wy,wz) 
  zz.f = CalcZRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition,wx,wy,wz) 

  ; 1. In 2D-Coordinaten umwandeln 2. Malen 
  Circle(Round(xx-zz/TwoTimesRootOfTwo,0)+scrw2,Round(yy-zz/TwoTimesRootOfTwo,0)+scrh2, diameter*CameraPosition) 
EndProcedure 

Procedure d_line3d(x1.f,y1.f,z1.f,x2.f,y2.f,z2.f,wx.w,wy.w,wz.w) 
  Shared Pi, TwoTimesRootOfTwo,CameraPosition 
  ; Drehung berechnen 
  xx.f = CalcXRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition,wx,wy,wz) 
  yy.f = CalcYRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition,wx,wy,wz) 
  zz.f = CalcZRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition,wx,wy,wz) 
  xx2.f = CalcXRotation(x2*CameraPosition,y2*CameraPosition,z2*CameraPosition,wx,wy,wz) 
  yy2.f = CalcYRotation(x2*CameraPosition,y2*CameraPosition,z2*CameraPosition,wx,wy,wz) 
  zz2.f = CalcZRotation(x2*CameraPosition,y2*CameraPosition,z2*CameraPosition,wx,wy,wz) 

  ; 1. In 2D-Coordianten umwandeln 2. Malen 
  LineXY(Round(xx-zz/TwoTimesRootOfTwo,0)+scrw2,Round(yy-zz/TwoTimesRootOfTwo,0)+scrh2,Round(xx2-zz2/TwoTimesRootOfTwo,0)+scrw2,Round(yy2-zz2/TwoTimesRootOfTwo,0)+scrh2) 
EndProcedure 

Procedure d_triangle3d(x1.f,y1.f,z1.f,x2.f,y2.f,z2.f,x3.f,y3.f,z3.f,wx.w,wy.w,wz.w) 
  Shared Pi, TwoTimesRootOfTwo, CameraPosition 
  ; Drehung berechnen 
  xx.f = CalcXRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition,wx,wy,wz) 
  yy.f = CalcYRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition,wx,wy,wz) 
  zz.f = CalcZRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition,wx,wy,wz) 
  xx2.f = CalcXRotation(x2*CameraPosition,y2*CameraPosition,z2*CameraPosition,wx,wy,wz) 
  yy2.f = CalcYRotation(x2*CameraPosition,y2*CameraPosition,z2*CameraPosition,wx,wy,wz) 
  zz2.f = CalcZRotation(x2*CameraPosition,y2*CameraPosition,z2*CameraPosition,wx,wy,wz) 
  xx3.f = CalcXRotation(x3*CameraPosition,y3*CameraPosition,z3*CameraPosition,wx,wy,wz) 
  yy3.f = CalcYRotation(x3*CameraPosition,y3*CameraPosition,z3*CameraPosition,wx,wy,wz) 
  zz3.f = CalcZRotation(x3*CameraPosition,y3*CameraPosition,z3*CameraPosition,wx,wy,wz) 
  ; 1. In 2D-Coordianten umwandeln 2. Malen 
  d_triangle(Round((xx-zz/TwoTimesRootOfTwo),0)+scrw2,Round((yy-zz/TwoTimesRootOfTwo),0)+scrh2,Round((xx2-zz2/TwoTimesRootOfTwo),0)+scrw2,Round((yy2-zz2/TwoTimesRootOfTwo),0)+scrh2,Round((xx3-zz3/TwoTimesRootOfTwo),0)+scrw2,Round((yy3-zz3/TwoTimesRootOfTwo),0)+scrh2) 
EndProcedure 

#breite = 1024 
#hoehe = 768 

;- Init-Zeugs 

InitSprite() 
InitMouse() 
InitKeyboard() 

d_init3d(#breite,#hoehe) 

OpenWindow(1,100,100,640,480,"Test",#PB_Window_SystemMenu) 
OpenWindowedScreen( WindowID(1),10,10,800,600,1,10,10) 
;OpenScreen(#breite,#hoehe,16,"Deeem2031 - 3D-Engine") 

;- Hauptprogramm 

;z = 0 ; Drehung um die Z-Achse 



Repeat 
  ExamineMouse() 
  x = MouseX() ; Drehung um die X-Achse 
  y = MouseY() ; Drehung um die Y-Achse 
  z = MouseX() + MouseY() ; naja hier passiert auch was... 
  
  ; Verhindern das x, y und z < 0 oder > 360 (sonst Fehler) 
  x = CheckXRotation(x) 
  y = CheckYRotation(y) 
  z = CheckZRotation(z) 
  
  ClearScreen(RGB(0,0,0)) 
  StartDrawing(ScreenOutput()) 
  
  ; DrawingMode: 
  ;  0: Default mode, text is displayed with background, graphics shape are filled 
  ;  1: Set the text background transparent 
  ;  2: Enable the XOr mode (all graphics are XOR'ed with current background) 
  ;  4: Enable the outlined shape. Circle, Box etc... will be only outlined, no more filled. 
  DrawingMode(0) 

  ; Kreis auf absoluten nullpunkt setzen (well sort of a Circle...) 
  ; Leider ist das kein Kreis sondern eine Kugel! 
  FrontColor(RGB(255,0,0)) 
  d_circle3d(0,0,0,5,x,y,z) 

  FrontColor(RGB(0,0,255)) 
  d_triangle3d(-50,-50,-50,50,-50,-50,-50,50,-50,x,y,z) 

  FrontColor(RGB(0,255,0)) 
  d_triangle3d(50,50,-50,50,-50,-50,-50,50,-50,x,y,z) 

  FrontColor(RGB(255,255,255)) 
  d_line3d(-50,-50, 50, 50,-50, 50,x,y,z) 
  d_line3d( 50,-50, 50, 50, 50, 50,x,y,z) 
  d_line3d( 50, 50, 50,-50, 50, 50,x,y,z) 
  d_line3d(-50, 50, 50,-50,-50, 50,x,y,z) 

  d_line3d(-50,-50,-50, 50,-50,-50,x,y,z) 
  d_line3d( 50,-50,-50, 50, 50,-50,x,y,z) 
  d_line3d( 50, 50,-50,-50, 50,-50,x,y,z) 
  d_line3d(-50, 50,-50,-50,-50,-50,x,y,z) 

  d_line3d(-50,-50, 50,-50,-50,-50,x,y,z) 
  d_line3d(-50, 50, 50,-50, 50,-50,x,y,z) 

  d_line3d( 50,-50, 50, 50,-50,-50,x,y,z) 
  d_line3d( 50, 50, 50, 50, 50,-50,x,y,z) 


  Plot(MouseX(),MouseY()) 

  StopDrawing() 
  FlipBuffers() 
  
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_PageUp) 
    CameraPosition = CameraPosition * 1.02 
  EndIf 
  If KeyboardPushed(#PB_Key_PageDown) 
    CameraPosition = CameraPosition * 0.98 
  EndIf 
Until MouseButton(1) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --