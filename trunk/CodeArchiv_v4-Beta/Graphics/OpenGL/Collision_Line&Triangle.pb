; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13933&highlight=
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 06. February 2005
; OS: Windows
; Demo: No


; With glwrapperlibrary you can have a triangle/line collision:

XIncludeFile "..\..\Includes+Macros\Includes\OpenGL\OpenGL.pbi"

Global PI.f
PI.f = ATan(1)*4

#Window = 0
#WindowWidth = 500
#WindowHeight = 400
#WindowFlags = #PB_Window_TitleBar | #PB_Window_MaximizeGadget | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered
Version = 1

Procedure MyWindowCallback(WindowID, Message, wParam, lParam)
  Result = #PB_ProcessPureBasicEvents
  If Message = #WM_SIZE
    glViewport_(0, 0, WindowWidth(#Window), WindowHeight(#Window))
    Result = 1
  EndIf
  ProcedureReturn Result
EndProcedure

Structure Point3D
  X.f
  Y.f
  Z.f
EndStructure

Dim Vec.Point3D(2)
Dim Line3D.Point3D(1)

Procedure.f Magnitude(X.f, Y.f, Z.f)
  ProcedureReturn Sqr(X*X + Y*Y + Z*Z)
EndProcedure

Procedure OGLSetCamera(FOV.f, X.f, Y.f, Z.f, AngleX.f, AngleY.f, AngleZ.f, Near.f, Far.f)
  If AngleY <= 0
    AngleY + 360
  ElseIf AngleY > 360
    AngleY - 360
  EndIf
  If AngleX <= 0
    AngleX + 360
  ElseIf AngleX > 360
    AngleX - 360
  EndIf
  If AngleZ <= 0
    AngleZ + 360
  ElseIf AngleZ > 360
    AngleZ - 360
  EndIf
  glMatrixMode_(5889)
  glLoadIdentity_()
  gluPerspective__(FOV, WindowWidth(#Window)/WindowHeight(#Window), Near.f, Far.f)
  glRotatef_(AngleX, 1.0, 0.0, 0.0)
  glRotatef_(AngleY, 0.0, 1.0, 0.0)
  glRotatef_(AngleZ, 0.0, 0.0, 1.0)
  glTranslatef_(X, Y, Z)
  glMatrixMode_(5888)
EndProcedure

Procedure.l Normal(*Pos1.Point3D, *Pos2.Point3D, *Pos3.Point3D, *vNormal.Point3D)
  vVector1.Point3D
  vVector1\X = *Pos1\X - *Pos2\X
  vVector1\Y = *Pos1\Y - *Pos2\Y
  vVector1\Z = *Pos1\Z - *Pos2\Z
  vVector2.Point3D
  vVector2\X = *Pos1\X - *Pos3\X
  vVector2\Y = *Pos1\Y - *Pos3\Y
  vVector2\Z = *Pos1\Z - *Pos3\Z

  *vNormal\X = ((vVector1\Y * vVector2\Z) - (vVector1\Z * vVector2\Y))
  *vNormal\Y = ((vVector1\Z * vVector2\X) - (vVector1\X * vVector2\Z))
  *vNormal\Z = ((vVector1\X * vVector2\Y) - (vVector1\Y * vVector2\X))

  Magnitude.f = Magnitude(*vNormal\X, *vNormal\Y, *vNormal\Z)

  *vNormal\X / Magnitude
  *vNormal\Y / Magnitude
  *vNormal\Z / Magnitude
EndProcedure

Procedure.f PlaneDistance(*vNormal.Point3D, *Point.Point3D)
  distance.f = 0
  distance = - ((*vNormal\X * *Point\X) + (*vNormal\Y * *Point\Y) + (*vNormal\Z * *Point\Z))
  ProcedureReturn distance.f
EndProcedure

Procedure IntersectedPlane(*LPos1.Point3D, *LPos2.Point3D, *TPos1.Point3D, *TPos2.Point3D, *TPos3.Point3D, *vNormal.Point3D)
  distance1.f=0
  distance2.f=0

  originDistance.f = PlaneDistance(*vNormal.Point3D, *TPos1.Point3D)

  distance1 = ((*vNormal\X * *LPos1\X) + (*vNormal\Y * *LPos1\Y) + (*vNormal\Z * *LPos1\Z)) + originDistance
  distance2 = ((*vNormal\X * *LPos2\X) + (*vNormal\Y * *LPos2\Y) + (*vNormal\Z * *LPos2\Z)) + originDistance
  If distance1 * distance2 >= 0
    ProcedureReturn 0
  Else
    ProcedureReturn 1
  EndIf
EndProcedure

Procedure.f Dot(*vVector1.Point3D, *vVector2.Point3D)
  ProcedureReturn ((*vVector1\x * *vVector2\x) + (*vVector1\y * *vVector2\y) + (*vVector1\z * *vVector2\z))
EndProcedure

Procedure IsNan(Num.f)
  If PeekB(@Num) = 0 And PeekB(@Num+1) = 0 And PeekB(@Num+2) = -64 And PeekB(@Num+3) = -1
    ProcedureReturn 1
  EndIf
EndProcedure

Procedure.f AngleBetweenVectors(*Vector1.Point3D, *Vector2.Point3D)
  dotProduct.f = Dot(*Vector1, *Vector2)

  vectorsMagnitude.f = Magnitude(*Vector1\X, *Vector1\Y, *Vector1\Z) * Magnitude(*Vector2\X, *Vector2\Y, *Vector2\Z)

  angle.f = ACos(dotProduct / vectorsMagnitude)

  If Isnan(angle.f)
    ProcedureReturn 0
  Else
    ProcedureReturn angle
  EndIf
EndProcedure

Procedure InsidePolygon(*vIntersection.Point3D, *TPos1.Point3D, *TPos2.Point3D, *TPos3.Point3D)
  vA.Point3D
  vB.Point3D
  Angle.f = 0.0
  MATCH_FACTOR.f = 0.9999

  vA\X = *TPos1\X - *vIntersection\X
  vA\Y = *TPos1\Y - *vIntersection\Y
  vA\Z = *TPos1\Z - *vIntersection\Z

  vB\X = *TPos2\X - *vIntersection\X
  vB\Y = *TPos2\Y - *vIntersection\Y
  vB\Z = *TPos2\Z - *vIntersection\Z

  Angle + AngleBetweenVectors(@vA, @vB)

  vA\X = *TPos2\X - *vIntersection\X
  vA\Y = *TPos2\Y - *vIntersection\Y
  vA\Z = *TPos2\Z - *vIntersection\Z

  vB\X = *TPos3\X - *vIntersection\X
  vB\Y = *TPos3\Y - *vIntersection\Y
  vB\Z = *TPos3\Z - *vIntersection\Z

  Angle + AngleBetweenVectors(@vA, @vB)

  vA\X = *TPos3\X - *vIntersection\X
  vA\Y = *TPos3\Y - *vIntersection\Y
  vA\Z = *TPos3\Z - *vIntersection\Z

  vB\X = *TPos1\X - *vIntersection\X
  vB\Y = *TPos1\Y - *vIntersection\Y
  vB\Z = *TPos1\Z - *vIntersection\Z

  Angle + AngleBetweenVectors(@vA, @vB)

  If Angle >= (MATCH_FACTOR * (2.0 * PI))
    ProcedureReturn 1
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure IntersectionPoint(*vNormal.Point3D, *LPos1.Point3D, *LPos2.Point3D, distance.f)
  vPoint.Point3D
  vLineDir.Point3D

  Numerator.f = 0.0
  Denominator.f = 0.0
  dist.f = 0.0

  vLineDir\X = *LPos2\X - *LPos1\X
  vLineDir\Y = *LPos2\Y - *LPos1\Y
  vLineDir\Z = *LPos2\Z - *LPos1\Z

  Mag.f = Magnitude(vLineDir\X, vLineDir\Y, vLineDir\Z)

  vLineDir\X / Mag
  vLineDir\Y / Mag
  vLineDir\Z / Mag

  Numerator = - (*vNormal\X * *LPos1\X + *vNormal\Y * *LPos1\Y + *vNormal\Z * *LPos1\Z + distance)
  Denominator = Dot(*vNormal, @vLineDir)

  If Denominator = 0.0
    ProcedureReturn *LPos1
  EndIf

  dist = Numerator / Denominator

  vPoint\X = (*LPos1\X + (vLineDir\X * dist))
  vPoint\Y = (*LPos1\Y + (vLineDir\y * dist))
  vPoint\Z = (*LPos1\Z + (vLineDir\z * dist))

  ProcedureReturn @vPoint
EndProcedure

Procedure IntersectedPolygon(*TPos1.Point3D, *TPos2.Point3D, *TPos3.Point3D, *LPos1.Point3D, *LPos2.Point3D, *vNormal.Point3D)
  originDistance.f = PlaneDistance(*vNormal.Point3D, *TPos1.Point3D)
  If IntersectedPlane(*LPos1.Point3D, *LPos2.Point3D, *TPos1.Point3D, *TPos2.Point3D, *TPos3.Point3D, *vNormal.Point3D) = 0
    ProcedureReturn 0
  EndIf
  CopyMemory(IntersectionPoint(*vNormal.Point3D, *LPos1.Point3D, *LPos2.Point3D, originDistance), @vIntersection.Point3D, SizeOf(Point3D))
  If InsidePolygon(@vIntersection, *TPos1.Point3D, *TPos2.Point3D, *TPos3.Point3D) = 1
    ProcedureReturn 1
  EndIf
EndProcedure

If OpenWindow(#Window, 0, 0, #WindowWidth, #WindowHeight, "Trianglecollision by DarkDragon", #WindowFlags)

  SetWindowCallback(@MyWindowCallback())

  hWnd = WindowID(0)
  pfd.PIXELFORMATDESCRIPTOR   ;OpenGL starten
  hDC = GetDC_(hWnd)
  pfd\nSize        = SizeOf(PIXELFORMATDESCRIPTOR)
  pfd\nVersion     = 1
  pfd\dwFlags      = #PFD_SUPPORT_OPENGL | #PFD_DOUBLEBUFFER | #PFD_DRAW_TO_WINDOW
  pfd\iLayerType   = #PFD_MAIN_PLANE
  pfd\iPixelType   = #PFD_TYPE_RGBA
  pfd\cColorBits   = 24
  pfd\cDepthBits   = 32
  pixformat = ChoosePixelFormat_(hDC, pfd)
  SetPixelFormat_(hDC, pixformat, pfd)
  hrc = wglCreateContext_(hDC)
  wglMakeCurrent_(hDC, hrc)

  SwapBuffers_(hDC)

  glEnable_(#GL_DEPTH_TEST)

  Vec(0)\X = -0.225
  Vec(0)\Y = 0.5
  Vec(0)\Z = 0.0

  Vec(1)\X = -0.225
  Vec(1)\Y = -0.5
  Vec(1)\Z = 0.5

  Vec(2)\X = -0.225
  Vec(2)\Y = -0.5
  Vec(2)\Z = -0.5

  Line3D(0)\X = -0.5
  Line3D(1)\X = 0.5

  Line3D(1)\Z = 0.5

  vNormal.Point3D
  vNormal\X = 1.0

  vIntersection.Point3D
  vIntersection\X = -0.225

  Repeat
    Collision = IntersectedPolygon(@Vec(0), @Vec(1), @Vec(2), @Line3D(0), @Line3D(1), @vNormal.Point3D)
    OGLSetCamera(45.0, 0.0, -0.125, -2.0, 1.0, 0.0, 0.0, 0.1, 50.0)
    glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    glLoadIdentity_()
    glBegin_(#GL_LINES)
    If Collision = 0
      glColor3f_(0.0, 1.0, 0.0)
    Else
      glColor3f_(1.0, 1.0, 0.0)
    EndIf
    glVertex3f_(Line3D(0)\X, Line3D(0)\Y, Line3D(0)\Z)
    glVertex3f_(Line3D(1)\X, Line3D(1)\Y, Line3D(1)\Z)
    glEnd_()
    glLoadIdentity_()
    glBegin_(#GL_TRIANGLES)
    glNormal3f_(vNormal\X, vNormal\Y, vNormal\Z)
    glColor4f_(0.0, 0.0, 1.0, 1.0)
    glVertex3f_(Vec(0)\X, Vec(0)\Y, Vec(0)\Z)
    glColor4f_(1.0, 0.0, 0.0, 1.0)
    glVertex3f_(Vec(1)\X, Vec(1)\Y, Vec(1)\Z)
    glColor4f_(1.0, 1.0, 0.0, 1.0)
    glVertex3f_(Vec(2)\X, Vec(2)\Y, Vec(2)\Z)
    glEnd_()
    SwapBuffers_(hDC)
    Event = WindowEvent()
    If Event = #WM_KEYDOWN
      Select EventwParam()
        Case #VK_PRIOR
          Vec(0)\Y + 0.05
          Vec(1)\Y + 0.05
          Vec(2)\Y + 0.05
        Case #VK_NEXT
          Vec(0)\Y - 0.05
          Vec(1)\Y - 0.05
          Vec(2)\Y - 0.05
        Case #VK_DOWN
          Vec(0)\Z + 0.05
          Vec(1)\Z + 0.05
          Vec(2)\Z + 0.05
        Case #VK_UP
          Vec(0)\Z - 0.05
          Vec(1)\Z - 0.05
          Vec(2)\Z - 0.05
        Case #VK_LEFT
          Vec(0)\X - 0.05
          Vec(1)\X - 0.05
          Vec(2)\X - 0.05
        Case #VK_RIGHT
          Vec(0)\X + 0.05
          Vec(1)\X + 0.05
          Vec(2)\X + 0.05
      EndSelect
    EndIf
    Delay(5)
  Until Event = #PB_Event_CloseWindow
  End
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---