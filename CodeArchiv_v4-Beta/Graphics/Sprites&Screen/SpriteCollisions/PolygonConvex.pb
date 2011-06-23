; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14049
; Author: Comtois (updated for PB 4.00 by Andre)
; Date: 19. February 2005
; OS: Windows
; Demo: Yes


;Comtois 19/02/05 
;Construction d'un polygone convexe 

;-Include 
Declare Erreur(Message$) 
Declare TracePolygone() 
Declare AffPoints() 
Declare TestPoint(x1, Y1, X2, Y2, d) 
Declare PolygoneConvexe() 

Global ScreenHeight.l, ScreenWidth.l 
If ExamineDesktops() 
  ScreenWidth = DesktopWidth(0) 
  ScreenHeight = DesktopHeight(0) 
Else 
  Erreur("Euh ?") 
EndIf 

Structure NewPoint 
  x.l 
  y.l 
  dx.l 
  dy.l 
EndStructure  

#Nbpoints = 16 
#Taille = 16 

Global NewList ListPoint.NewPoint() 
Global NewList Polygone.NewPoint() 

DiametreSelection = 6 

;Répartition des boules sur l'écran 
For i=1 To #Nbpoints 
  AddElement(ListPoint()) 
  *MemPos.NewPoint = ListPoint() 
  MemIndex=ListIndex(ListPoint()) 
  Repeat 
    Collision = #False 
    x = #Taille + Random(ScreenWidth - #Taille * 2) 
    y = #Taille + Random(ScreenHeight - #Taille * 2) 
    If CountList(ListPoint()) > 1 
      ForEach ListPoint() 
        If ListIndex(ListPoint()) = MemIndex 
          Continue 
        EndIf  
        If Sqr(Pow(ListPoint()\x - x, 2.0) + Pow(ListPoint()\y - y, 2.0)) <= #Taille * 2 
          Collision = #True 
          Break 
        EndIf 
      Next 
    EndIf 
  Until Collision = #False 
  SelectElement(ListPoint(), MemIndex) 
  ListPoint()\x = x 
  ListPoint()\y = y 
  ListPoint()\dx = 1 + Random(3) 
  ListPoint()\dy = 1 + Random(3) 
Next 

;-Initialisation 
If InitSprite() = 0 Or InitMouse() = 0 Or InitKeyboard() = 0 
  Erreur("Impossible d'initialiser DirectX 7 Ou plus") 
ElseIf OpenWindow(0, 0, 0, ScreenWidth, ScreenHeight, "Collision", #PB_Window_BorderLess) = 0 
  Erreur("Impossible de créer la fenêtre") 
EndIf 
If OpenWindowedScreen( WindowID(0), 0, 0, ScreenWidth , ScreenHeight, 0, 0, 0 ) = 0 
  Erreur("Impossible d'ouvrir l'écran ") 
EndIf 

;-Sprite 
CreateSprite(0,#Taille * 2, #Taille * 2) 
StartDrawing(SpriteOutput(0)) 
  For i = 0 To #Taille 
     Circle(#Taille, #Taille,#Taille - i, RGB(50 + i * 6, 40 + i * 6, 40 + i * 6)) 
  Next 
StopDrawing()  

;-Boucle 
Repeat 
  While WindowEvent():Wend 
  ClearScreen(RGB(0, 0, 0))
  ExamineKeyboard() 
  ExamineMouse() 
  AffPoints() 
  PolygoneConvexe() 
  TracePolygone() 
  ForEach ListPoint() 
    DisplayTransparentSprite(0,ListPoint()\x - #Taille, ListPoint()\y - #Taille) 
  Next  
  FlipBuffers() 
  Delay(1) 
Until KeyboardPushed(#PB_Key_Escape) 
End 

;-Procedures 
Procedure Erreur(Message$) 
  MessageRequester("Erreur", Message$, 0) 
  End 
EndProcedure 
Procedure PolygoneConvexe() 
  If CountList(ListPoint()) < 2 
    ProcedureReturn #False 
  EndIf 
  ;Initialise 
  *Min.NewPoint = #Null 
  *p0.NewPoint  = #Null 
  *pi.NewPoint  = #Null 
  *pc.NewPoint  = #Null 
  ;Trouve le point le plus bas dans la liste des points 
  FirstElement(ListPoint()) 
  *Min = ListPoint() 
  ForEach ListPoint() 
    *p0 = ListPoint() 
    ;Mémorise le point le plus bas , ou le plus à gauche s'il y a égalité 
    If (*p0\y < *Min\y) Or ((*p0\y = *Min\y) And (*p0\x < *Min\x)) 
      *Min = *p0 
    EndIf 
  Next  
  ;Initialise la liste pour le contour convexe 
  ClearList(Polygone()) 
  ;Effectue la progression de Jarvis pour calculer le contour 
  *p0 = *Min 
  Repeat 
    ;Insertion du nouveau p0 dans le contour convexe 
    If AddElement(Polygone()) = 0 
      Erreur("plus de mémoire pour ajouter un élément dans polygone") 
    Else  
      Polygone()\x = *p0\x 
      Polygone()\y = *p0\y 
    EndIf 
    ;Trouve le point pc dans le sens des aiguilles d'une montre 
    *pc = #Null 
    ForEach ListPoint() 
      *pi = ListPoint() 
      ;Saute p0 
      If *pi = *p0 
        Continue 
      EndIf 
      ;Sélectionne le premier point 
      If *pc = #Null 
        *pc = ListPoint() 
        Continue 
      EndIf 
      ;Teste si pi est dans le sens des aiguilles d'une montre par rapport à pc 
      z=(((*pi\x - *p0\x) * (*pc\y - *p0\y)) - ((*pi\y - *p0\y) * (*pc\x - *p0\x))) 
      If z > 0 
        ;pi est dans le sens des aiguilles d'une montre par rapport à pc 
        *pc = *pi 
      ElseIf z = 0 
        ;Si pi et pc sont colinéaires , on choisit le plus éloigné de p0 
        longueurpi = Pow(*pi\x - *p0\x, 2.0) + Pow(*pi\y - *p0\y, 2.0) 
        longueurpc = Pow(*pc\x - *p0\x, 2.0) + Pow(*pc\y - *p0\y, 2.0) 
        If longueurpi > longueurpc 
          *pc = *pi 
        EndIf 
      EndIf  
    Next 
    ;Cherche le point suivant 
    *p0 = *pc 
  Until *p0 = *Min 
EndProcedure 
Procedure TracePolygone() 
  CouleurPolygone = RGB(145, 155, 165) 
  StartDrawing(ScreenOutput()) 
  SelectElement(Polygone(), 0) 
  *mem0.NewPoint = Polygone() 
  *mem.NewPoint  = Polygone() 
  While NextElement(Polygone()) 
    LineXY(*mem\x, *mem\y, Polygone()\x, Polygone()\y, CouleurPolygone) 
    *mem = Polygone() 
  Wend  
  LineXY(*mem0\x, *mem0\y, *mem\x, *mem\y, CouleurPolygone) 
  StopDrawing() 
EndProcedure 
Procedure.l Limite(*Valeur.LONG, Min.l, Max.l) 
  If *Valeur\l < Min 
    *Valeur\l = Min 
    ProcedureReturn #True 
  ElseIf *Valeur\l > Max 
    *Valeur\l = Max 
    ProcedureReturn #True 
  EndIf 
EndProcedure 
Procedure AffPoints() 
  CouleurPoint = RGB(200, 255, 0) 
  Taille2 = #Taille / 2 
  ForEach ListPoint() 
    ListPoint()\x + ListPoint()\dx 
    ListPoint()\y + ListPoint()\dy 
    If Limite(@ListPoint()\x, #Taille, ScreenWidth - #Taille) 
      ListPoint()\dx * -1 
    EndIf 
    If Limite(@ListPoint()\y, #Taille, ScreenHeight - #Taille) 
      ListPoint()\dy * -1 
    EndIf 
    *MemPos.NewPoint=ListPoint() 
    MemIndex=ListIndex(ListPoint()) 
    ForEach ListPoint() 
      If ListIndex(ListPoint()) = MemIndex 
        Continue 
      EndIf  
      ;Calcul la distance 
      Distance = Sqr(Pow(ListPoint()\x - *MemPos\x, 2.0) + Pow(ListPoint()\y - *MemPos\y, 2.0)) 
      If Distance <= #Taille * 2 
        *MemPos\dx * -1 
        *MemPos\dy * -1  
        *MemPos\x + *MemPos\dx 
        *MemPos\y + *MemPos\dy 
      EndIf 
    Next 
    SelectElement(ListPoint(), MemIndex) 
  Next 
EndProcedure 
Procedure TestPoint(x1, Y1, X2, Y2, d) 
  If x1 > X2 - d And x1 < X2 + d And Y1 > Y2 - d And Y1 < Y2 + d 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger