; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3536
; Author: NicTheQuick
; Date: 21. December 2006
; OS: Windows
; Demo: No


; - Maus bewegt Punkt 1. Punkte 2 und 3 bewegen sich von selbst. 
; - F1 und F2 für andere Formeln 
; - ALT-F4 zum Beenden oder auf das X klicken 

#Width = 400 
#Height = 300 

InitSprite() 
OpenWindow(0, 0, 0, #Width, #Height, "blabla", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
OpenWindowedScreen(WindowID(0), 0, 0, #Width, #Height, 0, 0, 0) 

Structure PointF 
  x.f 
  y.f 
  Rx.f 
  Ry.f 
EndStructure 

Define.PointF p1, p2, p3, p4, P, D1, D2, D3, offset 

p2\x = Random(#Width - 1) 
p2\y = Random(#Height - 1) 
p2\Rx = Random(200) / 50 
p2\Ry = Random(200) / 50 

p3\x = Random(#Width - 1) 
p3\y = Random(#Height - 1) 
p3\Rx = Random(200) / 50 
p3\Ry = Random(200) / 50 

;a, b, c    - Punkte des Dreiecks (a: Ausgangspunkt für offset) 
;p          - anderer Punkt 
;offset     - beinhaltet die relative Position von p im Dreieck 
Procedure GetOffset(*a.PointF, *b.PointF, *c.PointF, *p.PointF, *Offset.PointF) 
  Protected u.PointF, v.PointF 
  
  u\x = *b\x - *a\x   ;Bestimmung des Richtungsvektors von a zu b 
  u\y = *b\y - *a\y 
  
  v\x = *c\x - *a\x   ;Bestimmung des Richtungsvektors von a zu c 
  v\y = *c\y - *a\y 
  
  ;Errechnung des Offsets 
  *Offset\y = (*p\y - u\y * ((*p\x - *a\x) / u\x) - *a\y) / (- v\x * u\y / u\x + v\y) 
  *Offset\x = (*p\x - *Offset\y * v\x - *a\x) / u\x 
EndProcedure 

Structure RTC3F 
  r.f 
  g.f 
  b.f 
EndStructure 

Define.RTC3F Color1, Color2, Color3, Color4, Color, Filter 

;Mischt Farben für ein Dreieck (0 <= (ratio1 + ratio2) <= 1) 
Macro Mix3FColor3(out, in1, in2, in3, ratio1, ratio2) 
  out\r = (ratio1 * ratio2) * (in1\r - 0.5 * (in2\r + in3\r)) + ratio1 * (in2\r - in1\r) + ratio2 * (in3\r - in1\r) + in1\r 
  out\g = (ratio1 * ratio2) * (in1\g - 0.5 * (in2\g + in3\g)) + ratio1 * (in2\g - in1\g) + ratio2 * (in3\g - in1\g) + in1\g 
  out\b = (ratio1 * ratio2) * (in1\b - 0.5 * (in2\b + in3\b)) + ratio1 * (in2\b - in1\b) + ratio2 * (in3\b - in1\b) + in1\b 
EndMacro 

;Mischt Farben für ein Viereck (0 <= ratio1 <= 1, 0 <= ratio2 <= 1) 
Macro Mix3FColor4(out, in1, in2, in3, in4, ratio1, ratio2) 
  out\r = (ratio1 * ratio2) * (in1\r - in2\r - in3\r + in4\r) + ratio1 * (in2\r - in1\r) + ratio2 * (in3\r - in1\r) + in1\r 
  out\g = (ratio1 * ratio2) * (in1\g - in2\g - in3\g + in4\g) + ratio1 * (in2\g - in1\g) + ratio2 * (in3\g - in1\g) + in1\g 
  out\b = (ratio1 * ratio2) * (in1\b - in2\b - in3\b + in4\b) + ratio1 * (in2\b - in1\b) + ratio2 * (in3\b - in1\b) + in1\b 
EndMacro 

Macro VectorLength(in) 
  Sqr(in\x * in\x + in\y + in\y) 
EndMacro 

Macro Distance(in1, in2) 
  Sqr((in1\x - in2\x) * (in1\x - in2\x) + (in1\y - in2\y) * (in1\y - in2\y)) 
EndMacro 

Macro DistanceSq(in1, in2) 
  ((in1\x - in2\x) * (in1\x - in2\x) + (in1\y - in2\y) * (in1\y - in2\y)) 
EndMacro 

;Filter für die Farbkanäle 
Filter\r = 1 
Filter\g = 1 
Filter\b = 1 

;Farben für die Ecken 
Color1\r = 1 
Color1\g = 0 
Color1\b = 0 

Color2\r = 1 
Color2\g = 0 
Color2\b = 0 

Color3\r = 1 
Color3\g = 0 
Color3\b = 0 

Color4\r = 0 
Color4\g = 0 
Color4\b = 0 

Define.d dist1, dist2, dist3, dist4, dist 

Define mode.l = 0, maxmode = 7 

Define KeyTime.l, KeyReleaseTime.l = 250 

Repeat 
  p1\x = WindowMouseX(0) 
  p1\y = WindowMouseY(0) 
  
  If ElapsedMilliseconds() > KeyTime 
    If GetAsyncKeyState_(#VK_UP) 
      KeyTime = ElapsedMilliseconds() + KeyReleaseTime 
      mode = (mode + 1) % (maxmode + 1) 
    EndIf 
    If GetAsyncKeyState_(#VK_DOWN) 
      KeyTime = ElapsedMilliseconds() + KeyReleaseTime 
      mode = (mode + maxmode) % (maxmode + 1) 
    EndIf 
  EndIf 
  
  p2\x + p2\Rx 
  p2\y + p2\Ry 
  p3\x + p3\Rx 
  p3\y + p3\Ry 
  
  If p2\x < 0 Or p2\x > #Width - 1 : p2\Rx = -p2\Rx : EndIf 
  If p2\y < 0 Or p2\y > #Height - 1 : p2\Ry = -p2\Ry : EndIf 
  If p3\x < 0 Or p3\x > #Width - 1 : p3\Rx = -p3\Rx : EndIf 
  If p3\y < 0 Or p3\y > #Height - 1 : p3\Ry = -p3\Ry : EndIf 
  
  StartDrawing(ScreenOutput()) 
    For x.l = 0 To #Width - 1 
      For y.l = 0 To #Height - 1 
        P\x = x 
        P\y = y 
        
        Select mode   ;Hier Werte zwischen 0 und 3 einsetzen 
          Case 0 ;Zeigt nur Inhalt des Dreiecks an 
            GetOffset(p1, p2, p3, P, offset) 
            If offset\x >= 0 And offset\y >= 0 And offset\x + offset\y <= 1 
              Mix3FColor3(Color, Color1, Color2, Color3, offset\x, offset\y) 
            Else 
              Color\r = 0;Color1\r 
              Color\g = 0;Color1\g 
              Color\b = 0;Color1\b 
            EndIf 
          
          Case 1 ;Zeigt Farbwerte in- und außerhalb des Dreiecks 
            GetOffset(p1, p2, p3, P, offset) 
            Mix3FColor3(Color, Color1, Color2, Color3, offset\x, offset\y) 
            If Color\r < 0 : Color\r = 0 : EndIf 
            If Color\g < 0 : Color\g = 0 : EndIf 
            If Color\b < 0 : Color\b = 0 : EndIf 
            If Color\r > 1 : Color\r = 1 : EndIf 
            If Color\g > 1 : Color\g = 1 : EndIf 
            If Color\b > 1 : Color\b = 1 : EndIf 
          
          Case 2 ;Zeigt Farbwerte innerhalb des Parallelogramms 
            GetOffset(p1, p2, p3, P, offset) 
            If offset\x >= 0 And offset\y >= 0 And offset\x <= 1 And offset\y <= 1 
              Mix3FColor4(Color, Color1, Color2, Color3, Color4, offset\x, offset\y) 
            Else 
              Color\r = 0 
              Color\g = 0 
              Color\b = 0 
            EndIf 
          
         Case 3 ;Zeigt Farbwerte in- und außerhalb des Parallelogramms 
            GetOffset(p1, p2, p3, P, offset) 
            Mix3FColor4(Color, Color1, Color2, Color3, Color4, offset\x, offset\y) 
            If Color\r < 0 : Color\r = 0 : EndIf 
            If Color\g < 0 : Color\g = 0 : EndIf 
            If Color\b < 0 : Color\b = 0 : EndIf 
            If Color\r > 1 : Color\r = 1 : EndIf 
            If Color\g > 1 : Color\g = 1 : EndIf 
            If Color\b > 1 : Color\b = 1 : EndIf 
          
          Case 4 
            dist1 = 1 / Distance(P, p1) 
            dist2 = 1 / Distance(P, p2) 
            dist3 = 1 / Distance(P, p3) 
            dist = 1 / (dist1 + dist2 + dist3) 
            dist1 * dist 
            dist2 * dist 
            dist3 * dist 
            Color\r = Color1\r * dist1 + Color2\r * dist2 + Color3\r * dist3 
            Color\g = Color1\g * dist1 + Color2\g * dist2 + Color3\g * dist3 
            Color\b = Color1\b * dist1 + Color2\b * dist2 + Color3\b * dist3 
          
          Case 5 
            dist1 = 1 / DistanceSq(P, p1) 
            dist2 = 1 / DistanceSq(P, p2) 
            dist3 = 1 / DistanceSq(P, p3) 
            dist = 1 / (dist1 + dist2 + dist3) 
            dist1 * dist 
            dist2 * dist 
            dist3 * dist 
            Color\r = Color1\r * dist1 + Color2\r * dist2 + Color3\r * dist3 
            Color\g = Color1\g * dist1 + Color2\g * dist2 + Color3\g * dist3 
            Color\b = Color1\b * dist1 + Color2\b * dist2 + Color3\b * dist3 
          
          Case 6 
            dist1 = 1 / Distance(P, p1) 
            dist2 = 1 / Distance(P, p2) 
            dist3 = 1 / Distance(P, p3) 
            dist4 = 1 / Distance(P, p4) 
            dist = 1 / (dist1 + dist2 + dist3 + dist4) 
            dist1 * dist 
            dist2 * dist 
            dist3 * dist 
            dist4 * dist 
            Color\r = Color1\r * dist1 + Color2\r * dist2 + Color3\r * dist3 + Color4\r * dist4 
            Color\g = Color1\g * dist1 + Color2\g * dist2 + Color3\g * dist3 + Color4\g * dist4 
            Color\b = Color1\b * dist1 + Color2\b * dist2 + Color3\b * dist3 + Color4\b * dist4 
          
          Case 7 
            dist1 = 1 / DistanceSq(P, p1) 
            dist2 = 1 / DistanceSq(P, p2) 
            dist3 = 1 / DistanceSq(P, p3) 
            dist4 = 1 / DistanceSq(P, p4) 
            dist = 1 / (dist1 + dist2 + dist3 + dist4) 
            dist1 * dist 
            dist2 * dist 
            dist3 * dist 
            dist4 * dist 
            Color\r = Color1\r * dist1 + Color2\r * dist2 + Color3\r * dist3 + Color4\r * dist4 
            Color\g = Color1\g * dist1 + Color2\g * dist2 + Color3\g * dist3 + Color4\g * dist4 
            Color\b = Color1\b * dist1 + Color2\b * dist2 + Color3\b * dist3 + Color4\b * dist4 
        EndSelect 
        
        ;*plott* *plott* 
        Plot(x, y, RGB(Color\r * Filter\r * 255, Filter\g * Color\g * 255, Filter\b * Color\b * 255)) 
      Next 
    Next 
    
    p4\x = p2\x + p3\x - p1\x 
    p4\y = p2\y + p3\y - p1\y 
    LineXY(p1\x, p1\y, p2\x, p2\y, $FFFFFF) 
    LineXY(p2\x, p2\y, p3\x, p3\y, $FFFFFF) 
    LineXY(p3\x, p3\y, p1\x, p1\y, $FFFFFF) 
    LineXY(p2\x, p2\y, p4\x, p4\y, $FFFFFF) 
    LineXY(p3\x, p3\y, p4\x, p4\y, $FFFFFF) 
    
    DrawingMode(1) 
    DrawText(0, 0, "Mode: " + Str(mode), $FFFFFF) 
    DrawText(p1\x - 4, p1\y - 8, "1", $FFFFFF) 
    DrawText(p2\x - 4, p2\y - 8, "2", $FFFFFF) 
    DrawText(p3\x - 4, p3\y - 8, "3", $FFFFFF) 
    DrawText(p4\x - 4, p4\y - 8, "4", $FFFFFF) 
  StopDrawing() 
  FlipBuffers() 
Until WindowEvent() = #PB_Event_CloseWindow 
CloseScreen() 
CloseWindow(0) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP