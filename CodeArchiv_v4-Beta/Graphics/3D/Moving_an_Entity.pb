; http://en.games-creators.org/wiki/PureBasic:Moving_an_entity
; Author: Comtois
; Date: 19. August 2006
; OS: Windows
; Demo: Yes


; Cube 3D - a more complex mesh example


;PB4.0 Le 19/08/06

EnableExplicit

InitEngine3D()
InitSprite()
InitKeyboard()

ExamineDesktops()
OpenScreen(DesktopWidth(0), DesktopHeight(0), DesktopDepth(0), "Cube 3D")

;OpenScreen(800, 600, 32, "Cube 3D")

Enumeration
  #VueDessus
  #VueArriere
  #VueCote
  #VueAvant
EndEnumeration

Global Angle.f, Vitesse.f
Define.l Options, ModeCamera, i

Vitesse = 1
ModeCamera = #VueArriere

Macro NEW_X(x, Angle, Distance)
  ((x) + Cos((Angle) * 0.0174533) * (Distance))
EndMacro

Macro NEW_Z(z, Angle, Distance)
  ((z) - Sin((Angle) * 0.0174533) * (Distance))
EndMacro

Macro AFFICHE_AIDE()
  StartDrawing(ScreenOutput())
  DrawText(0,0,"Touches [F1] - [F2] - [F3] - [F4] pour changer la vue de la caméra", $FF0000, $00FFFF)
  StopDrawing()
EndMacro

;- Declaration des procédures
Declare.f CurveValue(actuelle.f, Cible.f, P.f)
Declare GestionCamera(Mode.l)

;-Mesh
#Mesh = 0
CreateMesh(#Mesh, 100)
Options = #PB_Mesh_Vertex | #PB_Mesh_Normal | #PB_Mesh_Color | #PB_Mesh_UVCoordinate
SetMeshData(#Mesh, Options      , ?Sommets, 24)
SetMeshData(#Mesh, #PB_Mesh_Face, ?Triangles, 12)

;-Textures
#Texture = 0
CreateTexture(#Texture, 64, 64)

;Remplissage de la texture en blanc
StartDrawing(TextureOutput(#Texture))
Box(0, 0, TextureWidth(#Texture), TextureHeight(#Texture), $FFFFFF)
DrawingMode(#PB_2DDrawing_Outlined) ; Pour tracer le contour
Box(0, 0, TextureWidth(#Texture), TextureHeight(#Texture), 0)
StopDrawing()

#TextureSol = 1
CreateTexture(#TextureSol, 128, 128)

;Remplissage de la texture en blanc
StartDrawing(TextureOutput(#TextureSol))
Box(0, 0, TextureWidth(#TextureSol), TextureHeight(#TextureSol), $FFFFFF)
For i = 0 To 127 Step 10
  Line(i, 0, 0, TextureHeight(#TextureSol), $0000FF)
  Line(0, i, TextureWidth(#TextureSol), 0, $0000FF)
Next i

DrawingMode(#PB_2DDrawing_Outlined) ; Pour tracer le contour
Box(0, 0, TextureWidth(#TextureSol), TextureHeight(#TextureSol), $000088)
StopDrawing()


;-Matière
#Matiere = 0
CreateMaterial(#Matiere, TextureID(#Texture))

#MatiereSol = 1
CreateMaterial(#MatiereSol, TextureID(#TextureSol))

;-Entity
#Entity = 0
CreateEntity(#Entity, MeshID(#Mesh), MaterialID(#Matiere))
ScaleEntity(#Entity, 10, 10, 10) ; Agrandi l'entity
EntityLocate(#Entity, 500, 5, 500)

#EntitySol = 1
CreateEntity(#EntitySol, MeshID(#Mesh), MaterialID(#MatiereSol))
ScaleEntity(#EntitySol, 1000, 2, 1000) ; Agrandi l'entity
EntityLocate(#EntitySol, 500, -5, 500)

;-Camera
#Camera = 0
CreateCamera(#Camera, 0, 0, 100, 100)

;-Light
AmbientColor(RGB(55,55,55)) ; Réduit la lumière ambiante pour mieux voir les lumières
#LightRouge = 0 : CreateLight(#LightRouge,RGB(255, 0, 0),    0, 500,    0)
#LightBleue = 1 : CreateLight(#LightBleue,RGB(0, 0, 255),    0, 500, 1000)
#LightVerte = 2 : CreateLight(#LightVerte,RGB(0, 255, 0), 1000, 500, 1000)

Repeat

  If ExamineKeyboard()
    ;Change la vue de la caméra
    If KeyboardReleased(#PB_Key_F1)
      ModeCamera = #VueDessus
    ElseIf KeyboardReleased(#PB_Key_F2)
      ModeCamera = #VueArriere
    ElseIf KeyboardReleased(#PB_Key_F3)
      ModeCamera = #VueCote
    ElseIf KeyboardReleased(#PB_Key_F4)
      ModeCamera = #VueAvant
    EndIf

    If KeyboardPushed(#PB_Key_Left)
      Angle + 1
      RotateEntity(#Entity, Angle, 0, 0)
    ElseIf KeyboardPushed(#PB_Key_Right)
      Angle - 1
      RotateEntity(#Entity, Angle, 0, 0)
    EndIf

    If KeyboardPushed(#PB_Key_Up)
      MoveEntity(#Entity, NEW_X(0, Angle , Vitesse), 0, NEW_Z(0, Angle, Vitesse))
    ElseIf KeyboardPushed(#PB_Key_Down)
      MoveEntity(#Entity, NEW_X(0, Angle , -Vitesse), 0, NEW_Z(0, Angle, -Vitesse))
    EndIf

  EndIf

  GestionCamera(ModeCamera)

  RenderWorld()

  AFFICHE_AIDE()

  FlipBuffers()

Until KeyboardPushed(#PB_Key_Escape)


Procedure.f CurveValue(actuelle.f, Cible.f, P.f)
  ;Calcule une valeur progressive allant de la valeur actuelle à la valeur cible
  Define.f Delta
  Delta = Cible - actuelle
  If P > 1000.0 : P = 1000.0 : EndIf
  ProcedureReturn  (actuelle + ( Delta * P / 1000.0))
EndProcedure

Procedure GestionCamera(Mode.l)
  Define.f Px, Py, Pz, Pv
  Static AngleCamera.f

  Pv = 25

  Select Mode

    Case #VueDessus
      AngleCamera = CurveValue(AngleCamera, Angle + 180, Pv)
      Px = CurveValue(CameraX(#Camera), NEW_X(EntityX(#Entity), AngleCamera, 40), Pv)
      Py = CurveValue(CameraY(#Camera), EntityY(#Entity) + 140, Pv)
      Pz = CurveValue(CameraZ(#Camera), NEW_Z(EntityZ(#Entity), AngleCamera, 40), Pv)

    Case #VueArriere
      AngleCamera = CurveValue(AngleCamera, Angle + 180, Pv)
      Px = CurveValue(CameraX(#Camera), NEW_X(EntityX(#Entity), AngleCamera, 80), Pv)
      Py = CurveValue(CameraY(#Camera), EntityY(#Entity) + 40, Pv)
      Pz = CurveValue(CameraZ(#Camera), NEW_Z(EntityZ(#Entity), AngleCamera, 80), Pv)

    Case #VueCote
      AngleCamera = CurveValue(AngleCamera, Angle + 120, Pv)
      Px = CurveValue(CameraX(#Camera), NEW_X(EntityX(#Entity), AngleCamera, 80), Pv)
      Py = CurveValue(CameraY(#Camera), EntityY(#Entity) + 40, Pv)
      Pz = CurveValue(CameraZ(#Camera), NEW_Z(EntityZ(#Entity), AngleCamera, 80), Pv)

    Case #VueAvant
      AngleCamera = CurveValue(AngleCamera, Angle, Pv)
      Px = CurveValue(CameraX(#Camera), NEW_X(EntityX(#Entity), AngleCamera, 80), Pv)
      Py = CurveValue(CameraY(#Camera), EntityY(#Entity) + 40, Pv)
      Pz = CurveValue(CameraZ(#Camera), NEW_Z(EntityZ(#Entity), AngleCamera, 80), Pv)

  EndSelect

  CameraLocate(#Camera, Px, Py, Pz)
  CameraLookAt(#Camera, EntityX(#Entity), EntityY(#Entity), EntityZ(#Entity))
EndProcedure


;{ Définition du cube
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
;}

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP