; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13320&highlight=
; Author: Garzul (updated for PB 4.00 by Andre)
; Date: 08. December 2004
; OS: Windows
; Demo: Yes

;/********************************************* 
;/*            \\ Particle effect //          *  
;/*       \\  Crée par Garzul | 2004  //      *  
;/* \\JaPBe > 2.4.7.17 || Purebasic > 3.91 // *  
;/*********************************************  

#Largeur = 1024 
#Hauteur = 768 

Enumeration 

  #Box 
  
EndEnumeration 


;* Initialisation de DirectX *; 

If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 
  MessageRequester("Erreur", "Impossible d'initialiser DirectX", 0) 
  End 
EndIf 


;* Ouverture de la l'écran *; 
OpenScreen(#Largeur,#Hauteur,32,"") 

SetRefreshRate(60) 

Global NbrBox , ColorRed , ColorGreen , ColorBlue 
NbrBox = 2000 


Structure Box 

  x.l 
  y.l 
  Vit.l 
  
EndStructure 

Global NewList Box1.Box() 


For i = 0 To NbrBox 
  
  AddElement(Box1()) 
  
  Box1()\x   = Random(1024) 
  Box1()\y   = Random(768) 
  Box1()\Vit = 2 
  
Next i 



CreateSprite(#Box , 5 , 5) 
StartDrawing(SpriteOutput(#Box)) 
Box(0 , 0 , 2 , 2 , RGB(Random(255) , Random(255) , Random(255))) 
StopDrawing() 


;-Afficher Effet 
Procedure AffichEffect() 
  
  ResetList(Box1()) 
  
  ForEach Box1() 
    
    
    DisplayTransparentSprite(#Box , Box1()\x + Cos(Random(1000)) * #PI, Box1()\y + Sin(Random(1000)) * #PI ) 
    
      
  Next 
  
EndProcedure 


;-Option effet 
Procedure Option() 


  StartDrawing(ScreenOutput()) 
    DrawingMode(1) 
    FrontColor(RGB($C0,$C0,$C0))
    DrawText(0, 0, "Nombre de boite = " + Str(NbrBox)) 
    DrawText(0, 20, "Couleur RGB du fond de plan ( Rouge , Vert , Bleu ) = " + Str(ColorRed) + "," + Str( ColorGreen ) + "," + Str(ColorBlue)) 
    DrawText(0, 740, "C = Ajouter , S = Diminuer , Fléches = Déplacements , Entrer = Réinitialiser Aléatoirement , R = Plus de rouge , G = Plus de vert , B = Plus de bleu , N = Noir") 
  StopDrawing() 
  
  
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_C) 
  
     NbrBox + 50 
      
     For i = 0 To 50 
      
       AddElement(Box1()) 
        
     Next 
      
    ElseIf KeyboardPushed(#PB_Key_S) 
    
     NbrBox - 50 
      
     For i = 0 To 50 
      
       DeleteElement(Box1()) 
      
     Next 
      
   EndIf 
      
      
   If KeyboardPushed(#PB_Key_Right) 
    
   ForEach Box1() 
    
      Box1()\X + Box1()\Vit 
      
   Next 
    
     ElseIf KeyboardPushed(#PB_Key_Left) 
      
   ForEach Box1() 
    
      Box1()\X - Box1()\Vit 
      
   Next 
    
     ElseIf KeyboardPushed(#PB_Key_Up) 
      
   ForEach Box1() 
    
      Box1()\Y - Box1()\Vit 
      
   Next 
      
     ElseIf KeyboardPushed(#PB_Key_Down) 
      
   ForEach Box1() 
    
      Box1()\Y + Box1()\Vit 
      
   Next 
    
   EndIf 
    
    
   ForEach Box1() 
    
      If Box1()\Y < 0 
      
           Box1()\Y = 0 
          
         ElseIf Box1()\Y > 768 
          
           Box1()\Y = 768 
          
         ElseIf Box1()\X < 0 
          
           Box1()\X = 0 
          
         ElseIf Box1()\X > 1024 
          
           Box1()\X = 1024 
          
      EndIf 
      
   ;-réinitialiser 
   If KeyboardPushed(#PB_Key_Return) 
    
      Box1()\Y = Random(768) 
      Box1()\X = Random(1024) 
      
   EndIf 
    
    
   ;-// Changement de couleur de fond de plan \\ 
   If KeyboardReleased(#PB_Key_R) 
    
        ColorRed   + 1 
        
      ElseIf KeyboardReleased(#PB_Key_G) 
      
        ColorGreen + 1 
        
      ElseIf KeyboardReleased(#PB_Key_B) 
      
        ColorBlue  + 1 
        
      ElseIf KeyboardPushed(#PB_Key_N) 

        ColorBlue  = 0 
        ColorGreen = 0 
        ColorRed   = 0 
        
      ElseIf ColorBlue > 255 Or ColorGreen > 255 Or ColorBlue > 255 
      
        ColorBlue  = 0 
        ColorGreen = 0 
        ColorRed   = 0 
        
   EndIf  
    
   Next 
    
EndProcedure 
  

;// Boucle \\ 
Repeat 

  ClearScreen(RGB(ColorRed,ColorGreen,ColorBlue))
    

    Option() 
    AffichEffect() 
  
  FlipBuffers() 
  

;// On quitte ! :) \\ 
Until KeyboardPushed(#PB_Key_Escape) 
CloseScreen()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -