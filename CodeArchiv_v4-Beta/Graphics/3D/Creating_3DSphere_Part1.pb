; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5144&postdays=0&postorder=asc&start=20
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 01. August 2004
; OS: Windows
; Demo: Yes


; Erstellen einer 3D-Kugel - Teil 1
; ---------------------------------
; Schritt 1: 
; Mehrere (virtuelle) horizontale Kreise nehmen und feste 
; Verbindungspunkte miteinander verbinden. 
; Sozusagen mehrere Zylinder/Rohre mit unterschiedlichen 
; Durchmessern: 

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

schrittweite = 20 
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
        grad.f = 90.0 
        Point3Dto2D(obj_x+gSin(grad)*0.3,obj_y+0.3,(obj_z+0-GCos(grad)*0.1),pt.POINT) 
        old_x1 = pt\x : old_y1 = pt\y 
        Point3Dto2D(obj_x+gSin(grad)*0.5,obj_y    ,(obj_z-0-GCos(grad)*0.1),pt.POINT) 
        old_x2 = pt\x : old_y2 = pt\y 
        Point3Dto2D(obj_x+gSin(grad)*0.3,obj_y-0.3,(obj_z-0-GCos(grad)*0.1),pt.POINT) 
        old_x3 = pt\x : old_y3 = pt\y 
        While grad =< 360+90+360/schrittweite 
          Point3Dto2D(obj_x+gSin(grad)*0.3,obj_y+0.3,(obj_z+0-GCos(grad)*0.1),pt.POINT ) 
          Point3Dto2D(obj_x+gSin(grad)*0.5,obj_y    ,(obj_z-0-GCos(grad)*0.1),pt2.POINT) 
          Point3Dto2D(obj_x+gSin(grad)*0.3,obj_y-0.3,(obj_z-0-GCos(grad)*0.1),pt3.POINT) 
          LineXY(pt\x  ,pt\y  ,pt2\x ,pt2\y ) 
          LineXY(pt3\x ,pt3\y ,pt2\x ,pt2\y ) 
          LineXY(pt\x ,pt\y ,old_x1,old_y1) 
          LineXY(pt2\x,pt2\y,old_x2,old_y2) 
          LineXY(pt3\x,pt3\y,old_x3,old_y3) 
          old_x1 = pt\x  : old_y1 = pt\y 
          old_x2 = pt2\x : old_y2 = pt2\y 
          old_x3 = pt3\x : old_y3 = pt3\y 
          grad + 360/schrittweite 
        Wend 
        
        FrontColor(RGB(255, 255, 255))
        DrawingMode(1) 
        DrawText(50, 30, "Schrittweite (F1/F2): " + Str(Schrittweite)) 
        DrawText(50, 50, "Cursor Keys left/right & up/down to move object") 
        DrawText(50, 70, "Keypad +/- to z00m object") 
        StopDrawing() 
      EndIf 

      If KeyboardPushed(#PB_Key_F1) And keypressed = 0 
        Schrittweite + 1 
        keypressed = 5 
      ElseIf KeyboardPushed(#PB_Key_F2) And keypressed = 0 
        Schrittweite - 1 
        If Schrittweite < 3 : Schrittweite = 3 : EndIf 
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