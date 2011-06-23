; French forum: 
; Author: Le Soldat Inconnu (updated for PB 4.00 by Andre)
; Date: 18. July 2004
; OS: Windows
; Demo: Yes

; http://michel.dobro.free.fr/CodeFR/rubriques/graphisme/Cercle%20avec%20lissage.pb

; Auteur : Le Soldat Inconnu
; Version de PB : 3.90
; 
; Explication du programme :
; Dessiner un cercle avec un effet de fondu avec le fond afin d'avoir un cercle le plus lisse possible

Procedure Cercle(cx.l, cy.l, rx.l, ry.l, Couleur.l, Lumiere.f, OutputID.l)
  ; Cette procedure permet de dessiner une ellipse avec lissage
  
  ; cx = Centre de l'ellipse sur les x
  ; cy = Centre de l'ellipse sur les y
  
  ; rx = Rayon de l'ellipse sur les x
  ; ry = Rayon de l'ellipse sur les y
  
  ; couleur = Couleur de trac�
  
  ; Lumiere = Coefficient permettant d'ajuster le lissage en fonction de la couleur de fond et de celle du cercle 
  ; Lumiere = 1/2 : couleur claire 
  ; Lumiere = 1 : couleur fonc�e
  ; Lumiere = 2/3 : couleur interm�diaire
  ; Toutes les valeurs sont accept�es
  ; Plus Lumiere tant vers 0 et plus la couleur est �claircie
  ; Plus Lumiere tant vers l'infini et plus la couleur est assombrie
  ; Quand lumi�re = 1, il n'y a pas de modification des couleurs
  
  ; OutputID = la valeur OutputID de la fen�tre en cours n�cessaire � StartDrawing() pour effectuer les dessins 2D 
  
    
  ; On dimensionne la matrice qui servira de masque
  Dim Zone.f(2 * (rx + 1), 2 * (ry + 1))
  
  StartDrawing(OutputID)
    
    ; On d�finit les pixel qui doivent �tre color�s avec un coefficient d'application (pour le lissage)
    For n = 0 To rx * ry
      
      angle.f = 3.141593 * n / (rx * ry * 2) ; Angle
      
      X.f = rx * Cos(angle) ; Position r�elle en x
      Y.f = ry * Sin(angle) ; Position r�elle en y
      xx.l = Int(X + 0.5) ; Position approxim�e de x
      yy.l = Int(Y + 0.5) ; Position approxim�e de y
      
      For dx = -1 To 1 ; On se d�place autour du point aproxim�e
        For dy = -1 To 1
          
          CoefX.f = 1 - Abs(X - xx - dx) ; On calcul la diff�rence entre le point r�el et le point approxim� + d�placement
          CoefY.f = 1 - Abs(Y - yy - dy)
          
          If CoefX > 0 And CoefY > 0 ; Si les coefficient partiel sont positif
            Coef.f = Pow(CoefX * CoefY, Lumiere) ; on calcul le coefficient � appliquer pour r�partir la couleur du point sur plusieurs pixels
          Else ; Sinon le point ne doit pas contenir de couleur
            Coef.f = 0
          EndIf
          
          If Coef > Zone(xx + dx + rx + 1, yy + dy + ry + 1)
            ; On ne dessine qu'un quart du cercle que l'on duplique par sym�trie
            Zone(rx + 1 + (xx + dx), ry + 1 + (yy + dy)) = Coef
            Zone(rx + 1 - (xx + dx), ry + 1 + (yy + dy)) = Coef
            Zone(rx + 1 + (xx + dx), ry + 1 - (yy + dy)) = Coef
            Zone(rx + 1 - (xx + dx), ry + 1 - (yy + dy)) = Coef
          EndIf
          
        Next
      Next
      
    Next
    
    For dx = 1 To 2 * rx + 1

      For dy = 1 To 2 * ry + 1
        
        If Zone(dx, dy) > 0 ; Si le point est color�
          
          Couleur_origine = Point(cx - rx - 1 + dx, cy - ry - 1 + dy) ; On regarde la couleur d'origine
          
          Rouge.l = Int((1 - Zone(dx, dy)) * Red(Couleur_origine) + Zone(dx, dy) * Red(Couleur)) ; On fusionne la couleur du cercle avec la couleur du fond
          Vert.l = Int((1 - Zone(dx, dy)) * Green(Couleur_origine) + Zone(dx, dy) * Green(Couleur))
          Bleu.l = Int((1 - Zone(dx, dy)) * Blue(Couleur_origine) + Zone(dx, dy) * Blue(Couleur))
          
          Plot(cx - rx - 1 + dx, cy - ry - 1 + dy, RGB(Rouge, Vert, Bleu)) ; On dessine le nouveau point
          
        EndIf
        
      Next
    Next
    
  StopDrawing()
EndProcedure









;- Test

OpenWindow(0, 0, 0, 400, 400, "Cercle", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CreateGadgetList(WindowID(0))

; On cr�e une image
CreateImage(0, 400, 400)

; On r�alise un d�cor sur l'image
StartDrawing(ImageOutput(0))
  For n = 0 To 200
    Line(0, n, 400, 0, RGB(n, 0, 0)) ; d�grad� rouge
    Line(0, 400 - n, 400, 0, RGB(n, n, n)) ; d�grad� gris
  Next
  Box(300, 150, 100, 100, $FFFFFF)
StopDrawing()

; On dessine des cercles
Cercle(200, 200, 150, 190, $FFFFFF, 1/2, ImageOutput(0)) ; Ellipse blanche
Cercle(120, 200, 100, 100, $C800, 1/2,  ImageOutput(0)) ; Cercle vert
Cercle(350, 200, 40, 30, 0, 0.9,  ImageOutput(0)) ; Ellipse noire
Cercle(350, 200, 20, 20, $7A7A7A, 0.8,  ImageOutput(0)) ; Cercle gris

; On affiche l'image
ImageGadget(0, 0, 0, 400, 400, ImageID(0))

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -