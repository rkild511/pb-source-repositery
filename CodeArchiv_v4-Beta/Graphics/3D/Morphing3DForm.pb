; French forum: http://purebasic.hmt-forum.com/viewtopic.php?t=1399&sid=39aa32245ac870ecf2c0a6740bbb1984
; Author: Le Soldat Inconnu (updated for PB 4.00 by Andre)
; Date: 03. September 2004
; OS: Windows
; Demo: No


; Auteur : Le Soldat Inconnu 
; Version de PB : 3.90 
; 
; Explication du programme : 
; Dessiner un cube filaire en 3D avec de la perspective 

ProcedureDLL.l ColorLuminosity(Couleur, Echelle.f) ; Eclaicir ou foncer une couleur 
  Protected Rouge, Vert, Bleu 
  
  Rouge = Red(Couleur) * Echelle 
  Vert = Green(Couleur) * Echelle 
  Bleu = Blue(Couleur) * Echelle 
  
  If Rouge > 255 : Rouge = 255 : EndIf 
  If Vert > 255 : Vert = 255 : EndIf 
  If Bleu > 255 : Bleu = 255 : EndIf 
  
  ProcedureReturn RGB(Rouge, Vert, Bleu) 
EndProcedure

#TailleX = 1024 
#TailleY = 768 

#Couleur = $E5A974 

#Cube = 175 ; Taille du cube 
#Echo = 8 ; Nombre d'écho 
#Echo_Espacement = 1 ; Espacement entre chaque écho 

#VitesseMax = 70 
#VitesseMin = 350 
#VitesseEvolution = 20 

Structure Point3D 
  x.f ; Coordonnée X 
  y.f ; Coordonnée Y 
  z.f ; Coordonnée Z 
  p.f ; Facteur pour la perspective 
EndStructure 

#Perspective = 600 ; Intensité de la perspective 

Procedure XYFrom3D(x.f, y.f, z.f, ax.f, ay.f, az.f, XYZ) 
  ; x, y, z : position de l'objet 
  ; ax, ay, az : angle de rotation du point sur l'axe x, y et z, pour avoir un repère 3D décalé par rapport au repère de l'écran 
  
  Protected x2.f, y2.f, z3.f, Coord.Point3D 
  
  ; Rotation sur l'axe Z 
  x2 = x * Cos(az) - y * Sin(az) 
  y2 = x * Sin(az) + y * Cos(az) 
  ; z2 = z 
  ; Debug StrF(x2) + " , " + StrF(y2) + " , " + StrF(z) 
  
  ; Rotation sur l'axe X 
  ; x3 = x2 
  Coord\y = y2 * Cos(ax) - z * Sin(ax) 
  z3 = y2 * Sin(ax) + z * Cos(ax) 
  ; Debug StrF(x2) + " , " + StrF(Coord\y) + " , " + StrF(z3) 
  
  ; Rotation sur l'axe Y 
  Coord\z = z3 * Cos(ay) - x2 * Sin(ay) 
  Coord\x = z3 * Sin(ay) + x2 * Cos(ay) 
  ; y4 = y3 
  ; Debug StrF(Coord\x) + " , " + StrF(Coord\y) + " , " + StrF(z3) 
  
  ; Prise en compte de la perspective 
  Coord\p = 1 + Abs(Coord\z) / #Perspective 
  If Coord\z < 0 
    Coord\p = 1 / Coord\p 
  EndIf 
  Coord\x = Coord\x * Coord\p 
  Coord\y = Coord\y * Coord\p 
  
  ; On copie les données 
  CopyMemory(@Coord, XYZ, SizeOf(Point3D)) 
EndProcedure 

Procedure Cube3D(AngleX.f, AngleY.f, AngleZ.f, Couleur) 
  StartDrawing(ScreenOutput()) 
    
    ; On dessine une ligne du cube 
    XYFrom3D(#Cube, #Cube, #Cube, AngleX, AngleY, AngleZ, Coord1.Point3D) ; on calcul les coordonnées de l'extrémité de la ligne pour l'affichage sur l'écran 
    XYFrom3D(#Cube, -#Cube, #Cube, AngleX, AngleY, AngleZ, Coord2.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) ; on trace une ligne à partir des coordonnées calculées 
    
    ; Et on dessine les autres lignes de la même manière 
    XYFrom3D(#Cube, -#Cube, -#Cube, AngleX, AngleY, AngleZ, Coord1.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    CopyMemory(@Coord2, @Coord1, SizeOf(Point3D)) ; On copie les valeurs de Coord2 dans Coord1 
    XYFrom3D(-#Cube, -#Cube, #Cube, AngleX, AngleY, AngleZ, Coord2.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    XYFrom3D(-#Cube, -#Cube, -#Cube, AngleX, AngleY, AngleZ, Coord1.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    CopyMemory(@Coord2, @Coord1, SizeOf(Point3D)) ; On copie les valeurs de Coord2 dans Coord1 
    XYFrom3D(-#Cube, #Cube, #Cube, AngleX, AngleY, AngleZ, Coord2.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    XYFrom3D(-#Cube, #Cube, -#Cube, AngleX, AngleY, AngleZ, Coord1.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    CopyMemory(@Coord2, @Coord1, SizeOf(Point3D)) ; On copie les valeurs de Coord2 dans Coord1 
    XYFrom3D(#Cube, #Cube, #Cube, AngleX, AngleY, AngleZ, Coord2.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    XYFrom3D(#Cube, #Cube, -#Cube, AngleX, AngleY, AngleZ, Coord1.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    XYFrom3D(#Cube, -#Cube, -#Cube, AngleX, AngleY, AngleZ, Coord2.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    CopyMemory(@Coord2, @Coord1, SizeOf(Point3D)) ; On copie les valeurs de Coord2 dans Coord1 
    XYFrom3D(-#Cube, -#Cube, -#Cube, AngleX, AngleY, AngleZ, Coord2.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    CopyMemory(@Coord2, @Coord1, SizeOf(Point3D)) ; On copie les valeurs de Coord2 dans Coord1 
    XYFrom3D(-#Cube, #Cube, -#Cube, AngleX, AngleY, AngleZ, Coord2.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
    CopyMemory(@Coord2, @Coord1, SizeOf(Point3D)) ; On copie les valeurs de Coord2 dans Coord1 
    XYFrom3D(#Cube, #Cube, -#Cube, AngleX, AngleY, AngleZ, Coord2.Point3D) 
    LineXY(Int(#TailleX / 2 + Coord1\x), Int(#TailleY / 2 + Coord1\y), Int(#TailleX / 2 + Coord2\x), Int(#TailleY / 2 + Coord2\y), Couleur) 
    
  StopDrawing() 
EndProcedure 

Procedure.l Objectif() 
  ProcedureReturn Int((Random(#VitesseMin - #VitesseMax) + #VitesseMax) / #VitesseEvolution) * #VitesseEvolution 
EndProcedure 

;- Début du code 

; Ecran de veille : Si on veut paramétrer, on ne lance rien 
Param.s = Left(ProgramParameter(), 2) 
If Param = "/p" 
  MessageRequester("Information", "Concepteur : Le Soldat Inconnu [Bouguin Régis]" + Chr(10) + "Programmé sur PureBasic" + Chr(10) + Chr(10) + "http://perso.wanadoo.fr/lesoldatinconnu/", 4 * 16) 
  End 
EndIf 

If OpenWindow(0, 0, 0, 100, 100, "Cube 3D", #PB_Window_BorderLess | #WS_MAXIMIZE) = 0 
  End 
EndIf 
SetWindowPos_(WindowID(0), -1, 0, 0, 0, 0, #SWP_NOSIZE | #SWP_NOMOVE) ; Pour mettre la fenêtre toujours au premier plan 
UpdateWindow_(WindowID(0)) 

If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 
  End 
EndIf 

If OpenScreen(#TailleX, #TailleY, 32, "Cube 3D") = 0 
  End 
EndIf 

AngleX.f = 0 
AngleY.f = 0 
AngleZ.f = 0 

; Paramètres des vitesses de rotation du cube 
RotationX = Objectif() 
RotationY = Objectif() 
RotationZ = Objectif() 
; Objectif des vitesses de rotation 
RotationX_Objectif = Objectif() 
RotationY_Objectif = Objectif() 
RotationZ_Objectif = Objectif() 

Repeat 
  
  ; On change l'angle d'inclinaison du cube (en fait, on change les angles entre le repère écran et le repère du dessin) 
  AngleX + #PI / RotationX 
  AngleY + #PI / RotationY 
  AngleZ + #PI / RotationZ 
  
  ; Permet de faire varier la vitesse de rotation du cube 
  If AngleX >= 2 * #PI Or AngleX <= -2 * #PI 
    AngleX = 0 ; On initialise l'angle car un angle de 2*#Pi est équivalent à un angle de 0 
    If RotationX > RotationX_Objectif 
      RotationX - #VitesseEvolution 
    ElseIf RotationX < RotationX_Objectif 
      RotationX + #VitesseEvolution 
    Else 
      RotationX_Objectif = Objectif() ; On fixe une nouvelle vitesse de rotation en objectif 
    EndIf 
  EndIf 
  If AngleY >= 2 * #PI Or AngleY <= -2 * #PI 
    AngleY = 0 
    If RotationY > RotationY_Objectif 
      RotationY - #VitesseEvolution 
    ElseIf RotationY < RotationY_Objectif 
      RotationY + #VitesseEvolution 
    Else 
      RotationY_Objectif = Objectif() 
    EndIf 
  EndIf 
  If AngleZ >= 2 * #PI Or AngleZ <= -2 * #PI 
    AngleZ = 0 
    If RotationZ > RotationZ_Objectif 
      RotationZ - #VitesseEvolution 
    ElseIf RotationZ < RotationZ_Objectif 
      RotationZ + #VitesseEvolution 
    Else 
      RotationZ_Objectif = Objectif() 
    EndIf 
  EndIf 
  
  ClearScreen(RGB(0, 0, 0))
  
  For n = #Echo To 0 Step -1 
    Cube3D(AngleX - n * #PI / RotationX / #Echo_Espacement, AngleY - n * #PI / RotationY / #Echo_Espacement, AngleZ - n * #PI / RotationZ / #Echo_Espacement, ColorLuminosity(#Couleur, 1 - n / (#Echo + 1))) 
  Next 
  
  ; On affiche les différentes vitesses et les objectifs 
;   StartDrawing(ScreenOutput()) 
;     Box(2, 2, 2 * RotationX / #VitesseEvolution, 3, $505050) 
;     Line(2, 5, 2 * RotationX_Objectif / #VitesseEvolution, 0, $7800) 
;      
;     Box(2, 9, 2 * RotationY / #VitesseEvolution, 3, $505050) 
;     Line(2, 12, 2 * RotationY_Objectif / #VitesseEvolution, 0, $7800) 
;      
;     Box(2, 16,  2 * RotationZ / #VitesseEvolution, 3, $505050) 
;     Line(2, 19, 2 * RotationZ_Objectif / #VitesseEvolution, 0, $7800) 
;   StopDrawing() 
  
  FlipBuffers() 
  
  ExamineKeyboard() 
  ExamineMouse() 
Until KeyboardPushed(#PB_Key_All) Or Abs(MouseDeltaX()) > 2 Or Abs(MouseDeltaY()) > 2
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -