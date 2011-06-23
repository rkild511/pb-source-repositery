; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7475&highlight=
; Author: Comtois (updated for PB4.00 by blbltheworm)
; Date: 08. September 2003
; OS: Windows
; Demo: No


#winMain=1

Procedure.l GetWindowSize(type.l) 
   ; Source http://forum.purebasic.fr/    
   ; type = 1 : largeur de la bordure droite, gauche ou basse d'une fenêtre 
   ; type = 2 : hauteur de la bordure de titre d'une fenêtre 
   ; type = 3 : largeur de la fenêtre 
   ; type = 4 : hauteur de la fenêtre 
    
   GetWindowRect_(WindowID(#winMain), @Taille_Fenetre.RECT) 
   Largeur_Fenetre = Taille_Fenetre\Right - Taille_Fenetre\Left 
   Hauteur_Fenetre = Taille_Fenetre\Bottom - Taille_Fenetre\top 
   Largeur_Bordure = (Largeur_Fenetre - WindowWidth(#winMain)) / 2 
   Hauteur_Titre = Hauteur_Fenetre - WindowHeight(#winMain) - Largeur_Bordure 
   Select type 
      Case 1 
         ProcedureReturn Largeur_Bordure 
      Case 2 
         ProcedureReturn Hauteur_Titre 
      Case 3 
         ProcedureReturn Largeur_Fenetre 
      Case 4 
         ProcedureReturn Hauteur_Fenetre 
   EndSelect 
EndProcedure 

If OpenWindow(#winMain, 0, 0, 500, 500, "TEST", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget) 
  
   If CreateGadgetList(WindowID(#winMain)) 
      ScrollAreaGadget(0, 0, 0, 450, 450, 1000, 1000, 5, #PB_ScrollArea_BorderLess) 
      CloseGadgetList() 
   EndIf 
  
   If CreateStatusBar(0, WindowID(#winMain)) 
      AddStatusBarField(100) 
      AddStatusBarField(100) 
   EndIf 

   Repeat 
      ; Position curseur de la ScrollArea 
      PosScrollH.l = GetScrollPos_(GadgetID(0), #SB_HORZ) 
      PosScrollV.l = GetScrollPos_(GadgetID(0), #SB_VERT) 
      
      ; Largeur et hauteur bordures de la fenêtre 
      Largeur.l = GetWindowSize(1) 
      Hauteur.l = GetWindowSize(2) 
      
      ; Calcule la position de la souris sur la ScrollArea 
      MulotX = PosScrollH + WindowMouseX(#winMain)-Largeur 
      MulotY = PosScrollV + WindowMouseY(#winMain)-Hauteur 
      
      StatusBarText(0,0,Str(PosScrollH)+" - " +Str(PosScrollV),#PB_StatusBar_Center) 
      StatusBarText(0,1,Str(MulotX)+" - " +Str(MulotY),#PB_StatusBar_Center) 
  Until WaitWindowEvent() = #PB_Event_CloseWindow 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
