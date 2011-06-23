; French forum: 
; Author: Le Soldat Inconnu (updated for PB 4.00 by Andre)
; Date: 18. July 2004
; OS: Windows
; Demo: Yes

; http://michel.dobro.free.fr/CodeFR/rubriques/graphisme/Engrenage.pb

; Auteur : Le Soldat Inconnu
; Version de PB : 3.90
; 
; Explication du programme :
; Dessiner un engrenage


Procedure Engrenage(x.l, y.l, rayon.l, RayonAlesage.l, NbDents.l, HauteurDent.l, Decalage.f, Couleur.l)
  ; x, y : position duentre de l'engrenage
  ; Rayon : rayon de l'engrenage
  ; RayonAlesage : rayon du trou au centre de l'engrenage
  ; NbDents : nombre de dents
  ; HauteurDent : Hauteur des dents
  ; Decalage : norbre de dents de décalage par rapport à l'origine, utilise pour faire tourner l'engrenage
  ; Couleur : couleur de l'engrenage

  StartDrawing(ImageOutput(0))
  
    DrawingMode(4)
    Circle(x, y, rayon - HauteurDent, Couleur) ; on dessine l'engrenage
    Circle(x, y, RayonAlesage, Couleur) ; on dessine le trou de l'engrenage
    DrawingMode(0)
    FillArea(x, y + RayonAlesage + 2, Couleur, Couleur) ; on rempli l'engrenage
     
    LargeurDent = Int(rayon * 3 / 5 * Sin(#PI / NbDents) + 0.5) ; on détermine la largeur d'une dents
    
    For n = 1 To NbDents ; on passe en revue toutes les dents
      
      Cos.f = Cos((n + Decalage) * 2 * #PI / NbDents) ; Calcul du cos de l'angle
      Sin.f = Sin((n + Decalage) * 2 * #PI / NbDents) ; Calcul du sin de l'angle
      
      ; Point haut gauche de la dent
      PosX1 = Int(x + rayon * Cos + LargeurDent / 2 * Sin + 0.5)
      PosY1 = Int(y + rayon * Sin - LargeurDent / 2 * Cos + 0.5)
      ; Point haut droit de la dent
      PosX2 = Int(x + rayon * Cos - LargeurDent / 2 * Sin + 0.5)
      PosY2 = Int(y + rayon * Sin + LargeurDent / 2 * Cos + 0.5)
      ; Point bas gauche de la dent
      PosX3 = Int(x + (rayon - HauteurDent - 2) * Cos + LargeurDent * Sin + 0.5)
      PosY3 = Int(y + (rayon - HauteurDent - 2) * Sin - LargeurDent * Cos + 0.5)
      ; Point bas droit de la dent
      PosX4 = Int(x + (rayon - HauteurDent - 2) * Cos - LargeurDent * Sin + 0.5)
      PosY4 = Int(y + (rayon - HauteurDent - 2) * Sin + LargeurDent * Cos + 0.5)
      
      ; Dessin du contour de la dent
      LineXY(PosX1, PosY1, PosX2, PosY2, Couleur)
      LineXY(PosX1, PosY1, PosX3, PosY3, Couleur)
      LineXY(PosX4, PosY4, PosX2, PosY2, Couleur)
      
      ; Remplissage de la dent
      FillArea(Int(x + (rayon - HauteurDent / 2) * Cos + 0.5), Int(y + (rayon - HauteurDent / 2) * Sin + 0.5), Couleur, Couleur)
      
    Next
  StopDrawing()
EndProcedure


;- Exemple

; Création de la fenêtre et dela GadgetList
If OpenWindow(0, 0, 0, 300, 300, "Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget) = 0 Or CreateGadgetList(WindowID(0)) = 0
  End
EndIf

; Création de l'image
CreateImage(0, 300, 300)
StartDrawing(ImageOutput(0))
  Box(0, 0, 300, 300, RGB(255, 255, 255))
StopDrawing()

; On dessine l'engrenage
Engrenage(150, 150, 120, 40, 16, 30, 0.6, RGB(0, 0, 0))

; On affiche l'image
ImageGadget(0, 0, 0, 300, 300, ImageID(0))

; Sauvegarde de l'image
; UsePNGImageEncoder()
; SaveImage(0, "Engrenage.png", #PB_ImagePlugin_PNG)

Repeat
  Event = WaitWindowEvent()
  
Until Event = #PB_Event_CloseWindow

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -