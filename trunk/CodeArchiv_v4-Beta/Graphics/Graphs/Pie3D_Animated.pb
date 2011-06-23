; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13845&highlight=
; Author: Le Soldat Inconnu (updated for PB 4.00 by Andre)
; Date: 30. January 2005
; OS: Windows
; Demo: No


; Auteur : Le Soldat Inconnu 
; Version de PB : 3.92 
; 
; Explication du programme : 
; Dessiner un camembert en 3D 

Procedure Pie3D(HDC.l, x.l, y.l, Rayon.l, Orientation.f, Hauteur.l, AngleDepart.f, AngleFin.f, Couleur.l) 
  ; HDC : Handle du dessin 
  ; X, Y : centre du camembert 
  ; Rayon : Rayon du camembert 
  ; Orientation : Orientation du camembert qui donne l'effet 3D. cette valeur doit être comprise entre 0 et 1 
  ; Hauteur : Hauteur ou épaisseur du camembert 
  ; AngleDepart : Angle de départ en radian 
  ; AngleFin : Angle de fin en radian 
  ; Couleur : Couleur du camenbert 
  
  Protected R.l, G.l, b.l, n.l, AX1.l, AY1.l, AX2.l, AY2.l, Rayon2.l 
  
  Rayon2 = Rayon * Orientation ; calul du rayon sur l'axe Y du camembert 
  
  y = y - Hauteur / 2 ; on recentre le camemenbert en fonction de l'épaisseur 
  
  R = Red(Couleur) : G = Green(Couleur) : b = Blue(Couleur) ; On décompose la couleur en RGB 
  
  AX2 = Int(x + 100 * Cos(AngleDepart)) ; calcul du point d'arriver 
  AY2 = Int(y + 100 * Sin(AngleDepart) * Orientation) 
  
  AX1 = Int(x + 100 * Cos(AngleFin)) ; calcul du point de départ 
  AY1 = Int(y + 100 * Sin(AngleFin) * Orientation) 
  
  For n = Hauteur To 1 Step -1 ; On dessine l'épaisseur du camembert 
    FrontColor(RGB(R * (0.8 - 0.08 * n / Hauteur), G * (0.8 - 0.08 * n / Hauteur), b * (0.8 - 0.08 * n / Hauteur))) ; Choix de la couleur du bord du camembert 
    Pie_(HDC, x - Rayon, y - Rayon2 + n, x + Rayon, y + Rayon2 + n, AX1, AY1 + n, AX2, AY2 + n) 
  Next 
  
  ; On dessine le dessus du camembert 
  FrontColor(RGB(R, G, b)) 
  Pie_(HDC, x - Rayon, y - Rayon2, x + Rayon, y + Rayon2, AX1, AY1, AX2, AY2) ; on dessine le dessus du camembert 
  
EndProcedure 

Procedure DoublePie3D(HDC.l, x.l, y.l, Rayon.l, Orientation.f, Hauteur.l, Decalage.l, Angle.f, Couleur1.l, Couleur2.l) 
  ; HDC : Handle du dessin 
  ; X, Y : centre du camembert 
  ; Rayon : Rayon du camembert 
  ; Orientation : Orientation du camembert qui donne l'effet 3D. cette valeur doit être comprise entre 0 et 1 
  ; Hauteur : Hauteur ou épaisseur du camembert 
  ; Decalage : Pour mettre un espace entre les 2 zone du camenbert 
  ; Angle : Angle correspondant à la zone 1 du camembert 
  ; Couleur1 : Couleur de la zone 1 du camenbert 
  ; Couleur2 : Couleur de la zone 2 du camenbert 
  
  DecalageX = Int(Decalage * Cos(Angle / 2)) 
  DecalageY = Int(Decalage * Sin(Angle / 2) * Orientation) 
  
  If Angle = 0 
    Pie3D(HDC, x, y, Rayon, Orientation, Hauteur, 0, 2 * #PI, Couleur1) 
  ElseIf Angle <= #PI / 2 
    Pie3D(HDC, x + DecalageX, y + DecalageY, Rayon, Orientation, Hauteur, #PI + Angle, 0, Couleur1) 
    Pie3D(HDC, x - DecalageX, y - DecalageY, Rayon, Orientation, Hauteur, #PI, #PI + Angle, Couleur2) 
    Pie3D(HDC, x + DecalageX, y + DecalageY, Rayon, Orientation, Hauteur, 0, #PI, Couleur1) 
  ElseIf Angle <= 3 * #PI / 2 
    Pie3D(HDC, x - DecalageX, y - DecalageY, Rayon, Orientation, Hauteur, #PI, #PI + Angle, Couleur2) 
    Pie3D(HDC, x + DecalageX, y + DecalageY, Rayon, Orientation, Hauteur, #PI + Angle, #PI, Couleur1) 
  Else 
    Pie3D(HDC, x - DecalageX, y - DecalageY, Rayon, Orientation, Hauteur, #PI, 0, Couleur2) 
    Pie3D(HDC, x + DecalageX, y + DecalageY, Rayon, Orientation, Hauteur, #PI + Angle, #PI, Couleur1) 
    Pie3D(HDC, x - DecalageX, y - DecalageY, Rayon, Orientation, Hauteur, 0, #PI + Angle, Couleur2) 
  EndIf 
EndProcedure 



; Création de la fenêtre et dela GadgetList 
If OpenWindow(0, 0, 0, 600, 600, "Pie3D Animated", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget) = 0 Or CreateGadgetList(WindowID(0)) = 0 
  End 
EndIf 

CreateImage(0, 600, 600) 
ImageGadget(0, 0, 0, 0, 0, ImageID(0)) 

SetTimer_(WindowID(0), 0, 30, 0) 

Repeat 
  Event = WaitWindowEvent() 
  
  If Event = #WM_TIMER 
    
    Angle.f + 0.02 
    If Angle > 2 * #PI 
      Angle = 0 
    EndIf 
    
    HDC = StartDrawing(ImageOutput(0)) 
      Box(0, 0, 600, 600, 0) 
      
      ; Camenbert normal (1 seule part) 
      Pie3D(HDC, 150, 150, 120, 0.45, 20, Angle, 0, RGB(100, 200, 200)) 
      
      ; Camenbert normal (1 seule part) 
      Pie3D(HDC, 150, 450, 120, 0.8, 20, #PI, #PI + Angle, RGB(100, 200, 200)) 
      
      ; Camenbert avec 2 parts 
      DoublePie3D(HDC, 450, 150, 140, 0.6, 10, 0, Angle, RGB(100, 200, 200), RGB(0, 150, 150)) 
      
      ; Camenbert avec 2 parts et avec un espace entre les parts 
      DoublePie3D(HDC, 450, 450, 100, 0.5, 15, 5, Angle, RGB(100, 200, 200), RGB(0, 150, 150)) 
      
      
    StopDrawing() 
    SetGadgetState(0, ImageID(0)) 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

KillTimer_(WindowID(0), 0) 

End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -