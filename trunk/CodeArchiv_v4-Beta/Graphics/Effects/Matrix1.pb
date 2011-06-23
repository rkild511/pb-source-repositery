; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8367&highlight= 
; Author: Comtois (updated for PB 4.00 by Andre + Comtois)
; Date: 16. November 2003 
; OS: Windows 
; Demo: Yes

;******************************************* 
;** Comtois ** 15/11/03 ** Matrice / Vagues  ** 
;******************************************* 

;-Initialisation 
ExamineDesktops() 

If InitEngine3D()=0 
   MessageRequester("Erreur", "Impossible d'initialiser la 3D , Vérifiez la présence de la DLL Engine3D.dll", 0) 
   End 
ElseIf InitSprite() = 0 Or InitKeyboard() = 0 
   MessageRequester("Erreur", "Impossible d'initialiser DirectX 7 Ou plus", 0) 
   End 
ElseIf OpenScreen( DesktopWidth(0), DesktopHeight(0), DesktopDepth(0), "DemoMatrice" ) = 0 
   MessageRequester( "Erreur" , "Impossible d'ouvrir l'écran " , 0 ) 
   End 
EndIf 


;-Variables Globales 
Global *addpoint, *addtriangle 
Global AngleZ.f, AngleVague.f, vitesse.f, decaleX.f, decaleZ.f, hauteur.f 

AngleVague = Random(360) 
vitesse = 3.0 
decaleX = 8 
decaleZ = 8 
hauteur = 3 

;- Declaration des procédures 
Declare Matrice(NbpointsX.l,NbpointsZ.l) 

;-Constantes 
#NbX= 30 ; nombre de facettes 
#NbZ= 30 ; nombre de facettes 
#Deg2Rad = #PI / 180.0 

;-Mémoires Mesh 
*addpoint = AllocateMemory(20 * (#NbX + 1 )* (#NbZ + 1 )) 
*addtriangle = AllocateMemory(24 * #NbX * #NbZ * 4) 
Matrice(#NbX , #NbZ) 

;-Mesh 
CreateMesh(0, 100) 
SetMeshData(0, #PB_Mesh_Vertex | #PB_Mesh_UVCoordinate, *addpoint, (#NbX + 1) * (#NbZ + 1)) 
SetMeshData(0, #PB_Mesh_Face, *addtriangle, #NbX * #NbZ * 4) 

;-Texture 
UsePNGImageDecoder() 
;LoadTexture(0,"purebasiclogoNew.png") ; <<< pourquoi ça plante quand je mets juste ça ? 
LoadImage(0,"..\gfx\purebasiclogoNew.png")    ; alors que l'image se charge ? Je verrai ça plus tard 
CreateTexture(0, 256, 256) 
StartDrawing(TextureOutput(0)) 
DrawImage(ImageID(0), 0, 0) 
DrawingMode(4) 
Box(1, 1, 254, 254, #White) 
StopDrawing() 


;- MAterial 
CreateMaterial(0,TextureID(0)) 

;-Entity 
CreateEntity(0, MeshID(0), MaterialID(0)) 
RotateEntity(0, 0, 45,0) 
ScaleEntity(0, 10, 10, 10) 

;-Camera 
CreateCamera(0, 0, 0, 100, 100) 
CameraLocate(0,0,350,350) 
CameraLookAt(0,0,0,0) 
CameraRenderMode(0, #PB_Camera_Wireframe) ; added by Andre to show different start settings than Matrix2 example 

;-Procédures 
Procedure Matrice(FX.l,FZ.l) 
    
   adresse=*addpoint 
   For b=0 To FZ 
      For a=0 To FX 
         ;Position vertices 
         PokeF(adresse, a - FX/2) : PokeF(adresse + 4, 0 ) : PokeF(adresse + 8, b - FZ/2) 
         ;UV coordinates (Texture) 
         u.f = a/FX 
         v.f = b/FZ 
         PokeF(adresse + 12, u) : PokeF(adresse + 16, v)    
         adresse + 20 
      Next a 
   Next b 
    
   adresse=*addtriangle 
   Nb = FX + 1 
   For b=0 To FZ - 1 
      For a=0 To FX - 1 
         P1 = a + (b * Nb) 
         P2 = P1 + 1 
         P3 = a + ((b + 1) * Nb) 
         P4 = P3 + 1 
         ;Recto 
         PokeW(adresse     , P3) : PokeW(adresse +  2, P2) : PokeW(adresse +  4, P1) 
         PokeW(adresse +  6, P2) : PokeW(adresse +  8, P3) : PokeW(adresse + 10, P4)    
         ;Verso 
         PokeW(adresse + 12, P1) : PokeW(adresse + 14, P2) : PokeW(adresse + 16, P3) 
         PokeW(adresse + 18, P4) : PokeW(adresse + 20, P3) : PokeW(adresse + 22, P2)            
         adresse + 24 
      Next a 
   Next b 

EndProcedure 

Procedure.f WrapValue(angle.f); <- wraps a value into [0,360) fringe 
  ;Psychophanta : http://purebasic.fr/english/viewtopic.php?t=18635 
  !fild dword[@f] ; <- now i have 360 into st0 
  !fld dword[p.v_angle] 
  !fprem 
  !fadd st1,st0 
  !fldz 
  !fcomip st1 
  !fcmovnbe st0,st1 
  !fstp st1 
  ProcedureReturn 
  !@@:dd 360 
EndProcedure 

Macro Cosd(angle) 
  (Cos((angle) * #Deg2Rad)) 
EndMacro 

Macro Sind(angle) 
  (Sin((angle) * #Deg2Rad)) 
EndMacro 

Procedure vagues() 
   ; Modification sur l'axe des Y 
   adresse = *addpoint + 4 
   For z = 0 To #NbZ 
      For x = 0 To #NbX 
         Sommet.f = Sind(AngleVague + (x * decaleX) + (z * decaleZ)) * hauteur 
         PokeF(adresse, Sommet) 
         adresse + 20 
      Next x 
   Next z 
   SetMeshData(0, #PB_Mesh_Vertex | #PB_Mesh_UVCoordinate, *addpoint , (#NbX + 1) * (#NbZ + 1)) 
EndProcedure 

Procedure AffAide() 
   StartDrawing(ScreenOutput()) 
   DrawingMode(1) 
   FrontColor(RGB(255,255,255)) 
   DrawText(0, 0, "[F1] / [F2] => Change Mode affichage") 
   DrawText(0, 20, "[PageUp] / [PageDown] => Hauteur : " + StrF(hauteur)) 
   DrawText(0, 40, "[Flèche Haut] / [Flèche bas] => DecaleZ : " + Str(decaleZ)) 
   DrawText(0, 60, "[Flèche Gauche] / [Flèche droite] => DecaleX : " + Str(decaleX)) 
   StopDrawing() 
EndProcedure 

;-Boucle principale 

Repeat 
    
   ClearScreen(#Black) 
   ExamineKeyboard() 
   If KeyboardReleased(#PB_Key_F1) :ClearScreen(RGB(0, 0, 0)): CameraRenderMode(0, #PB_Camera_Wireframe)  : EndIf 
   If KeyboardReleased(#PB_Key_F2) :ClearScreen(RGB(0, 0, 0)): CameraRenderMode(0, #PB_Camera_Textured)  : EndIf 
    
   If KeyboardReleased(#PB_Key_PageUp) : hauteur + 0.5  : EndIf 
   If KeyboardReleased(#PB_Key_PageDown) : hauteur - 0.5  : EndIf 
    
   If KeyboardReleased(#PB_Key_Up) : decaleZ + 1  : EndIf 
   If KeyboardReleased(#PB_Key_Down) : decaleZ - 1  : EndIf 
   If KeyboardReleased(#PB_Key_Left) : decaleX - 1  : EndIf 
   If KeyboardReleased(#PB_Key_Right) : decaleX + 1  : EndIf 
    
   AngleVague = wrapvalue(AngleVague + vitesse) 
   vagues() 
   AngleZ + 0.5 
   RotateEntity(0,0,0, AngleZ) 
   RenderWorld() 
   AffAide() 
   FlipBuffers() 
    
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP
; DisableDebugger