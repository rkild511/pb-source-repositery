; http://michel.dobro.free.fr/
; Author: Le Soldat Inconnu (updated for PB 4.00 by Andre)
; Date: 25. July 2004
; OS: Windows
; Demo: No

; Auteur : Le Soldat Inconnu
; Version de PB : 3.90
;
; Explication du programme :
; Dessiner un engrenage en 3D avec une animation

Procedure Engrenage(ImageID, x.f, y.f, Rayon.l, RayonAlesage.l, NbDents.l, HauteurDent.l, Decalage.f, Inclinaison.f, Epaisseur.l, Couleur.l)
  Protected x2.f, y2.f, nn.l, LargeurDent.l, n.l, Facteur.f, Cos.f, Sin.f, Cos2.f, Sin2.f, PosX.f, PosY.f, PosX1, PosY1, PosX2, PosY2, PosX3, PosY3, PosX4, PosY4, PosX5, PosY5
  ; x, y : position duentre de l'engrenage
  ; Rayon : rayon de l'engrenage
  ; RayonAlesage : rayon du trou au centre de l'engrenage
  ; NbDents : nombre de dents
  ; HauteurDent : Hauteur des dents
  ; Decalage : nombre de dents de décalage par rapport r l'origine, utilise pour faire tourner l'engrenage
  ; Inclinaison : L'inclinaison de l'engrenage pour l'effet 3D
  ; Epaisseur : l'épaisseur de l'engrenage
  ; Couleur : couleur de l'engrenage
  
  StartDrawing(ImageOutput(ImageID))
    
    x2.f= x
    y2.f = y
    x = x + (Inclinaison * Cos(#PI / 4)) * Rayon * 2 / 3
    y = y + (Inclinaison * Cos(#PI / 4)) * Rayon * 2 / 3
    
    For nn = 0 To Epaisseur
      
      Couleur = RGB(Red(Couleur) * 0.98, Green(Couleur) * 0.98, Blue(Couleur) * 0.98)
      If nn = Epaisseur
        Couleur = RGB(Red(Couleur) * 0.9, Green(Couleur) * 0.9, Blue(Couleur) * 0.9)
      EndIf
      
      LargeurDent = Int(Rayon * 3 / 5 * Sin(#PI / NbDents) + 0.5) ; on détermine la largeur d'une dents
      
      For n = 1 To NbDents + 1 ; on passe en revue toutes les dents
        
        Facteur.f = (1 - Inclinaison * Cos((n + Decalage) * 2 * #PI / NbDents - #PI / 4))
        
        Cos.f = Cos((n + Decalage) * 2 * #PI / NbDents) ; Calcul du cos de l'angle
        Sin.f = Sin((n + Decalage) * 2 * #PI / NbDents) ; Calcul du sin de l'angle
        
        PosX.f = x + Facteur * Rayon * Cos
        PosY.f = y + Facteur * Rayon * Sin
        
        Longueur.f = Sqr(Pow(PosX - x2, 2) + Pow(PosY - y2, 2))
        
        Cos2.f = (PosX - x2) / Longueur ; Calcul du cos de l'angle
        Sin2.f = (PosY - y2) / Longueur ; Calcul du sin de l'angle
              
        ; Point haut gauche de la dent
        PosX1 = Int(PosX + Facteur * LargeurDent / 2 * Sin2 + 0.5)
        PosY1 = Int(PosY - Facteur * LargeurDent / 2 * Cos2 + 0.5)
        ; Point haut droit de la dent
        PosX2 = Int(PosX - Facteur * LargeurDent / 2 * Sin2 + 0.5)
        PosY2 = Int(PosY + Facteur * LargeurDent / 2 * Cos2 + 0.5)
        ; Point bas gauche de la dent
        PosX3 = Int(PosX + Facteur * (-HauteurDent * Cos2 + LargeurDent * Sin2) + 0.5)
        PosY3 = Int(PosY + Facteur * (-HauteurDent * Sin2 - LargeurDent * Cos2) + 0.5)
        ; Point bas droit de la dent
        PosX4 = Int(PosX + Facteur * (-HauteurDent * Cos2 - LargeurDent * Sin2) + 0.5)
        PosY4 = Int(PosY + Facteur * (-HauteurDent * Sin2 + LargeurDent * Cos2) + 0.5)
        
        ; Dessin du contour de la dent
        LineXY(PosX1, PosY1, PosX2, PosY2, Couleur)
        LineXY(PosX1, PosY1, PosX3, PosY3, Couleur)
        LineXY(PosX4, PosY4, PosX2, PosY2, Couleur)
        
        If n > 1
          LineXY(PosX3, PosY3, PosX5, PosY5, Couleur)
        EndIf
        
        PosX5 = PosX4
        PosY5 = PosY4
  
      Next
      
      ; Remplissage de l'engrenage
      FillArea(x, y, Couleur, Couleur)
      
      x + 1
      y + 1
      x2 + 1
      y2 + 1
      
      ; Circle(x, y, RayonAlesage, RGB(255, 255, 255))
      ; Circle(x2, y2, RayonAlesage/2, RGB(255, 0, 0))
    Next
  StopDrawing()
EndProcedure



;- Exemple

; Création de la fenetre et dela GadgetList
If OpenWindow(0, 0, 0, 600, 600, "Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget) = 0 Or CreateGadgetList(WindowID(0)) = 0
  End
EndIf

; On crée les 20 images de l'animation
For n = 0 To 19

  ; Création de l'image
  CreateImage(n, 600, 600)
  StartDrawing(ImageOutput(n))
    Box(0, 0, 600, 600, RGB(255, 255, 255))
  StopDrawing()
  
  ; On dessine les engrenages
  ; Il est important de garder le meme nombre de dents entre 2 engrenages qui s'engrainent, sinon les engrenages n'iront pas r la meme vitesse
  Engrenage(n, 420, 420, 136, 40, 15, 24, (16 - n) / 20, 0.2, 30, RGB(170, 170, 170))
  Engrenage(n, 200, 200, 190, 70, 15, 40, n / 20, 0.2, 30, RGB(170, 170, 170))
  Engrenage(n, 450, 450, 88, 40, 13, 22, (17 - n) / 20, 0.2,20, RGB(170, 170, 170)) ; on décale de l'épaisseur du premier engrenage cet engrenage afin de le positionner par dessus l'autre
  Engrenage(n, 450, 250, 120, 30, 13, 28, (n - 7) / 20, 0.2,20, RGB(170, 170, 170))
   
;   Engrenage(210, 210, 68, 20, 15, 12, (17 - n) / 20, 0.2, 15, RGB(170, 170, 170))
;   Engrenage(100, 100, 95, 35, 15, 20, n / 20, 0.2, 15, RGB(170, 170, 170))
;   Engrenage(225, 225, 44, 20, 13, 11, (17 - n) / 20, 0.2,10, RGB(170, 170, 170)) ; on décale de l'épaisseur du premier engrenage cet engrenage afin de le positionner par dessus l'autre
;   Engrenage(225, 125, 60, 30, 13, 14, (n - 6) / 20, 0.2,10, RGB(170, 170, 170))
   
  ; On affiche l'image
  StartDrawing(WindowOutput(0))
    DrawImage(ImageID(n), 0, 0)
  StopDrawing()
  
Next

StartDrawing(WindowOutput(0))

  ; On lance un Timer toutes les 20 ms
  SetTimer_(WindowID(0), 0, 20, 0)
  n = 0
  Repeat
    Event = WaitWindowEvent()
    
    If Event = #WM_TIMER ; Si on a le Timer
      ; On passe r l'image suivante
      n + 1
      If n = 20 : n = 0 : EndIf
      ; On dessine les engrenages dans la nouvelle position
      DrawImage(ImageID(n), 0, 0)
    EndIf
    
  Until Event = #PB_Event_CloseWindow
  
  ; On tue le Timer
  KillTimer_(WindowID(0), Timer)

StopDrawing()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger