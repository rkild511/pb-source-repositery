; http://en.games-creators.org/wiki/PureBasic:First_tutorial_on_3d
; Author: Comtois
; Date: 18. August 2006
; OS: Windows
; Demo: Yes


;PB 4.0 le 18/08/06

InitEngine3D()
InitSprite()
InitKeyboard()

ExamineDesktops()
OpenScreen(DesktopWidth(0), DesktopHeight(0), DesktopDepth(0), "Tutoriel 3D")

;OpenScreen(800, 600, 32, "Tutoriel 3D")

Structure s_Sommet
  Position.f[3]
  Couleur.l
EndStructure

Structure s_Triangle
  Index.w[3]
EndStructure

Dim Sommets.s_Sommet(2)
Dim Triangles.s_Triangle(0)

;Sommet 0 position et couleur
Sommets(0)\Position[0] =    0.0 : Sommets(0)\Position[1] =  100.0 : Sommets(0)\Position[2] = 0.0
Sommets(0)\Couleur = $FF0000

;Sommet 1 position et couleur
Sommets(1)\Position[0] =  200.0 : Sommets(1)\Position[1] = -100.0 : Sommets(1)\Position[2] = 0.0
Sommets(1)\Couleur = $00FF00

;Sommet 2 position et couleur
Sommets(2)\Position[0] = -200.0 : Sommets(2)\Position[1] = -100.0 : Sommets(2)\Position[2] = 0.0
Sommets(2)\Couleur = $0000FF

; D�finition du triangle
Triangles(0)\Index[0] = 2 : Triangles(0)\Index[1] = 1 : Triangles(0)\Index[2] = 0


;Cr�ation d'un mesh
#Mesh = 0
CreateMesh(#Mesh, 200)

;D�finition des sommets
SetMeshData(#Mesh, #PB_Mesh_Vertex | #PB_Mesh_Color , @Sommets(), 3) ; Indiquez ici le nombre de sommets

;D�finition des triangles
SetMeshData(#Mesh, #PB_Mesh_Face, @Triangles(), 1) ; indiquez ici le nombre de triangles

;Cr�ation d'une texture
#Texture = 0
CreateTexture(#Texture, 64, 64)

;Remplissage de la texture en blanc pour visualiser les couleurs des sommets
StartDrawing(TextureOutput(#Texture))
  Box(0,0, TextureWidth(#Texture), TextureHeight(#Texture), RGB(255, 255, 255))
StopDrawing()

;Cr�ation d'une mati�re
#Matiere = 0
CreateMaterial(#Matiere, TextureID(#Texture))
MaterialAmbientColor(#Matiere, #PB_Material_AmbientColors)

;Cr�ation entity
#Entity = 0
CreateEntity(#Entity, MeshID(#Mesh), MaterialID(#Matiere))


;Ajoute une cam�ra , c'est indispensable pour voir quelque chose
#Camera = 0
CreateCamera(#Camera, 25, 25, 50, 50) ; Cr�ation d'une cam�ra
CameraBackColor(#Camera, $FF0000) ; Couleur de fond bleue
CameraLocate(#Camera,0,0,500) ; Positionne la cam�ra
CameraLookAt(#Camera, EntityX(#Entity), EntityY(#Entity), EntityZ(#Entity)) ; Oriente la cam�ra vers l'entity

Repeat

  ClearScreen(0)

  ExamineKeyboard()

  RenderWorld() ; Affiche le monde 3D

  FlipBuffers()

Until KeyboardPushed(#PB_Key_All)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP