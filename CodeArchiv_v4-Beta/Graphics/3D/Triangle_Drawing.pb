; English forum: http://www.purebasic.fr/english/viewtopic.php?t=17030 
; Author: Dr. Dri (updated for PB 4.00 by edel)
; Date: 03. October 2005 
; OS: Windows 
; Demo: No 


Procedure IsDrawing() 
  !extrn _PB_2DDrawing_GlobalStructure 
  !MOV EAX,[_PB_2DDrawing_GlobalStructure] 
  ProcedureReturn 
EndProcedure 

Procedure Triangle(x1.l, y1.l, x2.l, y2.l, x3.l, y3.l) 
  ProcedureReturn Polygon_(IsDrawing(), @x1, 3) 
EndProcedure 

Structure Point3D 
  x.f 
  y.f 
  z.f 
EndStructure 

Structure Face3D 
  points.Long[3] 
  color.l 
EndStructure 

Structure Object3D 
  ;position 
  x.f 
  y.f 
  z.f 
  ;orientation 
  ax.f 
  ay.f 
  az.f 
  ;proportion 
  sx.f 
  sy.f 
  sz.f 
  nPoints.l 
  *points.Point3D 
  nFaces.l 
  *faces.Face3D 
EndStructure 

DataSection 
cube_points: 
Data.f -0.5, -0.5, -0.5 
Data.f -0.5, -0.5,  0.5 
Data.f -0.5,  0.5, -0.5 
Data.f -0.5,  0.5,  0.5 
Data.f  0.5, -0.5, -0.5 
Data.f  0.5, -0.5,  0.5 
Data.f  0.5,  0.5, -0.5 
Data.f  0.5,  0.5,  0.5 
cube_faces: 
Data.l 1, 3, 7, $0000FF 
Data.l 1, 7, 5, $0000FF 
Data.l 0, 4, 6, $00FF00 
Data.l 0, 6, 2, $00FF00 
Data.l 2, 6, 7, $FF0000 
Data.l 2, 7, 3, $FF0000 
Data.l 0, 1, 5, $00FFFF 
Data.l 0, 5, 4, $00FFFF 
Data.l 0, 2, 3, $FF00FF 
Data.l 0, 3, 1, $FF00FF 
Data.l 4, 5, 7, $FFFF00 
Data.l 4, 7, 6, $FFFF00 
EndDataSection 

Procedure Face3D_Render(*o.Object3D, face.l, cax.f, sax.f, cay.f, say.f, caz.f, saz.f) 
  Protected x1.l, y1.l, x2.l, y2.l, x3.l, y3.l, *p.Point, i.l, color.l, p.l, *p3D.Point3D 
  Protected x.f, y.f, z.f, tx.f, ty.f, tz.f, l.l, h.l, distance.f, visible.l, *f3D.Face3D 
  
  l = DesktopWidth (0) / 2 
  h = DesktopHeight(0) / 2 
  distance = l * 1.15470052 
  
  *p   = @x1 
  *f3D = *o\faces + face * SizeOf(Face3D) 
  While i < 3 
    p    = *f3D\points[i]\l 
    *p3D = *o\points + p * SizeOf(Point3D) 
    
    x = *p3D\x * *o\sx 
    y = *p3D\y * *o\sy 
    z = *p3D\z * *o\sz 
    
    ;rotation autour de l'axe x 
    ty = y : tz = z 
    y = cax * ty - sax * tz 
    z = sax * ty + cax * tz 
    
    ;rotation autour de l'axe y 
    tx = x : tz = z 
    x = say * tz + cay * tx 
    z = cay * tz - say * tx 
    
    ;rotation autour de l'axe z 
    tx = x : ty = y 
    x = caz * tx - saz * ty 
    y = saz * tx + caz * ty 
    
    x + *o\x 
    y + *o\y 
    z + *o\z 
    
    *p\x = l + distance * x / z 
    *p\y = h - distance * y / z 
    
    i  + 1 
    *p + SizeOf(Point) 
  Wend 
  
  visible = (x1 * y2) - (y1 * x2) + (x2 * y3) - (y2 * x3) + (x3 * y1) - (y3 * x1) 
  If visible < 0 
    color = *f3D\color 
    FrontColor(color) 
    Triangle(x1, y1, x2, y2, x3, y3) 
    FrontColor(RGB(0, 0, 0)) 
  EndIf 
EndProcedure 

Procedure Object3D_Render(*o.Object3D) 
  Protected ax.f, ay.f, az.f, i.l 
  Protected cax.f, sax.f, cay.f, say.f, caz.f, saz.f 
  
  ax = *o\ax * 0.01745329 
  ay = *o\ay * 0.01745329 
  az = *o\az * 0.01745329 
  
  cax = Cos(ax) : sax = Sin(ax) 
  cay = Cos(ay) : say = Sin(ay) 
  caz = Cos(az) : saz = Sin(az) 
  
  While i < *o\nFaces 
    Face3D_Render(*o, i, cax, sax, cay, say, caz, saz) 
    i + 1 
  Wend 
EndProcedure 

Rectangle.Object3D 
Rectangle\z       = 50.0 
Rectangle\sx      = 20.0 
Rectangle\sy      = 10.0 
Rectangle\sz      =  5.0 
Rectangle\nPoints =  8 
Rectangle\points  = ?cube_points 
Rectangle\nFaces  = 12 
Rectangle\faces   = ?cube_faces 

InitSprite() 
InitKeyboard() 

ExamineDesktops() 
OpenWindow(0, 0, 0, DesktopWidth(0), DesktopHeight(0), "", 0) 
OpenScreen(DesktopWidth(0), DesktopHeight(0), DesktopDepth(0), "") 

Repeat 
  ClearScreen(RGB(0, 0, 0)) 
  ExamineKeyboard() 
  
  If StartDrawing( ScreenOutput() ) 
    Object3D_Render(Rectangle) 
    StopDrawing() 
  EndIf 
  
  Rectangle\ax + 1 
  Rectangle\ay + 2 
  Rectangle\az + 3 
  If Rectangle\ax > 360 : Rectangle\ax - 360 : EndIf 
  If Rectangle\ay > 360 : Rectangle\ay - 360 : EndIf 
  If Rectangle\az > 360 : Rectangle\az - 360 : EndIf 
  
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger