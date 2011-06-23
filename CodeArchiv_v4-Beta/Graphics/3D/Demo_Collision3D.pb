; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8454&highlight= 
; Author: Comtois (updated for PB 4.00 by Comtois + Andre)
; Date: 22. November 2003 
; OS: Windows
; Demo: Yes

; http://perso.wanadoo.fr/comtois/codesforum/DemoCollisionV0.1.htm 
; ******************************************* 
; * Comtois : 22/11/03 : DémoCollisionV0.1  * 
; ******************************************* 

; [F1]/[F2]/[F3] => Changement Vue Caméra 
; [F4] => Nombre d'images / seconde et positions du perso 
; [PAgeUp]/[PageDown] => Lcve / Baisse la caméra 
; [Fin] => Position par défaut de la caméra 
; [Espace] => Saut du perso 

;-Initialisation 
;#ScreenWidth = 800 : #ScreenHeight = 600 : #ScreenDepth = 16 
ExamineDesktops()

If InitEngine3D() = 0 
   MessageRequester( "Erreur" , "Impossible d'initialiser la 3D , vérifiez la présence de engine3D.dll" , 0 ) 
   End 
ElseIf InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 Or InitSound() = 0 
   MessageRequester( "Erreur" , "Impossible d'initialiser DirectX 7 Ou plus" , 0 ) 
   End 
ElseIf OpenScreen( DesktopWidth(0), DesktopHeight(0) , DesktopDepth(0) , "Démo PlateForme" ) = 0 
   MessageRequester( "Erreur" , "Impossible d'ouvrir l'écran " , 0 ) 
   End 
EndIf 

;-Declare procedures 
Declare MakeBoxCollision( No.l , X.f , Y.f , Z.f , Longueur.f , Hauteur.f , Largeur.f , AngleX.f , Type.l ) 
Declare.f WrapValue( Angle.f ) 

;-Structures 
Structure BoxCollision 
   No.l      ; Si le type est 1 alors ce Numéro correspond obligatoirement r l'entity , sinon c'est un numéro différent des entitys existantes 
   X.f       ; Position en X de la Box 
   Y.f       ; Position en Y de la Box 
   Z.f       ; Position en Z de la Box 
   AngleX.f  ; Angle de la Box sur le Plan XZ 
   MinX.f    ; Dimension de la Box 
   MinY.f    ; Dimension de la Box 
   MinZ.f    ; Dimension de la Box 
   MaxX.f    ; Dimension de la Box 
   MaxY.f    ; Dimension de la Box 
   MaxZ.f    ; Dimension de la Box 
   Type.l    ; Type = 0 => Box Statique ; Type = 1 => Box Dynamique ( presque plus utile avec la nouvelle méthode ) 
EndStructure 

Structure Camera 
   AngleX.f 
   AngleY.f 
   CameraVue.l 
   CameraDist.f 
   CameraHaut.f 
   LookAtY.f 
EndStructure 

Structure Parametres 
   AngleX.f 
   AngleY.f 
   AngleZ.f 
EndStructure 

Global Dim entity.Parametres(100) 

Global NewList BoxCollision.BoxCollision() 
Global Camera.Camera 
Camera\CameraVue = 1 

;- Variables globales 
Global GetCollisionX.f , GetCollisionY.f , GetCollisionZ.f 
Global OldPosX.f , OldPosY.f , OldPosZ.f , Pas.f 
Global PosX0.f , PosY0.f , PosZ0.f 

;-Mesh 
CreateMesh(0,100) ; Cube 
SetMeshData(0, #PB_Mesh_Vertex | #PB_Mesh_Normal | #PB_Mesh_UVCoordinate, ?CubePoints       , 16) 
SetMeshData(0, #PB_Mesh_Face, ?CubeTriangles    , 12) 


;- Textures 
CreateTexture(1,128,128) 
StartDrawing(TextureOutput(1)) 
  Box(0,0,128,128,RGB(255,255,255)) 
  Box(2,2,124,124,RGB(200,0,0)) 
StopDrawing() 

CreateTexture(2,128,128) 
StartDrawing(TextureOutput(2)) 
  Box(0,0,128,128,RGB(255,255,255)) 
  Box(2,2,124,124,RGB(0,0,200)) 
StopDrawing() 

CreateTexture(3,128,128) 
StartDrawing(TextureOutput(3)) 
  Box(0,0,128,128,RGB(255,255,255)) 
  Box(2,2,124,124,RGB(0,200,0)) 
  For a = 0 To 128 Step 4 
   For b = 0 To 128 Step 4 
      Circle(a,b,2,RGB(10,150,10)) 
   Next b 
Next a 
StopDrawing() 

;- Material 
For a = 1 To 3 
   CreateMaterial(a, TextureID( a )) 
Next a 

;-Entity 
Restore Entitys 
For a = 0 To 20 
   If a < 5 
      Read materialID.l : Read Type.l 
      Read Longueur.f : Read Hauteur.f : Read Largeur.f 
      Read X.f : Read Y.f : Read Z.f 
      Read AngleX.f 
   EndIf 
   CreateEntity(a , MeshID(0) ,MaterialID(materialID)) 
   ScaleEntity(a , Longueur , Hauteur , Largeur ) 
   If a<5 
      EntityLocate(a,X,Y,Z) 
   Else 
      EntityLocate(a,X + a * 40,Y + a * 20,Z) 
   EndIf 
   entity(a)\AngleX = AngleX 
   RotateEntity(a,entity(a)\AngleX,0,0) 
   MakeBoxCollision( a , EntityX(a) , EntityY(a) , EntityZ(a) , Longueur , Hauteur , Largeur , entity(a)\AngleX , Type ) 
Next a 

;- Camera 
CreateCamera(0, 0, 0 , 100 , 100) 
CameraLocate(0,0,0,20) 
AmbientColor(RGB(255,255,255)) 

;- Procédures 
Procedure.f Cosd( Angle.f ) 
   ;calcule le cos d'un angle en degré 
   a.f = Angle * 0.0174533 
   ProcedureReturn Cos( a ) 
EndProcedure 

Procedure.f Sind( Angle.f ) 
   ;calcule le sin d'un angle en degré 
   a.f = Angle  * 0.0174533 
   ProcedureReturn Sin( a ) 
EndProcedure 

Procedure.f WrapValue( Angle.f ) 
   ;Permet de toujours avoir un angle compris entre 0° et 360° 
   While Angle < 0 
      Angle + 360 
   Wend 
   While Angle - 360 >= 0 
      Angle - 360 
   Wend 
   ProcedureReturn Angle 
EndProcedure 

Procedure.f NewXValue( X.f , Angle.f , NbUnite.f ) 
   ;r utiliser conjointement avec NewZvalue pour calculer une position de <NbUnite> dans la direction <angle> 
   Valeur.f = X + Cosd( Angle ) * NbUnite 
   ProcedureReturn Valeur 
EndProcedure 

Procedure.f NewZValue( Z.f , Angle.f , NbUnite.f ) 
   ;r utiliser conjointement avec NewXvalue pour calculer une position de <NbUnite> dans la direction <angle> 
   Valeur.f = Z - Sind( Angle ) * NbUnite 
   ProcedureReturn Valeur 
EndProcedure 

Procedure.f EcartAngle( angle1.f , angle2.f ) 
   ; simplifier tout ça 
   If angle1 > 180 
      ecart2.f = 360 - angle1 
   Else 
      ecart2.f = angle1 
   EndIf 

   If angle2 > 180 
      ecart1.f = 360 - angle2 
   Else 
      ecart1.f = angle2 
   EndIf 

   If Abs( WrapValue( angle2 ) - WrapValue( angle1 ) ) > 180 
      If angle2 < angle1 
         Delta.f = ( ecart1 + ecart2 ) 
      Else 
         Delta.f = ( ecart1 + ecart2 ) * -1 
      EndIf 
   Else 
      Delta.f = WrapValue( angle2 ) - WrapValue( angle1 ) 
   EndIf 

   ProcedureReturn Delta 

EndProcedure 

Procedure.f CurveAngle( Actuelle.f , Cible.f , P.f ) 
   ;Calcule un angle progressif allant de la valeur actuelle r la valeur cible 
   Delta.f = EcartAngle( Actuelle , Cible ) 
   If P > 1000 : P = 1000 : EndIf 
   Valeur.f = Actuelle + ( Delta * P / 1000 ) 
   ProcedureReturn WrapValue( Valeur ) 
EndProcedure 

Procedure.f CurveValue( Actuelle.f , Cible.f , P.f ) 
   ;Calcule une valeur progressive allant de la valeur actuelle r la valeur cible 
   Delta.f = Cible - Actuelle 
   If P > 1000 : P = 1000 : EndIf 
   Valeur.f = Actuelle + ( Delta * P / 1000 ) 
   ProcedureReturn Valeur 
EndProcedure 

Procedure MakeBoxCollision( No.l , X.f , Y.f , Z.f , Longueur.f , Hauteur.f , Largeur.f , AngleX.f , Type.l ) 
   ; X , Y et Z => Coordonnées de la Box 
   ; Longueur   => Longueur de la Box 
   ; Hauteur    => Hauteur de la Box 
   ; Largeur    => Largeur de la Box 
   ; AngleX     => Angle de la Box sur le plan XZ ( je n'ai pas besoin des autres plans pour l'instant ) 
   ; Type = 0   => Box statique ( calculée une seule fois , exemple pour un mur , un décor quelconque ) 
   ; Type = 1   => Box dynamique ( calculée avant de tester une collision selon la position de l'entity ) 


   ; MinZ .........|.......... 
   ;      .        |         . 
   ;      .        |         . 
   ;    -----------0-------------- 
   ;      .        |         . 
   ;      .        |         . 
   ; MaxZ .........|.......... 
   ; 
   ;    MinX               MaxX 

   ; Les paramctres MinX.f , MinY.f , MinZ.f , MaxX.f , MaxY.f , MaxZ.f , correspondent aux dimensions de la box en prenant 
   ; le centre de l'entity comme référence (0) . 

   ; Exemple pour un mur de longueur x = 400 , hauteur y = 100 et largeur z = 30 
   ; ensuite si on veut placer le mur r 45° r la position 1500,50,300 
   ; EntityLocate(#Mur,1500,50,300) 
   ; RotateEntity(#Mur,45,0,0) 
   ; Entity(#Mur)\\AngleX = 45 
   ; et on appelle la Procedure 
   ; MakeBoxCollision( #Mur , EntityX(#Mur) , EntityY(#Mur) , EntityZ(#Mur) , 400 , 100 , 30 , Entity(#Mur)\\AngleX , 0 ) 

   ; Pour l'instant je considcre que la Box est centré sur l'entity , si ça devait par la suite se révéler trop contraignant 
   ; il sera toujours possible de modifier légcrement cette procédure ainsi : 
   ; Procedure MakeBoxCollision( No.l, X.f, Y.f, Z.f, MinX.f, MinY.f, MinZ.f, MaxX.f, MaxY.f, MaxZ.f, AngleX.f, Type.l ) 

   AddElement( BoxCollision() ) 
   BoxCollision()\No = No 
   BoxCollision()\X = X 
   BoxCollision()\Y = Y 
   BoxCollision()\Z = Z 
   BoxCollision()\MinX = -Longueur/2 
   BoxCollision()\MinY = -Hauteur/2 
   BoxCollision()\MinZ = -Largeur/2 
   BoxCollision()\MaxX = Longueur/2 
   BoxCollision()\MaxY = Hauteur/2 
   BoxCollision()\MaxZ = Largeur/2 
   BoxCollision()\AngleX = AngleX 
   BoxCollision()\Type = Type 

EndProcedure 

Procedure.l EntityCollision( No1.l , No2.l ) 
   ; La procedure renvoit -1 en cas d'erreur de paramctres ( Box inexistante , Box 1 et 2 identiques ) 
   ; La procedure renvoit 0 si aucune Collision 
   ; La procedure renvoit 1 si la Box No1 est en Collision avec la Box No2 

   If No1 = No2 :  ProcedureReturn -1 : EndIf 

   ;************************************** Cherche Box ******************************************* 

   Trouve = 0 
   ResetList( BoxCollision() ) 
   While NextElement( BoxCollision() ) 
      If BoxCollision()\No = No1 

         ; Mise r Jour des caractériques de la Box 
         If BoxCollision()\Type = 1 
            BoxCollision()\X = EntityX(No1) 
            BoxCollision()\Y = EntityY(No1) 
            BoxCollision()\Z = EntityZ(No1) 
            BoxCollision()\AngleX = entity(No1)\AngleX 
         EndIf 

         ; On récupcre les caractéristiques de la Box No1 
         PosX1.f = BoxCollision()\X 
         PosY1.f = BoxCollision()\Y 
         PosZ1.f = BoxCollision()\Z 
         MinX1.f = BoxCollision()\MinX 
         MinY1.f = BoxCollision()\MinY 
         MinZ1.f = BoxCollision()\MinZ 
         MaxX1.f = BoxCollision()\MaxX 
         MaxY1.f = BoxCollision()\MaxY 
         MaxZ1.f = BoxCollision()\MaxZ 
         AngleX1.f = BoxCollision()\AngleX 

         Trouve + 1 

      ElseIf BoxCollision()\No = No2 

         ; Mise r Jour des caractériques de la Box 
         If BoxCollision()\Type = 1 
            BoxCollision()\X = EntityX(No2) 
            BoxCollision()\Y = EntityY(No2) 
            BoxCollision()\Z = EntityZ(No2) 
            BoxCollision()\AngleX = entity(No2)\AngleX 
         EndIf 

         ; On récupcre les caractéristiques de la Box No2 
         PosX2.f = BoxCollision()\X 
         PosY2.f = BoxCollision()\Y 
         PosZ2.f = BoxCollision()\Z 
         MinX2.f = BoxCollision()\MinX 
         MinY2.f = BoxCollision()\MinY 
         MinZ2.f = BoxCollision()\MinZ 
         MaxX2.f = BoxCollision()\MaxX 
         MaxY2.f = BoxCollision()\MaxY 
         MaxZ2.f = BoxCollision()\MaxZ 
         AngleX2.f = BoxCollision()\AngleX 

         Trouve + 1 

      EndIf 

      If Trouve = 2 : Break : EndIf 

   Wend 

   ; Il manque au moins une box 
   If Trouve < 2 
      ProcedureReturn -1 
   EndIf 

   ;****************************** Changement de repcres **************************************** 
   CosA1.f = Cosd( AngleX1 ) 
   SinA1.f = -Sind( AngleX1 ) 
   CosA2.f = Cosd( AngleX2 ) 
   SinA2.f = Sind( AngleX2 ) 
   PosX.f  = PosX1 - PosX2 
   PosY.f  = PosY1 - PosY2 
   PosZ.f  = PosZ1 - PosZ2 
   A1.f    = (CosA1 * CosA2 - SinA1 * SinA2) 
   A2.f    = (SinA1 * CosA2 + CosA1 * SinA2) 
   A3.f    = (PosX * CosA2 - PosZ * SinA2) 
   A4.f    = (PosX * SinA2 + PosZ * CosA2) 

   ; Calcul les 4 coins de la Box sur le plan XZ en tenant compte du changement de repcre 
   ; 
   ; MinX1/MinZ1(0)  ______    MaxX1/MinZ1(1) 
   ;                 \     \ 
   ;                  \     \ 
   ;                   \     \ 
   ; MinX1/MaxZ1(3)     \_____\ MaxX1/MaxZ1(2) 
   ; 

   ; Et ensuite on détermine une Box qui englobe le tout ( pas précis , mais plus simple ) 
   ; BoxMinX/BoxMinZ.............BoxMaxX/BoxMinZ 
   ;                . ______    . 
   ;                . \     \   . 
   ;                .  \     \  . 
   ;                .   \     \ . 
   ;                .    \_____\. 
   ; BoxMinX/BoxMaxZ.............BoxMaxX/BoxMaxZ 
   ; 
   ;MinX1/MinZ1 
   X0.f = MinX1 * A1 - MinZ1 * A2 + A3 
   Z0.f = MinX1 * A2 + MinZ1 * A1 + A4 

   BoxMinX.f = X0 
   BoxMinZ.f = Z0 
   BoxMaxX.f = X0 
   BoxMaxZ.f = Z0 

   ;MaxX1/MinZ1 
   X1.f = MaxX1 * A1 - MinZ1 * A2 + A3 
   Z1.f = MaxX1 * A2 + MinZ1 * A1 + A4 

   If X1 < BoxMinX 
      BoxMinX = X1 
   ElseIf  X1 > BoxMaxX 
      BoxMaxX = X1 
   EndIf 
   If Z1 < BoxMinZ 
      BoxMinZ = Z1 
   ElseIf  Z1 > BoxMaxZ 
      BoxMaxZ = Z1 
   EndIf 

   ;MaxX1/MaxZ1 
   X2.f = MaxX1 * A1 - MaxZ1 * A2 + A3 
   Z2.f = MaxX1 * A2 + MaxZ1 * A1 + A4 

   If X2 < BoxMinX 
      BoxMinX = X2 
   ElseIf  X2 > BoxMaxX 
      BoxMaxX = X2 
   EndIf 
   If Z2 < BoxMinZ 
      BoxMinZ = Z2 
   ElseIf  Z2 > BoxMaxZ 
      BoxMaxZ = Z2 
   EndIf 

   ;MinX1/MaxZ1 
   X3.f = MinX1 * A1 - MaxZ1 * A2 + A3 
   Z3.f = MinX1 * A2 + MaxZ1 * A1 + A4 

   If X3 < BoxMinX 
      BoxMinX = X3 
   ElseIf  X3 > BoxMaxX 
      BoxMaxX = X3 
   EndIf 
   If Z3 < BoxMinZ 
      BoxMinZ = Z3 
   ElseIf  Z3 > BoxMaxZ 
      BoxMaxZ = Z3 
   EndIf 
   BoxMinY.f = MinY1 + PosY 
   BoxMaxY.f = MaxY1 + PosY 

   ;**************************** Test si Collision ************************************************* 
   ; BoxMinX/BoxMinZ.............BoxMaxX/BoxMinZ    MinX2/MinZ2.............MaxX2/MaxZ2 
   ;                . ______    .                              .           . 
   ;                . \     \   .                              .           . 
   ;                .  \     \  .                              .           . 
   ;                .   \     \ .                              .           . 
   ;                .    \_____\.                              .           . 
   ; BoxMinX/BoxMaxZ.............BoxMaxX/BoxMaxZ    MinX2/MaxZ2.............MaxX2/MaxZ2 

   ;Test Collision 
   CondX = (BoxMaxX >= MinX2 And BoxMinX <= MaxX2) 
   CondY = (BoxMaxY >= MinY2 And BoxMinY <= MaxY2) 
   CondZ = (BoxMaxZ >= MinZ2 And BoxMinZ <= MaxZ2) 
   ;Utilisé pour les collisions glissantes 
   GetCollisionX = 0 
   GetCollisionY = 0 
   GetCollisionZ = 0 

   If CondY And CondX And CondZ 
      ; il serait surement plus judicieux de ne faire ces calculs que s'ils sont demandés 
      ; en effet , dans de nombreux cas , on a seulement besoin de savoir s'il y a une collision 
      ; et pas forcément de calculer une collision glissante ! 
      ;Collision en X 
      If BoxMinX < MaxX2 And BoxMinX > MinX2 And BoxMaxX > MaxX2 
         GetCollisionXa.f =  BoxMinX - MaxX2 
      ElseIf BoxMaxX < MaxX2 And BoxMaxX > MinX2 And BoxMinX < MinX2 
         GetCollisionXa.f =  BoxMaxX - MinX2 
      EndIf 

      ; a voir pour traiter ça autrement ! > c'est pour éviter de tomber quand on s'approche trop du bord d'une box ! 
      If Abs(GetCollisionXa) > 3 
         GetCollisionXa = 0 
      EndIf 

      ; Collision en Z 
      If BoxMinZ < MaxZ2 And BoxMaxZ > MaxZ2 And BoxMaxZ > MaxZ2 
         GetCollisionZa.f =  BoxMinZ - MaxZ2 
      ElseIf BoxMaxZ < MaxZ2 And BoxMaxZ > MinZ2 And BoxMinZ < MinZ2 
         GetCollisionZa.f =  BoxMaxZ - MinZ2 
      EndIf 

      ; A voir pour traiter ça autrement ! > c'est pour éviter de tomber quand on s'approche trop du bord d'une box ! 
      If Abs(GetCollisionZa) > 3 
         GetCollisionZa = 0 
      EndIf 

      ;Collision en Y 
      If BoxMinY < MaxY2 And BoxMinY > MinY2 And BoxMaxY > MaxY2 And GetCollisionXa = 0 And GetCollisionZa = 0 
         GetCollisionY =  BoxMinY - MaxY2 
      ElseIf BoxMaxY < MaxY2 And BoxMaxY> MinY2 And BoxMinY < MinY2 And OldPosY < PosY0 
         GetCollisionY =  BoxMaxY - MinY2 
      EndIf 

      ;Changement de repcre des valeurs Collisions glissantes 
      CosA2.f = Cosd( -AngleX2 ) 
      SinA2.f = Sind( -AngleX2 ) 
      GetCollisionX = GetCollisionXa * CosA2 - GetCollisionZa * SinA2 
      GetCollisionZ = GetCollisionXa * SinA2 + GetCollisionZa * CosA2 

      ProcedureReturn 1 

   Else 

      ProcedureReturn 0 

   EndIf 

EndProcedure 

Procedure GestionCamera() 

   ; Touches de la Caméra 
   If KeyboardReleased(#PB_Key_F1) : Camera\CameraVue = 1 : EndIf 
   If KeyboardReleased(#PB_Key_F2) : Camera\CameraVue = 2 : EndIf 
   If KeyboardReleased(#PB_Key_F3) : Camera\CameraVue = 3 : EndIf 

   If KeyboardPushed(#PB_Key_PageUp) 
      Camera\AngleY + 0.1 
   EndIf 

   If KeyboardPushed(#PB_Key_PageDown) 
      Camera\AngleY - 0.1 
   EndIf 

   If KeyboardPushed(#PB_Key_End) 
      Camera\AngleY = CurveValue(Camera\AngleY,0,20) 
   EndIf 

   If Camera\CameraVue = 1 

      Camera\CameraDist = CurveValue(Camera\CameraDist ,85 , 20) 
      Camera\CameraHaut = CurveValue(Camera\CameraHaut ,25 , 20) 
      Camera\LookAtY = CurveValue(Camera\LookAtY ,0 , 20) 
      Camera\AngleX = CurveAngle(Camera\AngleX , entity(0)\AngleX , 20 ) 
      PosXCamera.f = CurveValue(CameraX(0) , NewXValue(EntityX(0) , Camera\AngleX + 180 , Camera\CameraDist) , 280) 
      PosYCamera.f = CurveValue(CameraY(0) , EntityY(0) + Camera\CameraHaut , 30) 
      PosZCamera.f = CurveValue(CameraZ(0) , NewZValue(EntityZ(0) , Camera\AngleX + 180 , Camera\CameraDist) , 280) 
      CameraLocate(0 , PosXCamera , PosYCamera , PosZCamera) 
      CameraLookAt(0 , EntityX(0), EntityY(0) + Camera\LookAtY + Camera\AngleY  ,EntityZ(0)) 

   ElseIf Camera\CameraVue = 2 

      Camera\CameraDist = CurveValue(Camera\CameraDist ,45 , 20) 
      Camera\CameraHaut = CurveValue(Camera\CameraHaut ,25 , 20) 
      Camera\LookAtY = CurveValue(Camera\LookAtY , 8 , 20) 
      Camera\AngleX = CurveAngle(Camera\AngleX , entity(0)\AngleX , 20 ) 
      PosXCamera.f = CurveValue(CameraX(0) , NewXValue(EntityX(0) , Camera\AngleX + 180 , Camera\CameraDist) , 280) 
      PosYCamera.f = CurveValue(CameraY(0) , EntityY(0) + Camera\CameraHaut , 30) 
      PosZCamera.f = CurveValue(CameraZ(0) , NewZValue(EntityZ(0) , Camera\AngleX + 180 , Camera\CameraDist) , 280) 
      CameraLocate(0 , PosXCamera , PosYCamera , PosZCamera) 
      CameraLookAt(0 , EntityX(0), EntityY(0) + Camera\LookAtY + Camera\AngleY  ,EntityZ(0)) 

   ElseIf Camera\CameraVue = 3 

      Camera\CameraDist = CurveValue(Camera\CameraDist ,15 , 20) 
      Camera\CameraHaut = CurveValue(Camera\CameraHaut ,95 , 20) 
      Camera\LookAtY = CurveValue(Camera\LookAtY , 0 , 20) 
      Camera\AngleX = CurveAngle(Camera\AngleX , entity(0)\AngleX , 20 ) 
      PosXCamera.f = CurveValue(CameraX(0) , NewXValue(EntityX(0) , Camera\AngleX + 180 , Camera\CameraDist) , 280) 
      PosYCamera.f = CurveValue(CameraY(0) , EntityY(0) + Camera\CameraHaut , 30) 
      PosZCamera.f = CurveValue(CameraZ(0) , NewZValue(EntityZ(0) , Camera\AngleX + 180 , Camera\CameraDist) , 280) 
      CameraLocate(0 , PosXCamera , PosYCamera , PosZCamera) 
      CameraLookAt(0 , EntityX(0) , EntityY(0) + Camera\LookAtY + Camera\AngleY  , EntityZ(0)) 

   EndIf 

EndProcedure 

Procedure AffAide() 
   StartDrawing(ScreenOutput()) 
   DrawText(10, 10, "Nombre d'images Minimum = " + StrF(Engine3DFrameRate(#PB_Engine3D_Minimum )) + " / Nombre d'images Maximum = " + StrF(Engine3DFrameRate(#PB_Engine3D_Maximum))) 
   DrawText(10, 30, "Nombre d'images par seconde = " + StrF(Engine3DFrameRate(#PB_Engine3D_Current))) 
   DrawText(10, 50, StrF(EntityX(0)) + " / " + StrF(EntityY(0)) + " / " + StrF(EntityZ(0))) 
   StopDrawing() 
EndProcedure 

;- Boucle principale 

DecAttraction.f = 0.05 
Attraction.f = 0 
Pas.f = 0 

Repeat 

   ClearScreen(#Black) 

   If ExamineKeyboard() 

      ; Touches du joueur r mettre dans une procédure  et gérer un fichier préférence pour configurer les touches 
      If KeyboardPushed(#PB_Key_Left) 
         entity(0)\AngleX = WrapValue( entity(0)\AngleX + 1 ) 
      ElseIf KeyboardPushed(#PB_Key_Right) 
         entity(0)\AngleX = WrapValue( entity(0)\AngleX - 1 ) 
      EndIf 
      RotateEntity(0, entity(0)\AngleX , 0, 0 ) 

      If KeyboardPushed(#PB_Key_Up) 
         Pas = CurveValue(Pas, 2 , 120) 
      ElseIf KeyboardPushed(#PB_Key_Down) 
         Pas = CurveValue(Pas, -2 , 120) 
      Else 
         Pas = CurveValue(Pas, 0 , 200) 
      EndIf 

      If KeyboardPushed(#PB_Key_Space) And Attraction = 0 And  AutoriseSaut 
         Attraction = 1.6 : DecAttraction = 0.05 
      EndIf 

      If KeyboardReleased(#PB_Key_F4) : AfficheAide = 1 - AfficheAide : EndIf 

   EndIf 


   ; LE perso avant 
   OldPosY = EntityY(0) 
   OldPosX = EntityX(0) 
   OldPosZ = EntityZ(0) 

   ; LE perso pendant 
   MoveEntity( 0 , Cosd( entity(0)\AngleX ) * Pas , Attraction, -Sind( entity(0)\AngleX ) * Pas ) 

   ; LE perso aprcs 
   PosY0 = EntityY(0) 
   PosX0 = EntityX(0) 
   PosZ0 = EntityZ(0) 

   ; Gestion de l'attraction 
   Attraction - DecAttraction 

   ; Test des collisions 

   ResetList(BoxCollision()) 
   While NextElement(BoxCollision()) 

      NoBox = BoxCollision()\No 
      IndexBoxCollision = ListIndex(BoxCollision()) 

      If EntityCollision( 0 , NoBox ) > 0 

         ; Collision glissante 
         PosY0 - GetCollisionY 
         PosX0 - GetCollisionX 
         PosZ0 - GetCollisionZ 

         If GetCollisionY <> 0 
            If OldPosY < PosY0 And GetCollisionY > 0; pour ne pas rester coller sous une dalle quand on saute !! 
               Attraction = -0.1 
               AutoriseSaut = 0 
            Else 
               Attraction = 0 
               AutoriseSaut = 1 
            EndIf 
         EndIf 

      EndIf 

      SelectElement(BoxCollision(), IndexBoxCollision) 

   Wend 

   ; Repositionne le perso 
   EntityLocate(0,PosX0 ,PosY0 ,PosZ0 ) 

   ; Gestion de la caméra 
   GestionCamera() 

   RenderWorld() 
   If AfficheAide : AffAide(): EndIf 
   FlipBuffers() 

Until KeyboardPushed(#PB_Key_Escape) 


;-Datas du Cube 

DataSection 
Entitys: 
; le perso 
Data.l 2,1 ; matérial 
Data.f 6,6,6 ; Dimension longueur , hauteur , largeur 
Data.f 200,30,200,0 ; positions X,Y,Z et angle 
; le sol 
Data.l 3,0 ; matérial 
Data.f 1000,8,1000 ; Dimension longueur , hauteur , largeur 
Data.f 500,0,500,0 ; positions X,Y,Z et angle 
; Un mur 
Data.l 1,0 ; matérial 
Data.f 100,25,10 ; Dimension longueur , hauteur , largeur 
Data.f 400,16,400,45 ; positions X,Y,Z et angle 
; Un autre mur 
Data.l 1,0 ; matérial 
Data.f 100,25,10 ; Dimension longueur , hauteur , largeur 
Data.f 600,16,600,0 ; positions X,Y,Z et angle 
; et un escalier 
Data.l 1,0 ; matérial 
Data.f 35,5,35 ; Dimension longueur , hauteur , largeur 
Data.f 200,-80,700,0 ; positions X,Y,Z et angle 

CubePoints: 
Data.f -0.5,-0.5,-0.5 
Data.f -0.5,0,-0.5 
Data.f 0,1 
Data.f -0.5,-0.5,0.5 
Data.f -0.5,0,0.5 
Data.f 1,1 
Data.f 0.5,-0.5,0.5 
Data.f 0.5,0,0.5 
Data.f 0,1 
Data.f 0.5,-0.5,-0.5 
Data.f 0.5,0,-0.5 
Data.f 1,1 
Data.f -0.5,0.5,-0.5 
Data.f -0.5,0,-0.5 
Data.f 0,0 
Data.f -0.5,0.5,0.5 
Data.f -0.5,0,0.5 
Data.f 1,0 
Data.f 0.5,0.5,0.5 
Data.f 0.5,0,0.5 
Data.f 0,0 
Data.f 0.5,0.5,-0.5 
Data.f 0.5,0,-0.5 
Data.f 1,0 
Data.f -0.5,-0.5,-0.5 
Data.f 0,1,0 
Data.f 0,0 
Data.f -0.5,-0.5,0.5 
Data.f 0,1,0 
Data.f 1,0 
Data.f 0.5,-0.5,0.5 
Data.f 0,1,0 
Data.f 1,1 
Data.f 0.5,-0.5,-0.5 
Data.f 0,1,0 
Data.f 0,1 
Data.f -0.5,0.5,-0.5 
Data.f 0,-1,0 
Data.f 0,0 
Data.f -0.5,0.5,0.5 
Data.f 0,-1,0 
Data.f 1,0 
Data.f 0.5,0.5,0.5 
Data.f 0,-1,0 
Data.f 1,1 
Data.f 0.5,0.5,-0.5 
Data.f 0,-1,0 
Data.f 0,1 

CubeTriangles: 
Data.w 0,4,7 
Data.w 0,7,3 
Data.w 1,5,4 
Data.w 1,4,0 
Data.w 2,6,5 
Data.w 2,5,1 
Data.w 3,7,6 
Data.w 3,6,2 
Data.w 9,8,11 
Data.w 9,11,10 
Data.w 12,13,14 
Data.w 12,14,15 
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
; DisableDebugger
