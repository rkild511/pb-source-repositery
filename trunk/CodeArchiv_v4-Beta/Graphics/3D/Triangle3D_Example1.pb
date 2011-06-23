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

;Création of the mesh
#Mesh = 0
CreateMesh(#Mesh, 200)

;Définition of the vertices
SetMeshData(#Mesh, #PB_Mesh_Vertex | #PB_Mesh_Color , ?SommetsTriangles, 3) ; Indicate number of vertices

;Définition of triangles
SetMeshData(#Mesh, #PB_Mesh_Face, ?IndexTriangles, 1) ; indicate the number of triangles

;Création of a texture
#Texture = 0
CreateTexture(#Texture, 64, 64)

;{Remplissage de la texture en blanc pour visualiser les couleurs des sommets}
;Draw a box to use as the texture that gives visual/colour effect to the vectors / vertices?
StartDrawing(TextureOutput(#Texture))
  Box(0,0, TextureWidth(#Texture), TextureHeight(#Texture), RGB(255, 255, 255))
StopDrawing()

;Créate material
#Matiere = 0
CreateMaterial(#Matiere, TextureID(#Texture))
MaterialAmbientColor(#Matiere, #PB_Material_AmbientColors)

;Créate entity
#Entity = 0
CreateEntity(#Entity, MeshID(#Mesh), MaterialID(#Matiere))

;Add a caméra, indispensable if something is to be seen
#Camera = 0
CreateCamera(#Camera, 25, 25, 50, 50) ; Créate caméra
CameraBackColor(#Camera, $FF0000) ; Back color is blue
CameraLocate(#Camera,0,0,500) ; Position the caméra
CameraLookAt(#Camera, EntityX(#Entity), EntityY(#Entity), EntityZ(#Entity)) ; Point/orient the caméra towards the entity

Repeat

  ClearScreen(0)

  ExamineKeyboard()

  RenderWorld() ; Display the 3D world

  FlipBuffers()

Until KeyboardPushed(#PB_Key_All)

DataSection

  SommetsTriangles:

  Data.f 0.0,100.0,0.0              ; Position vertex 0
  Data.l $FF0000                    ; Colour vertex 0
  Data.f 200.0,-100.0,0.0           ; Position vertex 1
  Data.l $00FF00                    ; Colour vertex 1
  Data.f -200.0,-100.0,0.0          ; Position vertex 2
  Data.l $0000FF                    ; Colour vertex 2

  IndexTriangles:
  Data.w 2,1,0                      ; Vertices 2, 1 and 0 form a triangle

EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP