; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14136&postdays=0&postorder=asc&start=0
; Author: Guimauve (updated for PB 4.00 by Andre + Progi1984)
; Date: 28. March 2005
; OS: Windows
; Demo: No


; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Amination 3D simple Icosaèdre étoilé (60 triangles) -- Source principal
; Version 1.15
; Programmation = OK
; Programmé par : Guimauve
; Date : 16 octobre 2004
; Mise à jour : 2 mars 2005
; Codé avec PureBasic V3.93
; Updated : 13/03/07 Progi1984
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


Enumeration
  #Camera
EndEnumeration

Enumeration
  #CoordonneeX
  #CoordonneeY
  #CoordonneeZ
EndEnumeration

Enumeration
  #Vertical
  #Horizontal
EndEnumeration

Structure Info
  ModelID.l
  HelixRadius.f
  HelixNbSpire.f
  HelixPitch.f
  PosU.f
  PosX.f
  PosY.f
  PosZ.f
  ScaleFactor.f
  TextureID.l
  TextureSize.w
  TextureColor01.l
  TextureColor02.l
EndStructure

Global Dim Color(2, 10)

Color(1, 1) = RGB(000, 255, 000)
Color(2, 1) = RGB(100, 000, 155)

Color(1, 2) = RGB(000, 255, 000)
Color(2, 2) = RGB(000, 000, 255)

Color(1, 3) = RGB(255, 000, 000)
Color(2, 3) = RGB(150, 150, 150)

Color(1, 4) = RGB(255, 255, 255)
Color(2, 4) = RGB(100, 000, 160)

Color(1, 5) = RGB(000, 255, 255)
Color(2, 5) = RGB(150, 000, 150)

Color(1, 6) = RGB(000, 000, 255)
Color(2, 6) = RGB(255, 255, 000)

Color(1, 7) = RGB(255, 255, 000)
Color(2, 7) = RGB(000, 000, 255)

Color(1, 8) = RGB(000, 255, 000)
Color(2, 8) = RGB(100, 000, 155)

Color(1, 9) = RGB(255, 255, 128)
Color(2, 9) = RGB(180, 000, 000)

Color(1, 10) = RGB(255, 255, 000)
Color(2, 10) = RGB(255, 000, 000)

Global NewList Model.Info()


ScreenW = GetSystemMetrics_(#SM_CXSCREEN)
ScreenH = GetSystemMetrics_(#SM_CYSCREEN)
ScreenD = 32


; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;                      !!!!! WARNING !!!!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; THIS CODE HAS BEEN TESTED WITH :
; ASUS V9180 MX440 AGP 8X WITH 64 MB DDR MEMORY
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; On my system I have set this value to 500
; in order to have 500 models moving on the Helix
; and my computer just work fine.
; Remember, each model add 60 polygons to the
; animation.
;     2 models X 60 polygons = 120 polygons
;   20 models X 60 polygons = 1200 polygons
; 200 models x 60 polygons = 12000 polygons
; 500 models x 60 polygons = 30000 polygons

Nombre_de_model.l = 5

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;                      !!!!! WARNING !!!!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



Index.b =1

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Degré en Radian

Procedure.f DegToRad(Angle.f)

  ProcedureReturn Angle * #PI / 180

EndProcedure

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


ProcedureDLL.b SpinByte(No.b, mini.b, maxi.b, increment.b)
  No + increment

  If No > maxi
    No = mini
  EndIf

  If No < mini
    No = maxi
  EndIf

  ProcedureReturn No
EndProcedure


Procedure.f SpinFloat(No.f, mini.f, maxi.f, increment.f)

  No + increment

  If No > maxi
    No = mini
  EndIf

  If No < mini
    No = maxi
  EndIf

  ProcedureReturn No

EndProcedure

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Procedure.f Helice3D(rayon.f, NbSpire.f, Pas.f, Pos_u.f, Calcul.b)

  If Calcul = #CoordonneeX
    Resultat.f = rayon * Cos(DegToRad(360 * NbSpire * Pos_u))

  ElseIf Calcul = #CoordonneeY
    Resultat.f = rayon * Sin(DegToRad(360 * NbSpire * Pos_u))

  ElseIf Calcul = #CoordonneeZ
    Resultat.f = Pas * NbSpire * Pos_u

  EndIf

  ProcedureReturn Resultat
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Procedure DrawGradient(Color1.l, Color2.l, NbColor.l, largeur.l, hauteur.l, OutputID.l, Orientation.b)

  rt = Red(Color1)
  rd = Red(Color2) - rt
  gt = Green(Color1)
  gd = Green(Color2) - gt
  bt = Blue(Color1)
  bd = Blue(Color2) - bt

  StartDrawing(OutputID)
  If Orientation = #Vertical
    While i < NbColor
      r = MulDiv_(i, rd, NbColor) + rt
      g = MulDiv_(i, gd, NbColor) + gt
      b = MulDiv_(i, bd, NbColor) + bt
      y = MulDiv_(i, hauteur, NbColor)
      h = MulDiv_(i + 2, hauteur, NbColor)
      Box( 0, y, largeur, h, RGB(r, g, b))
      i + 1
    Wend

  ElseIf Orientation = #Horizontal
    While i < NbColor
      r = MulDiv_(i, rd, NbColor) + rt
      g = MulDiv_(i, gd, NbColor) + gt
      b = MulDiv_(i, bd, NbColor) + bt
      x = MulDiv_(i, largeur, NbColor)
      l = MulDiv_(i + 2, largeur, NbColor)
      Box(x, 0, l, hauteur, RGB(r, g, b))
      i + 1
    Wend
  EndIf
  StopDrawing()
EndProcedure
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

If InitEngine3D() = 0
  MessageRequester("Error", "The 3D Engine can't be initialized")
  End
Else

  If InitSprite() = 0 Or InitKeyboard() = 0
    MessageRequester("Error", "Can't open DirectX 7 Or later")
    End
  Else
    If OpenScreen(ScreenW, ScreenH, ScreenD, "Mouvement sur un hélive") = 0
      MessageRequester("Error", "Can't open a screen !")
      End
    Else

      For Model = 1 To Nombre_de_model
        AddElement(Model())
        Model()\ModelID = Model
        Model()\HelixRadius = 14.5
        Model()\HelixNbSpire = 5
        Model()\HelixPitch = 15
        Model()\PosU = 0.000 + u1.f
        Model()\PosX = Helice3D(Model()\HelixRadius, Model()\HelixNbSpire, Model()\HelixPitch, Model()\PosU, #CoordonneeZ)
        Model()\PosY = Helice3D(Model()\HelixRadius, Model()\HelixNbSpire, Model()\HelixPitch, Model()\PosU, #CoordonneeY)
        Model()\PosZ = Helice3D(Model()\HelixRadius, Model()\HelixNbSpire, Model()\HelixPitch, Model()\PosU, #CoordonneeX)
        Model()\ScaleFactor = 0.25
        Model()\TextureID = Model
        Model()\TextureSize = 64
        Model()\TextureColor01 = Color(1, Index)
        Model()\TextureColor02 = Color(2, Index)
        Index = SpinByte(Index,1,10,1)
        u1 = SpinFloat(u1, 0, 1, 1/Nombre_de_model)
      Next

      ForEach Model()
        CreateMesh(Model()\ModelID, 100)
        SetMeshData(Model()\ModelID, #PB_Mesh_Vertex, ?Vertices, 180)
        SetMeshData(Model()\ModelID, #PB_Mesh_Face, ?FacesIndexes, 60)
        SetMeshData(Model()\ModelID, #PB_Mesh_UVCoordinate, ?TextureCoordinates, 180)
        CreateEntity(Model()\ModelID, MeshID(Model()\ModelID), CreateMaterial(Model()\TextureID, CreateTexture(Model()\TextureID, Model()\TextureSize, Model()\TextureSize)))
        EntityLocate(Model()\ModelID, 0, 0, 0)
        ScaleEntity(Model()\ModelID, Model()\ScaleFactor, Model()\ScaleFactor, Model()\ScaleFactor)
        DrawGradient(Model()\TextureColor01, Model()\TextureColor02, 255, Model()\TextureSize, Model()\TextureSize, TextureOutput(Model()\TextureID), #Vertical)
      Next

      speed.b = 1

      CreateCamera(#Camera, 0, 0, 100, 100)
      CameraLocate(#Camera, 50, 0, 50)

      Repeat

        ClearScreen(RGB(0, 0, 0))

        If frame = 500

          If set = 0
            speed = 1
            frame = 0
            set = 1

          ElseIf set = 1
            speed = -1
            frame = 0
            set = 0
          EndIf
        EndIf

        ; Ici on fait la mise à jour des positions des models 3D et on positionne les models à leurs nouvelles positions.
        ForEach Model()
          Model()\PosU = SpinFloat(Model()\PosU, 0, 1, 0.0015)
          Model()\PosX = Helice3D(Model()\HelixRadius, Model()\HelixNbSpire, Model()\HelixPitch, Model()\PosU, #CoordonneeZ)
          Model()\PosY = Helice3D(Model()\HelixRadius, Model()\HelixNbSpire, Model()\HelixPitch, Model()\PosU, #CoordonneeY)
          Model()\PosZ = Helice3D(Model()\HelixRadius, Model()\HelixNbSpire, Model()\HelixPitch, Model()\PosU, #CoordonneeX)
          EntityLocate(Model()\ModelID, Model()\PosX, Model()\PosY, Model()\PosZ)
          RotateEntity(Model()\ModelID, -2 * speed, -2 * speed, -2 * speed)
        Next


        RenderWorld()

        frame + 1

        ExamineKeyboard()


        FlipBuffers()

      Until KeyboardPushed(#PB_Key_Escape)
    EndIf
  EndIf

EndIf

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

DataSection

  Vertices :
  Data.f - 4.014306, 5.254795, 0.000000
  Data.f 0.000000, 4.000000, 0.000000
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f - 4.014306, 5.254795, 0.000000
  Data.f - 2.894427, 1.788854, -2.102924
  Data.f 0.000000, 4.000000, 0.000000
  Data.f - 4.014306, 5.254795, -0.000000
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f - 2.894427, 1.788854, -2.102924
  Data.f - 1.240489, 5.254795, 3.817832
  Data.f 0.000000, 4.000000, 0.000000
  Data.f 1.105573, 1.788854, 3.402603
  Data.f - 1.240489, 5.254795, 3.817832
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f 0.000000, 4.000000, 0.000000
  Data.f - 1.240489, 5.254795, 3.817832
  Data.f 1.105573, 1.788854, 3.402603
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f 3.247642, 5.254795, 2.359550
  Data.f 0.000000, 4.000000, 0.000000
  Data.f 3.577708, 1.788854, 0.000000
  Data.f 3.247642, 5.254795, 2.359550
  Data.f 1.105573, 1.788854, 3.402603
  Data.f 0.000000, 4.000000, 0.000000
  Data.f 3.247642, 5.254795, 2.359550
  Data.f 3.577708, 1.788854, 0.000000
  Data.f 1.105573, 1.788854, 3.402603
  Data.f 3.247642, 5.254795, -2.359550
  Data.f 0.000000, 4.000000, 0.000000
  Data.f 1.105573, 1.788854, -3.402603
  Data.f 3.247642, 5.254795, -2.359550
  Data.f 3.577708, 1.788854, 0.000000
  Data.f 0.000000, 4.000000, 0.000000
  Data.f 3.247642, 5.254795, -2.359550
  Data.f 1.105573, 1.788854, -3.402603
  Data.f 3.577708, 1.788854, 0.000000
  Data.f - 1.240489, 5.254795, -3.817832
  Data.f 0.000000, 4.000000, 0.000000
  Data.f - 2.894427, 1.788854, -2.102924
  Data.f - 1.240489, 5.254795, -3.817832
  Data.f 1.105573, 1.788854, -3.402603
  Data.f 0.000000, 4.000000, 0.000000
  Data.f - 1.240489, 5.254795, -3.817832
  Data.f - 2.894427, 1.788854, -2.102924
  Data.f 1.105573, 1.788854, -3.402603
  Data.f - 6.495283, 1.240489, 0.000000
  Data.f - 3.577709, -1.788854, 0.000000
  Data.f - 2.894427, 1.788854, -2.102924
  Data.f - 6.495283, 1.240489, 0.000000
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f - 3.577709, -1.788854, 0.000000
  Data.f - 6.495283, 1.240489, 0.000000
  Data.f - 2.894427, 1.788854, -2.102924
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f - 2.007153, 1.240489, 6.177382
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f - 2.007153, 1.240489, 6.177382
  Data.f 1.105573, 1.788854, 3.402603
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f - 2.007153, 1.240489, 6.177382
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f 1.105573, 1.788854, 3.402603
  Data.f 5.254795, 1.240489, 3.817831
  Data.f 2.894427, -1.788854, 2.102924
  Data.f 1.105573, 1.788854, 3.402603
  Data.f 5.254795, 1.240489, 3.817832
  Data.f 3.577708, 1.788854, -0.000000
  Data.f 2.894427, -1.788854, 2.102924
  Data.f 5.254795, 1.240489, 3.817831
  Data.f 1.105573, 1.788854, 3.402603
  Data.f 3.577708, 1.788854, -0.000000
  Data.f 5.254794, 1.240489, -3.817832
  Data.f 2.894427, -1.788854, -2.102925
  Data.f 3.577708, 1.788854, -0.000000
  Data.f 5.254794, 1.240489, -3.817832
  Data.f 1.105572, 1.788854, -3.402603
  Data.f 2.894427, -1.788854, -2.102925
  Data.f 5.254794, 1.240489, -3.817832
  Data.f 3.577708, 1.788854, -0.000000
  Data.f 1.105572, 1.788854, -3.402603
  Data.f - 2.007153, 1.240489, -6.177382
  Data.f - 1.105573, -1.788854, -3.402603
  Data.f 1.105572, 1.788854, -3.402603
  Data.f - 2.007153, 1.240489, -6.177382
  Data.f - 2.894427, 1.788854, -2.102924
  Data.f - 1.105573, -1.788854, -3.402603
  Data.f - 2.007153, 1.240489, -6.177382
  Data.f 1.105572, 1.788854, -3.402603
  Data.f - 2.894427, 1.788854, -2.102924
  Data.f 2.007153, -1.240489, -6.177382
  Data.f 1.105573, 1.788854, -3.402603
  Data.f - 1.105572, -1.788854, -3.402603
  Data.f 2.007153, -1.240489, -6.177382
  Data.f 2.894427, -1.788854, -2.102924
  Data.f 1.105573, 1.788854, -3.402603
  Data.f 2.007153, -1.240489, -6.177382
  Data.f - 1.105572, -1.788854, -3.402603
  Data.f 2.894427, -1.788854, -2.102924
  Data.f - 5.254794, -1.240489, -3.817832
  Data.f - 2.894427, 1.788854, -2.102925
  Data.f - 3.577708, -1.788854, -0.000000
  Data.f - 5.254794, -1.240489, -3.817832
  Data.f - 1.105572, -1.788854, -3.402603
  Data.f - 2.894427, 1.788854, -2.102925
  Data.f - 5.254794, -1.240489, -3.817832
  Data.f - 3.577708, -1.788854, -0.000000
  Data.f - 1.105572, -1.788854, -3.402603
  Data.f - 5.254795, -1.240489, 3.817831
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f - 5.254795, -1.240489, 3.817832
  Data.f - 3.577708, -1.788854, -0.000000
  Data.f - 2.894427, 1.788854, 2.102924
  Data.f - 5.254795, -1.240489, 3.817831
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f - 3.577708, -1.788854, -0.000000
  Data.f 2.007153, -1.240489, 6.177382
  Data.f 1.105573, 1.788854, 3.402603
  Data.f 2.894427, -1.788854, 2.102924
  Data.f 2.007153, -1.240489, 6.177382
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f 1.105573, 1.788854, 3.402603
  Data.f 2.007153, -1.240489, 6.177382
  Data.f 2.894427, -1.788854, 2.102924
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f 6.495283, -1.240489, 0.000000
  Data.f 3.577709, 1.788854, 0.000000
  Data.f 2.894427, -1.788854, -2.102924
  Data.f 6.495283, -1.240489, 0.000000
  Data.f 2.894427, -1.788854, 2.102924
  Data.f 3.577709, 1.788854, 0.000000
  Data.f 6.495283, -1.240489, 0.000000
  Data.f 2.894427, -1.788854, -2.102924
  Data.f 2.894427, -1.788854, 2.102924
  Data.f 1.240489, -5.254795, -3.817832
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f 2.894427, -1.788854, -2.102924
  Data.f 1.240489, -5.254795, -3.817832
  Data.f - 1.105573, -1.788854, -3.402603
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f 1.240489, -5.254795, -3.817832
  Data.f 2.894427, -1.788854, -2.102924
  Data.f - 1.105573, -1.788854, -3.402603
  Data.f - 3.247642, -5.254795, -2.359550
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f - 1.105573, -1.788854, -3.402603
  Data.f - 3.247642, -5.254795, -2.359550
  Data.f - 3.577708, -1.788854, 0.000000
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f - 3.247642, -5.254795, -2.359550
  Data.f - 1.105573, -1.788854, -3.402603
  Data.f - 3.577708, -1.788854, 0.000000
  Data.f - 3.247642, -5.254795, 2.359550
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f - 3.577708, -1.788854, 0.000000
  Data.f - 3.247642, -5.254795, 2.359550
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f - 3.247642, -5.254795, 2.359550
  Data.f - 3.577708, -1.788854, 0.000000
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f 1.240489, -5.254795, 3.817832
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f 1.240489, -5.254795, 3.817832
  Data.f 2.894427, -1.788854, 2.102924
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f 1.240489, -5.254795, 3.817832
  Data.f - 1.105573, -1.788854, 3.402603
  Data.f 2.894427, -1.788854, 2.102924
  Data.f 4.014306, -5.254795, 0.000000
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f 2.894427, -1.788854, 2.102924
  Data.f 4.014306, -5.254795, 0.000000
  Data.f 2.894427, -1.788854, -2.102924
  Data.f - 0.000000, -4.000000, 0.000000
  Data.f 4.014306, -5.254795, -0.000000
  Data.f 2.894427, -1.788854, 2.102924
  Data.f 2.894427, -1.788854, -2.102924

  FacesIndexes :
  Data.w 2, 1, 0
  Data.w 5, 4, 3
  Data.w 8, 7, 6
  Data.w 11, 10, 9
  Data.w 14, 13, 12
  Data.w 17, 16, 15
  Data.w 20, 19, 18
  Data.w 23, 22, 21
  Data.w 26, 25, 24
  Data.w 29, 28, 27
  Data.w 32, 31, 30
  Data.w 35, 34, 33
  Data.w 38, 37, 36
  Data.w 41, 40, 39
  Data.w 44, 43, 42
  Data.w 47, 46, 45
  Data.w 50, 49, 48
  Data.w 53, 52, 51
  Data.w 56, 55, 54
  Data.w 59, 58, 57
  Data.w 62, 61, 60
  Data.w 65, 64, 63
  Data.w 68, 67, 66
  Data.w 71, 70, 69
  Data.w 74, 73, 72
  Data.w 77, 76, 75
  Data.w 80, 79, 78
  Data.w 83, 82, 81
  Data.w 86, 85, 84
  Data.w 89, 88, 87
  Data.w 92, 91, 90
  Data.w 95, 94, 93
  Data.w 98, 97, 96
  Data.w 101, 100, 99
  Data.w 104, 103, 102
  Data.w 107, 106, 105
  Data.w 110, 109, 108
  Data.w 113, 112, 111
  Data.w 116, 115, 114
  Data.w 119, 118, 117
  Data.w 122, 121, 120
  Data.w 125, 124, 123
  Data.w 128, 127, 126
  Data.w 131, 130, 129
  Data.w 134, 133, 132
  Data.w 137, 136, 135
  Data.w 140, 139, 138
  Data.w 143, 142, 141
  Data.w 146, 145, 144
  Data.w 149, 148, 147
  Data.w 152, 151, 150
  Data.w 155, 154, 153
  Data.w 158, 157, 156
  Data.w 161, 160, 159
  Data.w 164, 163, 162
  Data.w 167, 166, 165
  Data.w 170, 169, 168
  Data.w 173, 172, 171
  Data.w 176, 175, 174
  Data.w 179, 178, 177

  TextureCoordinates :
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000
  Data.f 0.500000, 0.000000
  Data.f 0.000000, 1.000000
  Data.f 1.000000, 1.000000

EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -