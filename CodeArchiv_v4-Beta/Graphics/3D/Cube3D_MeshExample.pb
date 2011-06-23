; http://en.games-creators.org/wiki/PureBasic:Mesh_more_complex
; Author: Comtois
; Date: 19. August 2006
; OS: Windows
; Demo: Yes


; Cube 3D - a more complex mesh example

;PB4.0 Le 19/08/06

InitEngine3D()
InitSprite()
InitKeyboard()

ExamineDesktops()
OpenScreen(DesktopWidth(0), DesktopHeight(0), DesktopDepth(0), "Cube 3D")

;OpenScreen(800, 600, 32, "Cube 3D")

Macro RGB_INVERSE(Rouge,Vert,Bleu)
  Rouge << 16 + Vert << 8 + Bleu
EndMacro

Structure s_Sommet
  px.f
  py.f
  pz.f
  nx.f
  ny.f
  nz.f
  co.l
  u.f
  v.f
EndStructure

Structure s_Triangle
  f1.w
  f2.w
  f3.w
EndStructure

Structure s_Mesh
  No.l
  *VBuffer.s_Sommet
  *Ibuffer.s_Triangle
EndStructure


Global Angle.f,Pas.f, CameraMode.l
Global *VBuffer,*IBuffer

Define.s_Mesh CubeMesh


Procedure CreateMeshCube(*Mesh.s_Mesh)
  *Mesh\VBuffer=AllocateMemory(SizeOf(s_Sommet) * 24)
  *Mesh\IBuffer=AllocateMemory(SizeOf(s_Triangle) * 12)
  CopyMemory(?Sommets,   *Mesh\VBuffer, SizeOf(s_Sommet)   * 24)
  CopyMemory(?Triangles, *Mesh\IBuffer, SizeOf(s_Triangle) * 12)

  If CreateMesh(*Mesh\No, 100)
    Options = #PB_Mesh_Vertex | #PB_Mesh_Normal | #PB_Mesh_UVCoordinate | #PB_Mesh_Color
    SetMeshData(*Mesh\No, Options      , *Mesh\VBuffer, 24)
    SetMeshData(*Mesh\No, #PB_Mesh_Face, *Mesh\IBuffer, 12)
    ProcedureReturn 1
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure UpColorCube(*Mesh.s_Mesh, Couleur)
  *Mem.s_Sommet = *Mesh\VBuffer
  For i = 0 To 3
    *Mem\co=Couleur
    *Mem + SizeOf(s_Sommet)
  Next i
EndProcedure

Procedure DownColorCube(*Mesh.s_Mesh, Couleur)
  *Mem.s_Sommet = *Mesh\VBuffer + 4 * SizeOf(s_Sommet)
  For i = 0 To 3
    *Mem\co=Couleur
    *Mem + SizeOf(s_Sommet)
  Next i
EndProcedure

Procedure FrontColorCube(*Mesh.s_Mesh, Couleur)
  *Mem.s_Sommet = *Mesh\VBuffer + 8 * SizeOf(s_Sommet)
  For i = 0 To 3
    *Mem\co=Couleur
    *Mem + SizeOf(s_Sommet)
  Next i
EndProcedure

Procedure BackColorCube(*Mesh.s_Mesh, Couleur)
  *Mem.s_Sommet = *Mesh\VBuffer + 12 * SizeOf(s_Sommet)
  For i = 0 To 3
    *Mem\co=Couleur
    *Mem + SizeOf(s_Sommet)
  Next i
EndProcedure

Procedure LeftColorCube(*Mesh.s_Mesh, Couleur)
  *Mem.s_Sommet = *Mesh\VBuffer + 16 * SizeOf(s_Sommet)
  For i = 0 To 3
    *Mem\co=Couleur
    *Mem + SizeOf(s_Sommet)
  Next i
EndProcedure

Procedure RightColorCube(*Mesh.s_Mesh, Couleur)
  *Mem.s_Sommet = *Mesh\VBuffer + 20 * SizeOf(s_Sommet)
  For i = 0 To 3
    *Mem\co=Couleur
    *Mem + SizeOf(s_Sommet)
  Next i
EndProcedure

Procedure UpDateCube(*Mesh.s_Mesh)
  Flag = #PB_Mesh_Vertex | #PB_Mesh_Normal | #PB_Mesh_UVCoordinate | #PB_Mesh_Color
  SetMeshData(*Mesh\No, Flag  , *Mesh\VBuffer, 24)
EndProcedure

;-Mesh
#Mesh = 0
CubeMesh\No = #Mesh
CreateMeshCube(@CubeMesh)
UpColorCube(@CubeMesh,   RGB_INVERSE(255,0,0))    ; Change la couleur de la face en haut
DownColorCube(@CubeMesh, RGB_INVERSE(255,255,0))  ; Change la couleur de la face en bas
FrontColorCube(@CubeMesh,RGB_INVERSE(0,255,0))    ; Change la couleur de la face avant
BackColorCube(@CubeMesh, RGB_INVERSE(0,0,255))    ; Change la couleur de la face arrière
LeftColorCube(@CubeMesh, RGB_INVERSE(255,128,0))  ; Change la couleur de la face gauche
RightColorCube(@CubeMesh,RGB_INVERSE(255,255,255)); Change la couleur de la face droite
UpDateCube(@CubeMesh) ; Mise à jour des couleurs, rend le changement effectif

;-Texture
#Texture = 0
CreateTexture(#Texture, 128, 128)
;Remplissage de la texture en blanc avec une bordure noire
StartDrawing(TextureOutput(#Texture))
Box(0, 0, 128, 128, 0)
Box(1, 1, 126, 126, $FFFFFF)
StopDrawing()

;-Matière
#Matiere = 0
CreateMaterial(#Matiere, TextureID(#Texture))
MaterialAmbientColor(#Matiere, #PB_Material_AmbientColors)

;-Entity
#Entity = 0
CreateEntity(#Entity, MeshID(#Mesh), MaterialID(#Matiere))
ScaleEntity(#Entity, 90, 90, 90) ; Agrandi l'entity

;-Camera
#Camera = 0
CreateCamera(#Camera, 0, 0 , 100 , 100)
MoveCamera(#Camera, 0, 0, -400)
CameraLookAt(#Camera, EntityX(#Entity), EntityY(#Entity), EntityZ(#Entity))


;-Light
AmbientColor(RGB(255,255,255))

pas = 0.8
Repeat

  Angle + Pas
  RotateEntity(0,angle,angle/2,-Angle)

  If ExamineKeyboard()
    If KeyboardReleased(#PB_Key_F1)
      CameraMode=1-CameraMode
      CameraRenderMode(#Camera, CameraMode)
    EndIf
  EndIf
  RenderWorld()
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)

DataSection
  Sommets:
  ;Dessus 0 à 3
  Data.f -0.5,0.5,-0.5
  Data.f 0,1,0
  Data.l 0
  Data.f 0,0

  Data.f 0.5,0.5,-0.5
  Data.f 0,1,0
  Data.l 0
  Data.f 0,1

  Data.f 0.5,0.5,0.5
  Data.f 0,1,0
  Data.l 0
  Data.f 1,1

  Data.f -0.5,0.5,0.5
  Data.f 0,1,0
  Data.l 0
  Data.f 1,0

  ;Dessous 4 à 7
  Data.f -0.5,-0.5,0.5
  Data.f 0,-1,0
  Data.l 0
  Data.f 0,0

  Data.f 0.5,-0.5,0.5
  Data.f 0,-1,0
  Data.l 0
  Data.f 0,1

  Data.f 0.5,-0.5,-0.5
  Data.f 0,-1,0
  Data.l 0
  Data.f 1,1

  Data.f -0.5,-0.5,-0.5
  Data.f 0,-1,0
  Data.l 0
  Data.f 1,0

  ;Devant 8 à 11
  Data.f -0.5,0.5,0.5
  Data.f 0,0,1
  Data.l 0
  Data.f 0,0

  Data.f 0.5,0.5,0.5
  Data.f 0,0,1
  Data.l 0
  Data.f 0,1

  Data.f 0.5,-0.5,0.5
  Data.f 0,0,1
  Data.l 0
  Data.f 1,1

  Data.f -0.5,-0.5,0.5
  Data.f 0,0,1
  Data.l 0
  Data.f 1,0

  ;Derrière 12 à 15
  Data.f 0.5,0.5,-0.5
  Data.f 0,0,-1
  Data.l 0
  Data.f 0,0

  Data.f -0.5,0.5,-0.5
  Data.f 0,0,-1
  Data.l 0
  Data.f 0,1

  Data.f -0.5,-0.5,-0.5
  Data.f 0,0,-1
  Data.l 0
  Data.f 1,1

  Data.f 0.5,-0.5,-0.5
  Data.f 0,0,-1
  Data.l 0
  Data.f 1,0

  ;Cote gauche 16 à 19
  Data.f -0.5,0.5,-0.5
  Data.f -1,0,0
  Data.l 0
  Data.f 0,0

  Data.f -0.5,0.5,0.5
  Data.f -1,0,0
  Data.l 0
  Data.f 0,1

  Data.f -0.5,-0.5,0.5
  Data.f -1,0,0
  Data.l 0
  Data.f 1,1

  Data.f -0.5,-0.5,-0.5
  Data.f -1,0,0
  Data.l 0
  Data.f 1,0

  ;Cote droit 20 à 23
  Data.f 0.5,0.5,0.5
  Data.f 1,0,0
  Data.l 0
  Data.f 0,0

  Data.f 0.5,0.5,-0.5
  Data.f 1,0,0
  Data.l 0
  Data.f 0,1

  Data.f 0.5,-0.5,-0.5
  Data.f 1,0,0
  Data.l 0
  Data.f 1,1

  Data.f 0.5,-0.5,0.5
  Data.f 1,0,0
  Data.l 0
  Data.f 1,0

  Triangles:
  ;Face en Haut
  Data.w 2,1,0
  Data.w 0,3,2
  ;Face en Bas
  Data.w 6,5,4
  Data.w 4,7,6
  ;Face Avant
  Data.w 10,9,8
  Data.w 8,11,10
  ;Face Arrière
  Data.w 14,13,12
  Data.w 12,15,14
  ;Face Gauche
  Data.w 18,17,16
  Data.w 16,19,18
  ;Face Droite
  Data.w 22,21,20
  Data.w 20,23,22
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP