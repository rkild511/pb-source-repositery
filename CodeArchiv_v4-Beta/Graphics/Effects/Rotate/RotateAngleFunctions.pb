; German forum: http://www.purebasic.fr/german/viewtopic.php?t=252
; Author: Sunny (updated for PB 4.00 by Andre)
; Date: 25. September 2004
; OS: Windows
; Demo: Yes


; 2 procedures for calculating 2D angles
; 2 Prozeduren zum Berechnen von 2D-Winkeln.

;- Prozedur 1: 
; Dabei handelt es sich in der ersten Prozedur lediglich um die Errechnung 
; eines Winkels im 360 Grad Bereich aus 2 Punkten. Wer also schnell und 
; einfach den Winkel von Objekt 1 zu Objekt 2 sucht, der kann mit dieser 
; Prozedur sich etwas Arbeit einsparen.
; Der Rückgabewert ist der Winkel in Grad. Also von 0 - 360 Grad, wobei 
; 360 Grad logischer Weise wieder 0 Grad ist. (keine Float sondern nur 
; Ganzkomma-Werte). 
Procedure get_angle(start_x, start_y, end_x, end_y)
 Protected angle.w
 Protected delta_x.w
 Protected delta_y.w

  delta_x = start_x - end_x
  delta_y = start_y - end_y
  angle = (ATan(delta_y / delta_x) * 180 / #PI) * (-1)        ;Der Winkel zum Object
 
  If angle < 0
    angle = 180 + angle
  EndIf
  If start_y < end_y       ;Negativer Winkel - also 180 dazu damit es volle 360 Grad werden!
    angle = 180 + angle
  EndIf
  If angle = 0 And start_x > end_x
    angle = 180
  EndIf
  If angle = 180 And start_x < end_x
    angle = 0
  EndIf

  ProcedureReturn angle
EndProcedure


;- Prozedur 2: 
; Die zweite Prozedur dient dazu, aus 2 Winkeln den kürzesten Weg zu errechnen.
; Als Beispiel nehme man eine Figur und die Maus. Die Figur soll sich zur 
; Maus hin drehen. Jetzt ist es wichtig zu wissen, in welche Richtung sich die 
; Figur drehen muss, damit der kürzeste Weg gewählt wird. Also entweder nach 
; links oder nach rechts rum. 
; Diese Prozedur also errechnet aus Ausgangswinkel und neuem Zielwinkel die 
; Drehrichtung, Rückgabewert ist entweder 0 für links herum oder 1 für rechts 
; herum drehen. 
; Der Parameter Start_angle muss den derzeitigen Winkel der Figur enthalten. 
; Der end_angle muss der neue Winkel sein, welchen die Figur einnehmen soll. 
; Als Beispiel: 
; Die Maus steht zur Figur um 90 Grad Winkel, also über der Figur. Die Figur 
; schaut nach links, also 180 Grad gedreht. Gibt man nun die Werte 180 und 90 
; ein, so ergibt sich der Rückgabewert der Prozedur = 1, also nach rechts 
; rotieren. Denn rechtsrum muss nur ein 90 Grad Winkel überbrückt werden, 
; linksherum sind es dann 270 Grad um zum Ziel zu gelangen. 
; Hat man die Drehrichtung, könnte man jetzt die Figur in diese Richtung 
; drehen lassen. Also eigentlich ganz einfach und nützlich wenn man ein 
; 2D-Spiel macht, indem man die Figur per Maus drehen kann, oder die Figur zu 
; einem bestimmten Punkt drehen will, aber nicht weiß, ob rechts rum oder 
; links herum der kürzere Weg ist. 
Procedure get_rotate_direction(start_angle, end_angle)
  Protected temp.w
  Protected temp2.w
  
  If start_angle > end_angle
    temp = start_angle - end_angle
    temp2 = end_angle + (360 - start_angle)
    If temp < temp2
      ProcedureReturn 1       ;Rechtsrum ist kuerzester Weg
    Else
      ProcedureReturn 0       ;Linksrum ist kuerzester Weg
    EndIf
  Else
    temp = end_angle - start_angle
    temp2 = start_angle + (360 - end_angle)
    If temp < temp2
      ProcedureReturn 0       ;Linksrum ist kuerzester Weg
    Else
      ProcedureReturn 1       ;Rechtsrum ist kuerzester Weg
    EndIf
  EndIf
EndProcedure



;- Beispiel:
; Um nun ein praktisches Anwendungsbeispiel zu geben, habe ich diesen Code erstellt: 
; Das erste Objekt im Beispielprogramm dreht sich immer automatisch zur Maus hin. 
; Das zweite Objekt dreht sich nur dann, wenn die linke Maustaste gedrückt wird. 
; Dabei nutzt sie die Prozedur 2 und errechnet den kürzesten Weg und dreht sich 
; dann in die entsprechende Richtung. Links herum oder rechts herum, kommt darauf 
; an wo sich die Maus befindet. Wichtig dabei, die linke Maustaste gedrückt halten 
; zum rotieren lassen. 
; So, ich hoffe es finden sich Leute die damit etwas anfangen können. Gedacht ist 
; das Ganze für 2D-Spiele indem man Winkel abfragt oder kürzeste Drehrichtungen 
; benötigt.

InitSprite() : InitMouse() : InitKeyboard() : InitSprite3D() : Sprite3DQuality(0)

ExamineDesktops()
Screenwidth  = DesktopWidth(0)
Screenheight = DesktopHeight(0)

If OpenScreen(Screenwidth, Screenheight, 32, "Rotation-Test")
  CreateSprite(1, 6, 6)
  LoadSprite(0, "rotate.bmp", #PB_Sprite_Texture)
  CreateSprite3D(0, 0)
    
  sprite1_x = 300
  sprite1_y = 400
  sprite2_x = 600
  sprite2_y = 400

  Repeat

    ExamineMouse()
    mouse_x = MouseX()
    mouse_y = MouseY()

    angle = get_angle(sprite1_x + 50, sprite1_y + 50, mouse_x, mouse_y)       ;+ 50 weil der Mittelpunkt der Drehpunkt ist, nicht Pixel 0,0 des Sprites

    If MouseButton(1)
      
      zielwinkel = get_angle(sprite2_x + 50, sprite2_y + 50, mouse_x, mouse_y)        ;Den Winkel: Objekt zu Maus berechnen
      
      If angle_2 <> zielwinkel
        If get_rotate_direction(angle_2, zielwinkel) = 0        ;Wenn Linksdrehung, dann Winkel vergrößern
          angle_2 = angle_2 + 3
        Else                                                    ;Wenn Rechtsdrehung, dann Winkel verkleinern
          angle_2 = angle_2 - 3
        EndIf
        
        If angle_2 >= 360
          angle_2 = angle_2 - 360
        EndIf
        
        If angle_2 <= 0
          angle_2 = 360 - angle_2
        EndIf
      EndIf
    EndIf

    ClearScreen(RGB(0,122,122))
    
    DisplaySprite(1, mouse_x, mouse_y)
    
    Start3D()
      RotateSprite3D(0, 270 -angle, 0)
      DisplaySprite3D(0, sprite1_x, sprite1_y)
      
      RotateSprite3D(0, 270 - angle_2, 0)
      DisplaySprite3D(0, sprite2_x, sprite2_y)
    Stop3D()
    
    StartDrawing(ScreenOutput())
      DrawText(10, 10, "Linke Maustaste gedrückt halten, um Objekt_2 neuen Winkel zuzuteilen")
      DrawText(10, 30, "Winkel - Object_links - Maus: " + Str(angle))
      DrawText(10, 50, "Winkel - Object_rechts: " + Str(angle_2))
    StopDrawing()
    
    FlipBuffers(1)
    
    ExamineKeyboard()
    
    If KeyboardPushed(#PB_Key_Escape)
      quit = #True
    EndIf
    
  Until quit = #True
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -