; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5144&postdays=0&postorder=asc&start=20
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 01. August 2004
; OS: Windows
; Demo: Yes


; Erstellen einer 3D-Kugel - Teil 3
; ---------------------------------
; Wie man Kegel und Zylinder/n-Eck-Rohre erstellt, hatte ich 
; ja schon gezeigt. Das letzte Beispiel kombiniert nur diese 
; 2 Sachen. 
; 
; Schritt 3: 
; Die verschiedenen horiz. Kreise sind von einem weiteren 
; virtuellen vertikalen Kreis abhängig, d.h. man kann nicht 
; einfach 5 horiz. Kreise mit Durchmesser 0.7, 0.6, 0.5, 0.4 
; und 0.3 nehmen, dann wär's kein Kreis. 
; 
; Also schnell eine Procedure dafür gemacht und alles miteinander 
; kombiniert: 
; 
; Mit F1/F2 stellt man jetzt ein in wieviel Teile der horizontale 
; 360°-Kreis geteilt wird. Das sind dann die Verbindungspunkte 
; zwischen den Kreisen. 
; Mit F3/F4 kann man noch einstellen wie oft die Kugel vertikal 
; geteilt wird. Dabei habe ich's mir jetzt mal ganz einfach gemacht 
; und einen festen Mittelkreis gesetzt. Ein Halbkreis wird dann 
; immer durch die Schrittweite2 geteilt und fertig. 
; 
; Die Dreiecke hab ich jetzt auch weggelassen. Das man die 
; entstehenden Trapeze in 2 Dreiecke aufteilen kann dürfte 
; ja jeder selbst sehen. 
; 
; Vielleicht bekommt ja doch noch jemand eine Idee vom Prinzip, 
; wenn er sich die letzten 3 Beispiele ansieht und in Beispiel 3 
; mal mit den Schrittweiten (F1/F2 & F3/F4) rumspielt. 
; Da sieht man doch eigentlich schon direkt wie die Kugel aufgebaut ist...
 

Procedure.f GSin(winkel.f) 
   ProcedureReturn Sin(winkel*(2*3.14159265/360)) 
EndProcedure 

Procedure.f GCos(winkel.f) 
   ProcedureReturn Cos(winkel*(2*3.14159265/360)) 
EndProcedure 

;----- 

#sw = 1024 
#sh = 768 
#sn = "Sinus" 

#hsw = #sw/2 
#hsh = #sh/2 

If InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant init game engine !"):End 
EndIf 

If OpenScreen(#sw,#sh,32,#sn)=0 
  If OpenScreen(#sw,#sh,24,#sn)=0 
    If OpenScreen(#sw,#sh,16,#sn)=0 
      If OpenScreen(#sw,#sh,08,#sn)=0 
        MessageRequester("ERROR","Cant open screen !"):End 
EndIf:EndIf:EndIf:EndIf 


Procedure Point3Dto2D(x.f,y.f,z.f,*pt.POINT) 
  #proj = 400 ; gew?nlich 100 
  z + 1 
  *pt\x = Round((x/z)* #proj+#hsw,1) 
  *pt\y = Round((y/z)*-#proj+#hsh,1) 
EndProcedure 


Procedure Line3D(x1.f,y1.f,z1.f,x2.f,y2.f,z2.f,color) 
  ; draw a line in 3D space 
  Point3Dto2D(x1,y1,z1,p1.POINT) 
  Point3Dto2D(x2,y2,z2,p2.POINT) 
  If color = -1 
    LineXY(p1\x,p1\y,p2\x,p2\y) 
  Else 
    LineXY(p1\x,p1\y,p2\x,p2\y,color) 
  EndIf 
EndProcedure 

Procedure DrawObject(Radius.f,schrittweite1,schrittweite2,obj_x.f,obj_y.f,obj_z.f) 
  If Schrittweite1 < 3 : Schrittweite1 = 3 : EndIf 
  If Schrittweite2 < 1 : Schrittweite2 = 1 : EndIf 
  gradschritte.f = 90.0 / Schrittweite2 
  sincos.f    = 90.0 
  For i = 1 To schrittweite2 
    grad.f = 90.0 
    Point3Dto2D(obj_x+gSin(grad)*(Radius*GSin(sincos)),obj_y-Radius*GCos(sincos),(obj_z+0-(Radius*GSin(sincos))*GCos(grad)*0.1),pt1.POINT) 
    Point3Dto2D(obj_x+gSin(grad)*(Radius*GSin(sincos)),obj_y+Radius*GCos(sincos),(obj_z+0-(Radius*GSin(sincos))*GCos(grad)*0.1),pt2.POINT) 
    old_x1 = pt1\x : old_y1 = pt1\y 
    old_x2 = pt2\x : old_y2 = pt2\y 
    While grad =< 360+90+360/schrittweite1 
      Point3Dto2D(obj_x+gSin(grad)*(Radius*GSin(sincos)),obj_y-Radius*GCos(sincos),(obj_z+0-(Radius*GSin(sincos))*GCos(grad)*0.1),pt1.POINT ) 
      Point3Dto2D(obj_x+gSin(grad)*(Radius*GSin(sincos)),obj_y+Radius*GCos(sincos),(obj_z+0-(Radius*GSin(sincos))*GCos(grad)*0.1),pt2.POINT ) 
      If i = schrittweite2 
        Point3Dto2D(obj_x,obj_y+Radius,obj_z,m1.POINT) 
        Point3Dto2D(obj_x,obj_y-Radius,obj_z,m2.POINT) 
        LineXY(pt1\x  ,pt1\y  ,m1\x  ,m1\y ) 
        LineXY(pt2\x  ,pt2\y  ,m2\x  ,m2\y ) 
      EndIf 
      LineXY(pt1\x ,pt1\y ,old_x1,old_y1) 
      If i>1 
        LineXY(pt2\x ,pt2\y ,old_x2,old_y2) 

        Point3Dto2D(obj_x+gSin(grad)*(Radius*GSin(sincos-gradschritte)),obj_y-Radius*GCos(sincos-gradschritte),(obj_z+0-(Radius*GSin(sincos-gradschritte))*GCos(grad)*0.1),pt3.POINT ) 
        LineXY(pt1\x,pt1\y,pt3\x,pt3\y) 
        Point3Dto2D(obj_x+gSin(grad)*(Radius*GSin(sincos-gradschritte)),obj_y+Radius*GCos(sincos-gradschritte),(obj_z+0-(Radius*GSin(sincos-gradschritte))*GCos(grad)*0.1),pt4.POINT ) 
        LineXY(pt2\x,pt2\y,pt4\x,pt4\y) 
      EndIf 
      old_x1 = pt1\x  : old_y1 = pt1\y 
      old_x2 = pt2\x  : old_y2 = pt2\y 
      grad + 360/schrittweite1 
    Wend 
    sincos + gradschritte 
    doit = 1 
  Next i 
EndProcedure 

schrittweite1 = 25 
schrittweite2 = 8 
z.f     = 0 
obj_y.f = 0 
obj_x.f = 0 
obj_z.f = -0.1 

Repeat 
    ExamineKeyboard() 
    FlipBuffers() 
    If IsScreenActive() 
      ClearScreen (RGB(0,0,0))

      If StartDrawing(ScreenOutput()) 
        FrontColor(RGB($FF,$FF,$00))
        DrawObject(0.7,Schrittweite1,Schrittweite2,obj_x,obj_y,obj_z) 
        
        FrontColor(RGB(255, 255, 255))
        DrawingMode(1) 
        DrawText(50, 30, "Schrittweite 1 (F1/F2): " + Str(Schrittweite1)) 
        DrawText(50, 50, "Schrittweite 2 (F3/F4): " + Str(Schrittweite2)) 
        DrawText(50, 80, "Cursor Keys left/right & up/down to move object") 
        DrawText(50, 100, "Keypad +/- to z00m object") 
        StopDrawing() 
      EndIf 

      If KeyboardPushed(#PB_Key_F1) And keypressed = 0 
        Schrittweite1 + 1 
        keypressed = 5 
      ElseIf KeyboardPushed(#PB_Key_F2) And keypressed = 0 
        Schrittweite1 - 1 
        If Schrittweite1 < 3 : Schrittweite1 = 3 : EndIf 
        keypressed = 5 
      ElseIf KeyboardPushed(#PB_Key_F3) And keypressed = 0 
        Schrittweite2 + 1 
        keypressed = 5 
      ElseIf KeyboardPushed(#PB_Key_F4) And keypressed = 0 
        Schrittweite2 - 1 
        If Schrittweite2 < 1 : Schrittweite2 = 1 : EndIf 
        keypressed = 5 
      ElseIf KeyboardPushed(#PB_Key_Up) 
        obj_y + 0.01 
      ElseIf KeyboardPushed(#PB_Key_Down) 
        obj_y - 0.01 
      ElseIf KeyboardPushed(#PB_Key_Left) 
        obj_x - 0.01 
      ElseIf KeyboardPushed(#PB_Key_Right) 
        obj_x + 0.01 
      ElseIf KeyboardPushed(#PB_Key_Add)      ; keypad + 
        obj_z - 0.01 
      ElseIf KeyboardPushed(#PB_Key_Subtract) ; keypad - 
        obj_z + 0.01 
      EndIf 
      If keypressed : keypressed - 1 : EndIf      

      Delay(10) 

    EndIf 
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -