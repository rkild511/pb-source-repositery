; English forum: http://www.purebasic.fr/english/viewtopic.php?t=12811
; Author: Guimauve (updated for PB 4.00 by Andre + Progi1984)
; Date: 17. October 2004
; OS: Windows
; Demo: No


; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Amination 3D simple Icosaèdre étoilé (60 triangles) -- Source principal
; Version 1.10
; Programmation = OK
; Programmé par : Guimauve
; Date : 16 octobre 2004
; Codé avec PureBasic V3.92 Beta
; Updated : 13/03/07 Progi1984
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Enumeration
  #Vertical
  #Horizontal
  #Icosahedron
  #Icosahedron_small
  #Icosahedron_small2
  #Icosahedron_small3
  #Icosahedron_tex
  #Icosahedron_mat
  #Icosahedron_tex_small
  #Icosahedron_tex_small2
  #Icosahedron_tex_small3
EndEnumeration

Procedure.f DegToRad(Angle.f)

  ProcedureReturn Angle * 3.1415926 / 180

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration du tableau >>>>>
Global Dim Texte.s(5)

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Initialisation du tableau >>>>>

; Texte(0) = "Presser ESCAPE pour sortir."
; Texte(1) = "Model 3D : Position ( X, Y, Z )"
; Texte(2) = "Bleu/Vert"
; Texte(3) = "Gris/Rouge"
; Texte(4) = "Gris/Bleu"
; Texte(5) = "Rayon orbital aléatoire : "

Texte(0) = "Press ESCAPE to exit."
Texte(1) = "Model 3D : Position ( X, Y, Z )"
Texte(2) = "Blue/Green"
Texte(3) = "Gray/Red"
Texte(4) = "Gray/Blue"
Texte(5) = "Orbital radius : "

; Largeur et hauteur de la résolution windows
ScreenW = GetSystemMetrics_(#SM_CXSCREEN)
ScreenH = GetSystemMetrics_(#SM_CYSCREEN)
; Couleur 32 bits
ScreenD = 32

Declare DrawGradienttex(Color1.l, Color2.l, NbColor.l, largeur.l, hauteur.l, OutputID.l, Orientation.b)
Declare.f LinearDistanceEntity(X1.f, Y1.f, Z1.f, X2.f, Y2.f, Z2.f)
Declare.f Spin(No.f, mini.f, maxi.f, increment.f)

If InitEngine3D()
  If InitSprite()
    If InitKeyboard()
      If OpenScreen(ScreenW, ScreenH, ScreenD, "Icosaèdre étoilé")

        CreateMesh(#Icosahedron, 1000)
        SetMeshData(#Icosahedron, #PB_Mesh_Vertex, ?Vertices, 180)
        SetMeshData(#Icosahedron, #PB_Mesh_Face , ?FacesIndexes, 60)
        SetMeshData(#Icosahedron, #PB_Mesh_UVCoordinate, ?TextureCoordinates, 180)
        CreateTexture(#Icosahedron_tex, 256, 256)
        CreateMaterial(#Icosahedron_mat, TextureID(#Icosahedron_tex))
        CreateEntity(#Icosahedron, MeshID(#Icosahedron), MaterialID(#Icosahedron_mat))
        EntityLocate(#Icosahedron, 0, 0, 0)

        texture = #Icosahedron_tex_small
        For Entity = #Icosahedron_small To #Icosahedron_small3
          CopyEntity(#Icosahedron, Entity)
          ScaleEntity(Entity, 0.25, 0.25, 0.25)
          EntityLocate(Entity, 0, 0, 0)
          EntityMaterial(Entity, CreateMaterial(texture, CreateTexture(texture, 256, 256)))
          texture + 1
        Next

        ; Dessin de la texture
        DrawGradienttex(RGB(000, 255, 000), RGB(100, 000, 155), 255, 256, 256, TextureOutput(#Icosahedron_tex), #Vertical)
        DrawGradienttex(RGB(000, 255, 000), RGB(000, 000, 255), 255, 256, 256, TextureOutput(#Icosahedron_tex_small), #Vertical)
        DrawGradienttex(RGB(255, 000, 000), RGB(150, 150, 150), 255, 256, 256, TextureOutput(#Icosahedron_tex_small2), #Vertical)
        DrawGradienttex(RGB(000, 000, 255), RGB(150, 150, 150), 255, 256, 256, TextureOutput(#Icosahedron_tex_small3), #Vertical)

        CreateCamera(0, 0, 0, 100, 100)
        CameraLocate(0, 0, 0, 28)
        Orbit_radius.f = 9.25
        speed = 1
        theta.f = 5
        phi.f = -180

        For Entity = #Icosahedron_small To #Icosahedron_small3
          HideEntity(Entity, 1)
        Next

        Repeat

          ClearScreen(RGB(0, 0, 0))

          If var = 500

            If set = 0
              speed = 1
              var = 0
              set = 1

            ElseIf set = 1
              speed = -1
              var = 0
              set = 0
            EndIf
          EndIf

          RotateEntity(#Icosahedron, speed, speed, speed)

          For Entity = #Icosahedron_small To #Icosahedron_small3
            RotateEntity(Entity, -2 * speed, -2 * speed, -2 * speed)
          Next

          posX.f = Orbit_radius * (Cos(DegToRad(theta))) * Sin(DegToRad(phi))
          posY.f = Orbit_radius * (Sin(DegToRad(theta))) * Sin(DegToRad(phi))
          posZ.f = Orbit_radius * Cos(DegToRad(phi))

          EntityLocate(#Icosahedron_small, posX.f, posY.f, posZ.f)

          posX2.f = Orbit_radius * (Cos(DegToRad(theta + 175))) * Sin(DegToRad(-phi + 175))
          posY2.f = Orbit_radius * (Sin(DegToRad(theta + 175))) * Sin(DegToRad(-phi + 175))
          posZ2.f = Orbit_radius * Cos(DegToRad(-phi + 175))

          EntityLocate(#Icosahedron_small2, posX2.f, posY2.f, posZ2.f)

          posX3.f = Orbit_radius * (Cos(DegToRad(theta + 90))) * Sin(DegToRad(phi + 90))
          posY3.f = Orbit_radius * (Sin(DegToRad(theta + 90))) * Sin(DegToRad(phi + 90))
          posZ3.f = Orbit_radius * Cos(DegToRad(phi + 90))

          EntityLocate(#Icosahedron_small3, posX3.f, posY3.f, posZ3.f)

          RenderWorld()
          StartDrawing(ScreenOutput())
          DrawingMode(1)
          FrontColor(RGB(0, 255, 0))
          DrawText(0, 0, Texte(0))
          DrawText(0, 15, Texte(1))
          DrawText(0, 30, Texte(2) + " : ( " + StrF(EntityX(#Icosahedron_small), 4) + ", " + StrF(EntityY(#Icosahedron_small), 4) + ", " + StrF(EntityZ(#Icosahedron_small), 4) + " )")
          DrawText(0, 45, Texte(3) + " : ( " + StrF(EntityX(#Icosahedron_small2), 4) + ", " + StrF(EntityY(#Icosahedron_small2), 4) + ", " + StrF(EntityZ(#Icosahedron_small2), 4) + " )")
          DrawText(0, 60, Texte(4) + " : ( " + StrF(EntityX(#Icosahedron_small3), 4) + ", " + StrF(EntityY(#Icosahedron_small3), 4) + ", " + StrF(EntityZ(#Icosahedron_small3), 4) + " )")
          DrawText(0, 75, Texte(5) + StrF(Orbit_radius, 4))
          StopDrawing()

          FlipBuffers()
          var + 1

          theta = Spin(theta, 0, 359, 1)
          phi = Spin(phi, 0, 359, -0.5)

          ExamineKeyboard()
          For Entity = #Icosahedron_small To #Icosahedron_small3
            HideEntity(Entity, 0)
          Next
        Until KeyboardPushed(#PB_Key_Escape)

      EndIf
    EndIf
  EndIf
EndIf

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Procedure DrawGradienttex(Color1.l, Color2.l, NbColor.l, largeur.l, hauteur.l, OutputID.l, Orientation.b)

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
      y = MulDiv_(i, hauteur, Nbcolor)
      h = MulDiv_(i + 2, hauteur, NbColor)
      Box( 0, y, largeur, h, RGB(r, g, b))
      i + 1
    Wend

  ElseIf Orientation = #Horizontal
    While i < NbColor
      r = MulDiv_(i, rd, NbColor) + rt
      g = MulDiv_(i, gd, NbColor) + gt
      b = MulDiv_(i, bd, NbColor) + bt
      x = MulDiv_(i, largeur, Nbcolor)
      l = MulDiv_(i + 2, largeur, NbColor)
      Box(x, 0, l, hauteur, RGB(r, g, b))
      i + 1
    Wend
  EndIf
  StopDrawing()
EndProcedure

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure.f LinearDistanceEntity(X1.f, Y1.f, Z1.f, X2.f, Y2.f, Z2.f)

  ProcedureReturn Sqr(Pow((X2 - X1), 2) + Pow((Y2 - Y1), 2) + Pow((Z2 - Z1), 2))

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Procedure.f Spin(No.f, mini.f, maxi.f, increment.f)

  No + increment

  If No > maxi
    No = mini
  EndIf

  If No < mini
    No = Maxi
  EndIf

  ProcedureReturn No

EndProcedure


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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
; DisableDebugger