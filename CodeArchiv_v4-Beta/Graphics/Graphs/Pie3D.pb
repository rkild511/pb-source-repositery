; French forum: http://purebasic.hmt-forum.com/viewtopic.php?t=612
; Author: Le Soldat Inconnu (updated for PB 4.00 by Andre)
; Date: 28. April 2004
; OS: Windows
; Demo: No


; Auteur : Le Soldat Inconnu
; Version de PB : 3.90
; 
; Explication du programme :
; Dessiner un camembert en 3D

Procedure Pie3D(hdc.l, X.l, Y.l, Rayon.l, Orientation.f, Hauteur.l, AngleDepart.f, AngleFin.f, Couleur.l)
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
  
  Y = Y - Hauteur / 2 ; on recentre le camemenbert en fonction de l'épaisseur
  
  R = Red(Couleur) : G = Green(Couleur) : b = Blue(Couleur) ; On décompose la couleur en RGB
  
  AX2 = Int(X + 100 * Cos(AngleDepart)) ; calcul du point d'arriver
  AY2 = Int(Y + 100 * Sin(AngleDepart) * Orientation)
  
  AX1 = Int(X + 100 * Cos(AngleFin)) ; calcul du point de départ
  AY1 = Int(Y + 100 * Sin(AngleFin) * Orientation)

  For n = Hauteur To 1 Step -1 ; On dessine l'épaisseur du camembert
    FrontColor(RGB(R * (0.8 - 0.08 * n / Hauteur), G * (0.8 - 0.08 * n / Hauteur), b * (0.8 - 0.08 * n / Hauteur))) ; Choix de la couleur du bord du camembert
    Pie_(hdc, X - Rayon, Y - Rayon2 + n, X + Rayon, Y + Rayon2 + n, AX1, AY1 + n, AX2, AY2 + n)
  Next
    
  FrontColor(RGB(R, G, b))
  Pie_(hdc, X - Rayon, Y - Rayon2, X + Rayon, Y + Rayon2, AX1, AY1, AX2, AY2) ; on dessine le dessus du camembert
  
EndProcedure



; Création de la fenêtre et dela GadgetList
If OpenWindow(0, 0, 0, 300, 300, "Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget) = 0 Or CreateGadgetList(WindowID(0)) = 0
  End
EndIf

hdc = StartDrawing(WindowOutput(0))
  
Pie3D(hdc, 150, 150, 120, 0.45, 20, 3 * 3.14159 / 4, 0 , RGB(100, 200, 100))
  
StopDrawing()

Repeat
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_Repaint
    hdc = StartDrawing(WindowOutput(0))
      Pie3D(hdc, 150, 150, 120, 0.45, 20, 3 * 3.14159 / 4, 0 , RGB(100, 200, 100))
    StopDrawing()
  EndIf
  
Until Event = #PB_Event_CloseWindow

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -